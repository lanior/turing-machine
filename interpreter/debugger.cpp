#include "debugger.h"

#include <algorithm>

namespace tmachine
{
    enum colors
    {
        COLOR_TEXT,
        COLOR_ERROR,
        COLOR_SUCCESS,
        COLOR_BREAKPOINT
    };

    void debugger::run()
    {
        run_ = true;

        commands_map& commands = vm_.get_commands();
        commands_map::iterator it;
        for (it = commands.begin(); it != commands.end(); it++)
        {
            std::map<int, command>::iterator it2;
            for (it2 = it->second.begin(); it2 != it->second.end(); it2++)
            {
                lines_cmd_[it2->second.line] = &it2->second;
            }
        }

        initscr();

        start_color();
        init_pair(COLOR_TEXT, COLOR_WHITE, COLOR_BLACK);
        init_pair(COLOR_ERROR, COLOR_RED, COLOR_BLACK);
        init_pair(COLOR_SUCCESS, COLOR_GREEN, COLOR_BLACK);
        init_pair(COLOR_BREAKPOINT, COLOR_RED, COLOR_BLACK);

        refresh();

        cbreak();
        keypad(stdscr, TRUE);
        noecho();
        curs_set(0);

        getmaxyx(stdscr, height_, width_);
        init();
        draw();

        int ch;
        while (run_ && (ch = getch()))
        {
            update(ch);
            draw();
        }

        endwin();
    }

    void debugger::update(int ch)
    {
        switch (ch)
        {
        case KEY_UP:
        case KEY_RIGHT:
        case KEY_ENTER:
            vm_step(1);
            break;
        case KEY_LEFT:
        case KEY_DOWN:
            vm_step(-1);
            break;
        case KEY_PPAGE:
            vm_step(-10);
            break;
        case KEY_NPAGE:
            vm_step(10);
            break;
        case KEY_HOME:
            vm_step(-10000);
            break;
        case KEY_END:
            vm_step(10000);
            break;
        case 'b':
        case 'B':
        {
            command& cmd = get_vm().get_current_command();
            if (cmd.defined) cmd.breakpoint = !cmd.breakpoint;
            break;
        }
        case 'c':
        case 'C':
        {
            int_command_map::iterator it;
            for (it = lines_cmd_.begin(); it != lines_cmd_.end(); it++)
            {
                if (it->second != NULL) it->second->breakpoint = false;
            }
            break;
        }
        case 'q':
        case 'Q':
            run_ = false;
            break;
        }
        getmaxyx(stdscr, height_, width_);
    }

    bool debugger::vm_step(int step)
    {
        if (step > 0)
        {
            for (int i = 0; i < step; i++)
            {
                executed_commands_.push_back(&vm_.get_current_command());

                try
                {
                    if (vm_.step()) step_++;
                    else
                    {
                        executed_commands_.pop_back();
                        return false;
                    }

                    if (vm_.get_current_command().breakpoint) return false;
                }
                catch (vm_exception& ex)
                {
                    error_ = ex.what();
                    executed_commands_.pop_back();
                    return false;
                }

            }
        }
        else
        {
            error_ = "";
            for (int i = 0; i > step; i--)
            {
                if (executed_commands_.size() == 0) return false;

                command* cmd = executed_commands_.back();
                executed_commands_.pop_back();
                vm_.set_cursor(vm_.get_cursor() - cmd->get_shift());
                vm_.set_cell(vm_.get_cursor(), cmd->symbol);
                vm_.set_state(cmd->state);
                step_--;

                if (vm_.get_current_command().breakpoint) return false;
            }
        }
        return true;
    }


    void debugger::draw()
    {
        wnd_stripe_.draw();
        wnd_info_.draw();
        wnd_source_.draw();
        wnd_trace_.draw();
    }

    void debugger::init()
    {
        wnd_stripe_.init();
        wnd_info_.init();
        wnd_source_.init();
        wnd_trace_.init();
    }

    command* debugger::get_command_by_line(int line)
    {
        int_command_map::iterator it = lines_cmd_.find(line);
        if (it == lines_cmd_.end()) return NULL;
        return it->second;
    }

    window::~window()
    {
        if (wnd_ != NULL) delwin(wnd_);
    }

    void window::init()
    {

    }

    void window::draw()
    {
        wrefresh(wnd_);
    }

    void stripe_window::init()
    {
        wnd_ = newwin(4, debugger_.get_width(), y_, x_);
    }

    void stripe_window::draw()
    {
        vm& vm = debugger_.get_vm();

        int cursor = vm.get_cursor();
        int width = debugger_.get_width();
        int middle = width / 2;

        wclear(wnd_);

        for (int i = 0; i < width; i++)
        {
            mvwaddch(wnd_, 0, i, '=');
            mvwaddch(wnd_, 1, i, vm.get_cell(cursor - middle + i));
            mvwaddch(wnd_, 2, i, '=');
        }
        mvwaddch(wnd_, 3, middle, '^');

        window::draw();
    }

    void info_window::init()
    {
        wnd_ = newwin(2, debugger_.get_width(), y_, x_);
    }

    void info_window::draw()
    {
        wclear(wnd_);
        mvwprintw(wnd_, 0, 1, "Step: %d", debugger_.get_step());

        if (debugger_.get_error().size() > 0)
        {
            wattron(wnd_, COLOR_PAIR(COLOR_ERROR));
            wprintw(wnd_, "  Error: %s", debugger_.get_error().c_str());
            wattroff(wnd_, COLOR_PAIR(COLOR_ERROR));
        }

        command& cmd = debugger_.get_vm().get_current_command();
        if (cmd.defined && cmd.breakpoint)
        {
            wattron(wnd_, COLOR_PAIR(COLOR_ERROR));
            wprintw(wnd_, "  Breakpoint");
            wattroff(wnd_, COLOR_PAIR(COLOR_ERROR));
        }

        if (debugger_.get_vm().is_stopped())
        {
            wattron(wnd_, COLOR_PAIR(COLOR_SUCCESS));
            wprintw(wnd_, "  End reached");
            wattroff(wnd_, COLOR_PAIR(COLOR_SUCCESS));
        }
        window::draw();
    }

    void source_window::init()
    {
        wnd_ = newwin(debugger_.get_height() - y_ - 1, 20, y_, x_);
    }

    void source_window::draw()
    {
        wclear(wnd_);
        mvwprintw(wnd_, 0, 1, "Source code");

        command& cmd = debugger_.get_vm().get_current_command();
        if (!cmd.defined) return;

        int line = cmd.line;
        int height = debugger_.get_height() - y_ - 3;
        int start = std::max(0, line - height / 2);
        int count = lines_.size() - start;

        for (int i = 0; i < std::min(height, count); i++)
        {
            command* lcmd = debugger_.get_command_by_line(start + i + 1);
            int color = COLOR_TEXT;
            char sym = ' ';

            if (lcmd != NULL) {
                if (lcmd->breakpoint)
                {
                    sym = 'B';
                    color = COLOR_BREAKPOINT;
                }
                if (lcmd == &cmd) sym = '>';
            }

            mvwprintw(wnd_, 2 + i, 1, "%s", lines_[start+i].c_str());
            mvwaddch(wnd_, 2 + i, 0, sym | COLOR_PAIR(color));
        }

        window::draw();
    }

    void trace_window::init()
    {
        wnd_ = newwin(debugger_.get_height() - y_ - 1, 20, y_, x_);
    }

    void trace_window::draw()
    {
        vm& vm = debugger_.get_vm();
        int height = debugger_.get_height() - y_ - 3;
        int count = debugger_.get_executed_commands().size();
        int start = std::max(0, count - height);

        wclear(wnd_);
        mvwprintw(wnd_, 0, 0, "Trace");

        for (int i = 0; i < std::min(height, count); i++)
        {
            command* cmd = debugger_.get_executed_commands()[start + i];

            char action = 'S';
            if      (cmd->action == CA_MOVE_LEFT)  action = 'L';
            else if (cmd->action == CA_MOVE_RIGHT) action = 'R';

            mvwprintw(wnd_, 2 + i, 0, "%c %s -> %c %s %c",
                cmd->symbol, vm.get_state_name(cmd->state).c_str(),
                cmd->new_symbol, vm.get_state_name(cmd->new_state).c_str(),
                action
            );
        }

        window::draw();
    }
}


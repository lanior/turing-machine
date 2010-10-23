#include <algorithm>
#include <iostream>

#include "vm.h"

namespace tmachine
{
    void vm::put_data(const std::string& data)
    {
        int pos = get_cursor();
        for (size_t i = 0; i < data.length(); i++)
        {
            memory_[get_cursor()] = data[i];
            set_cursor(get_cursor() + 1);
        }
        set_cursor(pos);
    }

    char vm::get_cell(int pos)
    {
        std::map<int, char>::iterator it = memory_.find(pos);
        if (it == memory_.end())
        {
            return memory_[pos] = filler_;
        }
        return it->second;
    }

    void vm::set_cursor(int cursor)
    {
        cursor_ = cursor;
        min_pos_ = std::min(cursor, min_pos_);
        max_pos_ = std::max(cursor, max_pos_);
    }

    command& vm::get_command(int symbol, int state)
    {
        return commands_[state][symbol];
    }

    command& vm::get_current_command()
    {
        return get_command(get_cell(get_cursor()), get_state());
    }

    int vm::get_state_id(std::string state)
    {
        std::map<std::string, int>::iterator it = states_.find(state);
        if (it == states_.end())
        {
            int id = states_.size() + 1;
            states_[state] = id;
            state_names_[id] = state;
            return id;
        }
        return it->second;
    }

    std::string vm::get_state_name(int state)
    {
        return state_names_[state];
    }

    void vm::validate()
    {
        if (get_state() == -1) error("Initial state must be set");
        if (get_filler() == -1) error("Filler must be set");

        commands_map::const_iterator it;
        for (it = commands_.begin(); it != commands_.end(); it++)
        {
            std::map<int, command>::const_iterator it2;
            for (it2 = it->second.begin(); it2 != it->second.end(); it2++)
            {
                const command& cmd = it2->second;
                if (cmd.action != CA_STOP)
                {
                    if (commands_.find(cmd.new_state) == commands_.end())
                    {
                        std::string msg = "Unknown target command ";
                        msg += cmd.new_symbol;
                        msg += " ";
                        msg += get_state_name(cmd.new_state);
                        error(msg);
                    }
                }
            }
        }

        if (!get_command(get_cell(get_cursor()), get_state()).defined)
        {
            error("No command matches default state and cursor position");
        }
    }

    void vm::error(const std::string& message)
    {
        throw vm_exception(message);
    }

    bool vm::step()
    {
        if (stopped_) return false;

        command& cmd = get_current_command();
        if (!cmd.defined) error("No command can be executed");

        set_cell(get_cursor(), cmd.new_symbol);
        if (cmd.action == CA_STOP)
        {
            stopped_ = true;
            return true;
        }

        set_state(cmd.new_state);
        set_cursor(get_cursor() + cmd.get_shift());

        return true;
    }
}


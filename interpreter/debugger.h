#ifndef TM_DEBUGGER_H
#define TM_DEBUGGER_H

#include <curses.h>
#include <vector>

#include "vm.h"

namespace tmachine
{
    class debugger;

    class window
    {
    public:
        window(int x, int y, debugger& debugger)
            : x_(x), y_(y), debugger_(debugger), wnd_(NULL) {}
        virtual ~window();

        virtual void init();
        virtual void draw();
    protected:
        int x_;
        int y_;
        debugger& debugger_;
        WINDOW* wnd_;
    };

    class stripe_window : public window
    {
    public:
        stripe_window(int x, int y, debugger& debugger)
            : window(x, y, debugger) {}
        virtual void init();
        virtual void draw();
    };

    class info_window : public window
    {
    public:
        info_window(int x, int y, debugger& debugger)
            : window(x, y, debugger) {}
        virtual void init();
        virtual void draw();
    };

    class source_window : public window
    {
    public:
        source_window(int x, int y, debugger& debugger, std::vector<std::string> lines)
            : window(x, y, debugger), lines_(lines) {}
        virtual void init();
        virtual void draw();
    protected:
        std::vector<std::string> lines_;
    };

    class trace_window : public window
    {
    public:
        trace_window(int x, int y, debugger& debugger)
            : window(x, y, debugger) {}
        virtual void init();
        virtual void draw();
    };

    class debugger
    {
    public:
        debugger(vm& vm, std::vector<std::string>& lines)
            : vm_(vm), wnd_stripe_(0, 0, *this), wnd_info_(0, 4, *this),
              wnd_source_(0, 6, *this, lines),
              wnd_trace_(22, 6, *this), step_(0) {}
        void run();
        bool vm_step(int step);

        vm& get_vm()                  { return vm_; }
        int get_height()        const { return height_; }
        int get_width()         const { return width_; }
        int get_step()          const { return step_; }
        std::string get_error() const { return error_; }
        std::vector<command*>& get_executed_commands()
        {
            return executed_commands_;
        }

    private:
        vm& vm_;
        stripe_window wnd_stripe_;
        info_window wnd_info_;
        source_window wnd_source_;
        trace_window wnd_trace_;

        std::vector<command*> executed_commands_;
        int height_;
        int width_;
        int step_;
        std::string error_;

        void init();
        void update(int ch);
        void draw();
    };
}

#endif


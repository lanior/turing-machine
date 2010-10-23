#ifndef TM_VM_H
#define TM_VM_H

#include <map>
#include <string>
#include <stdexcept>

namespace tmachine
{
    class vm_exception : public std::runtime_error
    {
    public:
        vm_exception(const std::string& message)
            : std::runtime_error(message) {}
    };

    enum command_action
    {
        CA_NONE,
        CA_MOVE_LEFT,
        CA_MOVE_RIGHT,
        CA_STOP,
    };

    struct command
    {
        command() : defined(false), breakpoint(false) {}

        int state;
        int symbol;

        int new_state;
        int new_symbol;
        command_action action;

        int line;
        bool defined;
        bool breakpoint;

        int get_shift()
        {
            switch (action)
            {
                case CA_MOVE_LEFT:  return -1;
                case CA_MOVE_RIGHT: return 1;
                default: return 0;
            }
        }
    };

    typedef std::map<int, std::map<int, command> > commands_map;

    class vm
    {
    public:
        vm() : state_(-1), cursor_(0), min_pos_(0), max_pos_(0), filler_(0),
               stopped_(false) {}

        bool step();

        void put_data(const std::string& data);

        void set_cursor(int cursor);
        int get_cursor() const             { return cursor_; }
        int get_left_bound() const         { return min_pos_; }
        int get_right_bound() const        { return max_pos_; }

        char get_cell(int pos);
        void set_cell(int pos, char value) { memory_[pos] = value; }

        int get_state() const              { return state_; }
        void set_state(int state)          { state_ = state; stopped_ = false; }

        char get_filler() const            { return filler_; }
        void set_filler(char filler)       { filler_ = filler; }

        bool is_stopped() const            { return stopped_; }

        command& get_command(int symbol, int state);
        command& get_current_command();
        commands_map& get_commands()       { return commands_; }

        int get_state_id(std::string state);
        std::string get_state_name(int state);

        void validate();
        void error(const std::string& message);
    private:
        std::map<int, char> memory_;
        commands_map commands_;
        std::map<std::string, int> states_;
        std::map<int, std::string> state_names_;

        int state_;
        int cursor_;
        int min_pos_;
        int max_pos_;
        char filler_;
        bool stopped_;
    };
};

#endif


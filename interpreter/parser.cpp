#include <sstream>

#include "parser.h"

namespace tmachine
{
    void parser::parse()
    {
        next_token();

        vm_.set_state(-1);

        while (token_.type != TT_EOS)
        {
            if (token_.type == TT_NL)
            {
                next_token();
                continue;
            }

            std::string cmd = get_ident();
            if      (cmd == "put")    vm_.put_data(get_ident());
            else if (cmd == "cursor") vm_.set_cursor(get_int());
            else if (cmd == "filler") vm_.set_filler(get_ident()[0]);
            else if (cmd == "state")
            {
                vm_.set_state(vm_.get_state_id(get_ident()));
            }
            else parse_command(cmd);

            if (token_.type != TT_EOS && token_.type != TT_NL)
            {
                error("Newline expected");
            }
            next_token();
        }
    }

    void parser::parse_command(const std::string& symbol)
    {
        std::string new_symbol, action_str;
        int state, new_state, line;

        line = token_.line;
        state = vm_.get_state_id(get_ident());

        if (token_.type != TT_FOLLOW) error("-> expected");
        next_token();

        new_symbol = get_ident();
        new_state = vm_.get_state_id(get_ident());

        command_action action = CA_NONE;
        bool breakpoint = false;

        action_str = get_ident();
        for (size_t  i = 0; i < action_str.size(); i++)
        {
            switch (action_str[i])
            {
                case 's':
                case 'S':
                    action = CA_STOP; break;
                case 'l':
                case 'L':
                    action = CA_MOVE_LEFT; break;
                case 'r':
                case 'R':
                    action = CA_MOVE_RIGHT; break;
                case 'b':
                case 'B':
                    breakpoint = true; break;
                default:
                    error("Unknown action");
            }
        }
        if (action == CA_NONE) error("No action assigned");

        if (symbol.length() > 1 || new_symbol.length() > 1)
        {
            error("Symbol should be 1 character long");
        }

        command& cmd = vm_.get_command(symbol[0], state);
        if (cmd.defined) error("Command is already defined");

        cmd.symbol = symbol[0];
        cmd.state = state;
        cmd.new_symbol = new_symbol[0];
        cmd.new_state = new_state;
        cmd.action = action;
        cmd.line = line;
        cmd.breakpoint = breakpoint;
        cmd.defined = true;
    }

    void parser::next_token()
    {
        do
        {
            token_ = lexer_.next_token();
        } while (token_.type == TT_COMMENT);
    }

    std::string parser::get_ident()
    {
        if (token_.type != TT_IDENT) error("Ident expected");
        std::string value = token_.value;
        next_token();
        return value;
    }

    int parser::get_int()
    {
        std::stringstream ss;
        int value;

        ss << get_ident();
        ss >> value;

        return value;
    }

    void parser::error(const std::string& message)
    {
        throw parser_exception(message, token_.line);
    }
}


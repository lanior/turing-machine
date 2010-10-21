#include "lexer.h"

#include <sstream>

namespace tmachine
{
    lexer::lexer(std::istream& is) : is_(is), line_(1)
    {
        get_char();
    }

    token lexer::next_token()
    {
        skip_ws();

        if (is_.eof())
        {
            return token(TT_EOS, "", line_);
        }

        skip_ws();

        if (cur_char == '\n' || cur_char == '\r')
        {
            if (cur_char == '\r')
            {
                get_char();
                if (cur_char == '\n') get_char();
            }
            else get_char();

            line_++;
            return token(TT_NL, "", line_);
        }
        else if (cur_char == '#')
        {
            return get_comment();
        }
        else if (is_ident())
        {
            return get_ident();
        }

        throw lexer_exception(std::string("Unexpected symbol ") + cur_char);
    }

    char lexer::get_char()
    {
        is_.get(cur_char);
        return cur_char;
    }

    void lexer::skip_ws()
    {
        while (is_ws() && !is_.eof()) get_char();
    }

    bool lexer::is_ident()
    {
        return cur_char > ' ';
    }

    bool lexer::is_ws()
    {
        return cur_char == ' ' || cur_char == '\t';
    }

    token lexer::get_comment()
    {
        std::stringstream ss;
        get_char();
        while (cur_char != '\n' && cur_char != '\r' && !is_.eof())
        {
            ss << cur_char;
            get_char();
        }
        return token(TT_COMMENT, ss.str(), line_);
    }

    token lexer::get_ident()
    {
        std::stringstream ss;
        do {
            ss << cur_char;
            get_char();
        } while (is_ident() && !is_.eof());

        std::string value = ss.str();
        token_type type = (value == "->") ? TT_FOLLOW : TT_IDENT;

        return token(type, value, line_);
    }
}


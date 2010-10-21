#ifndef TM_LEXER_H
#define TM_LEXER_H

#include <iostream>
#include <string>
#include <stdexcept>

namespace tmachine
{
    class lexer_exception : public std::runtime_error
    {
    public:
        lexer_exception(const std::string& message)
            : std::runtime_error(message) {}
    };

    enum token_type
    {
        TT_IDENT, TT_COMMENT,
        TT_FOLLOW,
        TT_NL, TT_EOS
    };

    struct token
    {
        token() {}
        token(token_type type_, std::string value_, int line_)
            : type(type_), value(value_), line(line_) {}

        token_type type;
        std::string value;
        int line;
    };

    class lexer
    {
    public:
        lexer(std::istream& is);

        token next_token();

    private:
        std::istream& is_;
        char cur_char;
        int line_;

        void skip_ws();

        bool is_ws();
        bool is_ident();

        char get_char();

        token get_comment();
        token get_ident();
    };
}

#endif


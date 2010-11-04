#ifndef TM_PARSER_H
#define TM_PARSER_H

#include <stdexcept>
#include <vector>

#include "lexer.h"
#include "vm.h"

namespace tmachine
{
    class parser_exception : public std::runtime_error
    {
    public:
        parser_exception(const std::string& message, int line)
            : std::runtime_error(message), line_(line) {}
        int line() { return line_; }
    protected:
        int line_;
    };

    class parser
    {
    public:
        parser(lexer& lexer, vm& vm)
            : lexer_(lexer), vm_(vm) {}
        void parse();
    private:
        lexer& lexer_;
        vm& vm_;
        token token_;

        void parse_command(const std::string& symbol);
        std::string get_ident();
        int get_int();
        void next_token();
        void error(const std::string& message);

        void process_symbol_class(const std::string& sym_class, std::vector<char>& symbols);
    };
}

#endif


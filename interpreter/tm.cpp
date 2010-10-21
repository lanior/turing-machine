#include <cstdlib>
#include <iostream>
#include <fstream>

#include "lexer.h"
#include "parser.h"
#include "vm.h"
#include "debugger.h"

int main(int argc, char *argv[])
{
    std::ifstream is(argv[1]);

    tmachine::lexer lexer(is);
    tmachine::vm vm;
    tmachine::parser parser(lexer, vm);

    parser.parse();
    vm.validate();

    std::string line;
    std::vector<std::string> lines;

    is.clear();
    is.seekg(0, std::ios::beg) ;
    while(!std::getline(is, line).eof())
    {
        lines.push_back(line);
    }

    tmachine::debugger debugger(vm, lines);
    debugger.run();

    return EXIT_SUCCESS;

    while (vm.step());

    for (int i = vm.get_left_bound(); i <= vm.get_right_bound(); i++)
    {
        std::cout << vm.get_cell(i);
    }
    std::cout << std::endl << std::endl;
    return EXIT_SUCCESS;
}


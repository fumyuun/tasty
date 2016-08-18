/**
 * This tool will parse an input log file generated by bizhawk into something we can program into tasty.
 * To generate such an input log, use TAStudio to program out your run.
 * From TAStudio, use file -> export to .bk2. Inside this archive you can find Input File.txt.
 */

#include <iostream>
#include <fstream>
#include <list>
#include <iomanip>

struct snes_js_t {
    bool up;
    bool down;
    bool left;
    bool right;
    bool start;
    bool select;
    bool a;
    bool b;
    bool x;
    bool y;
    bool l;
    bool r;

    snes_js_t ()
        : up(false), down(false), left(false), right(false), start(false), select(false),
        a(false), b(false), x(false), y(false), l(false), r(false)
    {
    }

    friend std::istream& operator >> (std::istream& input, snes_js_t& js) {
        char cbuf;
        while (input.good() && cbuf != '\n') {
            cbuf = input.get();

            switch (cbuf) {
                case 'U': js.up = true;     break;
                case 'D': js.down = true;   break;
                case 'L': js.left = true;   break;
                case 'R': js.right = true;  break;
                case 'A': js.a = true;      break;
                case 'B': js.b = true;      break;
                case 'X': js.x = true;      break;
                case 'Y': js.y = true;      break;
                case 'l': js.l = true;      break;
                case 'r': js.r = true;      break;
                case 'S': js.start = true;  break;
                case 's': js.select = true; break;
                default:                    break;
            }
        }
        return input;
    };

    friend std::ostream& operator << (std::ostream& output, const snes_js_t& js) {
        unsigned int out = 0x0000;

        if (js.b) {     out |= (1 <<  0);}
        if (js.y) {     out |= (1 <<  1);}
        if (js.select) {out |= (1 <<  2);}
        if (js.start) { out |= (1 <<  3);}
        if (js.up) {    out |= (1 <<  4);}
        if (js.down) {  out |= (1 <<  5);}
        if (js.left) {  out |= (1 <<  6);}
        if (js.right) { out |= (1 <<  7);}
        if (js.a) {     out |= (1 <<  8);}
        if (js.x) {     out |= (1 <<  9);}
        if (js.l) {     out |= (1 << 10);}
        if (js.r) {     out |= (1 << 11);}

        if (output.good()) {
            output << std::hex << std::setw(4) << std::setfill('0') << out;
        }
        return output;
    };
};



int main (int argc, char **argv) {
    std::ifstream input;
    std::ofstream output;
    std::list<snes_js_t> snes_list;


    if (argc < 3) {
        std::cout << "Missing argument. Usage: " << argv[0] << " <input filename> <output filename>" << std::endl;
        return 1;
    }

    input.open(argv[1]);

    if (!input.is_open()) {
        std::cerr << "Unable to open input file " << argv[1] << std::endl;
        return 2;
    }

    output.open(argv[2], std::ios_base::trunc);

    if (!output.is_open()) {
        std::cerr << "Unable to open output file " << argv[2] << std::endl;
        input.close();
        return 3;
    }

    int i = 0;
    while (input.good()) {
        char cbuf;
        snes_js_t js;

        cbuf = input.get();

        if (cbuf == '|' && (input >> js)) {
            snes_list.push_back(js);
        } else {
            input.ignore(256, '\n');
        }
    }

    if (input.bad()) {
        std::cout << "read error" << std::endl;
        input.close();
        output.close();
        return 4;
    }

    output << "memory_initialization_radix=16;" << std::endl;
    output << "memory_initialization_vector=" << std::endl;

    int linecount = 0;
    std::list<snes_js_t>::iterator it;
    for (it = snes_list.begin(); it != snes_list.end(); ++it) {
        output << *it << " ";
        if (linecount++ > 16) {
            output << std::endl;
            linecount = 0;
        }
    }

    output << ";" << std::endl;

    std::cout << "Succesfully parsed " << snes_list.size() << " inputs!" << std::endl;
}

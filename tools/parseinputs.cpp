#include <iostream>
#include <fstream>
#include <list>

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
        : up(false), down(false), left(false), right(false), start(false), select(false), a(false), b(false), x(false), y(false), l(false), r(false) 
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
        if (output.good()) {
            output << js.up << js.down << js.left << js.right << js.start << js.select << js.a << js.b << js.x << js.y << js.l << js.r;
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
    }

    std::cout << "Succesfully parsed " << snes_list.size() << " inputs!" << std::endl;
}

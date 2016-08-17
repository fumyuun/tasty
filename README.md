# Tasty
A TASbot platform (Tool Assisted Speed-run) implemented on an FPGA in VHDL.
Inspired by the original TASbot on [http://tasvideos.org/TASBot.html].

Don't expect much yet, this is in a very early stage of development.
For now, everything is assumed to run on a Nexys4DDR board.
Currently only some component exists that attempts to emulate a SNES joystick by using push buttons on the board (and some externally connected).
I connected it to a logic level adjusting circuit to interface with the SNES connected to Pmod port JA: don't connect them directly! Read on first.

# I/O Testing
As mentioned earlier, this is all assuming that we run on a Nexys4DDR board.
The push buttons on the board itself are mapped to up, down, left, right and start.
Additional push buttons are connected to pins 1 to 4 from the JB Pmod port (using a PmodBTN component): these are mapped to a, b, x and y.

At the moment, the LEDs are used for debugging, to verify you connected everything correctly.
LED 0 should blink (fastly) to indicate the received clock pulses, while LED 1 blinks (slower) to indicate latch pulses.

If you don't want to use the push buttons, the switches are also useable as inputs.
Switch 15 is used to switch input source from push buttons (high) or switches (low).
If you want to use switches instead, switches 0 until 11 are connected to buttons.

# Pointers on the output schematic
I connected JA's Pmod pins to a cut off SNES controller cable's wires, but as the Nexys4 uses 3.3V logic levels while the SNES uses 5V, you need a circuit in between to do the conversion.
Currently the code hooks up JA1 to the latch pin, JA2 to the clock pin and JA3 to the data pin.
You might also need JA5 and JA6 as GND and V3.3's in the voltage level adjustment circuit.
Be careful when making this yourself, as having wrong voltage levels can damage either your SNES or your FPGA board.
Only attempt this if you know what you're doing, and triple check everything. I'm not responsible for breaking anything. :)

The following colouring (from the SNES) should be helpful when connecting:
* White: 5V
* Yellow: clock
* Orange: latch
* Red: data
* Brown: GND

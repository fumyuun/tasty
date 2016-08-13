# Tasty
A TASbot platform (Tool Assisted Speed-run) implemented on an FPGA in VHDL.
Inspired by the original TASbot on [http://tasvideos.org/TASBot.html].

Don't expect much yet, this is in a very early stage of development.
For now, everything is assumed to run on a Nexys4DDR board.
Currently only some component exists that attempts to emulate a SNES joystick by using push buttons on the board (and some externally connected).
As my logic level adjusting I/O circuit is not yet finished, I currently use some LEDs and switches on the board for testing.

# I/O Testing
As mentioned earlier, this is all assuming that we run on a Nexys4DDR board.
The push buttons on the board itself are mapped to up, down, left, right and start.
Additional push buttons are connected to pins 1 to 4 from the JB Pmod port (using a PmodBTN component): these are mapped to a, b, x and y.

The SNES input wires are currently "simulated" by switches 0 and 1.
Switch 0 simulates the clock, switch 1 simulates the latch.
I'm praying that this design will survive an actual clock with a period of 12us too, but unfortunately my hands are not that fast as a clock generator.

The state of the button latch is displayed over the LEDs, in a way that LED0 shows the output data wire going back to the SNES.

Pointers on using the I/O testing:

* Make sure both switches are asserted low.
* Hold buttons that you want as inputs.
* While still holding, assert the latch signal (switch 1) low and high.
* Now you can release the buttons. The state should be stored (look at the LEDs ignoring LEDS 8 until 11, they should always be high).
* Alternate the clock signal (switch 0) to shift out the data signal.
* Congratulations, you just manually simulated the communication between a SNES and it's controller (albeit a tiny bit too slow for the real thing)!

# Pointers on the output schematic
My plan is to connect JA's Pmod pins to a cut off SNES controller cable's wires, but as the Nexys4 uses 3.3V logic levels while the SNES uses 5V, I need a circuit in between to do the conversion.
Be careful when making this yourself, as having wrong voltage levels can damage either your SNES or your FPGA board.
Only attempt this if you know what you're doing, and triple check everything. I'm not responsible for breaking anything. :)


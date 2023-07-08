# Cummings_FIFO
Simulation and Synthesis Techniques for Asynchronous FIFO Design.

The asynchronous FIFO design described in
http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf by CLifford
Cummings is implemented using System Verilog in this repository.

An asynchronous FIFO refers to a FIFO design where data values are written to a
FIFO buffer from one clock domain and the data values are read from the same FIFO
buffer from another clock domain, where the two clock domains are asynchronous
to each other.

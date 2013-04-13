1-WIRE-Slave by Alberto Ruffo
==============================

A VHDL 1-WIRE slave interface

it supports these 1-WIRE commands:

(0xF0) SEARCH ROM
(0x55) READ ROM followed by an address

You must change output ports and Sequencer state machine to link a real sensor and get a global behaviour!

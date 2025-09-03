# FPGA Traffic Signal Controller

## Overview
16-state traffic light controller implemented in **VHDL** on FPGA using a **Moore finite state machine**.  
Sequences **North/South and East/West light phases** (green → amber → red) and safely handles pedestrian requests.

## Features
- 16-state Moore FSM for traffic light sequencing  
- Pedestrian crossing logic with holding registers  
- Conditional state transitions for safe arbitration between NS/EW directions  
- Register-clear signals for resetting crossing requests  
- Hardware outputs on LEDs and 7-segment displays for phase visualization  

## Project Files
- VHDL source (`.vhd`)  
- Quartus project files (`.qpf`, `.qsf`)  
- Simulation waveforms (`.vwf`, `.do`)  
- Diagrams/screenshots (`.png`)  

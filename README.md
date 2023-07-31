# Data Cache

## About 
This repository contains SystemVerilog code that behaviorly models a **2-way set-associative cache controller** with 32 cache lines in each way. It also contains a testbench to verify the design. 

The data cache also has a block size of 2 words where each word is 32 bits wide. It is also implements a write-back policy and uses **LRU** (least recently used) strategy to determine which way to write to. 

All code is in the **source** directory. 

## Tools
`iverilog`: verilog compiler

`gtkwave`: waveform viewer 




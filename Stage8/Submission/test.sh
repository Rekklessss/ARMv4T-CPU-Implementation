#!/bin/bash
cp /media/sf_Aryan/desktop/Code/test.s /home/aryan/Desktop/ARMSim
cd /home/aryan/Desktop/ARMSim
gcc gentest.c && ./a.out test.s
cp  /home/aryan/Desktop/ARMSim/mem.vhd /media/sf_Aryan/desktop/Code/mem.vhd

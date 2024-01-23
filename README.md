# VerilogHDL-32-bits-MIPS-CPU
Computer Composition Course Design

## 1： Single cycle processor development
In addition to supporting the original MIPS Lite instruction set (addu, sub, ori, lw, sw, beq, Lui, j), we have also focused on improving the IFU module to support the MIPS Lite 1 instruction set (MIPS Lite, addi, addiu, slt, jal, jr).

## 2： Multi cycle processor development
The data path design of multi cycle processors has been improved and expanded on the previous data path design. In addition to supporting the original MIPS Lite1 instruction set (MIPS Lite, addi, addiu, slt, jal, jr), the support for the MIPS Lite2 instruction set (MIPS Lite1, lb, SB) has been achieved by adding a selection module before the DM module and other improvement measures.

## 3： MIPS microsystem development (supporting devices and interrupts)
The data path design of the MIPS microsystem has been improved and expanded on the previous data path design. In addition to supporting the original MIPS Lite2 instruction set (addu, sub, ori, lw, sw, beq, Lui, addi, addiu, slt, j, jal, jr, lb, SB), it also implements support for the MIPS Lite3 instruction set (MIPS Lite2, ERET, MFC0, MTC0).
The data path of MIPS microsystems is mainly divided into two parts: one is the data path of multi cycle processors, and the other is the external bridge of the CPU and the connection with peripherals.
The data path of the multi cycle processor adds a CP0 coprocessor and its corresponding data path on the basis of P1, and also adds an LW module to choose whether to write DM data to the register or read data from the peripheral device to the register when the MemToWrite signal is 01.
There are three main external devices of the CPU: input devices, output devices, and timers.
The system bridge connects peripherals to the internal CPU and serves as a link.

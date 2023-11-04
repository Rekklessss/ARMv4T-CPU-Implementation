# ARM Microarchitecture VHDL Design

## Overview
This repository contains the VHDL code and documentation for the design and implementation of a microarchitecture that executes a subset of ARM instructions. The project is structured into multiple stages, each adding functionality to the processor's design.

## Instruction Set
The processor supports executing the following ARM instruction sets:

### Arithmetic Instructions
- `add` - Add
- `sub` - Subtract
- `rsb` - Reverse Subtract
- `adc` - Add with Carry
- `sbc` - Subtract with Carry
- `rsc` - Reverse Subtract with Carry

### Logical Instructions
- `and` - AND
- `orr` - OR
- `eor` - Exclusive OR
- `bic` - Bit Clear

### Test Instructions
- `cmp` - Compare
- `cmn` - Compare Negative
- `teq` - Test Equivalence
- `tst` - Test

### Move Instructions
- `mov` - Move
- `mvn` - Move Not

### Branch Instructions
- `b` - Branch
- `bl` - Branch with Link

### Multiply Instructions
- `mul` - Multiply
- `mla` - Multiply Accumulate
- `smull` - Signed Multiply Long
- `smlal` - Signed Multiply Accumulate Long
- `umull` - Unsigned Multiply Long
- `umlal` - Unsigned Multiply Accumulate Long

### Load/Store Instructions
- `ldr` - Load Register
- `str` - Store Register

### Software Interrupt
- SW interrupt handling

### Conditions
- Conditions include `EQ`, `NE`, `CS`, `CC`, `MI`, `PL`, `VS`, `VC`, `HI`, `LS`, `GE`, `LT`, `GT`, `LE`, `AL`.

## Design Stages
1. **Stage 1**: Basic modules design and testing, including ALU, Register File, Program Memory, and Data Memory.
2. **[Subsequent stages are detailed within the repository]**

## Files and Directories
- `src/`: Contains all VHDL source files.
- `test/`: Contains test benches for each module.
- `doc/`: Documentation and design descriptions.
- `bin/`: Synthesis and simulation results.

## Getting Started
To run the VHDL files, you will need a VHDL simulator like ModelSim or GHDL, and a synthesis tool such as Xilinx Vivado or Altera Quartus. Follow the setup instructions for your tools of choice, and use the provided test benches to validate the design.

## Contributing
Contributions to this project are welcome. Please follow these steps to contribute:
1. Fork the repository.
2. Create a new branch for your feature (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details.

We hope this repository serves as a useful reference for those interested in the microarchitecture design using VHDL for ARM instruction sets.

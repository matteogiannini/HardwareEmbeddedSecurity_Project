# LightHash — Hardware Implementation of a Lightweight Hash Function

A hardware (FPGA) implementation of a **lightweight cryptographic hash function** in SystemVerilog, with a Python high-level reference model, developed for the *Hardware and Embedded Security* course, Master's Degree in Cybersecurity, University of Pisa.

The design (`light_hash`, version 5) processes an 8-byte state through a sequence of round transformations and is synthesised and verified for an FPGA target.

## Design overview

The hash core is built from composable round operations, each implemented as its own SystemVerilog module:

| Module        | Role                                                        |
| ------------- | ----------------------------------------------------------- |
| `SA`          | State addition — XOR of the state with the Initial Vector   |
| `theta`       | Linear diffusion layer (state permutation/reversal)         |
| `rho`         | Non-linear transformation (modular addition)                |
| `FPX`         | Mixing / fixed-point transformation stage                   |
| `aux_conv`    | Auxiliary conversion logic                                  |
| `hash_round`  | One full round combining the stages above                   |
| `hash_top`    | Top-level entity wiring rounds, I/O and control             |
| `light_hash`  | The hash datapath                                           |

The Python model (`model/light_hash_v5_high_level.py`) is the golden reference used to generate and check test vectors against the RTL.

## Tech stack & tools

- **RTL:** SystemVerilog
- **Reference model:** Python
- **Synthesis:** Intel Quartus (`quartus/`), with timing constraints (`.sdc`) and virtual-pin TCL scripts
- **Simulation:** ModelSim (`modelsim/`), driven by the testbench `tb/light_hash_tb.sv` and hex test vectors (`modelsim/tv/`)

## Repository structure

```
.
├── db/                  # SystemVerilog RTL sources
│   ├── light_hash.sv  hash_top.sv  hash_round.sv
│   ├── SA.sv  theta.sv  rho.sv  FPX.sv  aux_conv.sv
├── tb/
│   └── light_hash_tb.sv         # Testbench
├── model/
│   └── light_hash_v5_high_level.py   # Python golden reference model
├── modelsim/            # Simulation flow (build.py, clean.py, test vectors in tv/)
├── quartus/             # Synthesis flow (build.py, clean.py, constraints in constr/)
└── doc/                 # Project report, specs and environment guide (PDF)
```

## Usage

Generate / inspect reference outputs:

```shell
python3 model/light_hash_v5_high_level.py
```

Simulate the RTL against the test vectors (ModelSim):

```shell
cd modelsim
python3 build.py        # compile + run the testbench
python3 clean.py        # clean simulation artifacts
```

Synthesise for the FPGA target (Quartus):

```shell
cd quartus
python3 build.py        # run synthesis/fitting/timing
python3 clean.py
```

## Documentation

`doc/light_hash_v5_Project_Report.pdf` contains the full design report; `project_specs.pdf`, `project_rules.pdf` and `work_env_guide.pdf` document the assignment and toolchain setup.

## Authors

Matteo Giannini · Francesco Camaccioli

# Low-Power INT8 Systolic Array AI Accelerator

This project implements a Low-Power INT8 Systolic Array AI Accelerator in Verilog for matrix multiplication.

## Current Status

- Designed and verified INT8 MAC Processing Element
- Implemented 2x2 systolic array
- Implemented 4x4 systolic array
- Added controller FSM for clear, enable, valid, and done control
- Integrated controller and 4x4 systolic array in top-level AI accelerator module
- Verified functionality using Vivado testbenches

## Low-Power RTL Techniques

- Zero-skipping MAC operation
- Operand isolation for multiplier inputs
- Enable-based register updates instead of manual clock gating

## RTL Modules

- `pe_mac.v`
- `systolic_array2x2.v`
- `systolic_array4x4.v`
- `controller.v`
- `top_ai_accelerator.v`

## Testbenches

- `pe_mac_tb.v`
- `systolic_array2x2_tb.v`
- `systolic_array4x4_tb.v`
- `controller_tb.v`
- `tb_top_ai_accelerator.v`

## Tools Used

- Verilog HDL
- Xilinx Vivado

## Verification

The 4x4 accelerator was verified using identity matrix multiplication:

```text
C = A × I = A

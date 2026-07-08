
# Low-Power INT8 Systolic AI Accelerator

A 4×4 systolic array accelerator for INT8 matrix multiplication, designed
in SystemVerilog with a power-saving operand-isolation (zero-skip) feature,
and verified against an independently-built Python golden model.

## Architecture

- **`pe_mac.sv`** — single processing element: INT8×INT8 multiply-accumulate
  with a 32-bit signed accumulator. Implements operand isolation (zero-skip):
  the multiplier inputs are gated to zero whenever either operand is zero,
  avoiding unnecessary switching activity in the multiplier for a power
  saving, with no effect on the computed result.
- **`systolic_array4x4.sv`** — 4x4 grid of pe_mac instances. Activations
  (a) flow left-to-right, weights (b) flow top-to-bottom, one register
  hop per cycle in each direction.
- **`input_skew.sv`** (+ skew_delay.sv, delay_reg.sv) — pre-delays each
  external row/column input by an amount proportional to its index before
  it enters the array, so that matched elements of a streamed dot product
  arrive at every PE on the same cycle (see "Bugs found" below).
- **`controller.sv`** — FSM (IDLE -> CLEAR -> RUN -> DONE) sequencing a full
  matrix-multiply operation from a single start pulse.
- **`top_ai_accelerator.sv`** — top-level module wiring the above together.

## Verification approach

Rather than relying on manually-derived expected values, this project uses
a golden reference model (golden_model/golden_model.py) - a cycle-accurate
Python re-implementation of the same RTL structure (built independently,
module by module) - as the source of truth for correctness.

- Directed + self-checking SystemVerilog testbenches (tb/) compare
  RTL outputs against hand-computed or golden-model-derived expected values,
  reporting clear PASS/FAIL results per check.
- Automated comparison pipeline (golden_model/gen_stimulus_top.py,
  run_golden_top.py, compare_top.py, tb/top_ai_accelerator_compare_tb.sv)
  drives both the golden model and the RTL from an identical, shared
  stimulus file, then diffs their outputs cycle-by-cycle - removing the
  need to manually recalculate expected values for every new test case.

## Bugs found and fixed during verification

Two real, non-obvious RTL bugs were found using this methodology and fixed:
an input-skew timing mismatch (off-diagonal PEs were combining mismatched
elements of a streamed dot product), and a controller drain-timing gap
(DONE was asserted before the farthest PEs had finished accumulating).
Both are fixed in the current RTL and confirmed via the golden-model
comparison pipeline.

## Known limitations

- The golden-model-vs-RTL comparison currently shows an exact match on all
  computed accumulator values; there is a known, understood 1-cycle
  difference in exactly which cycle the done flag is reported between
  the Python model and the SystemVerilog testbench's sampling point. This
  is a simulation/sampling convention difference, not a functional bug.
- Code coverage (Verilator) and structured functional coverage counters
  are not yet implemented.
- The array size (4x4) is currently fixed, not parameterized.

## Folder structure

rtl/            SystemVerilog design source
tb/              SystemVerilog testbenches
golden_model/    Python golden reference model + comparison pipeline scripts

## Future work

- Code coverage (Verilator) and functional coverage counters
- Parameterize array size (currently fixed at 4x4)
- Synthesis-level area/timing/power estimation
EOF

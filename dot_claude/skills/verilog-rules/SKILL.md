---
name: verilog-rules
description: Formatting and design rules for Verilog. Use this skill whenever you're writing Verilog (.v) or SystemVerilog (.sv) files.
---

## Comments

- No comments on struct/protobuf message declarations or fields.
- Only comment non-obvious implementation subtleties; keep brief.
- Place function comments *inside* the function body, not above the prototype.

## Visual Alignment

Align related lines for readability:

```verilog
struct = '{
    field_a      = value_a,
    long_field_b = value_b,
    c            = value_c
};

always_comb begin
    field_a = 1'b0;
    b       = something;
end
```

## Control Flow

- Always use braces (or `begin`/`end` in Verilog), even for single-line bodies.

## Other Rules

- No banner-style //////////// section separators. Use a single // comment line if a section label is needed.
- No comments on struct fields or port declarations unless they convey non-obvious formation.
- Use targeted // verilator lint_off X / // verilator lint_on around specific signals, not file-wide pragmas.
- Keep localparams minimal — don't declare computed widths that are only used once or never referenced.
- Truncation of wide signals should happen inside helper functions, not at every call site.
- In testbenches, use initial begin ... forever for clocks rather than always #N to avoid Verilator warnings.
- Prefix module ports: `inp_`, `out_`.
- Do not use `always_ff` except when explicitly trying to describe a RAM. Explicitly instantiate `Flop.sv` or `EnableFlop.sv` from `hw/src`.
- Avoid `always_comb` unless setting one or two struct fields or for complex state machine control logic. Prefer plain `logic` with ternary operators.

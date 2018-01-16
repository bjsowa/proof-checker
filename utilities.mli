open Proof

val parse_with_error : Lexing.lexbuf -> proof list
val print_proof : out_channel -> proof -> unit
val print_formula : out_channel -> formula -> unit
val ( $@ ) : FormulaSet.t -> FormulaSet.t -> FormulaSet.t

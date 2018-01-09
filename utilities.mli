open Proof

val parse_with_error : Lexing.lexbuf -> Proof.proof list
val remove_duplicates : formula list -> formula list
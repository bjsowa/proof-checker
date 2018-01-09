open Core
open Lexer
open Lexing
open Proof

let print_position outx lexbuf =
  let pos = lexbuf.lex_curr_p in
  fprintf outx "%s:%d:%d" pos.pos_fname
    pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)

let parse_with_error lexbuf =
    try Parser.prog Lexer.read lexbuf with
    | SyntaxError msg ->
        fprintf stderr "%a: %s\n" print_position lexbuf msg;
        exit (1)
    | Parser.Error ->
        fprintf stderr "%a: syntax error\n" print_position lexbuf;
        exit (1)

let remove_duplicates premises =
	List.fold premises ~init:[]
		~f:(fun acc p1 -> if List.exists acc 
			~f:(fun p2 -> formula_equal p1 p2)
			then acc else p1::acc)
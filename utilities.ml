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

let rec print_proof outc = function
	{ name; goal; proof } -> fprintf outc "goal %s: %a\nproof\n%a\nend." 
		name print_formula goal print_premises proof

and print_premises outc = function
	| [] -> ()
	| (Formula (f,_))::[]  -> fprintf outc "%a"
		print_formula f
	| (Formula (f,_))::t   -> fprintf outc "%a;\n%a" 
		print_formula f print_premises t
	| (Frame (f,p))::[] -> fprintf outc "[ %a :\n%a ]"
		print_formula f print_premises p
	| (Frame (f,p))::t -> fprintf outc "[ %a :\n%a ];\n%a"
		print_formula f print_premises p print_premises t

and print_formula outc = function
	| Lit x     -> fprintf outc "%c" x
	| Neg x     -> fprintf outc "~(%a)" print_formula x
	| And (x,y) -> fprintf outc "(%a)/\\(%a)" print_formula x print_formula y
	| Or (x,y)  -> fprintf outc "(%a)\\/(%a)" print_formula x print_formula y
	| Imp (x,y) -> fprintf outc "(%a)=>(%a)" print_formula x print_formula y
	| Eq (x,y)  -> fprintf outc "(%a)<=>(%a)" print_formula x print_formula y
	| True		-> fprintf outc "T"
	| False 	-> fprintf outc "F"

let ($@) = FormulaSet.union

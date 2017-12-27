type formula = 
	| Lit of char
	| Neg of formula
	| And of (formula * formula)
	| Or of (formula * formula)
	| Imp of (formula * formula)
	| Eq of (formula * formula)

open Core
let rec output_value outc = function
	| Lit x     -> printf "%c" x
	| Neg x     -> printf "~(%a)" output_value x
	| And (x,y) -> printf "(%a)/\\(%a)" output_value x output_value y
	| Or (x,y)  -> printf "(%a)\\/(%a)" output_value x output_value y
	| Imp (x,y) -> printf "(%a)=>(%a)" output_value x output_value y
	| Eq (x,y)  -> printf "(%a)<=>(%a)" output_value x output_value y
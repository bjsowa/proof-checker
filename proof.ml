type formula = 
	| Lit of char
	| Neg of formula
	| And of (formula * formula)
	| Or of (formula * formula)
	| Imp of (formula * formula)
	| Eq of (formula * formula)

type premise = 
	| FORMULA of formula
	| FRAME of formula * (premise list)

type proof =
	{ name : string;
	  goal : formula;
	  proof: premise list; }

open Core

let rec proof_value outc = function
	{ name; goal; proof } -> printf "goal %s: %a\n" name formula_value goal

and formula_value outc = function
	| Lit x     -> printf "%c" x
	| Neg x     -> printf "~(%a)" formula_value x
	| And (x,y) -> printf "(%a)/\\(%a)" formula_value x formula_value y
	| Or (x,y)  -> printf "(%a)\\/(%a)" formula_value x formula_value y
	| Imp (x,y) -> printf "(%a)=>(%a)" formula_value x formula_value y
	| Eq (x,y)  -> printf "(%a)<=>(%a)" formula_value x formula_value y
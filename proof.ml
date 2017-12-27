type formula = 
	| Lit of char
	| Neg of formula
	| And of (formula * formula)
	| Or of (formula * formula)
	| Imp of (formula * formula)
	| Eq of (formula * formula)

type premise = 
	| Formula of formula
	| Frame of formula * (premise list)

type proof =
	{ name : string;
	  goal : formula;
	  proof: premise list; }

open Core

let rec output_value outc = function
	{ name; goal; proof } -> printf "goal %s: %a\nproof\n%aend." 
		name formula_value goal proof_value proof

and proof_value outc = function
	| [] -> ()
	| (Formula f)::[]  -> printf "%a"
		formula_value f
	| (Formula f)::t   -> printf "%a;\n%a" 
		formula_value f proof_value t
	| (Frame (f,p))::[] -> printf "[ %a :\n%a ]"
		formula_value f proof_value p
	| (Frame (f,p))::t -> printf "[ %a :\n%a ];\n%a\n"
		formula_value f proof_value p proof_value t

and formula_value outc = function
	| Lit x     -> printf "%c" x
	| Neg x     -> printf "~(%a)" formula_value x
	| And (x,y) -> printf "(%a)/\\(%a)" formula_value x formula_value y
	| Or (x,y)  -> printf "(%a)\\/(%a)" formula_value x formula_value y
	| Imp (x,y) -> printf "(%a)=>(%a)" formula_value x formula_value y
	| Eq (x,y)  -> printf "(%a)<=>(%a)" formula_value x formula_value y
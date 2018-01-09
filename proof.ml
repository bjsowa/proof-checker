open Core

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

let formula_equal f1 f2 = 
	f1 = f2

let rec output_value outc = function
	{ name; goal; proof } -> fprintf outc "goal %s: %a\nproof\n%a\nend." 
		name formula_value goal proof_value proof

and proof_value outc = function
	| [] -> ()
	| (Formula f)::[]  -> fprintf outc "%a"
		formula_value f
	| (Formula f)::t   -> fprintf outc "%a;\n%a" 
		formula_value f proof_value t
	| (Frame (f,p))::[] -> fprintf outc "[ %a :\n%a ]"
		formula_value f proof_value p
	| (Frame (f,p))::t -> fprintf outc "[ %a :\n%a ];\n%a"
		formula_value f proof_value p proof_value t

and formula_value outc = function
	| Lit x     -> fprintf outc "%c" x
	| Neg x     -> fprintf outc "~(%a)" formula_value x
	| And (x,y) -> fprintf outc "(%a)/\\(%a)" formula_value x formula_value y
	| Or (x,y)  -> fprintf outc "(%a)\\/(%a)" formula_value x formula_value y
	| Imp (x,y) -> fprintf outc "(%a)=>(%a)" formula_value x formula_value y
	| Eq (x,y)  -> fprintf outc "(%a)<=>(%a)" formula_value x formula_value y
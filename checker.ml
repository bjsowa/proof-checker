open Core
open Proof
open Producer
open Utilities

let rec frame premises products = function
	| [Formula (f,l)] -> 
		if FormulaSet.mem premises (f,None) ||
		   FormulaSet.mem products (f,None) ||
		   check_introduction premises f
		then f
		else raise (ProofError (f,l))
	| (Formula (f,l))::t -> 
		if FormulaSet.mem premises (f,None)
		then frame premises products t
		else if FormulaSet.mem products (f,None) || check_introduction premises f 
		then frame 
			(FormulaSet.add premises (f,None)) 
			((FormulaSet.remove products (f,None)) $@ (produce premises f)) 
			t
		else raise (ProofError (f,l))
	| (Frame (f,p))::t ->
		let goal = frame 
			(FormulaSet.add premises (f,None)) 
			((FormulaSet.remove products (f,None)) $@ (produce premises f)) 
			p in
		let newf = Imp(f,goal) in
		frame premises (FormulaSet.add products (newf,None)) t
	| _ -> raise FrameError

let check_proof p fill = match p with
	{ name; goal; proof } -> 
	try 
		let res = frame FormulaSet.empty FormulaSet.empty proof in
		if Formula.compare_formula res goal = 0
		then printf "goal %s: proved successfully\n" name
		else eprintf "goal %s: not proved\n" name
	with
		| ProofError (f,l) -> 
			eprintf "goal %s: can't produce formula %a (line %d)\n" name print_formula f l
		| FrameError ->
			eprintf "goal %s: frame doesn't end with formula\n" name
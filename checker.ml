open Core
open Proof
open Producer
open Utilities

let fill_production premises products goal = function
	| Some x -> 
		printf "trying to fill production of formula %a\n" print_formula goal;
		true
	| None -> false

let rec frame premises products fill = function
	| [Formula (f,l)] -> 
		if FormulaSet.mem premises (f,None) ||
		   FormulaSet.mem products (f,None) ||
		   check_introduction premises f ||
		   fill_production premises products f fill
		then f
		else raise (ProofError (f,l))
	| (Formula (f,l))::t -> 
		if FormulaSet.mem premises (f,None)
		then frame premises products fill t
		else if FormulaSet.mem products (f,None) || 
			check_introduction premises f ||
			fill_production premises products f fill
		then frame 
			(FormulaSet.add premises (f,None)) 
			((FormulaSet.remove products (f,None)) $@ (produce premises f)) 
			fill t
		else raise (ProofError (f,l))
	| (Frame (f,p))::t ->
		let goal = frame 
			(FormulaSet.add premises (f,None)) 
			((FormulaSet.remove products (f,None)) $@ (produce premises f)) 
			fill p in
		let newf = Imp(f,goal) in
		frame premises (FormulaSet.add products (newf,None)) fill t
	| _ -> raise FrameError

let check_proof p fill = match p with
	{ name; goal; proof } -> 
	try 
		let res = frame FormulaSet.empty FormulaSet.empty fill proof in
		if Formula.compare_formula res goal = 0
		then printf "goal %s: proved successfully\n" name
		else eprintf "goal %s: not proved\n" name
	with
		| ProofError (f,l) -> 
			eprintf "goal %s: can't produce formula %a (line %d)\n" name print_formula f l
		| FrameError ->
			eprintf "goal %s: frame doesn't end with formula\n" name
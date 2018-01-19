open Core
open Proof
open Producer
open Utilities

let goalname = ref ""
let fill_depth = ref None

let fill_production premises products goal = match !fill_depth with
	| Some depth -> (
		printf "goal %s: trying to fill production of formula %a\n" !goalname print_formula goal;

		let rec print_production premises p =
			let (form,prod) = p in
			if prod = NoParent then () else
			let plist = (match prod with
				| NoParent -> failwith "this should not happen"
				| Frame -> []
				| Unary f1 -> [f1]
				| Binary (f1,f2) -> [f1;f2]
				| Ternary (f1,f2,f3) -> [f1;f2;f3]) in
			List.iter plist (fun prod -> 
				let f = FormulaSet.find premises 
					~f:(fun p -> Formula.compare p (prod,NoParent) = 0) in
				(match f with
					| None -> failwith "this should not happen"
					| Some p -> print_production premises p
				));
			printf "%a\n" print_formula form in

		let rec aux premises products fill =
			if fill <= 0 
			then 
				let () = printf "goal %s: filling production failed!\n" !goalname in
				false 
			else
				let new_products = FormulaSet.fold ~init:FormulaSet.empty products 
					~f:( fun acc (f,_) -> FormulaSet.union acc (produce premises f) ) in
				let premises = FormulaSet.union premises products in
				let new_products = FormulaSet.diff new_products premises in

				let f = FormulaSet.find new_products ~f:( fun x -> Formula.compare x (goal,NoParent) = 0 ) in

				(
					match f with
					| Some p -> 
						printf "goal %s: successfully filled production:\n" !goalname;
						print_production premises p;
						true
					| None -> 
						aux premises new_products (fill-1)
				)

		in aux premises products depth)
	| None -> false

let rec frame premises products = function
	| [Formula (f,l)] -> 
		if FormulaSet.mem premises (f,NoParent) ||
		   FormulaSet.mem products (f,NoParent) ||
		   check_introduction premises f ||
		   fill_production premises products f
		then f
		else raise (ProofError (f,l))
	| (Formula (f,l))::t -> 
		if FormulaSet.mem premises (f,NoParent)
		then frame premises products t
		else if FormulaSet.mem products (f,NoParent) || 
			check_introduction premises f ||
			fill_production premises products f
		then frame 
			(FormulaSet.add premises (f,NoParent)) 
			((FormulaSet.remove products (f,NoParent)) $@ (produce premises f)) 
			t
		else raise (ProofError (f,l))
	| (Frame (f,p))::t ->
		let goal = frame 
			(FormulaSet.add premises (f,NoParent)) 
			((FormulaSet.remove products (f,NoParent)) $@ (produce premises f)) 
			p in
		let newf = Imp(f,goal) in
		frame premises (FormulaSet.add products (newf,Frame)) t
	| _ -> raise FrameError

let check_proof p fill = match p with
	{ name; goal; proof } -> 
	try 
		goalname := name;
		fill_depth := fill;
		let res = frame FormulaSet.empty FormulaSet.empty proof in
		if Formula.compare_formula res goal = 0
		then printf "goal %s: proved successfully\n" name
		else eprintf "goal %s: not proved\n" name
	with
		| ProofError (f,l) -> 
			eprintf "goal %s: can't produce formula %a (line %d)\n" name print_formula f l
		| FrameError ->
			eprintf "goal %s: frame doesn't end with formula\n" name
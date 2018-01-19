open Core
open Proof
open Producer
open Utilities

let fill_production premises products goal = function
	| Some depth -> (
		printf "trying to fill production of formula %a\n" print_formula goal;

		let rec print_production premises p =
			let (form,prod) = p in
			if prod = None then () else
			let plist = (match prod with
				| None -> failwith "this should not happen"
				| Unary f1 -> [f1]
				| Binary (f1,f2) -> [f1;f2]
				| Ternary (f1,f2,f3) -> [f1;f2;f3]) in
			List.iter plist (fun prod -> 
				let f = FormulaSet.find premises 
					~f:(fun p -> Formula.compare p (prod,None) = 0) in
				(match f with
					| None -> failwith "this should not happen"
					| Some p -> print_production premises p
				));
			printf "%a\n" print_formula form in

		let rec aux premises products fill =
			if fill <= 0 
			then 
				let () = printf "filling production failed!\n" in
				false 
			else
				let new_products = FormulaSet.fold ~init:FormulaSet.empty products 
					~f:( fun acc (f,_) -> FormulaSet.union acc (produce premises f) ) in
				let premises = FormulaSet.union premises products in
				let new_products = FormulaSet.diff new_products premises in

				let f = FormulaSet.find new_products ~f:( fun x -> Formula.compare x (goal,None) = 0 ) in

				(
					match f with
					| Some p -> 
						printf "successfully filled production:\n";
						print_production premises p;
						true
					| None -> 
						aux premises new_products (fill-1)
				)

		in aux premises products depth)
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
open Proof
open Core
open Utilities

let andE form = match form with
	| And (l,r) -> FormulaSet.of_list [(l,Unary form);(r, Unary form)]
	| _ -> FormulaSet.empty

let impEl premises form = 
	FormulaSet.filter_map premises
		~f:(function 
			| (Imp(a,b) as f,_) -> 
				if Formula.compare_formula a form = 0 
				then Some (b,Binary (form,f)) else None
			| _ -> None)

let impEr premises form = match form with
	| Imp(a,b) -> 
		if FormulaSet.mem premises (a, NoParent)
		then FormulaSet.singleton (b, Binary(form,a))
		else FormulaSet.empty
	| _ -> FormulaSet.empty

let orE premises form = match form with
	| Or(a,b) ->
		let imA = impEl premises a 
		and imB = impEl premises b in
		let p = FormulaSet.inter imA imB in
		FormulaSet.map p ~f:(fun (f,_) ->
			( f, Ternary(form, Imp(a,f), Imp(b,f)) ))
	| Imp(a,b) ->
		let imA = FormulaSet.filter_map premises
			~f:(function
				| (Imp(c,d),_) -> 
					if Formula.compare_formula d b = 0 then Some (c,NoParent) else None
				| _ -> None)
		and orA = FormulaSet.filter_map premises
			~f:(function
				| (Or(c,d),_) -> 
					if Formula.compare_formula c a = 0 then Some (d,NoParent) 
					else if Formula.compare_formula d a = 0 then Some (c,NoParent)
					else None
				| _ -> None) in
		let p = FormulaSet.inter imA orA in
		FormulaSet.map p ~f:(fun (f,_) ->
			( b, Ternary(Or(a,f), form, Imp(f,b))))
	| _ -> FormulaSet.empty

let eqE premises form = match form with
	| Eq(a,b) -> 
		FormulaSet.of_list [(Imp(a,b), Unary form);(Imp(b,a), Unary form)]
	| _ -> FormulaSet.empty

let eqI premises form = match form with
	| Imp(a,b) ->
		if FormulaSet.mem premises (Imp(b,a),NoParent)
		then FormulaSet.singleton (Eq(a,b), Binary(form, Imp(b,a)))
		else FormulaSet.empty
	| _ -> FormulaSet.empty

let falseI premises form = 
	if FormulaSet.mem premises (Neg(form),NoParent)
	then FormulaSet.singleton (False, Binary(form, Neg(form)))
	else match form with
		| Neg(f) -> 
			if FormulaSet.mem premises (f,NoParent)
			then FormulaSet.singleton (False, Binary(form,f))
			else FormulaSet.empty
		| _ -> FormulaSet.empty

let negE form = match form with
	| Neg(f) -> FormulaSet.singleton (Imp(f,False), Unary(form))
	| _ -> FormulaSet.empty

let negI form = match form with
	| Imp(a,False) -> FormulaSet.singleton (Neg(a), Unary(form))
	| _ -> FormulaSet.empty

let negnegE form = match form with
	| Neg(Neg f) -> FormulaSet.singleton (f, Unary(form))
	| _ -> FormulaSet.empty

let raa form = match form with
	| Imp(Neg(f),False) -> FormulaSet.singleton (f, Unary(form))
	| _ -> FormulaSet.empty

let produce premises form = 
	FormulaSet.diff
	(andE form $@
	impEl premises form $@
	impEr premises form $@
	orE premises form $@
	eqE premises form $@
	eqI premises form $@
	falseI premises form $@
	negE form $@
	negI form $@
	negnegE form $@
	raa form)
	premises

let check_introduction premises form = 
	if FormulaSet.mem premises (False,NoParent)  		(* falseE *)
	then true else match form with
	| And(a,b) ->					  	  			(* andI *)
		FormulaSet.mem premises (a,NoParent) &&
		FormulaSet.mem premises (b,NoParent)
	| Or(a,b) -> 
		(match (a,b) with			  	  			(* magic *)
		| (Neg f1, f2)
		| (f1, Neg f2) -> Formula.compare_formula f1 f2 = 0
		| _ -> false) ||
		FormulaSet.mem premises (a,NoParent) ||  		(* orI *)
		FormulaSet.mem premises (b,NoParent)
	| Eq(a,b) -> Formula.compare_formula a b = 0  	(* eqI1 *)
	| True -> true 					  				(* trueI *)
	| Neg(Neg(f)) -> 
		FormulaSet.mem premises (f,NoParent)			(* negnegI *)
	| _ -> false

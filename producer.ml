open Proof
open Core
open Utilities

let andE form = match form with
	| And (l,r) -> FormulaSet.of_list [l;r]
	| _ -> FormulaSet.empty

let impEl premises form = 
	FormulaSet.filter_map premises
		~f:(function 
			| Imp(a,b) -> if a = form then Some b else None
			| _ -> None)

let impEr premises form = match form with
	| Imp(a,b) -> if FormulaSet.mem premises a
		then FormulaSet.singleton b else FormulaSet.empty 
	| _ -> FormulaSet.empty

let orE premises form = match form with
	| Or(a,b) ->
		let imA = impEl premises a 
		and imB = impEl premises b in
		FormulaSet.inter imA imB
	| Imp(a,b) ->
		let imA = FormulaSet.filter_map premises
			~f:(function
				| Imp(c,d) -> 
					if d = b then Some c else None
				| _ -> None)
		and orA = FormulaSet.filter_map premises
			~f:(function
				| Or(c,d) -> 
					if c = a then Some d 
					else if d = a then Some c
					else None
				| _ -> None) in
		if not (FormulaSet.is_empty @@ FormulaSet.inter imA orA)
		then FormulaSet.singleton b
		else FormulaSet.empty
	| _ -> FormulaSet.empty

let eqE premises form = match form with
	| Eq(a,b) -> 
		FormulaSet.of_list [Imp(a,b);Imp(b,a)]
	| _ -> FormulaSet.empty

let eqI premises form = match form with
	| Imp(a,b) ->
		if FormulaSet.mem premises (Imp(b,a))
		then FormulaSet.of_list [Eq(a,b);Eq(b,a)]
		else FormulaSet.empty
	| _ -> FormulaSet.empty

let falseI premises form = 
	if FormulaSet.mem premises (Neg(form))
	then FormulaSet.singleton False
	else match form with
		| Neg(f) -> 
			if FormulaSet.mem premises f
			then FormulaSet.singleton False
			else FormulaSet.empty
		| _ -> FormulaSet.empty

let negE form = match form with
	| Neg(f) -> FormulaSet.singleton (Imp(f,False))
	| _ -> FormulaSet.empty

let negI form = match form with
	| Imp(a,False) -> FormulaSet.singleton (Neg(a))
	| _ -> FormulaSet.empty

let negnegE form = match form with
	| Neg(Neg f) -> FormulaSet.singleton f
	| _ -> FormulaSet.empty

let raa form = match form with
	| Imp(Neg(f),False) -> FormulaSet.singleton f
	| _ -> FormulaSet.empty

let negnegI form =
	FormulaSet.singleton (Neg(Neg form))

let produce premises form = 
	andE form $@
	impEl premises form $@
	impEr premises form $@
	orE premises form $@
	eqE premises form $@
	eqI premises form $@
	falseI premises form $@
	negE form $@
	negI form $@
	negnegE form $@
	negnegI form $@
	raa form

let check_introduction premises form = 
	if FormulaSet.mem premises False  (* falseE *)
	then true else match form with
	| And(a,b) ->					  (* andI *)
		FormulaSet.mem premises a &&
		FormulaSet.mem premises b
	| Or(Neg a, b) 					  (* magic *)
	| Or(a, Neg b) -> a = b
	| Or(a,b) ->					  (* orI *)
		FormulaSet.mem premises a ||
		FormulaSet.mem premises b
	| Eq(a,b) -> a = b 				  (* eqI1 *)
	| True -> true 					  (* trueI *)
	| _ -> false

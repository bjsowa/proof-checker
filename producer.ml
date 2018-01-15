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
		FormulaSet.filter_map premises
			~f:(function
				| Imp(c,d) -> 
					if c = a then Some(Imp(b,d))
					else if c = b then Some(Imp(a,d))
					else None
				| _ -> None)
	| Imp(a,b) ->
		FormulaSet.filter_map premises
			~f:(function
				| Eq(c,d) ->
					if c = a then Some(Imp(d,b))
					else if d = a then Some(Imp(c,b))
					else None
				| _ -> None)
	| _ -> FormulaSet.empty

let eqI premises form = match form with
	| Imp(a,b) ->
		if FormulaSet.mem premises (Imp(b,a))
		then FormulaSet.of_list [Eq(a,b);Eq(b,a)]
		else FormulaSet.empty
	| _ -> FormulaSet.empty

let produce premises form = 
	andE form $@
	impEl premises form $@
	impEr premises form $@
	orE premises form $@
	eqE premises form $@
	eqI premises form

let check_introduction premises form = match form with
	| And(a,b) ->
		FormulaSet.mem premises a &&
		FormulaSet.mem premises b
	| Or(a,b) ->
		FormulaSet.mem premises a ||
		FormulaSet.mem premises b
	| _ -> false

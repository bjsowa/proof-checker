open Proof
open Core
open Utilities

let andE form = match form with
	| And (l,r) -> [l;r]
	| _ -> []

let impE1 premises form = 
	List.fold premises ~init:[] 
		~f:(fun acc p -> match p with
			| Imp(a,b) -> if formula_equal a form then b::acc else acc
			| _ -> acc)

let impE2 premises form = match form with
	| Imp(a,b) -> if List.exists premises 
		~f:(fun p -> formula_equal p a) then [b] else []
	| _ -> [] 

let orE premises form = match form with
	| Or(a,b) -> 
		let imA = List.fold premises ~init:[]
			~f:(fun acc p -> match p with
				| Imp(x,c) -> if formula_equal a x then c::acc else acc
				| _ -> acc)
		and imB = List.fold premises ~init:[]
			~f:(fun acc p -> match p with
				| Imp(x,c) -> if formula_equal b x then c::acc else acc
				| _ -> acc) in
		List.fold imA ~init:[]
			~f:(fun acc p1 -> if List.exists imB
				~f:(fun p2 -> formula_equal p1 p2) then p1::acc else acc)
	| Imp(a,b) ->
		let imA = List.fold premises ~init:[]
			~f:(fun acc p -> match p with
				| Imp(c,x) -> if formula_equal b x then c::acc else acc
				| _ -> acc)
		and orA = List.fold premises ~init:[]
			~f:(fun acc p -> match p with
				| Or(x,y) -> if formula_equal x a then y::acc else
							 if formula_equal y a then x::acc else acc
				| _ -> acc) in
		if List.exists imA 
			~f:(fun p1 -> List.exists orA
				~f:(fun p2 -> formula_equal p1 p2))
		then [b]
		else []
	| _ -> []

let produce premises form = 
	remove_duplicates @@
		andE form @ 
		impE1 premises form @ 
		impE2 premises form @ 
		orE premises form

let check_introduction premises form = match form with
	| And(a,b) -> 
		List.exists premises ~f:(fun p -> formula_equal a p) &&
		List.exists premises ~f:(fun p -> formula_equal b p)
	| Or(a,b) ->
		List.exists premises ~f:(fun p -> formula_equal a p) ||
		List.exists premises ~f:(fun p -> formula_equal b p)
	| _ -> false
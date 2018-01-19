open Core

type formula = 
	| Lit of char
	| Neg of formula
	| And of (formula * formula)
	| Or of (formula * formula)
	| Imp of (formula * formula)
	| Eq of (formula * formula)
	| True | False
[@@deriving sexp]

type parent = 
    | NoParent
    | Frame
    | Unary of formula
    | Binary of formula * formula
    | Ternary of formula * formula * formula
[@@deriving sexp]

type premise = 
	| Formula of formula * int
	| Frame of formula * (premise list)

type proof =
	{ name : string;
	  goal : formula;
	  proof: premise list; }

exception ProofError of formula * int
exception FrameError


module Formula : sig
	type t = formula * parent [@@deriving sexp]
    val compare_formula : formula -> formula -> int
	include Comparable.S with type t := t
end = struct
	module T = struct
    	type t = formula * parent [@@deriving sexp]

    	let tag_to_int f = match f with
			| Lit _ -> 0 | Neg _ -> 1
			| And _ -> 2 | Or _  -> 3
			| Imp _ -> 4 | Eq _  -> 5
			| True  -> 6 | False -> 7

    	let rec compare_formula f1 f2 = match f1, f2 with
    		| Lit x, Lit y -> Char.compare x y
    		| Neg x, Neg y -> compare_formula x y
    		| Imp (x1,x2), Imp(y1,y2) ->
    			let c = compare_formula x1 y1 in 
    			if c <> 0 then c 
    			else compare_formula x2 y2
    		| And (x1,x2), And(y1,y2)
    		| Or (x1,x2), Or(y1,y2)
    		| Eq (x1,x2), Eq(y1,y2) ->
    			let c = compare_formula x1 y1 in
    			if c <> 0 then
    				let c = compare_formula x1 y2 in
    				if c <> 0 then c
    				else compare_formula x2 y1
    			else compare x2 y2
    		| _ -> Int.compare (tag_to_int f1) (tag_to_int f2)

        let compare (f1,_) (f2,_) = 
            compare_formula f1 f2

  	end
  	include T
  	include Comparable.Make(T)
end

module FormulaSet = Set.Make(Formula)

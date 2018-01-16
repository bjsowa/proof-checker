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
	type t = formula [@@deriving sexp]
	include Comparable.S with type t := t
end = struct
	module T = struct
    	type t = formula [@@deriving sexp]
  	end
  	include T
  	include Comparable.Poly(T)
end

module FormulaSet = Set.Make(Formula)

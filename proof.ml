type formula = 
	| Lit of string
	| Neg of formula
	| And of (formula * formula)
	| Or of (formula * formula)
	| Imp of (formula * formula)
	| Eq of (formula * formula)

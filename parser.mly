%{
    open Proof
%}


%token <char> VAR
%token AND OR NEG IMP EQ
%token LPAREN RPAREN
%token EOF
(* %token GOAL
%token PROOF
%token END
%token LBRACK RBRACK
%token COLON
%token SEMICOLON *)

%right IMP EQ   (* Lowest Precedence *)
%left AND OR    (* Medium Precedence *)
%nonassoc NEG   (* Highest Precedence *)


%start <Proof.formula option> prog

%%

prog: 
    | f = formula EOF  { Some f }
    | EOF              { None   } ;

formula: 
    | f1 = formula; EQ; f2 = formula  { Eq (f1,f2) }
    | f1 = formula; IMP; f2 = formula { Imp (f1,f2) }
    | f1 = formula; AND; f2 = formula { And (f1,f2) }
    | f1 = formula; OR; f2 = formula  { Or (f1,f2) }
    | NEG; f = formula                { Neg f }
    | LPAREN; f = formula; RPAREN     { f } 
    | s = VAR                         { Lit s } ;


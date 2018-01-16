%{
    open Proof
    open Core
    open Lexing
%}


%token <char> VAR
%token <string> STRING
%token GOAL PROOF END
%token AND OR NEG IMP EQ
%token TRUE FALSE
%token LPAREN RPAREN
%token LBRACK RBRACK
%token COLON SEMICOLON 
%token EOF

%right EQ  (* Lowest Precedence *)
%right IMP      
%left AND OR 
%nonassoc NEG  (* Highest Precedence *)

%start <Proof.proof list> prog

%%

prog: 
    | f = list(goal); EOF   { f }

goal:
    | GOAL; n = STRING; COLON; f = formula; PROOF; p = proof; END 
    { {name = n; goal = f; proof = p} }

proof:
    premises = separated_list(SEMICOLON, premise)   { premises }

premise:
    | f = formula                                   { Formula (f,$symbolstartpos.pos_lnum) }
    | LBRACK; f = formula; COLON; p = proof RBRACK  { Frame (f,p) }

formula: 
    | f1 = formula; EQ; f2 = formula                { Eq (f1,f2) }
    | f1 = formula; IMP; f2 = formula               { Imp (f1,f2) }
    | f1 = formula; AND; f2 = formula               { And (f1,f2) }
    | f1 = formula; OR; f2 = formula                { Or (f1,f2) }
    | NEG; f = formula                              { Neg f }
    | LPAREN; f = formula; RPAREN                   { f } 
    | s = VAR                                       { Lit s }
    | TRUE                                          { True }
    | FALSE                                         { False }


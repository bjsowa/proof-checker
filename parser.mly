%{
    open Proof
%}


%token <string> STRING
%token AND
%token OR
%token NEG
%token IMP
%token EQ
%token LBRACK
%token RBRACK
%token EOF
(* %token GOAL
%token PROOF
%token END
%token COLON
%token SEMICOLON *)
%right OR
%right NEG
%right IMP
%right EQ
%right AND

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
    | LBRACK; f = formula; RBRACK     { f }
    | s = STRING                      { Lit s } ;


(*
%token <int> INT
%token <float> FLOAT
%token <string> STRING
%token TRUE
%token FALSE
%token NULL
%token LEFT_BRACE
%token RIGHT_BRACE
%token LEFT_BRACK
%token RIGHT_BRACK
%token COLON
%token COMMA
%token EOF

%start <Json.value option> prog

%%
(* part 1 *)
prog:
  | v = value { Some v }
  | EOF       { None   } ;

value:
  | LEFT_BRACE; obj = obj_fields; RIGHT_BRACE { `Assoc obj  }
  | LEFT_BRACK; vl = list_fields; RIGHT_BRACK { `List vl    }
  | s = STRING                                { `String s   }
  | i = INT                                   { `Int i      }
  | x = FLOAT                                 { `Float x    }
  | TRUE                                      { `Bool true  }
  | FALSE                                     { `Bool false }
  | NULL                                      { `Null       } ;

obj_fields:
    obj = separated_list(COMMA, obj_field)    { obj } ;

obj_field:
    k = STRING; COLON; v = value              { (k, v) } ;

list_fields:
    vl = separated_list(COMMA, value)         { vl } ;
*)
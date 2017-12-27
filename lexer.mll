{
open Lexing
open Parser

exception SyntaxError of string

let next_line lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <-
    { pos with pos_bol = lexbuf.lex_curr_pos;
               pos_lnum = pos.pos_lnum + 1 }
}

let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"
let letter = ['a'-'z' 'A'-'Z']
let name = ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9']+

rule read =
    parse 
    | white    { read lexbuf }
    | newline  { next_line lexbuf; read lexbuf }
    | letter   { VAR (Lexing.lexeme lexbuf).[0] }
    | "goal"   { GOAL }
    | "proof"  { PROOF }
    | "end."   { END }
    | name     { STRING (Lexing.lexeme lexbuf) }
    | ":"      { COLON }
    | ";"      { SEMICOLON }
    | "["      { LBRACK }
    | "]"      { RBRACK }
    | "("      { LPAREN }
    | ")"      { RPAREN }
    | "/\\"    { AND }
    | "\\/"    { OR }
    | "~"      { NEG }
    | "=>"     { IMP }
    | "<=>"    { EQ }
    | eof      { EOF }
    | _ { raise (SyntaxError 
        ("Unexpected char: " ^ Lexing.lexeme lexbuf)) }



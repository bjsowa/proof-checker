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

rule read =
    parse 
    | white    { read lexbuf }
    | newline  { next_line lexbuf; read lexbuf }
    | letter   { VAR (Lexing.lexeme lexbuf).[0] }
    | "("      { LPAREN }
    | ")"      { RPAREN }
    | "/\\"    { AND }
    | "\\/"    { OR }
    | "~"      { NEG }
    | "=>"     { IMP }
    | "<=>"    { EQ }
    | _ { raise (SyntaxError 
        ("Unexpected char: " ^ Lexing.lexeme lexbuf)) }
    | eof      { EOF }



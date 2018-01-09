open Core
open Lexing
open Producer
open Utilities

let rec parse_and_print lexbuf = 
    let rec aux = function
        | [] -> ()
        | h::t -> 
            printf "%a\n" Proof.output_value h;
            aux t
    in aux @@ parse_with_error lexbuf

let loop filename () =
    let inx = In_channel.create filename in
    let lexbuf = Lexing.from_channel inx in
    lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = filename };
    parse_and_print lexbuf;
    In_channel.close inx

(* part 2 *)
let () =
(*     let form = Imp(Lit 'p', Lit 's') in
    let premises = [Or(Lit 'q', Lit 'p');
                    Imp(Lit 'q', Lit 's');
                    Lit 'p' ] in
    let prod = produce premises form in
    printf "%a\n" Proof.formula_value form;
    List.iter prod ~f:(fun f -> printf "%a\n" formula_value f) *)
    Command.basic 
        ~summary:"Parse and display logical formulas"
        Command.Spec.(empty +> anon ("filename" %: file))
        loop 
    |> Command.run

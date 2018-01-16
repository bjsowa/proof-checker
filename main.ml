open Core
open Lexing
open Checker
open Utilities

let main filename () =
    let inx = In_channel.create filename in
    let lexbuf = Lexing.from_channel inx in
    lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = filename };
    
    let proofs = parse_with_error lexbuf in
    List.iter proofs ~f:(fun p -> check_proof p);

    In_channel.close inx

let () =
    Command.basic 
        ~summary:"Check the correctness of proof of classical logic formula in the natural deduction system"
        Command.Spec.(empty +> anon ("filename" %: file))
        main 
    |> Command.run

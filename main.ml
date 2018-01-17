open Core
open Lexing
open Checker
open Utilities

let main filename parse fill () =
    let inx = In_channel.create filename in
    let lexbuf = Lexing.from_channel inx in
    lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = filename };

    let proofs = parse_with_error lexbuf in (
        if parse 
        then List.iter proofs ~f:(printf "%a\n" print_proof)
        else List.iter proofs ~f:(fun p -> check_proof p fill)
    );
    In_channel.close inx

let () =
    Command.basic_spec
        ~summary:"Check the correctness of proof of classical logic formula in the natural deduction system"
        Command.Spec.(empty 
            +> anon ("filename" %: file)
            +> flag "-parse" no_arg ~doc:"only print parsed proofs"
            +> flag "-fill" (optional int) ~doc:"D try to fill the gaps in proof. Consider only up to D formulas")
        main 
    |> Command.run

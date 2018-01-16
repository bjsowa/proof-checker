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
    Command.basic 
        ~summary:"Check the correctness of proof of classical logic formula in the natural deduction system"
        Command.Spec.(empty 
            +> anon ("filename" %: file)
            +> flag "-parse" no_arg ~doc:"only print parsed proofs"
            +> flag "-fill" (optional int) ~doc:"D fill")
        main 
    |> Command.run

(* open Proof

let () = 
    let set1 = FormulaSet.of_list [Lit 'x'; Lit 'y'; Lit 'z'] in
    let set2 = FormulaSet.of_list [Lit 'z'; Lit 'a'] in
    let diff = FormulaSet.diff set2 set1 in
    FormulaSet.iter diff ~f:(printf "%a\n" print_formula) *)
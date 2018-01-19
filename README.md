# Proof Checker
Program sprawdzający poprawność dowodów formuł logiki klasycznej w systemie dedukcji naturalnej

## Wymagania
- [Ocaml][ocaml], testowano na 4.05.0
- [Core][core], testowano na 0.10.0
- [menhir][menhir], testowano na 20171222
- [ocamlbuild][ocamlbuild], testowano na 0.12.0
- [ppx_sexp_conv][ppx], testowano na 0.10.0

do uruchomienia testów:

- Python, testowano na 2.7.14
- [cram][cram] 0.7

## Jak kompilować
Wystarczy użyć dołączonego pliku makefile wpisując w konsoli:

- `make` - kompilacja
- `make test` - kompilacja i uruchomienie testów
- `make clean` - usunięcie plików powstałych w wyniku kompilacji

## Jak używać
>    ./main.native [NAZWA_PLIKU]

[ocaml]: http://caml.inria.fr
[core]: https://opam.ocaml.org/packages/core/core.v0.10.0/
[menhir]: https://opam.ocaml.org/packages/menhir/menhir.20171222/
[ocamlbuild]: https://opam.ocaml.org/packages/ocamlbuild/ocamlbuild.0.12.0/
[ppx]: https://opam.ocaml.org/packages/ppx_sexp_conv/ppx_sexp_conv.v0.10.0
[cram]: https://pypi.python.org/pypi/cram/0.7

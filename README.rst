Proof Checker
=============
Program sprawdzający poprawność dowodów formuł logicznych w systemie dedukcji naturalnej

Wymagania
---------
- Ocaml_, testowano na 4.05.0
- Core_, testowano na 0.10.0
- menhir_, testowano na 20171222
- ocamlbuild_, testowano na 0.12.0
do odpalenia testów:

- Python, testowano na 2.7.14
- cram_ 0.7

Jak kompilować
--------------
Wystarczy użyć dołączonego pliku makefile wpisując w konsoli:

- ``make`` - kompilacja
- ``make test`` - kompilacja i odpalenie testów
- ``make clean`` - usunięcie plików powstałych w wyniku kompilacji

Jak używać
----------
``./main.native [NAZWA_PLIKU]``

.. _OCaml: http://caml.inria.fr
.. _Core: https://opam.ocaml.org/packages/core/core.v0.10.0/
.. _menhir: https://opam.ocaml.org/packages/menhir/menhir.20171222/
.. _cram: https://pypi.python.org/pypi/cram/0.7
.. _ocamlbuild: https://opam.ocaml.org/packages/ocamlbuild/ocamlbuild.0.12.0/
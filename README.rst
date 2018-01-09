Proof Checker
=============
Program sprawdzający poprawność dowodów formuł logicznych w systemie dedukcji naturalnej

Wymagania
---------
- Ocaml_, testowano na 4.05.0
- Core_, testowano na 0.9.1
- menhir_, testowano na 20171013
- ocamlbuild, testowano na 0.11.0
- GNU Make, testowano na 4.1
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
.. _Core: https://opam.ocaml.org/packages/core/core.113.33.03/
.. _menhir: https://opam.ocaml.org/packages/menhir/
.. _cram: https://pypi.python.org/pypi/cram

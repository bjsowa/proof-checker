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
``./test.native [NAZWA_PLIKU]``

Aktualny stan projektu
----------------------
W tej chwili mam działający parser

Plany dalszej pracy
-------------------
1. Parsowanie więcej niż jednego dowodu z jednego pliku
2. Funkcja sprawdzająca czy dwie formuły są izomorficzne
3. Funkcja tworząca listę możliwych produkcji z dostępnych przesłanek
4. Sprawdzanie poprawności dowodów

   - sprawdzanie czy dana produkcja może być otrzymana z dostępnych przesłanek  
   - przekazywanie dostępnych przesłanek do następnego elementu
   - zadbanie o to, żeby przesłanki nie były dostępne na zewnątrz ramki
   - wypisywanie błędów wraz z miejscem ich wystąpienia (trzeba jakoś zapamiętać te miejsca)

.. _OCaml: http://caml.inria.fr
.. _Core: https://opam.ocaml.org/packages/core/core.113.33.03/
.. _menhir: https://opam.ocaml.org/packages/menhir/
.. _cram: https://pypi.python.org/pypi/cram

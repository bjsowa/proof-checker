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
```
./main.native [OPCJE] [ŚCIEŻKA_DO_PLIKU]
```

dostępne opcje:
* `-parse` - wypisz tylko sparsowany plik
* `-fill [D]` - spróbuj uzupełnić luki w dowodzie (szczegóły w dalszej części)

## Specyfikacja wejścia

W pliku może znajdować się więcej niż jeden dowód. Każdy z nich zostanie sprawdzony osobno.

**Dowód**

Ogólny Schemat dowodu wygląda następująco:
```
goal (NAZWA): (FORMUŁA)
proof
(LISTA PRZESŁANEK)
end.
```
Przesłanki muszą być oddzielone znakiem `;`. 

**Przesłanka**
```
(FORMUŁA | RAMKA)
```
Każda przesłanka musi być formułą albo ramką

**Formuła**

Formuła składa się z:
- zmiennych zdaniowych - jedna litera (duża lub mała) z wyjątkiem liter `T` i `F`
- stałych logicznych - `T` (true) i `F` (false)
- nawiasów okrągłych 
- operatorów logicznych:

| Operator | Znaczenie    | Asocjatywność | Pierwszeństwo |
|:--------:|--------------|---------------|---------------|
|    <=>   | równoważność |     prawo     |       1       |
|    =>    | implikacja   |     prawo     |       2       |
|    /\\   | koniunkcja   |      lewo     |       3       |
|    \\/   | alternatywa  |      lewo     |       3       |
|     ~    | negacja      |       -       |       4       |

**Ramka**
```
[ (FORMUŁA):
  (LISTA PRZESŁANEK) ]
```
Ramka zaczyna się od założenia, a następnie wyprowadzane są kolejne przesłanki. Ostatnia przesłanka zostanie uznana za udowodnioną tezę

### Przykład
```
goal morgan: ~(p /\ q) => ~q \/ ~p
proof
  [ ~(p /\ q) :
    [ ~(~q \/ ~p) :
      [ ~q :
        ~q \/ ~p;
        F];
      ~q => F;
      q;
      [ ~p :
        ~q \/ ~p;
        F];
      ~p => F;
      p;
      p /\ q;
      F];
    ~(~q \/ ~p) => F;
    ~~(~q \/ ~p);
    ~q \/ ~p ];
  ~(p /\ q) => ~q \/ ~p
end.
```

[ocaml]: http://caml.inria.fr
[core]: https://opam.ocaml.org/packages/core/core.v0.10.0/
[menhir]: https://opam.ocaml.org/packages/menhir/menhir.20171222/
[ocamlbuild]: https://opam.ocaml.org/packages/ocamlbuild/ocamlbuild.0.12.0/
[ppx]: https://opam.ocaml.org/packages/ppx_sexp_conv/ppx_sexp_conv.v0.10.0
[cram]: https://pypi.python.org/pypi/cram/0.7

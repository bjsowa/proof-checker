.PHONY: all test clean

TAGS = -tag thread
PKGS = -pkg core,ppx_sexp_conv
FLAGS = -use-menhir -use-ocamlfind $(TAGS) $(PKGS)
OUT = main.native

all:
	ocamlbuild $(FLAGS) $(OUT)

TESTS=test1.t test2.t test3.t fail.t
test: all
	cd tests; \
	cram -v $(TESTS)

clean:
	rm -rf _build 
	rm -f $(OUT)
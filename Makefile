.PHONY: all test clean

TAGS = -tag thread
PKGS = -pkg core,ppx_sexp_conv
FLAGS = -use-menhir -use-ocamlfind $(TAGS) $(PKGS)
OUT = main.native

all:
	ocamlbuild $(FLAGS) $(OUT)

TESTS=fail_parser.t test_success.t
test: all
	cd tests; \
	cram -v $(TESTS)

clean:
	rm -rf _build 
	rm -f $(OUT)
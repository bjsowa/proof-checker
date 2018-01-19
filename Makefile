.PHONY: all test clean

TAGS = -tag thread
PKGS = -pkg core,ppx_sexp_conv
FLAGS = -use-menhir -use-ocamlfind $(TAGS) $(PKGS)
OUT = main.native

all:
	ocamlbuild $(FLAGS) $(OUT)

TESTS=success_parser.t fail_parser.t \
success_checker.t fail_checker.t \
success_fill.t fail_fill.t
test: all
	cd tests; \
	cram -v $(TESTS)

clean:
	rm -rf _build 
	rm -f $(OUT)
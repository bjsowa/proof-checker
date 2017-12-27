.PHONY: all clean

TAGS = -tag thread
PKGS = -pkg core
FLAGS = -use-menhir -use-ocamlfind $(TAGS) $(PKGS)
OUT = test.native

all:
	ocamlbuild $(FLAGS) $(OUT)

# test: all
# 	cram tests/tests.t

clean:
	rm -rf _build 
	rm -f $(OUT)
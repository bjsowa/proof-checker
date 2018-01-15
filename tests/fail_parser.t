  $ PARSECMD="$TESTDIR/../main.native"

Lexer error:
  $ $PARSECMD $TESTDIR/fail_parser1.pf
  *tests/fail_parser1.pf:5:*: Unexpected char: . (glob)
  [1]

Parser error:
  $ $PARSECMD $TESTDIR/fail_parser2.pf
  *tests/fail_parser2.pf:5:*: syntax error (glob)
  [1]
  $ PARSECMD="$TESTDIR/../test.native"

Lexer error:
  $ $PARSECMD $TESTDIR/fail1.pf
  *tests/fail1.pf:5:*: Unexpected char: . (glob)

Parser error:
  $ $PARSECMD $TESTDIR/fail2.pf
  *tests/fail2.pf:5:*: syntax error (glob)
  [1]
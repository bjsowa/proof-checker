  $ PARSECMD="$TESTDIR/../main.native"

  $ $PARSECMD $TESTDIR/fail_checker.pf
  goal test1: frame doesn't end with formula
  goal test2: can't produce formula ((A)=>(B))=>(A) (line 13)
  goal test3: can't produce formula r (line 24)
  goal eq: not proved
  goal negimp: can't produce formula (p)=>(F) (line 58)
  goal morgan: can't produce formula ~(~((~(p))\/(~(p)))) (line 83)

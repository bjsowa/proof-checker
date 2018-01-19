  $ PARSECMD="$TESTDIR/../main.native -fill 2"

  $ $PARSECMD $TESTDIR/fail_fill.pf
  goal test1: trying to fill production of formula (B)=>(A)
  goal test1: filling production failed!
  goal test3: trying to fill production of formula r
  goal test3: filling production failed!
  goal eq: trying to fill production of formula ((p)/\(q))=>(r)
  goal eq: filling production failed!
  goal negimp: trying to fill production of formula (p)=>(F)
  goal negimp: filling production failed!
  goal morgan: trying to fill production of formula F
  goal morgan: filling production failed!
  goal test1: can't produce formula (B)=>(A) (line 8)
  goal test3: can't produce formula r (line 18)
  goal eq: can't produce formula ((p)/\(q))=>(r) (line 45)
  goal negimp: can't produce formula (p)=>(F) (line 56)
  goal morgan: can't produce formula F (line 74)

  $ PARSECMD="$TESTDIR/../main.native -fill 5"

  $ $PARSECMD $TESTDIR/success_fill.pf
  goal test1: trying to fill production of formula B
  goal test1: successfully filled production:
  A
  (A)=>(B)
  B
  goal test1: proved successfully
  goal eq: trying to fill production of formula r
  goal eq: successfully filled production:
  p
  (q)=>(r)
  q
  r
  goal eq: proved successfully
  goal negimp: trying to fill production of formula (q)=>(F)
  goal negimp: successfully filled production:
  ~(q)
  (q)=>(F)
  goal negimp: trying to fill production of formula q
  goal negimp: successfully filled production:
  (p)=>(q)
  q
  goal negimp: trying to fill production of formula ~(p)
  goal negimp: successfully filled production:
  (p)=>(F)
  ~(p)
  goal negimp: proved successfully
  goal morgan: trying to fill production of formula q
  goal morgan: successfully filled production:
  (~(q))=>(F)
  q
  goal morgan: trying to fill production of formula p
  goal morgan: successfully filled production:
  (~(p))=>(F)
  p
  goal morgan: trying to fill production of formula (~(q))\/(~(p))
  goal morgan: successfully filled production:
  (~((~(q))\/(~(p))))=>(F)
  (~(q))\/(~(p))
  goal morgan: proved successfully

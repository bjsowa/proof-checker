  $ PARSECMD="$TESTDIR/../test.native"

  $ $PARSECMD $TESTDIR/test3.pf
  goal test3: (((p)\/(q))=>(r))=>(((p)=>(r))/\((q)=>(r)))
  proof
  [ ((p)\/(q))=>(r) :
  [ p :
  (p)\/(q);
  r ];
  (p)=>(r);
  [ q :
  (p)\/(q);
  r ];
  (q)=>(r);
  ((p)=>(r))/\((q)=>(r)) ];
  (((p)\/(q))=>(r))=>(((p)=>(r))/\((q)=>(r)))
  end.

Test if it can be reparsed:

  $ $PARSECMD $TESTDIR/test3.pf > $TESTDIR/test3.out
  $ $PARSECMD $TESTDIR/test3.out
  goal test3: (((p)\/(q))=>(r))=>(((p)=>(r))/\((q)=>(r)))
  proof
  [ ((p)\/(q))=>(r) :
  [ p :
  (p)\/(q);
  r ];
  (p)=>(r);
  [ q :
  (p)\/(q);
  r ];
  (q)=>(r);
  ((p)=>(r))/\((q)=>(r)) ];
  (((p)\/(q))=>(r))=>(((p)=>(r))/\((q)=>(r)))
  end.

  $ rm -f $TESTDIR/test3.out
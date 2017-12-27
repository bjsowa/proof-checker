  $ PARSECMD="$TESTDIR/../test.native"

Example proof from pdf:

  $ $PARSECMD $TESTDIR/test1.pf
  goal test1: ((A)/\((A)=>(B)))=>(B)
  proof
  [ (A)/\((A)=>(B)) :
  A;
  (A)=>(B);
  B ];
  ((A)/\((A)=>(B)))=>(B)
  end.

Test if it can be reparsed:

  $ $PARSECMD $TESTDIR/test1.pf > $TESTDIR/test1.out
  $ $PARSECMD $TESTDIR/test1.out
  goal test1: ((A)/\((A)=>(B)))=>(B)
  proof
  [ (A)/\((A)=>(B)) :
  A;
  (A)=>(B);
  B ];
  ((A)/\((A)=>(B)))=>(B)
  end.

  $ rm -f $TESTDIR/test1.out
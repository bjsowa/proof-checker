  $ PARSECMD="$TESTDIR/../test.native"

  $ $PARSECMD $TESTDIR/test2.pf
  goal test2: (A)=>((B)=>(A))
  proof
  [ A :
  [ B :
  A ];
  (B)=>(A) ];
  (A)=>((B)=>(A))
  end.

Test if it can be reparsed:

  $ $PARSECMD $TESTDIR/test2.pf > $TESTDIR/test2.out
  $ $PARSECMD $TESTDIR/test2.out
  goal test2: (A)=>((B)=>(A))
  proof
  [ A :
  [ B :
  A ];
  (B)=>(A) ];
  (A)=>((B)=>(A))
  end.

  $ rm -f $TESTDIR/test2.out
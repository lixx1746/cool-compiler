
(*  Example cool program testing as many aspects of the code generator
    as possible.
 *)

class Main {
  hw:Helloworld <- (new Helloworld);
  mc:Myclass <- (new Myclass);
  test:A <- (new B);
  hi:Myclass;
  firstint:Int;
  secondint:Int <- 6 + 3;
  thirdint:Int <- (1 + 5) + 8;
  --fourint:Int <- 1 + (5 + 8);
  main():Int {
    {
      hw.say();
      hi.hello();
    }
  };
};

class A {
  a:Object;
  --b:IO2 <- (new IO2);
  myself:A <- new SELF_TYPE;
};

class B inherits A {
  c:String;
  d:Bool <- true;
  -- test code generated for new__class
  e:Object <- (new Object);
  f:Int <- (new Int);
  g:Bool <- (new Bool);
  h:String <- (new String);
  i:IO <- (new IO);
  j:Main <- (new Main);
  k:Helloworld <- (new Helloworld);
};

class Helloworld inherits Main {
  myint:Int;
  myint2:Int <- 5;
  myint3:Int <- myint2;
  myint4:Int;
  mystr:String;
  mystr2:String <- "hello";
  mybool:Bool;
  mybool2:Bool <- true;
  mybool3:Bool <- false;
  blah:Myclass;
  myobj:Object;
  myobj2:Object <- 6;
  say():Int {
    {
      --out_string("hello world");
      1;
    }
  };
};

class Myclass {
  a:Int;
  b:Int;
  c:Int <- 8;
  hello():Int {
    {
      a <- 5;
      b <- c;
    }
  };
};

class IO2 inherits IO {
    asdf : Int;
};

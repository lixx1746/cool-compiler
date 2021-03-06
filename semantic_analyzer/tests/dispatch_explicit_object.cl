(* Testing explicitly defined object dispatch *)

Class Main {
	attr_one:A <- new B;
	attr_two:A <- new C;
	attr_three:A <- new A;
	attr_four:C <- new C;
	main():String {
	    {
		attr_one.a(5, "hello");
		attr_one.a(5, "hello", "extra argument");
		attr_two.a("hello", 5);
		attr_two.b(attr_three, attr_four);
		attr_one.b(attr_four, attr_three);
		attr_four.c((new C), (new A));
		attr_four.c((new A), (new C));
	    }
	};
};

Class A {
	a(arg_one:Int, arg_two:String):Int {
		5
	};
};

Class B inherits A {
	b(arg_one:A, arg_two:C):String {
		"return"
	};
};

Class C inherits A {
	c(arg_one:B, arg_two:A):String {
		"return"
	};
};

(* CS540 Carl Chapman:  Programming Assignment 1 *)
 
class El inherits IO{
    next : El;
    getNext() : El {next};
    setNext(el : El) : Object {{next <- el;}};
    getVal() : Int {{abort(); 0;}};
    isDummyElement() : Bool {next = self}; 
    printElement() : SELF_TYPE {out_string("we never print the dummy element")};
};

class PlusEl inherits El{
    printElement() : SELF_TYPE {out_string("+\n")};
};

class SwapEl inherits El{
    printElement() : SELF_TYPE {out_string("s\n")};
};

class IntEl inherits El{
    val: Int;
    getVal() : Int {val};
	init(n : Int) : IntEl {{val <- n; self;}};
	printElement() : SELF_TYPE {out_string((new A2I).i2a(val).concat("\n"))};
};

class CustomStack {
    top : El;
	init() : CustomStack {{top <- new El; top.setNext(top); self;}};
    push(e : El) : Object {{e.setNext(top); top <- e;}};
    display() : Object {
        {
            (let temp : El <- top in
                while not(temp.isDummyElement())
                loop 
                {
                    temp.printElement();
                    temp <- temp.getNext();
                } 
                pool 
            );
        }
    };
    
    evaluate() : Object {
        {
            (let operator : El <- top, left : El <- operator.getNext(), right : El <- left.getNext() in
                case operator of
                    plus : PlusEl =>    
                        {
                            top <- (new IntEl).init(left.getVal() + right.getVal());
                            top.setNext(right.getNext());
                        };
                    swap : SwapEl =>
                        {
                            left.setNext(right.getNext());
                            right.setNext(left);
                            top <- right;
                        };
                    el : El => {self;};
                esac
            );
        }
    };    
};

class Main inherits IO {
    input : String;
    customStack : CustomStack;
   	main() : Object {
	   {
	   input <- "initially not x";
	   customStack <- (new CustomStack).init();
	   (while not(input = "x")
		    loop 
		    {
	        out_string(">");
	        input <- in_string();
            respond(input, customStack);
		    } 
		    pool 
		);
	   }
	};
	
	respond(input: String, stack : CustomStack) : Object{
		    if input = "x" then {self;} 
	        else if input = "d" then {stack.display();}
	        else if input = "e" then {stack.evaluate();}
	        else if input = "s" then {stack.push(new SwapEl);}
            else if input = "+" then {stack.push(new PlusEl);}
            else {stack.push((new IntEl).init((new A2I).a2i(input)));}
	        fi fi fi fi fi
	};
};
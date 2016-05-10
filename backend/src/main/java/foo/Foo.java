package foo;

/**
 * Foo class
 */
public class Foo {

	public int i;

    public static int div(int a, int b) {
    	if (b == 0) {
    		throw new UnsupportedOperationException("Can't divide by zero!");
    	}

    	System.out.println("foo");
    	
        return a / b;  
    }

}

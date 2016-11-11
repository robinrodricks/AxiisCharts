package com.vizsage.as3mathlib.math.alg {
/**
 * @class       com.vizsage.as3mathlib.math.alg.Complex
 * @author      Richard Wright
 * @version     1.7
 * @description Implements the static behaviours of the Complex Class, with
 *              algorithm logic based on the use of reverse Polish notation.
 *              <p>
 *		        Supports all functions pertaining to the complex number calculator
 *              and three added functions that are beyond the calculator's scope.
 *              The calculator is capable of performing all basic operations:
 *              powers, roots, logarithms, trigonometric functions, hyperbolic
 *              functions, gamma and polygamma functions. Other than the following
 *              exceptions, all methods call an inner 'Complex.input(re, im)' method
 *              to capture the values of the two UI input fields for manipulation
 *              within the outer method:
 *              <blockquote><pre>
 *              - new complex number instantiation (C button).
 *              - new Math.PI complex number instantiation (Pi button).
 *              - hold active complex number in memory (MR button).
 *              </pre></blockquote>
 *              Although many of the methods are only used privately within the
 *              class for the calculator's procedures, I have left all methods
 *              declared as 'public static' to be able to utilize all class methods
 *              in other application structures.
 * @usage       <pre>
 *              var inst:Complex = new Complex(re, im);
 *              Complex.classMethod(args);</pre>
 * @param       re (Number)  -- real portion of complex number from re_txt string
 *                              converted in UI.
 * @param       im (Number)  --imaginary portion of complex number from im_txt
 *                             string converted in UI.
 * -----------------------------------------------
 * Latest update: August 8, 2004
 * -----------------------------------------------
 * AS2 revision copyright � 2003, Richard Wright [wisolutions2002@shaw.ca]
 * JS  original copyright � 2003, Dario Alpern   [http://www.alpertron.com.ar/ENGLISH.HTM]
 * -----------------------------------------------
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     - Redistributions of source code must retain the above copyright notice,
 *       this list of conditions and the following disclaimer.
 *
 *     - Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 *     - Neither the name of this software nor the names of its contributors
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * -----------------------------------------------
 * Functions:
 *     Complex(re, im)
 *           1.  input(re, im)
 *           2.  arg(x, y)
 *           3.  chSign(c)
 *           4.  norm(c)
 *           5.  rAbs(c)
 *           6.  abs(c)
 *           7.  timesi(c)
 *           8.  timesi3(c)
 *           9.  adds(c1, c2)
 *           10. subt(c1, c2)
 *           11. mult(c1, c2)
 *           12. div(c1, c2)
 *           13. log(c)
 *           14. exp(c)
 *           15. sqrt(c)
 *           16. power(c1, c2)
 *           17. root(c1, c2)
 *           18. rSinh(r)
 *           19. rCosh(r)
 *           20. sin(c)
 *           21. cos(c)
 *           22. tan(c)
 *           23. cot(c)
 *           24. sec(c)
 *           25. cosec(c)
 *           26. asin(c)
 *           27. acos(c)
 *           28. atan(c)
 *           29. acot(c)
 *           30. asec(c)
 *           31. acosec(c)
 *           32. sinh(c)
 *           33. cosh(c)
 *           34. tanh(c)
 *           35. coth(c)
 *           36. sech(c)
 *           37. cosech(c)
 *           38. asinh(c)
 *           39. acosh(c)
 *           40. atanh(c)
 *           41. acoth(c)
 *           42. asech(c)
 *           43. acosech(c)
 *           44. contFrac(arguments)
 *           45. factorial(c)
 *           46. equals(c1, c2)
 *           47. conjugate(c)
 *           48. modulo(c)
 *           49. logGamma(c)
 *           50. diGamma(c)
 *           51. triGamma(c)
 *           52. tetraGamma(c)
 *           53. pentaGamma(c)
 *           54. hexaGamma(c)
 *         - getters/setters
 *           55. get _real()
 *           55. set _real()
 *           56. get _imag()
 *           56. set _imag()
 * -----------------------------------------------
 *  Updates may be available at:
 *              http://members.shaw.ca/flashprogramming/wisASLibrary/wis/
 * -----------------------------------------------
**/

public class Complex {
	/**
	 * @property $r  (Number)  -- real portion of complex number, any real number.
	 * @property $i  (Number)  -- imaginary portion of complex number, any real number.
	 * @property Mem  (Complex)  -- static -- holder for saved complex number.
	 * @property One  (Complex)  -- static -- identity instantiated complex number.
	 * @property Pi  (Complex)  -- static -- pi instantiated complex number.
	 * @property ToRad  (Complex)  -- static -- (to radio group) rad-to-deg instantiated complex number for radio group manipulation.
	**/
    private var $r:Number;
    private var $i:Number;
    public static var Mem:Complex   = new Complex(0, 0);
    public static var One:Complex   = new Complex(1, 0);
    public static var Pi:Complex    = new Complex(Math.PI, 0);
    public static var ToRad:Complex = new Complex(180/Math.PI, 0);

    // constructor
    public function Complex(re:Number, im:Number) {
        //trace ("$$ Complex Class fired! $$");
        $r = re;
        $i = im;
    }

      // 1. input --------------------------------------

    /**
     * @method  input
     * @description  Main public  method for capture of UI input from textfields to
     *               instantiate a new Complex class instance.
     * @usage  <pre>Complex.input(re, im);</pre>
     * @param   re   (Number)  -- real portion of complex number from re_txt string converted in UI.
     * @param   im   (Number)  -- imaginary portion of complex number from im_txt string converted in UI.
     * @return  (Complex)  -- returns a new Complex object.
    **/
    public static function input(re:Number, im:Number):Complex {
        var oldRe:String = re.toString();
        var oldIm:String = im.toString();
        var newRe:String = ""
        var newIm:String = "";
        var j:Number;

        for (j=0;j<oldRe.length;j++) {
            if (oldRe.charAt(j)==", ") newRe += ".";
            else newRe += oldRe.charAt(j);
        }
        for (j=0;j<oldIm.length;j++) {
            if (oldIm.charAt(j)==", ") newIm += ".";
            else newIm += oldIm.charAt(j);
        }

        return new Complex(parseFloat(newRe), parseFloat(newIm));
    }

      // 2. arg ----------------------------------------

    /**
     * @method  arg
     * @description  Method used within 'log' and 'atan' methods.
     * @usage  <pre>Complex.arg(x, y);</pre>
     * @param   x   (Number)  -- any real number.
     * @param   y   (Number)  -- any real number.
     * @return  (Number)  -- returns a real number based on input signs.
    **/
    public static function arg(x:Number, y:Number):Number {
        if (x>0) return Math.atan(y/x);
        if (x<0 && y>=0) return Math.PI+Math.atan(y/x);
        if (x<0 && y<0) return -Math.PI+Math.atan(y/x);
        if (y>0) return Math.PI/2;
        if (y<0) return -Math.PI/2;

        return 0;
    }

      // 3. chSign -------------------------------------

    /**
     * @method  chSign
     * @description  Method used within 'asinh' method and called with
     *               'chSign' button in UI.
     * @usage  <pre>Complex.chSign(c);</pre>
     * @param   c   (Complex)  -- 'log' of 'asinh' inner c2 complex number, or UI complex input.
     * @return  (Complex)  -- returns a modified Complex object.
    **/
    public static function chSign(c:Complex):Complex {
        c.$r = -c.$r;
        c.$i = -c.$i;

        return c;
    }

      // 4. norm ----------------------------------------

    /**
     * @method  norm
     * @description  Complex normal method used within 'atan', 'asinh',
     *               and 'acosh' methods as a boolean construct.
     * @usage  <pre>Complex.norm(c);</pre>
     * @param   c   (Complex)  -- complex number to be normalized.
     * @return  (Number)  -- returns a real number.
    **/
    public static function norm(c:Complex):Number {
        return(c.$r*c.$r+c.$i*c.$i);
    }

      // 5. rAbs ---------------------------------------

    /**
     * @method  rAbs
     * @description  Used within 'abs', 'log', and 'sqrt' methods.
     * @usage  <pre>Complex.rAbs(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Number)  -- returns a positive real number.
    **/
    public static function rAbs(c:Complex):Number {
        if (Math.abs(c.$r)>Math.abs(c.$i)) {
            return Math.abs(c.$r)*Math.sqrt(1+(c.$i/c.$r)*(c.$i/c.$r));
        }

        return Math.abs(c.$i)*Math.sqrt(1+(c.$r/c.$i)*(c.$r/c.$i));
    }

      // 6. abs ----------------------------------------

    /**
     * @method  abs
     * @description  Method called by the UI abs button.
     * @usage  <pre>Complex.abs(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)    -- returns a new Complex object.
    **/
    public static function abs(c:Complex):Complex {
        return new Complex(Complex.rAbs(c), 0);
    }

      // 7. timesi -------------------------------------

    /**
     * @method  timesi
     * @description  Input is multiplied by i ... (sqrt(-1)).
     * @usage <pre>Complex.timesi(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a new Complex object.
    **/
    public static function timesi(c:Complex):Complex {
        return new Complex(-c.$i, c.$r);
    }

      // 8. timesi3 ------------------------------------

    /**
     * @method  timesi3
     * @description  Input is multiplied by i^3 ... (sqrt(-1)^3).
     * @usage <pre>Complex.timesi3(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a new Complex object.
    **/
    public static function timesi3(c:Complex):Complex {
        return new Complex(c.$i, -c.$r);
    }

      // 9. adds ---------------------------------------

    /**
     * @method  adds
     * @description  Adds two complex numbers.
     * @usage <pre>Complex.adds(c1, c2);</pre>
     * @param   c1   (Complex)  -- complex number input.
     * @param   c2   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a new Complex object.
    **/
    public static function adds(c1:Complex, c2:Complex):Complex {
        return new Complex(c1.$r+c2.$r, c1.$i+c2.$i);
    }

      // 10. subt ---------------------------------------

    /**
     * @method  subt
     * @description  Subtracts two complex numbers.
     * @usage <pre>Complex.subt(c1, c2);</pre>
     * @param   c1   (Complex)  -- complex number input.
     * @param   c2   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a new Complex object.
    **/
    public static function subt(c1:Complex, c2:Complex):Complex {
        return new Complex(c1.$r-c2.$r, c1.$i-c2.$i);
    }

      // 11. mult ---------------------------------------

    /**
     * @method  mult
     * @description  Multiplies two complex numbers.
     * @usage <pre>Complex.mult(c1, c2);</pre>
     * @param   c1   (Complex)  -- complex number input.
     * @param   c2   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a new Complex object.
    **/
    public static function mult(c1:Complex, c2:Complex):Complex {
        return new Complex(c1.$r*c2.$r - c1.$i*c2.$i, c1.$i*c2.$r + c1.$r*c2.$i);
    }

      // 12. div ----------------------------------------

    /**
     * @method  div
     * @description  Divides two complex numbers.
     * @usage <pre>Complex.div(c1, c2);</pre>
     * @param   c1   (Complex)  -- complex number input.
     * @param   c2   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a new Complex object.
    **/
    public static function div(c1:Complex, c2:Complex):Complex {
        var r:Number;
	    var s:Number;

        if (Math.abs(c2.$r)>=Math.abs(c2.$i)) {
            r = c2.$i/c2.$r;
            s = c2.$r+r*c2.$i;

            return new Complex((c1.$r+c1.$i*r)/s, (c1.$i-c1.$r*r)/s);
        }
        r = c2.$r/c2.$i;
        s = c2.$i+r*c2.$r;

        return new Complex((c1.$r*r+c1.$i)/s, (c1.$i*r-c1.$r)/s);
    }

      // 13. log ----------------------------------------

    /**
     * @method  log
     * @description  Calculates the logarithm of the complex number.
     * @usage <pre>Complex.log(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a new Complex object.
    **/
    public static function log(c:Complex):Complex {
        return new Complex(Math.log(Complex.rAbs(c)), Complex.arg(c.$r, c.$i));
    }

      // 14. exp ----------------------------------------

    /**
     * @method  exp
     * @description  Calculates the product of the exponential number and
     *               the complex number.
     * @usage <pre>Complex.exp(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a new Complex object.
    **/
    public static function exp(c:Complex):Complex {
        return new Complex(Math.exp(c.$r)*Math.cos(c.$i), Math.exp(c.$r)*Math.sin(c.$i));
    }

      // 15. sqrt ---------------------------------------

    /**
     * @method  sqrt
     * @description  Calculates the squareroot of the complex number.
     * @usage <pre>Complex.sqrt(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a new Complex object.
    **/
    public static function sqrt(c:Complex):Complex {
        var aux:Number;

        if (c.$r>0) {
            aux = Complex.rAbs(c)+c.$r;

            return new Complex(Math.sqrt(aux/2), c.$i/Math.sqrt(2*aux));
        }
        else {
            aux = Complex.rAbs(c)-c.$r;
            if (c.$i<0) {
                return new Complex(Math.abs(c.$i)/Math.sqrt(2*aux), -Math.sqrt(aux/2));
            }
            else {
                return new Complex(Math.abs(c.$i)/Math.sqrt(2*aux), Math.sqrt(aux/2));
            }
        }
    }

      // 16. power --------------------------------------

    /**
     * @method  power
     * @description  Calculates c2 power of c1.
     * @usage <pre>Complex.power(c1, c2);</pre>
     * @param   c1   (Complex)  -- complex number input.
     * @param   c2   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function power(c1:Complex, c2:Complex):Complex {
        return Complex.exp(Complex.mult(Complex.log(c1), c2));
    }

      // 17. root ---------------------------------------

    /**
     * @method  root
     * @description  Calculates c2 root of c1.
     * @usage <pre>Complex.root(c1, c2);</pre>
     * @param   c1   (Complex)  -- complex number input.
     * @param   c2   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function root(c1:Complex, c2:Complex):Complex {
        return Complex.exp(Complex.div(Complex.log(c1), c2));
    }

      // 18. rSinh --------------------------------------

    /**
     * @method  rSinh
     * @description  Calculates hyperbolic sine of real number input.
     * @usage <pre>Complex.rSinh(r);</pre>
     * @param   r   (Number)  -- a real number.
     * @return  (Number)  -- returns a real number.
    **/
    public static function rSinh(r:Number):Number {
        if (Math.abs(r)>.1) {
            return (Math.exp(r)-Math.exp(-r))/2;
        }
        else {
            var s:Number = 1;
            var j:Number;

            for (j=19;j>2;j-=2) s = s*r*r/j/(j-1)+1;

            return s*r;
        }
    }

      // 19. rCosh --------------------------------------

    /**
     * @method  rCosh
     * @description  Calculates hyperbolic cosine of real number input.
     * @usage <pre>Complex.rCosh(r);</pre>
     * @param   r   (Number)  -- a real number.
     * @return  (Number)  -- returns a real number.
    **/
    public static function rCosh(r:Number):Number {
        return (Math.exp(r)+Math.exp(-r))/2;
    }

      // 20. sin ----------------------------------------

    /**
     * @method  sin
     * @description  Calculates sine of complex number input.
     * @usage <pre>Complex.sin(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a new Complex object.
    **/
    public static function sin(c:Complex):Complex {
        return new Complex(Math.sin(c.$r)*Complex.rCosh(c.$i), Math.cos(c.$r)*Complex.rSinh(c.$i));
    }

      // 21. cos ----------------------------------------

    /**
     * @method  cos
     * @description  Calculates cosine of complex number input.
     * @usage <pre>Complex.cos(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a new Complex object.
    **/
    public static function cos(c:Complex):Complex {
        return new Complex(Math.cos(c.$r)*Complex.rCosh(c.$i), -Math.sin(c.$r)*Complex.rSinh(c.$i));
    }

      // 22. tan ----------------------------------------

    /**
     * @method  tan
     * @description  Calculates tangent of complex number input.
     * @usage <pre>Complex.tan(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function tan(c:Complex):Complex {
        return Complex.div(Complex.sin(c), Complex.cos(c));
    }

      // 23. cot ----------------------------------------

    /**
     * @method  cot
     * @description  Calculates cotangent of complex number input.
     * @usage <pre>Complex.cot(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function cot(c:Complex):Complex {
        return Complex.div(Complex.cos(c), Complex.sin(c));
    }

      // 24. sec ----------------------------------------

    /**
     * @method  sec
     * @description  Calculates secant of complex number input.
     * @usage <pre>Complex.sec(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function sec(c:Complex):Complex {
        return Complex.div(Complex.One, Complex.cos(c));
    }

      // 25. cosec --------------------------------------

    /**
     * @method  cosec
     * @description  Calculates cosecant of complex number input.
     * @usage <pre>Complex.cosec(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function cosec(c:Complex):Complex {
        return Complex.div(Complex.One, Complex.sin(c));
    }

      // 26. asin ---------------------------------------

    /**
     * @method  asin
     * @description  Calculates arcsine of complex number input.
     * @usage <pre>Complex.asin(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function asin(c:Complex):Complex {
        return Complex.timesi(Complex.asinh(Complex.timesi3(c)));
    }

      // 27. acos ---------------------------------------

    /**
     * @method  acos
     * @description  Calculates arccosine of complex number input.
     * @usage <pre>Complex.acos(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function acos(c:Complex):Complex {
        return Complex.timesi(Complex.acosh(c));
    }

      // 28. atan ---------------------------------------

    /**
     * @method  atan
     * @description  Calculates arctangent of complex number input.
     * @usage <pre>Complex.atan(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a new Complex object.
    **/
    public static function atan(c:Complex):Complex {
        var tre:Number = Complex.arg(1-Complex.norm(c), 2*c.$r)/2;
        var s:Number = 4*c.$i/(c.$r*c.$r+(c.$i-1)*(c.$i-1));

        if (Math.abs(s)>.1) {
            return new Complex(tre, Math.log(1+s)/4);
        }
        else {
            var i2:Number = -1/20;
            var j:Number;

            s = -s;
            for (j=19;j>0;j--) i2 = i2*s-1/j;

            return new Complex(tre, s*i2/4)
        }
    }

      // 29. acot ---------------------------------------

    /**
     * @method  acot
     * @description  Calculates arccotangent of complex number input.
     * @usage <pre>Complex.acot(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function acot(c:Complex):Complex {
        return Complex.atan(Complex.div(One, c));
    }

      // 30. asec ---------------------------------------

    /**
     * @method  asec
     * @description  Calculates arcsecant of complex number input.
     * @usage <pre>Complex.asec(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function asec(c:Complex):Complex {
        return Complex.timesi(Complex.asech(c));
    }

      // 31. acosec -------------------------------------

    /**
     * @method  acosec
     * @description  Calculates arccosecant of complex number input.
     * @usage <pre>Complex.acosec(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function acosec(c:Complex):Complex {
        return Complex.asin(Complex.div(Complex.One, c));
    }

      // 32. sinh ---------------------------------------

    /**
     * @method  sinh
     * @description  Calculates hyperbolic sine of complex number input.
     * @usage <pre>Complex.sinh(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a new Complex object.
    **/
    public static function sinh(c:Complex):Complex {
        return new Complex(Complex.rSinh(c.$r)*Math.cos(c.$i), Complex.rCosh(c.$r)*Math.sin(c.$i));
    }

      // 33. cosh ---------------------------------------

    /**
     * @method  cosh
     * @description  Calculates hyperbolic cosine of complex number input.
     * @usage <pre>Complex.cosh(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a new Complex object.
    **/
    public static function cosh(c:Complex):Complex {
        return new Complex(Complex.rCosh(c.$r)*Math.cos(c.$i), Complex.rSinh(c.$r)*Math.sin(c.$i));
    }

      // 34. tanh  ---------------------------------------

    /**
     * @method  tanh
     * @description  Calculates hyperbolic tangent of complex number input.
     * @usage <pre>Complex.tanh(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function tanh(c:Complex):Complex {
        return Complex.div(Complex.sinh(c), Complex.cosh(c));
    }

      // 35. coth ---------------------------------------

    /**
     * @method  coth
     * @description  Calculates hyperbolic cotangent of complex number input.
     * @usage <pre>Complex.coth(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function coth(c:Complex):Complex {
        return Complex.div(Complex.cosh(c), Complex.sinh(c));
    }

      // 36. sech ---------------------------------------

    /**
     * @method  sech
     * @description  Calculates hyperbolic secant of complex number input.
     * @usage <pre>Complex.sech(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function sech(c:Complex):Complex {
        return Complex.div(Complex.One, Complex.cosh(c));
    }

      // 37. cosech -------------------------------------

    /**
     * @method  cosech
     * @description  Calculates hyperbolic cosecant of complex number input.
     * @usage <pre>Complex.cosech(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function cosech(c:Complex):Complex {
        return Complex.div(Complex.One, Complex.sinh(c));
    }

      // 38. asinh --------------------------------------

    /**
     * @method  asinh
     * @description  Calculates hyperbolic arcsine of complex number input.
     * @usage <pre>Complex.asinh(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function asinh(c:Complex):Complex {
    	var c1:Complex;
        var c2:Complex;
        var c3:Complex;
        var sgn:Number = 1;
        var j:Number;
        
        if (Complex.norm(c)>.1) {
            c1 = Complex.adds(Complex.sqrt(Complex.adds(Complex.mult(c, c), Complex.One)), c);
            c2 = Complex.subt(Complex.sqrt(Complex.adds(Complex.mult(c, c), Complex.One)), c);
            if 	 (Complex.norm(c1) > Complex.norm(c2)) { return Complex.log(c1) }
            else { return Complex.chSign(Complex.log(c2)); }
        } else {

			c2 = new Complex(-1/19, 0);
			c3 = Complex.mult(c, c);
	        for (j=17; j>0; j-=2) {
	            c2 = Complex.mult(c3, c2);
	            c2._real = (c2._real *j / (j+1)) + (sgn/j);
	            c2._imag = (c2._imag *j / (j+1));
	            sgn = -sgn;
	        }
	
	        return Complex.mult(c, c2);
       	}
    }

      // 39. acosh --------------------------------------

    /**
     * @method  acosh
     * @description  Calculates hyperbolic arccosine of complex number input.
     * @usage <pre>Complex.acosh(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function acosh(c:Complex):Complex {
        var c1:Complex = Complex.adds(Complex.sqrt(Complex.subt(Complex.mult(c, c), Complex.One)), c);
        var c2:Complex = Complex.subt(Complex.sqrt(Complex.subt(Complex.mult(c, c), Complex.One)), c);

        if (Complex.norm(c1)>Complex.norm(c2)) return Complex.log(c1);

        return Complex.log(Complex.mult(new Complex(-1, 0), c2));
    }

      // 40. atanh --------------------------------------

    /**
     * @method  atanh
     * @description  Calculates hyperbolic arctangent of complex number input.
     * @usage <pre>Complex.atanh(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function atanh(c:Complex):Complex {
        return Complex.timesi(Complex.atan(Complex.timesi3(c)));
    }

      // 41. acoth --------------------------------------

    /**
     * @method  acoth
     * @description  Calculates hyperbolic arccotangent of complex number input.
     * @usage <pre>Complex.acoth(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function acoth(c:Complex):Complex {
        return Complex.atanh(Complex.div(Complex.One, c));
    }

      // 42. asech --------------------------------------

    /**
     * @method  asech
     * @description  Calculates hyperbolic arcsecant of complex number input.
     * @usage <pre>Complex.asech(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function asech(c:Complex):Complex {
        return Complex.acosh(Complex.div(Complex.One, c));
    }

      // 43. acosech ------------------------------------

    /**
     * @method  acosech
     * @description  Calculates hyperbolic arccosecant of complex number input.
     * @usage <pre>Complex.acosech(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function acosech(c:Complex):Complex {
        return Complex.asinh(Complex.div(Complex.One, c));
    }

      // 44. contFrac -----------------------------------

    /**
     * @method  contFrac
     * @description  Calculates continued fraction loop of complex number input
     *               by applying variant fractional arguments.
     * @usage <pre>Complex.contFrac(c);</pre>
     * @param   arguments   (variant)  -- 1st argument is complex number, balance are fractional input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function contFrac(...args):Complex {
        var s:Complex = Complex.div(new Complex(3, 0), args[0]); //, c);
        var j:Number;

        for (j=7;j>0;j--) {
            //s = Complex.div(new Complex(Complex.contFrac.arguments[j], 0), Complex.adds(c, s));
            s = Complex.div(new Complex(args[j], 0), Complex.adds(args[0], s)); //(c, s));
            trace(j+" .. s._real: "+s._real+", _imag: "+s._imag);
        }
        return s;
    }

      // 45. factorial ----------------------------------

    /**
     * @method  factorial
     * @description  Calculates factorial of complex number input.
     * @usage <pre>Complex.factorial(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function factorial(c:Complex):Complex {
        var c1:Complex;
        var c2:Complex;
        var s:Complex;
        var j:Number;

        if (c.$r<-1) {
            c2 = Complex.div(Complex.Pi, Complex.sin(Complex.mult(Complex.Pi, c)));
            c2.$r = -c2.$r;
            c2.$i = -c2.$i;
            c1 = Complex.subt(new Complex(5, 0), c);
        }
        else {
            c1 = Complex.adds(c, new Complex(6, 0));
        }
        s = Complex.contFrac(c1, 1/12, 1/30, 53/210, 195/371, 22999/22737, 29944523/19733142, 109535241009/48264275462);
        s = Complex.adds(s, new Complex(.5*Math.log(2*Math.PI), 0));
        s = Complex.adds(s, Complex.mult(Complex.adds(c1, new Complex(.5, 0)), Complex.log(c1)));
        s = Complex.exp(Complex.subt(s, c1));
        for (j=0;j<6;j++) {
            s = Complex.div(s, c1);
            c1.$r--;
        }
        if (c.$r>=-1) return s;

        return Complex.div(c2, s);
    }

      // 46. equals -------------------------------------

    /**
     * @method  equals
     * @description  Determines whether complex numbers c1 and c2 are equal.
     * @usage <pre>Complex.equals(c1, c2);</pre>
     * @param   c1   (Complex)  -- complex number input.
     * @param   c2   (Complex)  -- complex number input.
     * @return  (Boolean)
    **/
    public static function equals(c1:Complex, c2:Complex):Boolean {
        return (c1.$r==c2.$r && c1.$i==c2.$i);
    }

      // 47. conjugate ----------------------------------

    /**
     * @method  conjugate
     * @description  Defines the conjugate of the complex number.
     * @usage <pre>Complex.conjugate(c)</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a new Complex object.
    **/
    public static function conjugate(c:Complex):Complex {
        return new Complex(c.$r, -c.$i);
    }

      // 48. modulo -------------------------------------

    /**
     * @method  modulo
     * @description  Calculates the modulo of the complex number (length of vector).
     * @usage <pre>Complex.modulo(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Number)  -- returns a real number.
    **/
    public static function modulo(c:Complex):Number {
        return Math.sqrt(c.$r*c.$r+c.$i*c.$i);
    }

      // 49. logGamma -----------------------------------

    /**
     * @method  logGamma
     * @description  Calculates log Gamma of complex number input.
     * @usage <pre>Complex.logGamma(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function logGamma(c:Complex):Complex {
        var c1:Complex;
        var c2:Complex;
        var s:Complex;
        var j:Number;

        if (c.$r<0) {
            c2 = Complex.log(Complex.sin(Complex.mult(Complex.Pi, c)));
            c1 = Complex.subt(new Complex(6, 0), c);
            trace ("1. Complex.logGamma (c.$r<0) ... c2.$r: "+c2.$r+", $i: "+c2.$i+", c1.$r: "+c1.$r+", $i: "+c1.$i);
        }
        else {
            c1 = Complex.adds(c, new Complex(7, 0));
            trace ("2. Complex.logGamma (c.$r>=0) ... c1.$r: "+c1.$r+", $i: "+c1.$i);
        }
        s = Complex.contFrac(c1, 1/12, 1/30, 53/210, 195/371, 22999/22737, 29944523/19733142, 109535241009/48264275462);
        trace ("3. Complex.logGamma contFrac ... s.$r: "+s.$r+", $i: "+s.$i);
        s = Complex.adds(s, new Complex(.5*Math.log(2*Math.PI), 0));
        trace ("4. Complex.logGamma adds ... s.$r: "+s.$r+", $i: "+s.$i);
        s = Complex.subt(Complex.adds(s, Complex.mult(Complex.subt(c1, new Complex(.5, 0)), Complex.log(c1))), c1);
        trace ("5. Complex.logGamma subt ... s.$r: "+s.$r+", $i: "+s.$i);
        for (j=0;j<7;j++) {
            c1.$r--;
            s = Complex.subt(s, Complex.log(c1));
            trace ("6. Complex.logGamma subt "+j+" ... s.$r: "+s.$r+", $i: "+s.$i);
        }
        trace ("7. Complex.logGamma (c.$r>=0): "+(c.$r>=0)+" ... s.$r: "+s.$r+", $i: "+s.$i);
        if (c.$r>=0) return s;
        trace ("8. Complex.logGamma return: "+(c.$r<0)+" ... s.$r: "+s.$r+", $i: "+s.$i+", c2.$r: "+c2.$r+", $i: "+c2.$i);
        return Complex.subt(s, c2);
    }

      // 50. diGamma ------------------------------------

    /**
     * @method  diGamma
     * @description  Calculates power2 Gamma of complex number input.
     * @usage <pre>Complex.diGamma(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function diGamma(c:Complex):Complex {
        var c1:Complex;
        var c2:Complex;
        var s:Complex;
        var j:Number;

        if (c.$r<0) {
            c2 = Complex.div(Complex.Pi, Complex.tan(Complex.mult(Complex.Pi, c)));
            c1 = Complex.subt(new Complex(6, 0), c);
        }
        else {
            c1 = Complex.adds(c, new Complex(7, 0));
        }
        s = Complex.contFrac(c1, 1/12, 1/10, 79/210, 1205/1659, 262445/209429, 33461119209/18089284070, 361969913862291/137627660760070);
        s = Complex.div(s, c1);
        s = Complex.adds(s, Complex.div(new Complex(.5, 0), c1));
        s = Complex.subt(Complex.log(c1), s);
        for (j=0;j<7;j++) {
            c1.$r--;
            s = Complex.subt(s, Complex.div(Complex.One, c1));
        }
        if (c.$r>=0) return s;

        return Complex.subt(s, c2);
    }

      // 51. triGamma -----------------------------------

    /**
     * @method  triGamma
     * @description  Calculates power3 Gamma of complex number input.
     * @usage <pre>Complex.triGamma(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function triGamma(c:Complex):Complex {
        var c1:Complex;
        var c2:Complex;
        var c3:Complex;
        var u:Complex;
        var s:Complex;
        var j:Number;

        if (c.$r<0) {
            u = Complex.cot(Complex.mult(Complex.Pi, c));
            c2 = Complex.mult(Complex.mult(Complex.Pi, Complex.Pi), Complex.adds(Complex.mult(u, u), Complex.One));
            c1 = Complex.subt(new Complex(6, 0), c);
        }
        else {
            c1 = Complex.adds(c, new Complex(7, 0));
        }
        s = Complex.contFrac(c1, 1/6, 1/5, 18/35, 20/21, 50/33, 315/143, 196/65);
        s = Complex.adds(s, new Complex(.5, 0));
        s = Complex.div(s, c1);
        s = Complex.adds(s, Complex.One);
        s = Complex.div(s, c1);
        for (j=0;j<7;j++) {
            c1.$r--;
            c3 = Complex.mult(c1, c1);
            s = Complex.adds(s, Complex.div(Complex.One, c3));
        }
        if (c.$r>=0) return s;

        return Complex.subt(c2, s);
    }

      // 52. tetraGamma ---------------------------------

    /**
     * @method  tetraGamma
     * @description  Calculates power4 Gamma of complex number input.
     * @usage <pre>Complex.tetraGamma(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function tetraGamma(c:Complex):Complex {
        var c1:Complex;
        var c2:Complex;
        var c3:Complex;
        var u:Complex;
        var s:Complex;
        var j:Number;

        if (c.$r<0) {
            u = Complex.cot(Complex.mult(Complex.Pi, c));
            c2 = Complex.mult(new Complex(2*Math.PI*Math.PI*Math.PI, 0), Complex.mult(u, Complex.adds(Complex.mult(u, u), Complex.One)));
            c1 = Complex.subt(new Complex(6, 0), c);
        }
        else {
            c1 = Complex.adds(c, new Complex(7, 0));
        }
        s = Complex.contFrac(c1, 1/2, 1/3, 2/3, 6/5, 9/5, 18/7, 24/7);
        s = Complex.div(Complex.div(Complex.adds(Complex.div(Complex.adds(s, Complex.One), c1), Complex.One), c1), c1);
        s.$r = -s.$r;
        s.$i = -s.$i;
        for (j=0;j<7;j++) {
            c1.$r--;
            c3 = Complex.mult(Complex.mult(c1, c1), c1);
            c3.$r /= 2;
            c3.$i /= 2;
            s = Complex.subt(s, Complex.div(Complex.One, c3));
        }
        if (c.$r>=0) return s;

        return Complex.subt(s, c2);
    }

      // 53. pentaGamma ---------------------------------

    /**
     * @method  pentaGamma
     * @description  Calculates power5 Gamma of complex number input.
     * @usage <pre>Complex.pentaGamma(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function pentaGamma(c:Complex):Complex {
        var c1:Complex;
        var c2:Complex;
        var c3:Complex;
        var u:Complex;
        var s:Complex;
        var j:Number;
		/* 
        if (c.$r<0) {
            u = Complex.cot(Complex.mult(Complex.Pi, c));
            c2 = Complex.adds( 
            		Complex.mult( 
            		  Complex.adds(
            		  	Complex.mult( Complex.mult(u, u), 
            		  				  Complex.mult( new Complex(6, 0) ), new Complex(8, 0) 
            		    ), 
            		  Complex.mult(u, u)), 
            		new Complex(2, 0))
            	  );
            c2.$r *= -Math.PI*Math.PI*Math.PI*Math.PI;
            c2.$i *= -Math.PI*Math.PI*Math.PI*Math.PI;

            c1 = Complex.subt(new Complex(6, 0), c);
        }
        else {
            c1 = Complex.adds(c, new Complex(7, 0));
        }
        s = Complex.contFrac(c1, 2, 1/2, 5/6, 22/15, 116/55, 942/319, 17622/4553);
        s = Complex.div(Complex.div(Complex.div(Complex.adds(Complex.div(Complex.adds(s, new Complex(3, 0)), c1), new Complex(2, 0)), c1), c1), c1);
        for (j=0;j<7;j++) {
            c1.$r--;
            var c3 = Complex.mult(Complex.mult(c1, c1), Complex.mult(c1, c1));
            c3.$r /= 6;
            c3.$i /= 6;
            s = Complex.adds(s, Complex.div(Complex.One, c3));
        }
        if (c.$r>=0) return s;

        return Complex.subt(c2, s);*/
        throw new Error("This needs to be reimplemented");
    }

      // 54. hexaGamma ----------------------------------

    /**
     * @method  hexaGamma
     * @description  Calculates power6 Gamma of complex number input.
     * @usage <pre>Complex.hexaGamma(c);</pre>
     * @param   c   (Complex)  -- complex number input.
     * @return  (Complex)  -- returns a Complex object result.
    **/
    public static function hexaGamma(c:Complex):Complex {
    	/*
        var c1:Complex;
        var c2:Complex;
        var c3:Complex;
        var u:Complex;
        var s:Complex;
        var j:Number;

        if (c.$r<0) {
            u = Complex.cot(Complex.mult(Complex.Pi, c));
            c2 = Complex.mult(Complex.adds(Complex.mult(Complex.adds(Complex.mult(Complex.mult(u, u), Complex.mult(new Complex(24, 0)), new Complex(40, 0)), Complex.mult(u, u)), new Complex(16, 0)), u));
            c2.$r *= -Math.PI*Math.PI*Math.PI*Math.PI*Math.PI;
            c2.$i *= -Math.PI*Math.PI*Math.PI*Math.PI*Math.PI;

            c1 = subt(new Complex(6, 0), c);
        }
        else {
            c1 = adds(c, new Complex(7, 0));
        }
        s = Complex.contFrac(c1, 10, 7/10, 71/70, 870/497, 15092/6177, 156910/46893, 2585118/595595);
        s = Complex.div(Complex.div(Complex.div(Complex.div(Complex.adds(Complex.div(Complex.adds(s, new Complex(12, 0)), c1), new Complex(6, 0)), c1), c1), c1), c1);
        s.$r = -s.$r;
        s.$i = -s.$i;
        for (j=0;j<7;j++) {
            c1.$r--;
            c3 = Complex.mult(Complex.mult(Complex.mult(c1, c1), Complex.mult(c1, c1)), c1);
            c3.$r /= 24;
            c3.$i /= 24;
            s = Complex.subt(s, Complex.div(Complex.One, c3));
        }
        if (c.$r>=0) return s;

        return Complex.subt(s, c2);
        */        
        throw new Error("This needs to be reimplemented");
    }

      // 55. get _real ----------------------------------

    /**
     * @method  get _real
     * @description  Gets real portion of Complex object.
     * @usage <pre>Complex._real;</pre>
     * @return  (Number)  -- returns a real number.
    **/
    public function get _real():Number {
        return $r;
    }

      // 56. set _real ----------------------------------

    /**
     * @method  set _real
     * @description  Sets real portion of Complex object.
     * @usage <pre>Complex._real = num;</pre>
     * @param  (Number)  -- a real number.
     * @return  (void)
    **/
    public function set _real(num:Number):void {
        $r = num;
    }

      // 57. get _imag ----------------------------------

    /**
     * @method  get _imag
     * @description  Gets imaginary portion of Complex object.
     * @usage <pre>Complex._imag);</pre>
     * @return  (Number)  -- returns a real number (to be multiplied by i).
    **/
    public function get _imag():Number {
	    return $i;
    }

      // 58. set _imag ----------------------------------

    /**
     * @method  get _imag
     * @description  Sets imaginary portion of Complex object.
     * @usage <pre>Complex._imag = num;</pre>
     * @return  (void)
    **/
    public function set _imag(num:Number):void {
	    $i = num;
    }

}// class
}//package


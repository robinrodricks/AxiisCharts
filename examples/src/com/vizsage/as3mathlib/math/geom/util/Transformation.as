package com.vizsage.as3mathlib.math.geom.util {
/**
 * @class       com.vizsage.as3mathlib.math.geom.util.Transformation
 * @author      Richard Wright
 * @version     1.7
 * @description Implements the behaviours of the Transformation Class.
 *              <p>
 *		        Provides utility methods for the IObj interface based on JS
 *              RayTracer2 by John Haggerty.
 * @usage       <pre>var inst:Transformation = new Transformation(vx, vy, vz, c, dontFindInverse, vecsByRef]);</pre>
 * @param       vx (Vector)  -- an x-axis Vector object.
 * @param       vy (Vector)  -- a y-axis Vector object.
 * @param       vz (Vector)  -- a z-axis Vector object.
 * @param       c (Vector)  -- a translation Vector object.
 * @param       dontFindInverse (Boolean)  -- if 'false', initialization populates $inverse Transformation object.
 * @param       vecsByRef = true (Boolean)  -- if 'true', copies passed vx, vy, and vz directly, else creates new Vector objects from their elements.
 * -----------------------------------------------
 * Latest update: August 5, 2004
 * -----------------------------------------------
 * Dependencies:  com.vizsage.as3mathlib.math.alg.Vector
 * -----------------------------------------------
 * AS2 revision copyright � 2004, Richard Wright [wisolutions2002@shaw.ca]
 * JS  original copyright � 2003, John Haggerty  [http://www.slimeland.com/]
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
 *       Transformation(vx, vy, vz, c, dontFindInverse, actualOrder)
 *             1.  copy()
 *             2.  findInverse(trans)
 *             3.  reducedRowEchelonForm(rows)
 *             4.  toString()
 *             5.  multipleTrans(trans_arr)
 *             6.  scale(amount)
 *             7.  rotate(dim, amnt)
 *             8.  translate(amount)
 * -----------------------------------------------
 *  Updates may be available at:
 *              http://members.shaw.ca/flashprogramming/wisASLibrary/wis/
 * -----------------------------------------------
 * NOTE: This class is under construction .. it presently loads
 *       without error, but the testing environment is incomplete. There may be
 *       traces and old code snippets within the code to assist in debugging.
 * -----------------------------------------------
**/

import com.vizsage.as3mathlib.math.alg.MLVector;

public class Transformation  {
	/**
	 * @property $vx (MLVector)  -- an x-axis MLVector object.
	 * @property $vy (MLVector)  -- a y-axis MLVector object.
	 * @property $vz (MLVector)  -- a z-axis MLVector object.
	 * @property $c (MLVector)  -- a translation MLVector object.
	 * @property $identity (Boolean)  -- if 'true', this instance is an Identity Transformation object.
	 * @property $inverse (Transformation)  -- the inverse of this instance, if available.
     * @property $IdentityTrans (Transformation)  -- static -- an Identity Transformation object.
	**/
    public 			var $vx:MLVector;
    public 			var $vy:MLVector;
    public 			var $vz:MLVector;
    public 			var $c:MLVector;
    public 			var $identity:Boolean;
    public 			var $inverse:Transformation;
    public static 	var $IdentityTrans:Transformation = new Transformation(MLVector.XX, MLVector.YY, MLVector.ZZ, MLVector.OO);
    public static 	var $ACCURACY:Number = 0.00000001;
    public static	var XAXIS:int = 0;
    public static	var YAXIS:int = 1;
    public static	var ZAXIS:int = 2;

    // constructor
    public function Transformation(vx:MLVector, vy:MLVector, vz:MLVector, c:MLVector, 
    								findInverse:Boolean = true, vecsByRef:Boolean = true) {
        //trace ("Transformation Class fired");
    	if (vecsByRef) {
    		$vx = vx;
    		$vy = vy;
    		$vz = vz;
    	}
    	else {
    		$vx = vx.clone();
    		$vy = vy.clone();
    		$vz = vz.clone();
    	}
    	$c  = c;
    	$identity = false;
    	if ( MLVector.compare(vx, MLVector.XX) && 
    		 MLVector.compare(vy, MLVector.YY) && 
    		 MLVector.compare(vz, MLVector.ZZ) && 
    		 MLVector.compare(c, MLVector.OO)) {
    		$identity = true;
    	}
    	if (findInverse) {
    		if ($identity) 	$inverse = this;
    		else 			$inverse = this.findInverse(this);
    	}
    }

      // 1. copy ---------------------------------------

    /**
     * @method  copy
     * @description  Creates a copy of this instance.
     * @usage  <pre>inst.copy();</pre>
     * @return  (Transformation)  -- returns a new Transformation object, a copy of this instance.
    **/
    public function copy():Transformation {
    	var useThisInverse:Boolean = true;

    	if (typeof($inverse)=="undefined") useThisInverse = false;

    	var toReturn:Transformation = new Transformation($vx.copy(), $vy.copy(), $vz.copy(), $c.copy(), useThisInverse, true);

    	if (useThisInverse) {
            if (!$identity) toReturn.$inverse = new Transformation($inverse.$vx.copy(), $inverse.$vy.copy(), $inverse.$vz.copy(), $inverse.$c.copy(), true, true);
    		else toReturn.$inverse = toReturn;
    	}

    	return toReturn;
    };

      // 2. findInverse --------------------------------

    /**
     * @method  findInverse
     * @description  Defines inverse of passed 'trans' Transformation object
     *               using the reduced row echelon method.
     * @usage  <pre>inst.findInverse(trans);</pre>
     * @param   trans   (Transformation)  -- a Transformation object.
     * @return  (Transformation)  -- returns inverse of passed 'trans' Transformation object.
    **/
    public function findInverse(trans:Transformation):Transformation {
    	var readFrom:Array = Transformation.reducedRowEchelonForm([[trans.$vx.x, trans.$vx.y, trans.$vx.z, 1, 0, 0], [trans.$vy.x, trans.$vy.y, trans.$vy.z, 0, 1, 0], [trans.$vz.x, trans.$vz.y, trans.$vz.z, 0, 0, 1]]);

    	$vx = new MLVector(readFrom[0][3], readFrom[0][4], readFrom[0][5]);
		$vy = new MLVector(readFrom[1][3], readFrom[1][4], readFrom[1][5]);
    	$vz = new MLVector(readFrom[2][3], readFrom[2][4], readFrom[2][5]);

       	var tempTrans:Transformation = new Transformation(  new MLVector($vx.x, $vy.x, $vz.x), 
       														new MLVector($vx.y, $vy.y, $vz.y), 
       														new MLVector($vx.z, $vy.z, $vz.z), 
       														new MLVector(0, 0, 0), 
       														true);

    	tempTrans.$c = MLVector.neg( trans.$c.transformed(tempTrans) );
    	tempTrans.$inverse = trans;

    	return tempTrans;
    }

      // 3. reducedRowEchelonForm ----------------------

    /**
     * @method  reducedRowEchelonForm
     * @description  Defines passed 'rows' array in reduced row echelon form.
     * @usage  <pre>inst.reducedRowEchelonForm(rows);</pre>
     * @param   rows   (Array)  -- a 2d nested array.
     * @return  (Array)  -- returns passed 'rows' array in reduced row echelon form.
    **/
    public static function reducedRowEchelonForm(rows:Array):Array {
    	var m:Number = rows.length;
    	var n:Number = rows[0].length;
    	var temp:Number, r:Number, r2:Number;
		var c:Number, divBy:Number, multBy:Number;

    	for (r=0;r<m;r++) {
    	    // testing against zero is mathematically correct, but the tiny errors can get magnified a *ton*; this is a small compromise.
    		if (Math.abs(rows[r][r]-0)<Transformation.$ACCURACY) {
    			for (r2=r+1;r2<m;r2++) {
    				if (Math.abs(rows[r2][r]-0)>Transformation.$ACCURACY) {
    					// swap
    					for (c=0;c<n;c++) {
    						temp = rows[r][c];
    						rows[r][c] = rows[r2][c];
    						rows[r2][c] = temp;
    					}
    					break;
    				}
    			}
    		}
    		divBy = rows[r][r];
    		for (c=0;c<n;c++) rows[r][c] = rows[r][c]/divBy;
    		for (r2=0;r2<m;r2++) {
    			if (r2!=r) {
    				multBy = rows[r2][r];
    				for (c=r;c<n;c++) rows[r2][c] -= rows[r][c]*multBy;
    			}
    		}
    	}

    	return rows;
    }

      // 4. toString -----------------------------------

    /**
     * @method  toString
     * @description  Creates a formatted string representation of this instance.
     * @usage  <pre>inst.toString();</pre>
     * @return  (String)  -- returns a formatted string representation of this instance.
    **/
    public function toString():String {
    	var rows:Array = [[$vx.x, $vx.y, $vx.z], [$vy.x, $vy.y, $vy.z], [$vz.x, $vz.y, $vz.z], [$c.x, $c.y, $c.z]];
    	var r:Number, c:Number;
    	var str:String;

    	str = "[ ";
    	for (r=0;r<rows.length;r++) {
    		for (c=0;c<rows[r].length;c++) {
    			if (Math.abs(rows[r][c]-0)<Transformation.$ACCURACY) str += "0 ";
    			else str += rows[r][c]+" ";
    		}
    		if (r<rows.length-1) str += "\n  ";
    	}

    	return (str + " ]");
    }

      // 5. multipleTrans ------------------------------

    // - this is an extremely helpful function that takes an array of transformations and turns them all into one single transformation.

    /**
     * @method  multipleTrans
     * @description  Static -- this is an extremely helpful function that takes an
     *               array of transformations and turns them all into one single
     *               transformation.
     * @usage  <pre>inst.multipleTrans(trans_arr);</pre>
     * @param   trans_arr   (Array)  -- a list of Transformation objects.
     * @return  (Transformation)  -- returns a single Transformation object, a summation of MLVector objects produced by a progression of dot product results.
    **/
    public static function multipleTrans(trans_arr:Array):Transformation {
    	if (trans_arr.length==0) return Transformation.$IdentityTrans;

    	var currentTrans:Transformation;
    	var a:Number;

    	if (trans_arr.length==1) currentTrans = trans_arr[0].copy();
    	else currentTrans = trans_arr[0];

    	for (a=1;a<trans_arr.length;a++) {
    		// multiply this one times what we already have
    		currentTrans = new Transformation
    		(
    			new MLVector(MLVector.dot(trans_arr[a].$vx, new MLVector(currentTrans.$vx.x, currentTrans.$vy.x, currentTrans.$vz.x)), MLVector.dot(trans_arr[a].$vx, new MLVector(currentTrans.$vx.y, currentTrans.$vy.y, currentTrans.$vz.y)), MLVector.dot(trans_arr[a].vx, new MLVector(currentTrans.$vx.z, currentTrans.$vy.z, currentTrans.$vz.z))),
    			new MLVector(MLVector.dot(trans_arr[a].$vy, new MLVector(currentTrans.$vx.x, currentTrans.$vy.x, currentTrans.$vz.x)), MLVector.dot(trans_arr[a].$vy, new MLVector(currentTrans.$vx.y, currentTrans.$vy.y, currentTrans.$vz.y)), MLVector.dot(trans_arr[a].vy, new MLVector(currentTrans.$vx.z, currentTrans.$vy.z, currentTrans.$vz.z))),
    			new MLVector(MLVector.dot(trans_arr[a].$vz, new MLVector(currentTrans.$vx.x, currentTrans.$vy.x, currentTrans.$vz.x)), MLVector.dot(trans_arr[a].$vz, new MLVector(currentTrans.$vx.y, currentTrans.$vy.y, currentTrans.$vz.y)), MLVector.dot(trans_arr[a].vz, new MLVector(currentTrans.$vx.z, currentTrans.$vy.z, currentTrans.$vz.z))),
    			currentTrans.$c.transformed(trans_arr[a]), false, true
    		);
    	}

    	return currentTrans;
    }

      // 6. scale --------------------------------------

    /**
     * @method  scale
     * @description  Scales an Identity Transformation object with passed MLVector object.
     * @usage  <pre>inst.scale(amount);</pre>
     * @param   amount   (MLVector)  -- a direction MLVector object.
     * @return  (Transformation)  -- returns a new scaled Transformation object.
    **/
    public function scale(amount:MLVector):Transformation {
	    return new Transformation(MLVector.scaler(MLVector.XX, amount.x), MLVector.scaler(MLVector.YY, amount.y), MLVector.scaler(MLVector.ZZ, amount.z), MLVector.OO);
	}

      // 7. rotate -------------------------------------

	/**
	 * @method  rotate
	 * @description  Creates a rotated Transformation object around the passed
	 *               'dim' axis.
	 * @usage  <pre>inst.rotate(dim, amnt);</pre>
	 * @param   dim   (Number)  -- a pointer to axis, created in UI 'main.as'.
	 * @param   amnt   (Number)  -- a real number representing radians.
	 * @return  (Transformation)  -- returns a new rotated Transformation object.
	**/
	public function rotate(dim:Number, amnt:Number):Transformation {
	    if (dim == Transformation.XAXIS) // will cause a typecasting error // *** TODO 
		{
    		return new Transformation(MLVector.XX, MLVector.adder(MLVector.scaler(MLVector.YY, Math.cos(amnt)), MLVector.scaler(MLVector.ZZ, Math.sin(amnt))), MLVector.adder(MLVector.scaler(MLVector.ZZ, Math.cos(amnt)), MLVector.neg(MLVector.scaler(MLVector.YY, Math.sin(amnt)))), MLVector.OO);
    	}
    	if (dim == Transformation.YAXIS) {
    		return new Transformation(MLVector.adder(MLVector.scaler(MLVector.XX, Math.cos(amnt)), MLVector.neg(MLVector.scaler(MLVector.ZZ, Math.sin(amnt)))), MLVector.YY, MLVector.adder(MLVector.scaler(MLVector.ZZ, Math.cos(amnt)), MLVector.scaler(MLVector.XX, Math.sin(amnt))), MLVector.OO);
    	}
    	if (dim == Transformation.ZAXIS) {
    		return new Transformation(MLVector.adder(MLVector.scaler(MLVector.XX, Math.cos(amnt)), MLVector.scaler(MLVector.YY, Math.sin(amnt))), MLVector.adder(MLVector.scaler(MLVector.YY, Math.cos(amnt)), MLVector.neg(MLVector.scaler(MLVector.XX, Math.sin(amnt)))), MLVector.ZZ, MLVector.OO);
    	}
    	else return null;
    }

      // 8. translate ----------------------------------

    /**
     * @method  translate
     * @description  Creates a new translation Transformation object using passed MLVector object.
     * @usage  <pre>inst.translate(amount);</pre>
     * @param   amount   (MLVector)  -- a direction MLVector object.
     * @return  (Transformation)  -- returns a new translation Transformation object.
    **/
    public function translate(amount:MLVector):Transformation {
    	return new Transformation(MLVector.XX, MLVector.YY, MLVector.ZZ, amount);
    }

}// class
}//package


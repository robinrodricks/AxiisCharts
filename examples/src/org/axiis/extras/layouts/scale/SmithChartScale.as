///////////////////////////////////////////////////////////////////////////////
//	Copyright (c) 2009 Team Axiis
//
//	Permission is hereby granted, free of charge, to any person
//	obtaining a copy of this software and associated documentation
//	files (the "Software"), to deal in the Software without
//	restriction, including without limitation the rights to use,
//	copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following
//	conditions:
//
//	The above copyright notice and this permission notice shall be
//	included in all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//	OTHER DEALINGS IN THE SOFTWARE.
///////////////////////////////////////////////////////////////////////////////

package org.axiis.extras.layouts.scale
{
	import com.degrafa.GraphicPoint;
	import com.vizsage.as3mathlib.math.alg.Complex;
	
	import org.axiis.layouts.scale.AbstractScale;
	import org.axiis.layouts.scale.IScale;
	
	public class SmithChartScale extends AbstractScale implements IScale
	{
		/**
		 * z0 is the factor to normalize all input values by.  For example, a 50 ohm transmission
		 * line would use z0=Complex(50,0);
		 */
		public var z0:Complex = new Complex(1,0);
		
		/**
		 * The chart radius is the radius of the inner circle containing all the arcs.
		 */
		private var _chartRadius:Number;
		[Bindable]
		public function set chartRadius(value:Number):void
		{
			_chartRadius = value;
		}
		public function get chartRadius():Number
		{
			return _chartRadius;
		}
		
		/**
		 * The center point (both x and y) of the smith chart.  Used to calculate arc offsets
		 * in the SmithChartAxis.
		 */
		private var _center:Number;
		[Bindable]
		public function set center(value:Number):void
		{
			_center = value;
		}
		public function get center():Number
		{
			return _center;
		}
		
		/**
		 * For a given value (complex number), return the x,y value between minLayout (0) and maxLayout (the width/height of the chart)
		 * We don't do computed mins and maxes because there is no sliding scale.  it's a fixed scale from 0 to the user-specified
		 * width of the chart.
		 */
		public function valueToLayout(value:*, invert:Boolean=false, clamp:Boolean = false):*
		{
			if(!(value is Complex))
				throw new Error("value must be a complex number for a Smith Chart");
				
			var imped:Complex = Complex.div(value as Complex, z0);

			//figure out location of this point on the chart
			var rc:Complex = Complex.div(Complex.subt(imped, Complex.One), Complex.adds(imped, Complex.One));
		
			var point:GraphicPoint = new GraphicPoint(center + rc._real * chartRadius, center - rc._imag * chartRadius);
			return point;
		}
		
		/**
		 * For a given GraphicPoint (layout), return the complex number representing the de-normalized (resistance,reactance)
		 */
		public function layoutToValue(layout:*, invert:Boolean=false, clamp:Boolean = false):*
		{
			if(!(layout is GraphicPoint))
				throw new Error("layout must be a GraphicPoint for a Smith Chart");
				
			var point:GraphicPoint = GraphicPoint(layout);

			var rc:Complex = new Complex((point.x - center) / chartRadius, (point.y + center) / chartRadius);
			
			var imped:Complex = Complex.mult(new Complex(-1,0), Complex.div(Complex.adds(rc, Complex.One), Complex.subt(rc, Complex.One)));
			
			return imped;
		}
		
		public override function set maxLayout(value:Number):void
		{
			super.maxLayout = value;
			chartRadius = maxLayout * 0.45871559633; //take into account for outer scale circles
			center = maxLayout * 0.5;
		}
	}
}
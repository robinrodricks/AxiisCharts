package com.degrafa.geometry{
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	public class SuperShape2D extends Geometry{
		
		private var p1:String = "4,1,1,1,2,4";
		private var p2:String = "5,1,1,1,2,50";
		private var p3:String = "3,1,1,1,2,50";
		private var p4:String = "8,1,1,1,2,8";
		
		
		
		public function SuperShape2D(){
			super();
			invalidated = true;
		}
		
		private var _n1:Number=1;
		/**
		* The n1 paramater of the super shape.
		**/
		public function get n1():Number{
			return _n1;
		}
		public function set n1(value:Number):void{
			if(_n1 != value){
				_n1 = value;
				invalidated = true;
			}
		}
		
		private var _n2:Number=1;
		/**
		* The n2 paramater of the super shape.
		**/
		public function get n2():Number{
			return _n2;
		}
		public function set n2(value:Number):void{
			if(_n2 != value){
				_n2 = value;
				invalidated = true;
			}
		}
		
		private var _n3:Number=1;
		/**
		* The n3 paramater of the super shape.
		**/
		public function get n3():Number{
			return _n3;
		}
		public function set n3(value:Number):void{
			if(_n3 != value){
				_n3 = value;
				invalidated = true;
			}
		}
				
		private var _m:Number=4;
		/**
		* The m paramater of the super shape.
		**/
		public function get m():Number{
			return _m;
		}
		public function set m(value:Number):void{
			if(_m != value){
				_m = value;
				invalidated = true;
			}
		}
		
		private var _detail:int=4;
		/**
		* The detail of the super shape. The number of points to be used.
		**/
		public function get detail():int{
			return _detail;
		}
		public function set detail(value:int):void{
			if(_detail != value){
				_detail = value;
				invalidated = true;
			}
		}
		
		private var _range:int=2;
		/**
		* The range of the super shape.
		**/
		public function get range():int{
			return _range;
		}
		public function set range(value:int):void{
			if(_range != value){
				_range = value;
				invalidated = true;
			}
		}
		
		protected var _preset:String;
		[Inspectable(category="General", enumeration="p1,p2,p3,p4", defaultValue="p1")]
		/**
		* A preset value.
		**/
		public function get preset():String{
			if(!_preset){return "p1";}
			return _preset;
		}
		public function set preset(value:String):void{			
			if(_preset != value){
				var oldValue:String=_preset;
				_preset = value;
				
				mapPreset();
				
				//call local helper to dispatch event	
				initChange("preset",oldValue,_preset,this);
			}
		}
		
		private function mapPreset():void{
			
			var presetdata:Array = String(this[preset]).split(",");
			
			_m =presetdata[0];
			_n1=presetdata[1];
			_n2=presetdata[2];
			_n3=presetdata[3];
			_range=presetdata[4];
			_detail=presetdata[5];
						
		}
		
		private function eval(phi:Number,isLine:Boolean=true):void{
			
			var a:Number = 1; 
			var b:Number = 1;
			
			var t1:Number = Math.cos(m * phi / 4) / a;
			t1 = Math.abs(t1);
			t1 = Math.pow(t1, n2);

			var t2:Number = Math.sin(m * phi / 4) / b;
			t2 = Math.abs(t2);
			t2 = Math.pow(t2, n3);

			var r:Number = Math.pow(t1 + t2, 1 / _n1);
			
			if (Math.abs(r) != 0) {
				r = 1 / r;
				
				if(isLine){
					commandStack.addLineTo(r * Math.cos(phi),r * Math.sin(phi))
				}	
				else{//move to
					commandStack.addMoveTo(r * Math.cos(phi),r * Math.sin(phi))	
				}			
			}
			
			
		}
		
		/**
		* @inheritDoc 
		**/
		override public function preDraw():void{
			if(invalidated){
				
				commandStack.source.length = 0;
				
				if(_preset){
					mapPreset();
				}
				
				eval(0,false);
				
				var i:int = 0;
				
				while (++i <= detail) {
					//phi = i * (PI*2) / detail;
					//phi = range * Math.PI * (i / detail);
					//eval((i * (Math.PI*2) / detail),true);
					
					eval(range * Math.PI * (i / detail),true);
					
				}
				
				invalidated = false;
			}
		}
		
		
		
		/**
		* Performs the specific layout work required by this Geometry.
		* @param childBounds the bounds to be layed out. If not specified a rectangle
		* of (0,0,1,1) is used. 
		**/
		override public function calculateLayout(childBounds:Rectangle=null):void{
			if(_layoutConstraint){
				if (_layoutConstraint.invalidated){
					
					var tempLayoutRect:Rectangle = new Rectangle(0,0,1,1);
					
					//default to bounds if no width or height is set
					//and we have layout
					if(isNaN(_layoutConstraint.width)){
						tempLayoutRect.width = bounds.width;
					}
					 
					if(isNaN(_layoutConstraint.height)){
						tempLayoutRect.height = bounds.height;
					}
										
					super.calculateLayout(tempLayoutRect);
						
					_layoutRectangle = _layoutConstraint.layoutRectangle;

				}
			}
		}
		
		/**
		* Begins the draw phase for geometry objects. All geometry objects 
		* override this to do their specific rendering.
		* 
		* @param graphics The current context to draw to.
		* @param rc A Rectangle object used for fill bounds. 
		**/
		override public function draw(graphics:Graphics,rc:Rectangle):void{
			
			//re init if required
		 	if (invalidated) preDraw(); 
			
			//init the layout in this case done after predraw.
			if (_layoutConstraint) calculateLayout();
			
			super.draw(graphics,(rc)? rc:bounds);
	 	}
	}
}

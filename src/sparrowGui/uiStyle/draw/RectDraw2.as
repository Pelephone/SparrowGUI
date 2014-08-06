/*
* Copyright(c) 2011 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES 
*/
package sparrowGui.uiStyle.draw
{
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import asSkinStyle.draw.ShapeDraw;
	
	/**
	 * 双边矩形
	 * @author Pelephone
	 */
	public class RectDraw2 extends ShapeDraw
	{
		public function RectDraw2(uiName:String="draw")
		{
			super(uiName);
		}
		
		/**
		 * 基本绘制函数
		 */
		override protected function draw():void
		{
			graphics.clear();
			if(this.bgAlpha){
				if(this.bgColor>=0 && this.bgColor2<0)
				{
					graphics.beginFill(this.bgColor,this.bgAlpha);
				}
				else if(this.bgColor>=0 && this.bgColor2>=0) {
					var matr:Matrix = new Matrix();
					matr.createGradientBox(this.width, this.height, this.bgRotaion);
					graphics.beginGradientFill(GradientType.LINEAR,[this.bgColor,this.bgColor2],
						[this.bgAlpha,this.bgAlpha],[0x00, 0xFF],matr);
				}
				
				if(_borderTop == _borderBottom && _borderBottom == _borderLeft && _borderLeft == _borderRight
					&& _borderTopColor == _borderBottomColor && _borderBottomColor == _borderLeftColor 
					&& _borderLeftColor == _borderRightColor)
				{
					var linAlpha:Number = (borderTopColor>0)?1:0;
					graphics.lineStyle(this.borderTop,this.borderTopColor,linAlpha);
					if(ellipse<=0)
						graphics.drawRect(0,0,this.width,this.height);
					else
						graphics.drawRoundRect(0,0,this.width,this.height,this.ellipse,this.ellipse);
				}
				else
				{
					if(this.borderTop){
						linAlpha = (borderTopColor>0)?1:0;
						graphics.moveTo(0,0);
						graphics.lineStyle(this.borderTop,this.borderTopColor,linAlpha);
						graphics.lineTo((0+this.width),0);
					}
					if(this.borderLeft){
						linAlpha = (borderLeftColor>0)?1:0;
						graphics.moveTo(0,0);
						graphics.lineStyle(this.borderLeft,this.borderLeftColor,linAlpha);
						graphics.lineTo(0,(this.height));
					}
					if(this.borderRight){
						linAlpha = (borderRightColor>0)?1:0;
						graphics.moveTo((0+this.width),0);
						graphics.lineStyle(this.borderRight,this.borderRightColor,linAlpha);
						graphics.lineTo((0+this.width),(0+this.height));
					}
					if(this.borderBottom){
						linAlpha = (borderBottomColor>0)?1:0;
						graphics.moveTo(0,(0+this.height));
						graphics.lineStyle(this.borderBottom,this.borderBottomColor,linAlpha);
						graphics.lineTo((0+this.width),(0+this.height));
					}
					if(this.bgColor>=0)
					{
						graphics.lineStyle(0,0,0);
						graphics.drawRect(0,0,this.width,this.height);
					}
				}
				
				if(this.bgColor>=0) graphics.endFill();
			}
			super.draw();
			
			var pd:int = 1;
			scale9Grid = new Rectangle((width*0.5-pd),(height*0.5-pd),pd*2,pd*2);
		}
		
		// getter/setter /////////
		
		
		private var _borderTop:int = 0;
		
		/**
		 * 上边框厚度
		 */
		public function get borderTop():int
		{
			return this._borderTop;
		}
		
		/**
		 * @private
		 */
		public function set borderTop(value:int):void
		{
			if(this._borderTop == value) return;
			this._borderTop = value;
			reDraw();
		}
		
		private var _borderRight:int = 0;
		
		/**
		 * 右边框厚度
		 */
		public function get borderRight():int
		{
			return this._borderRight;
		}
		
		/**
		 * @private
		 */
		public function set borderRight(value:int):void
		{
			if(this._borderRight == value) return;
			this._borderRight = value;
			reDraw();
		}
		
		private var _borderLeft:int = 0;
		
		/**
		 * 左边框厚度
		 */
		public function get borderLeft():int
		{
			return this._borderLeft;
		}
		
		/**
		 * @private
		 */
		public function set borderLeft(value:int):void
		{
			if(this._borderLeft == value) return;
			this._borderLeft = value;
			reDraw();
		}
		
		private var _borderBottom:int = 0;
		
		/**
		 * 下边框厚度
		 */
		public function get borderBottom():int
		{
			return this._borderBottom;
		}
		
		/**
		 * @private
		 */
		public function set borderBottom(value:int):void
		{
			if(this._borderBottom == value) return;
			this._borderBottom = value;
			reDraw();
		}
		
		private var _borderTopColor:int = 0;
		
		/**
		 * 上边框颜色
		 */
		public function get borderTopColor():int
		{
			return this._borderTopColor;
		}
		
		/**
		 * @private
		 */
		public function set borderTopColor(value:int):void
		{
			if(this._borderTopColor == value) return;
			this._borderTopColor = value;
			reDraw();
		}
		
		private var _borderLeftColor:int = 0;
		
		/**
		 * 左边框颜色
		 */
		public function get borderLeftColor():int
		{
			return this._borderLeftColor;
		}
		
		/**
		 * @private
		 */
		public function set borderLeftColor(value:int):void
		{
			if(this._borderLeftColor == value) return;
			_borderLeftColor = value;
			reDraw();
		}
		
		private var _borderRightColor:int = 0;
		
		/**
		 * 右边框颜色
		 */
		public function get borderRightColor():int
		{
			return this._borderRightColor;
		}
		
		/**
		 * @private
		 */
		public function set borderRightColor(value:int):void
		{
			if(this._borderRightColor == value) return;
			this._borderRightColor = value;
			reDraw();
		}
		
		private var _borderBottomColor:int = 0;
		
		/**
		 * 下边框颜色
		 */
		public function get borderBottomColor():int
		{
			return this._borderBottomColor;
		}
		
		/**
		 * @private
		 */
		public function set borderBottomColor(value:int):void
		{
			if(this._borderBottomColor == value) return;
			this._borderBottomColor = value;
			reDraw();
		}
		
		private var _ellipse:int = 0;
		
		/** 
		 * 圆角,border不为0是有效
		 */
		public function get ellipse():int
		{
			return this._ellipse;
		}
		
		/**
		 * @private
		 */
		public function set ellipse(value:int):void
		{
			if(this._ellipse == value) return;
			this._ellipse = value;
			reDraw();
		}
		
		/**
		 * 是否整型坐标和长宽
		 
		 public function get isIntNum():int
		 {
		 return _isIntNum;
		 }*/
		
		/**
		 * @private
		 
		 public function set isIntNum(value:int):void
		 {
		 _isIntNum = value;
		 }*/
		
		override public function set border(value:int):void
		{
			_borderTop = value;
			_borderBottom = value;
			_borderLeft = value;
			_borderRight = value;
			reDraw();
		}
		
		override public function get border():int
		{
			if(_borderTop == _borderBottom && _borderBottom == _borderLeft && _borderLeft == _borderRight)
				return _borderTop;
			else
				return NaN;
		}
		
		override public function set borderColor(value:int):void
		{
			_borderTopColor = value;
			_borderBottomColor = value;
			_borderLeftColor = value;
			_borderRightColor = value;
			reDraw();
		}
		
		override public function get borderColor():int
		{
			if(_borderTopColor == _borderBottomColor == _borderLeftColor == _borderRightColor)
				return _borderTop;
			else
				return NaN;
		}
		
		/**
		 * 快捷输入左上右下外边框
		 * @param args
		 */	
		public function setBorder(...args):void
		{
			var i:int=0;
			borderLeft = (args.length>i)?args[i++]:0;
			borderTop = (args.length>i)?args[i++]:borderLeft;
			borderRight = (args.length>i)?args[i++]:borderTop;
			borderBottom = (args.length>i)?args[i++]:borderRight;
		}
		
		/**
		 * 快捷输入左上右下外边框颜色
		 * @param args
		 */	
		public function setBorderColor(...args):void
		{
			var i:int=0;
			borderLeftColor = (args.length>i)?args[i++]:0;
			borderTopColor = (args.length>i)?args[i++]:borderLeftColor;
			borderRightColor = (args.length>i)?args[i++]:borderTopColor;
			borderBottomColor = (args.length>i)?args[i++]:borderRightColor;
		}
	}
}



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
	import asSkinStyle.draw.DrawTool;
	import asSkinStyle.draw.RectSprite;
	
	import flash.events.Event;
	
	
	/**
	 * 关闭叉图形
	 * @author Pelephone
	 */
	public class CloseRectDraw extends RectSprite
	{
		public function CloseRectDraw()
		{
			super();
		}
		
		/**
		 * 基本绘制函数
		 */
		override protected function draw():void
		{
			graphics.clear();
			
			DrawTool.drawRect(graphics,this);
			
			graphics.lineStyle(_inBorder,inBorderColor);
			graphics.moveTo(inPadding,inPadding);
			graphics.lineTo((_width - inPadding),(_height - inPadding));
			graphics.moveTo((_width - inPadding),inPadding);
			graphics.lineTo(inPadding,(_height - inPadding));
			
			dispatchEvent(new Event(COMPONENT_DRAW));
		}
		
		private var _inBorder:int = 1;

		/**
		 * 叉的线粗细
		 */
		public function get inBorder():int
		{
			return _inBorder;
		}

		/**
		 * @private
		 */
		public function set inBorder(value:int):void
		{
			if(_inBorder == value)
				return;
			_inBorder = value;
			reDraw();
		}

		
		private var _inBorderColor:int;

		/**
		 * 线颜色
		 */
		public function get inBorderColor():int
		{
			return _inBorderColor;
		}

		/**
		 * @private
		 */
		public function set inBorderColor(value:int):void
		{
			if(_inBorderColor == value)
				return;
			
			_inBorderColor = value;
			reDraw();
		}

		private var _inPadding:int;

		/**
		 * 内叉边距
		 */
		public function get inPadding():int
		{
			return _inPadding;
		}

		/**
		 * @private
		 */
		public function set inPadding(value:int):void
		{
			if(_inPadding == value)
				return;
			_inPadding = value;
			reDraw();
		}
	}
}
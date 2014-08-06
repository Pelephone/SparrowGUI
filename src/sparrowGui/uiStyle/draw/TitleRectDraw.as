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
	import asSkinStyle.draw.RectDraw;
	
	import flash.display.Sprite;
	
	
	/**
	 * 标题栏特殊矩形
	 * @author Pelephone
	 */
	public class TitleRectDraw extends Sprite
	{
		public function TitleRectDraw()
		{
			rect1 = new RectDraw();
			rect1.bgColor = 0x66656D;
//			rect1.border = 1;
			rect1.borderColor = 0x666666;
			rect1.width = rect1.height = 20;
			rect1.setBorder(1,1,1,1);
			rect2 = new RectDraw();
//			rect2.border = 1;
			rect2.setBorder(1,1,1,0);
//			rect2.setBorderColor(0xE5F5F9,0xE5F5F9,0xE5F5F9,0x999999);
			rect2.borderColor = 0xE5F5F9;
			rect2.borderBottomColor = 0x999999;
//			rect2.borderColor = 0xE5F5F9;
			rect2.bgColor = 0x8DD3E4;
			rect2.width = rect2.height = 20;
			rect2.x = padding;
			rect2.y = padding;
			
			addChild(rect1);
			addChild(rect2);
		}
		
		private var padding:int = 1;
		
		private var rect1:RectDraw;
		
		private var rect2:RectDraw;
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			rect1.width = value;
			rect2.width = value - 2*padding;
//			super.width = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			rect1.height = value;
//			rect2.height = value - 2*padding;
			rect2.height = value - padding;
//			super.height = value;
		}
	}
}
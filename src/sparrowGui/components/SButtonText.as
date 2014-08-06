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
package sparrowGui.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	
	/**
	 * 按钮样式的文本
	 * 最轻量极的按钮
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class SButtonText extends TextField
	{
		public function SButtonText()
		{
			super();
			
			this.selectable = false;
			
			this.background = true;
			this.border = true;
			this.backgroundColor = normalBackgroundColor;
			this.borderColor = normalBorderColor;
			this.width = 100;
			
			this.defaultTextFormat = tFormat;
			super.text = "按钮";
			
			addEventListener(MouseEvent.ROLL_OVER,onTxtMouse);
			addEventListener(MouseEvent.ROLL_OUT,onTxtMouse);
			addEventListener(MouseEvent.MOUSE_DOWN,onTxtMouse);
			addEventListener(MouseEvent.MOUSE_UP,onTxtMouse);
		}
		
		public static var tFormat:TextFormat = new TextFormat();
		{
			tFormat.align = TextFormatAlign.CENTER;
			tFormat.leading = -12;
		}
		
		/**
		 * 是否跟椐文本内容改变宽度
		 */
		public var isAutoWidth:Boolean = true;
		
		/**
		 * 左右边距
		 */
		public var space:int = 7;
		
		private var _text:String;
		
		override public function set text(value:String):void 
		{
			if(_text == value)
				return;
			if(!value)
				value = "";
			super.text = "\n"+value+"\n";
			
			if(isAutoWidth)
			{
				this.width = space*2 + textWidth;
				this.height = textHeight + 8;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get text():String
		{
			return _text;
		}
		
		/**
		 * 正常状态时背景颜色
		 */
		public var normalBackgroundColor:int = 0xEBEBEB;
		/**
		 * 正常状态时边框颜色
		 */
		public var normalBorderColor:int = 0x707070;
		
		/**
		 * 鼠标经过状态时背景颜色
		 */
		public var overBackgroundColor:int = 0xD8F0F2;
		/**
		 * 鼠标经过状态时边框颜色
		 */
		public var overBorderColor:int = 0x556F7E;
		
		/**
		 * 鼠标按下状态时背景颜色
		 */
		public var downBackgroundColor:int = 0xBECCCF;
		/**
		 * 鼠标按下状态时边框颜色
		 */
		public var downBorderColor:int = 0x5F7686;
		
		/**
		 * 文本鼠标事件
		 * @param e
		 */
		private function onTxtMouse(e:Event):void
		{
			switch(e.type)
			{
				case MouseEvent.ROLL_OVER:
				{
					Mouse.cursor = MouseCursor.BUTTON;
					backgroundColor = overBackgroundColor;
					borderColor = overBorderColor;
					break;
				}
				case MouseEvent.MOUSE_DOWN:
				{
					backgroundColor = downBackgroundColor;
					borderColor = downBorderColor;
					break;
				}
					
				default:
				{
					this.backgroundColor = normalBackgroundColor;
					this.borderColor = normalBorderColor;
					Mouse.cursor = MouseCursor.AUTO;
					break;
				}
			}
		}
	}
}
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
package uiEdit
{
	import flash.text.TextField;
	
	
	/**
	 * 
	 * @author Pelephone
	 */
	public dynamic class UIText extends TextField
	{
		public function UIText()
		{
			super();
			
			selectable = false;
			
			text = "这是系统字";
			this.multiline = true;
			this.wordWrap = true;
			this.border = true;
			this.borderColor = 0xFFFF00;
		}
		
		public var uiType:String = "text";
		public var _bgSrc:String;
		
		/**
		 * 背景图片路径
		 */
		public function get bgSrc():String
		{
			return _bgSrc;
		}
		/**
		 * @private
		 */
		public function set bgSrc(value:String):void
		{
			if(_bgSrc == value)
				return;
			_bgSrc = value;
			text = value;
		}
	}
}
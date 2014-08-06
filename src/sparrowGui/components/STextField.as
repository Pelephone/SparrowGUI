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
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**
	 * 继承一个文本，方便在这里给所有文本进行统一处理,例如换全局默认字体
	 * @author Pelephone
	 */
	public class STextField extends TextField
	{
		public function STextField()
		{
			super();
			height = 24;
		}
		
		/**
		 * 考虑到经常会遇到text为空会报错。重写该方法 
		 * @param value
		 */
		override public function set text(value:String):void
		{
			if(value == null)
				value = "";
			super.text = value;
		}
		
		/**
		 * 考虑到经常会遇到htmlText为空会报错。重写该方法 
		 * @param value
		 */
		override public function set htmlText(value:String):void
		{
			if(value == null)
				value = "";
			super.htmlText = value;
		}
		
		/**
		 * 设置样式后要重写一次内容
		 * @inheritDoc
		 */
		override public function set defaultTextFormat(format:TextFormat):void
		{
			super.defaultTextFormat = format;
			text = super.text;
		}
	}
}
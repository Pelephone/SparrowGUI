/**
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
package sparrowGui.components.base
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sparrowGui.utils.SparrowUtil;
	
	
	/**
	 * 绑定文本格式操作
	 * Pelephone
	 */
	public class BindTextFormat
	{
		/**
		 * 文本格式是否改变
		 */
		private var hasFormChange:Boolean = false;
		
		/**
		 * 绑定文本和格式操作
		 * @param txt 要操作的文本
		 * @param textForm 要绑定操作的格式
		 */
		public function BindTextFormat(txt:TextField,textForm:TextFormat=null)
		{
			super();
			
			_tf = txt;
			_txtForm = textForm || new TextFormat();
		}
		
		/**
		 * 激活下帧验证文本格式
		 */
		private function invalidateForm():void
		{
			hasFormChange = false;
			SparrowUtil.addNextCall(commitData);
		}
		
		/**
		 * 下帧提交改变
		 */
		private function commitData():void
		{
			if(hasFormChange)
			{
				_tf.defaultTextFormat = _txtForm;
				hasFormChange = false;
			}
		}
		
		//----------------------------------------------------
		// 文本操作
		//----------------------------------------------------
		
		private var _tf:TextField;
		
		/**
		 * 绑定格式的文本
		 */
		public function get tf():TextField
		{
			return _tf;
		}
		
		/**
		 * @private
		 */
		public function set tf(value:TextField):void
		{
			_tf = value;
		}
		
		public function get width():int
		{
			return _tf.width;
		}

		public function set width(value:int):void
		{
			_tf.width = value;
		}

		
		public function get height():int
		{
			return _tf.height;
		}

		public function set height(value:int):void
		{
			_tf.height = value;
		}

		public function get text():String
		{
			return _tf.text;
		}

		public function set text(value:String):void
		{
			_tf.text = value;
		}
		
		public function get htmlText():String
		{
			return _tf.htmlText;
		}

		public function set htmlText(value:String):void
		{
			_tf.htmlText = value;
		}
		
		public function get wordWrap():Boolean
		{
			return _tf.wordWrap;
		}

		public function set wordWrap(value:Boolean):void
		{
			_tf.wordWrap = value;
		}

		public function get multiline():Boolean
		{
			return _tf.multiline;
		}

		public function set multiline(value:Boolean):void
		{
			_tf.multiline = value;
		}

		
		public function get selectable():Boolean
		{
			return _tf.selectable;
		}

		public function set selectable(value:Boolean):void
		{
			_tf.selectable = value;
		}

		public function get autoSize():String
		{
			return _tf.autoSize;
		}

		public function set autoSize(value:String):void
		{
			_tf.autoSize = value;
		}
		

		//----------------------------------------------------
		// 格式操作
		//----------------------------------------------------
		
		private var _txtForm:TextFormat;
		
		/**
		 * 文本格式
		 */
		public function get txtForm():TextFormat
		{
			return _txtForm;
		}
		
		/**
		 * @private
		 */
		public function set txtForm(value:TextFormat):void
		{
			_txtForm = value;
		}
		
		public function get align():String
		{
			return _txtForm.align;
		}

		public function set align(value:String):void
		{
			_txtForm.align = value;
			invalidateForm();
		}

		public function get blockIndent():int
		{
			return int(_txtForm.blockIndent);
		}

		public function set blockIndent(value:int):void
		{
			_txtForm.blockIndent = value;
			invalidateForm();
		}

		public function get bold():Boolean
		{
			return _txtForm.bold;
		}

		public function set bold(value:Boolean):void
		{
			_txtForm.bold = value;
			invalidateForm();
		}

		public function get bullet():Boolean
		{
			return _txtForm.bullet;
		}

		public function set bullet(value:Boolean):void
		{
			_txtForm.bullet = value;
			invalidateForm();
		}

		public function get color():int
		{
			return _tf.textColor;
		}

		public function set color(value:int):void
		{
			_tf.textColor = value;
			_txtForm.color = value;
		}

		public function get font():String
		{
			return _txtForm.font;
		}

		public function set font(value:String):void
		{
			_txtForm.font = value;
			invalidateForm();
		}
		
		public function get indent():int
		{
			return int(_txtForm.indent);
		}

		public function set indent(value:int):void
		{
			_txtForm.indent = value;
			invalidateForm();
		}

		public function get italic():Boolean
		{
			return _txtForm.italic;
		}

		public function set italic(value:Boolean):void
		{
			_txtForm.italic = value;
			invalidateForm();
		}

		public function get kerning():Boolean
		{
			return _txtForm.kerning;
		}

		public function set kerning(value:Boolean):void
		{
			_txtForm.kerning = value;
			invalidateForm();
		}

		public function get leading():int
		{
			return int(_txtForm.leading);
		}

		public function set leading(value:int):void
		{
			_txtForm.leading = value;
			invalidateForm();
		}

		public function get leftMargin():int
		{
			return int(_txtForm.leftMargin);
		}

		public function set leftMargin(value:int):void
		{
			_txtForm.leftMargin = value;
			invalidateForm();
		}

		public function get letterSpacing():int
		{
			return int(_txtForm.letterSpacing);
		}

		public function set letterSpacing(value:int):void
		{
			_txtForm.letterSpacing = value;
			invalidateForm();
		}

		public function get rightMargin():int
		{
			return int(_txtForm.rightMargin);
		}

		public function set rightMargin(value:int):void
		{
			_txtForm.rightMargin = value;
			invalidateForm();
		}

		public function get size():int
		{
			return int(_txtForm.size);
		}

		public function set size(value:int):void
		{
			_txtForm.size = value;
			invalidateForm();
		}

		public function get tabStops():Array
		{
			return _txtForm.tabStops;
		}

		public function set tabStops(value:Array):void
		{
			_txtForm.tabStops = value;
			invalidateForm();
		}

		public function get target():String
		{
			return _txtForm.target;
		}

		public function set target(value:String):void
		{
			_txtForm.target = value;
			invalidateForm();
		}

		public function get underline():Boolean
		{
			return _txtForm.underline;
		}

		public function set underline(value:Boolean):void
		{
			_txtForm.underline = value;
			invalidateForm();
		}

		public function get url():String
		{
			return _txtForm.url;
		}

		public function set url(value:String):void
		{
			_txtForm.url = value;
			invalidateForm();
		}
	}
}
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
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	import sparrowGui.event.ListEvent;
	
	
	/**
	 * 选中项改变
	 */
	[Event(name="list_item_select", 	type="sparrowGui.event.ListEvent")]
	
	/**
	 * 带输入搜索功能的下拉控件
	 * @author Pelephone
	 */
	public class SearchCombobox extends SCombobox
	{
		public function SearchCombobox(uiVars:Object=null)
		{
			super(uiVars || defaultUIVar);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
			
			_txtLabel.type = TextFieldType.INPUT;
			_txtLabel.addEventListener(Event.CHANGE,onTxtChange);
			_txtLabel.addEventListener(KeyboardEvent.KEY_DOWN,onTxtKeyDown);
		}
		
		/**
		 * 更新内容
		 */
		override public function set data(o:Object):void
		{
			if(_txtLabel.text == "" || _txtLabel.text == null)
			{
				if(o && o.length)
					_txtLabel.text = String(o[0]);
				else
					_txtLabel.text = "";
			}
			
			_popTip.data = (o);
			
			_data = o;
		}
		
		/**
		 * 在文本上按键盘键
		 * @param e
		 */
		private function onTxtKeyDown(e:KeyboardEvent):void
		{
			isTxtKey = true;
			switch(e.keyCode)
			{
				case Keyboard.ENTER:
				{
					closePop();
					var fstData:Object = popTip.selectData;
					if(!fstData)
						return;
					_txtLabel.text = String(fstData);
					break;
				}
				case Keyboard.UP:
				{
					if(selectIndex > 0)
						selectIndex = selectIndex -1;
					else
						selectIndex = 0;
					break;
				}
				case Keyboard.DOWN:
				{
					if(data && selectIndex < (_popTip.data.length - 1) )
						selectIndex = selectIndex + 1;
					else
						selectIndex = 0;
					
					break;
				}
			}
			isTxtKey = false;
		}
		
		/**
		 * 是否是键盘事件，是的话就不改变文字
		 */
		private var isTxtKey:Boolean = false;
		
		override protected function onSelectEvt(e:ListEvent):void
		{
			if(isTxtKey)
				return;
			
			super.onSelectEvt(e);
		}
		
		/**
		 * 文本内容改变
		 * @param e
		 */
		private function onTxtChange(e:Event):void
		{
			if(label)
			{
				showTxtChange();
				
				_selected = true;
				showListRender();
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function showTxtChange():void
		{
			if(!label)
				return;
			var ary:Array = [];
			for each (var itm:Object in data) 
			{
				var str:String = itm.toString();
				if(str && str.indexOf(label)>=0)
					ary.push(itm);
			}
			_popTip.data = ary;
		}
		
		/**
		 * 监听鼠标事件
		 * @param e
		 */
		override protected function onMouseEvent(e:MouseEvent):void
		{
			if(e.target == _txtLabel)
				return;
			if(_popTip.data != _data)
				_popTip.data = _data;
			super.onMouseEvent(e);
		}
		
		/**
		 * 文本内容
		 * @return 
		 */
		public function get label():String 
		{
			if(_txtLabel)
				return _txtLabel.text;
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultUIVar():Object
		{
			return "searchCombobox";
		}
	}
}
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
package sparrowGui.components.item
{
	import asCachePool.interfaces.IRecycle;
	import asCachePool.interfaces.IReset;
	
	import flash.display.DisplayObjectContainer;
	
	import sparrowGui.components.base.BaseUIComponent;
	import sparrowGui.data.ItemState;
	import sparrowGui.i.IItem;
	import sparrowGui.utils.SparrowUtil;
	
	
	/**
	 * 基础项
	 * @author Pelephone
	 */
	public class ItemBase extends BaseUIComponent implements IItem,IRecycle,IReset
	{
		public function ItemBase(uiVars:Object=null)
		{
			super(uiVars || defaultUIVar);
			reset();
		}
		
		protected var _data:Object;
		
		public function set data(value:Object):void
		{
			if(_data == value)
				return;
			
			_data = value;
			parseData();
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * 将数据解析到此项
		 */
		protected function parseData():void
		{
			
		}
		
		private var _itemIndex:int = -1;
		
		public function set itemIndex(value:int):void
		{
			if(value == _itemIndex)
				return;
			_itemIndex = value;
		}
		
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		
		/**
		 * @inheritDoc
		 
		override public function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
			invalidateDraw();
		}*/
		
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultUIVar():Object
		{
			return "item";
		}
		
		/**
		 * @inheritDoc
		 
		override public function set width(value:Number):void
		{
			if(_width == value)
				return;
			_width = value;
		}*/
		
		//---------------------------------------------------
		// 显示状态
		//---------------------------------------------------
		
		protected var _currentState:String;
		
		public function get currentState():String
		{
			return _currentState;
		}
		
		public function set currentState(value:String):void
		{
			if(_currentState == value)
				return;
			_currentState = value;
			SparrowUtil.addNextCall(stateRender);
		}
		
		override public function set enabled(value:Boolean):void
		{
			if(value == _enabled)
				return;
			_enabled = value;
			super.enabled = value;
			_currentState = ItemState.UP;
			SparrowUtil.addNextCall(stateRender);
		}

		
		private var _selected:Boolean;

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			if(_selected == value)
				return;
			_selected = value;
			_currentState = ItemState.UP;
			SparrowUtil.addNextCall(stateRender);
		}
		
		public function setState(stateName:String, value:Object=null):void
		{
			switch(stateName)
			{
				case ItemState.ENABLED:
				{
					enabled = value;
					break;
				}
				case ItemState.SELECT:
				{
					selected = value;
					break;
				}
			}
		}
		
		/**
		 * 状态改变影响显示
		 */
		protected function stateRender():void
		{
			
		}
		
		//---------------------------------------------------
		// 池用接口
		//---------------------------------------------------
		
		override public function dispose():void
		{
			_data = null;
			if(this.parent)
				parent.removeChild(this);
			
			super.dispose();
		}
		
		public function reset():void
		{
			enabled = true;
			selected = false;
		}
	}
}
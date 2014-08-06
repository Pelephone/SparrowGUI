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
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sparrowGui.SparrowMgr;
	import sparrowGui.components.item.SListItem;
	import sparrowGui.data.ItemState;
	import sparrowGui.data.ListSelectionData;
	import sparrowGui.event.ListEvent;
	import sparrowGui.i.IItem;
	import sparrowGui.i.IListSelectionData;
	
	/**
	 * 列表选中状态改变
	 */
	[Event(name="list_item_select", 	type="sparrowGui.event.ListEvent")]
	
	/**
	 * 列表组件
	 * @author Pelephone
	 */
	public class List extends BaseComponent
	{
		public function List(uiVars:Object=null)
		{
			super(uiVars);
			
			_group = new ItemGroup();
			_selectModel = new ListSelectionData();
			_layout = new LayoutClip();
			_selectModel.addListSelectionListener(onSelectChange);
		}
		
		private var _selectModel:IListSelectionData;

		/**
		 * 选项数据
		 */
		public function get selectModel():IListSelectionData
		{
			return _selectModel;
		}

		/**
		 * @private
		 */
		public function set selectModel(value:IListSelectionData):void
		{
			_selectModel = value;
		}

		
		private var _group:ItemGroup;
		
		/**
		 * 组项映射
		 */
		public function get group():ItemGroup
		{
			return _group;
		}
		
		private var _layout:LayoutClip;

		/**
		 * 布局工具
		 */
		public function get layout():LayoutClip
		{
			return _layout;
		}

		/**
		 * @private
		 */
		public function set layout(value:LayoutClip):void
		{
			_layout = value;
		}
		
		
		private var _data:Object;

		/**
		 * 列表数据, 通过数据刷新列表组件
		 */
		public function get data():Object
		{
			return _data;
		}

		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			if(_data == value)
				return;
			
			_data = value;
			invalidateDraw();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			if(_group)
			{
				// 清旧的项
				for each (var itm:IItem in _group.itemLs) 
				{
					SparrowMgr.removeInCLsCache(itm);
					removeItem(itm);
				}
				
				for each (var itmData:Object in data) 
				{
					itm = createItem(itmData);
					itm.addEventListener(MouseEvent.CLICK,onItemClick);
					addItem(itm);
				}
			}
			
			if(_layout)
				_layout.updateDisplayList(_group.itemLs);
			
			super.draw();
		}
		
		//---------------------------------------------------
		// 子项
		//---------------------------------------------------
		
		/**
		 * 子项类
		 */
		public var itemClass:Class = SListItem;
		
		/**
		 * 处理子项更新的函数
		 */
		public var updateFunc:Function;
		
		/**
		 * 创建子项
		 * @param data
		 */
		protected function createItem(data:Object):IItem
		{
			var itm:IItem = SparrowMgr.getAndCreatePoolObj(itemClass) as IItem;
			itm.data = data;
			if(updateFunc != null)
				updateFunc.apply(null,[itm]);
			return itm;
		}
		
		/**
		 * 添加子项
		 * @param itm
		 */
		public function addItem(itm:IItem):void
		{
			_group.addItem(itm);
			if(itm is DisplayObject)
				this.addChild(itm as DisplayObject);
		}
		
		/**
		 * 清除项
		 * @param itm
		 */
		public function removeItem(itm:IItem):void
		{
			_group.removeItem(itm);
			if(itm is DisplayObject)
				(itm as DisplayObject).parent.removeChild(itm as DisplayObject);
		}
		
		//---------------------------------------------------
		// 选项
		//---------------------------------------------------
		
		/**
		 * 是否支持多选，默认只能单选
		 */
		public function get multiSelect():Boolean
		{
			return _selectModel.multiSelect;
		}
		
		/**
		 * @private
		 */
		public function set multiSelect(value:Boolean):void
		{
			_selectModel.multiSelect = value;
		}
		
		public function get selectIndex():int
		{
			return _selectModel.getSelectIndex();
		}
		
		public function get selectIds():Vector.<int>
		{
			return _selectModel.getSelectIds();
		}
		
		/**
		 * 选中项数据
		 * @return 
		 */
		public function get selectData():*
		{
			if(!_data || !_data.hasOwnProperty(selectIndex))
				return null;
			else
				return _data[selectIndex];
		}
		
		//---------------------------------------------------
		// 布局相关
		//---------------------------------------------------
		
		/**
		 * 子项高
		 */
		public function get itemHeight():int
		{
			return _layout.itemHeight;
		}
		
		/**
		 * @private
		 */
		public function set itemHeight(value:int):void
		{
			_layout.itemHeight = value;
		}
		
		/**
		 * 子项宽
		 */
		public function get itemWidth():int
		{
			return _layout.itemWidth;
		}
		
		/**
		 * @private
		 */
		public function set itemWidth(value:int):void
		{
			_layout.itemWidth = value;
		}
		
		/**
		 * 每列有多少项,-1表示自动通过width和itemWidth计算每列个数
		 */
		public function get colNum():int
		{
			return _layout.colNum;
		}
		
		/**
		 * @private
		 */
		public function set colNum(value:int):void
		{
			_layout.colNum = value;
		}
		
		//---------------------------------------------------
		// 事件
		//---------------------------------------------------
		
		/**
		 * 选中项改变
		 * @param e
		 */
		private function onSelectChange(e:ListEvent):void
		{
			var m:IListSelectionData = selectModel;
			for (var i:int = 0; i < _group.itemLs.length; i++) 
			{
				var itm:IItem = _group.itemLs[i] as IItem;
				var itmSelected:Boolean = m.isSelect(i);
				itm.setState(ItemState.SELECT,itmSelected);
			}
			dispatchEvent(new ListEvent(ListEvent.LIST_ITEM_SELECT,null,itm));
		}
		
		/**
		 * 项点击事件
		 * @param e
		 */
		private function onItemClick(e:Event):void
		{
			var itm:IItem = e.currentTarget as IItem;
			selectModel.setSelect(itm.itemIndex);
		}
	}
}
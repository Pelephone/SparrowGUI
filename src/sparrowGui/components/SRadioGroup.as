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
	
	import sparrowGui.data.ItemState;
	import sparrowGui.data.ListSelectionData;
	import sparrowGui.event.ListEvent;
	import sparrowGui.i.IItem;
	import sparrowGui.i.IListSelectionData;
	import sparrowGui.components.base.ItemGroup;
	
	/**
	 * 列表选中状态改变
	 */
	[Event(name="list_item_select", 	type="sparrowGui.event.ListEvent")]
	/**
	 * 单选组组件
	 * 单选项是一个个addItem到这里的,不用时记得remove
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class SRadioGroup extends ItemGroup
	{
		public function SRadioGroup(itmLs:Vector.<IItem>=null)
		{
			addItemsByLs(itmLs);
			_selectModel = new ListSelectionData();
			_selectModel.multiSelect = false;
			_selectModel.addListSelectionListener(onSelectChange);
		}
		/**
		 * 选中项改变
		 * @param e
		 */
		private function onSelectChange(e:ListEvent):void
		{
			var m:IListSelectionData = selectModel;
			for (var i:int = 0; i < itemLength; i++) 
			{
				var itm:IItem = itemLs[i] as IItem;
				var itmSelected:Boolean = m.isSelect(i);
				itm.setState(ItemState.SELECT,itmSelected);
			}
			dispatchEvent(new ListEvent(ListEvent.LIST_ITEM_SELECT,null,itm));
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
		
		/**
		 * @inheritDoc
		 */
		override public function addItem(itm:IItem):IItem
		{
			itm.addEventListener(MouseEvent.CLICK,onItemClick);
			return super.addItem(itm);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addItemAt(itm:IItem, index:int):IItem
		{
			itm.addEventListener(MouseEvent.CLICK,onItemClick);
			return super.addItemAt(itm,index);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeItem(itm:IItem):IItem
		{
			itm.removeEventListener(MouseEvent.CLICK,onItemClick);
			return super.removeItem(itm);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeItemAt(index:int):IItem
		{
			var itm:IItem = super.removeItemAt(index);
			itm.removeEventListener(MouseEvent.CLICK,onItemClick);
			return itm;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeAllItems():void
		{
			for each (var itm:IItem in itemLs) 
			{
				itm.removeEventListener(MouseEvent.CLICK,onItemClick);
			}
			super.removeAllItems();
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
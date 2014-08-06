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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import sparrowGui.components.SPopupMenu;
	import sparrowGui.components.base.AlignMgr;
	import sparrowGui.event.ListEvent;
	
	/**
	 * 菜单下拉按钮
	 * @author Pelephone
	 */
	public class SMenuButton extends SToggleButton
	{
		public function SMenuButton(uiVars:Object=null)
		{
			menuPopList = new SPopupMenu();
			super(uiVars || defaultUIVar);
		}
		
		/**
		 * 菜单列表文字
		 */
		public function get menuData():Object
		{
			return menuPopList.data;
		}

		/**
		 * @private
		 */
		public function set menuData(value:Object):void
		{
			menuPopList.data = value;
		}

		
		/**
		 * @inheritDoc
		 */
		override protected function addSkinListen():void
		{
			super.addSkinListen();
			
			menuPopList.addEventListener(ListEvent.LIST_ITEM_SELECT,onFileSelect);
			menuPopList.addEventListener(Event.CANCEL,onCancel);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function removeSkinListen():void
		{
			super.removeSkinListen();
			
			menuPopList.removeEventListener(ListEvent.LIST_ITEM_SELECT,onFileSelect);
			menuPopList.removeEventListener(Event.CANCEL,onCancel);
		}
		
		/**
		 * 弹出下拉菜单列表
		 */
		public var menuPopList:SPopupMenu;
		
		/**
		 * @inheritDoc
		 */
		override protected function onMouseClick(e:MouseEvent):void
		{
			super.onMouseClick(e);
			
			if(this.selected)
			{
				menuPopList.show(this);
				
				var pt:Point = this.localToGlobal(AlignMgr.oPoint);
				AlignMgr.comboboxTipAlign(pt,menuPopList,this.width,this.height,menuPopList.showParent);
			}
			else
				menuPopList.clearUp();
		}
		
		/**
		 * 按钮菜单
		 * @param e
		 */
		private function onCancel(e:Event):void
		{
			selected = false;
		}
		
		/**
		 * 选中项索引
		 */
		public function get selectIndex():int
		{
			return menuPopList.selectIndex;
		}

		/**
		 * 选中项索引
		 */
		public function set selectIndex(value:int):void
		{
			menuPopList.selectIndex = value;
		}
		
		/**
		 * 文件项选择
		 * @param e
		 */
		private function onFileSelect(e:Event):void
		{
			dispatchEvent(e);
		}
	}
}
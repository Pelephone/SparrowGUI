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
	import asSkinStyle.draw.RectDrawBmp;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sparrowGui.components.SWindow;
	import sparrowGui.components.ScrollList;
	import sparrowGui.components.SearchCombobox;
	import sparrowGui.components.item.SButton;
	import sparrowGui.components.item.SListItem;
	import sparrowGui.event.ListEvent;
	import sparrowGui.i.IItem;
	
	
	/**
	 * 资源导航目录
	 * @author Pelephone
	 */
	public class NavLibView extends SWindow
	{
		
		/**
		 * 预览区
		 */
		private var preBG:RectDrawBmp;
		
		/**
		 * 搜索条
		 */
		private var cbSearch:SearchCombobox;
		
		/**
		 * 滚动区
		 */
		private var scrollPan:ScrollList;
		/**
		 * 上下拖动按钮
		 */
		private var btnDrag:SButton;
		
		/**
		 * 预览组件
		 */
		public var preImg:EditURLImg;
		
		private var editMgr:EditMgr = EditMgr.getInstance();
		
		public function NavLibView(uiVars:Object=null)
		{
			super(uiVars);
			width = 126;
			height = ReH;
			
			var padding:int = 20;
			
			preBG = new RectDrawBmp();
			preBG.width = 120;
			preBG.height = 100;
			preBG.border = 1;
			preBG.borderColor = 0xCCCCCC;
			preBG.mouseChildren = false;
			preBG.mouseEnabled = true;
			contDP.addChild(preBG);
			
			preImg = new EditURLImg();
			preImg.mouseChildren = false;
			preImg.mouseEnabled = false;
			preImg.bWidth = preBG.width;
			preImg.bHeight = preBG.height;
			contDP.addChild(preImg);
			
			scrollPan = new ScrollList();
			scrollPan.y = 125;
			scrollPan.width = 118;
			scrollPan.height = height - 170;
			scrollPan.list.updateFunc = upListItem;
//			scrollPan.list.itemClass
			contDP.addChild(scrollPan);
			
			btnDrag = new SButton();
			btnDrag.name = "btnDrag";
			btnDrag.label = "↑↓";
			btnDrag.width = 120;
			btnDrag.height = 18;
			btnDrag.labelText.y = 0;
			btnDrag.y = height - 43;
			contDP.addChild(btnDrag);
			
			cbSearch = new SearchCombobox();
			cbSearch.data = editMgr.searchKeyLs;
			cbSearch.y = 101;
			cbSearch.width = 118;
			contDP.addChild(cbSearch);
			
			contDP.x = 3;
			contDP.y = 22;
			contDP.mouseChildren = true;
			contDP.mouseEnabled = false;
			
			btnDrag.addEventListener(MouseEvent.MOUSE_DOWN,onDragMouseEvent);
			scrollPan.list.addEventListener(ListEvent.LIST_ITEM_SELECT,onListItemSelect);
			cbSearch.addEventListener(Event.CHANGE,onSearchChange);
			cbSearch.addEventListener(ListEvent.LIST_ITEM_SELECT,onSearchChange);
			editMgr.addEventListener(EditMgr.SCAN_COMPLETE,onScanComplete);
			preBG.addEventListener(MouseEvent.MOUSE_DOWN,onPreBGDown);
//			contDP.addEventListener(MouseEvent.MOUSE_DOWN,onPreBGDown);
		}
		
		// 按下预览区
		private function onPreBGDown(e:Event):void
		{
			editMgr.dragLibSrc = preImg.src;
		}
		
		private var ReH:int = 328;
		private var startY:int;
		
		private function onDragMouseEvent(e:Event):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
				{
					startY = this.mouseY;
					ReH = _height;
					this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onDragMouseEvent);
					this.stage.addEventListener(MouseEvent.MOUSE_UP,onDragMouseEvent);
					this.stage.addEventListener(Event.MOUSE_LEAVE,onDragMouseEvent);
					break;
				}
				case MouseEvent.MOUSE_MOVE:
				{
					drageMove();
					break;
				}
					
				default:
				{
					drageMove();
					this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onDragMouseEvent);
					this.stage.removeEventListener(MouseEvent.MOUSE_UP,onDragMouseEvent);
					this.stage.removeEventListener(Event.MOUSE_LEAVE,onDragMouseEvent);
					break;
				}
			}
		}
		
		// 每拖时移动
		private function drageMove():void
		{
			var dy:int = this.mouseY - startY;
			var eh:int = ReH + dy;
			if(eh<250)
				eh = 250;
			else if(eh>700)
				eh = 700;
			this.height = eh;
			btnDrag.y = eh - 43;
			scrollPan.height = eh - 170;
		}
		
		// 选中库目录
		private function onListItemSelect(e:ListEvent):void
		{
			var itm:IItem = e.item;
			var str:String = String(itm.data);
			preImg.src = editMgr.rootPath + str;
		}
		
		// 搜索项改变
		private function onSearchChange(event:Event):void
		{
			var sLabel:String = cbSearch.label;
			if(event is ListEvent)
			{
				var e:ListEvent = event as ListEvent;
				sLabel = String(e.itemData);
			}
			if(sLabel == "all")
			{
				scrollPan.data = editMgr.scanLs;
				return;
			}
			var res:Array = [];
			var str:String;
			for each (str in editMgr.scanLs) 
			{
				if(str.indexOf(cbSearch.label)>=0)
					res.push(str);
			}
			scrollPan.data = res;
		}
		
		// 更新子项
		private function upListItem(itm:SListItem):void
		{
			itm.width = 100;
			var data:String = String(itm.data);
			var tid:int = data.lastIndexOf("/");
			if(tid<0)
				return;
			var str:String = data.substring(0,tid);
			tid = str.lastIndexOf("/");
			if(tid<0)
				return;
			str = data.substring(tid + 1);
			itm.label = str;
		}
		
		// 扫描完成
		private function onScanComplete(e:Event):void
		{
			scrollPan.data = editMgr.scanLs;
			cbSearch.data = editMgr.searchKeyLs;
		}
	}
}
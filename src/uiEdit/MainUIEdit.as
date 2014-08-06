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
	import asSkinStyle.ReflPositionInfo;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.Security;
	import flash.ui.Keyboard;
	
	import sparrowGui.SparrowMgr;
	import sparrowGui.components.item.SButton;
	
	/**
	 * UI编辑工具
	 * @author Pelephone
	 */
	public class MainUIEdit extends Sprite
	{
		public function MainUIEdit()
		{
//			this.mouseEnabled = false;
//			mouseChildren = false;
			
			if(this.stage)
			{
				init();
				return;
			}
			this.addEventListener(Event.ADDED_TO_STAGE,init);
			this.addEventListener(Event.REMOVED_FROM_STAGE,removeToStage);
		}
		
		/**
		 * 加入舞台
		 */
		private function init(e:Event=null):void
		{
			Security.allowDomain("*");
			
			this.removeEventListener(Event.ADDED_TO_STAGE,init);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,removeToStage);
			new SparrowMgr(this,500,500);
			sstage = stage;
			sstage.addEventListener(KeyboardEvent.KEY_UP,onStageKeyUp);
			
			uiEditor.addEventListener("ReCreateView",onReCreateView);
			editMgr.loadCfg();
//			var a:SList = new SList();
//			a.data = ["11",22,33,44];
//			addChild(a);
			
			var obj:Object = this.loaderInfo.parameters;
			if(obj && obj["parseMode"])
			{
				setParseMode(int(obj["parseMode"]));
			}
			
			editMgr.addEventListener(EditMgr.CFG_COMPLETE,onCfgComplete);
			
			stage.stageFocusRect = false;
			this.root.stage.addEventListener(Event.RESIZE,onStageResize);
			onStageResize();
			
			/*
			this.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
			this.stage.align = flash.display.StageAlign.TOP_LEFT;
			test();
		}
		
		private function test():void
		{
			addChild(new SButton());*/
		}
		
		private function onStageResize(event:Event=null):void
		{
			SparrowMgr.stageWidth = this.stage.width;
			SparrowMgr.stageHeight = this.stage.height;
		}
		
		private function onReCreateView(event:Event):void
		{
			sstage.dispatchEvent(new EditEvent("ReCreateView",[editMgr.editTarget,uiEditor.loadingContent,editMgr.cfgData]));
		}
		
		private var editMgr:EditMgr = EditMgr.getInstance();
		
		private function onCfgComplete(event:Event):void
		{
			setParseMode(editMgr.parseMode);
		}
		
		/**
		 * 移出舞台
		 * @param e
		 */
		private function removeToStage(e:Event):void
		{
			sstage.removeEventListener(KeyboardEvent.KEY_UP,onStageKeyUp);
		}
		
		private var sstage:DisplayObjectContainer;
		
		/**
		 * UI编辑器
		 */
		private var uiEditor:UIEditor = new UIEditor();
		
		/**
		 * 打开UI编辑器
		 * @param e
		 */
		private function onStageKeyUp(e:KeyboardEvent):void
		{
			if(e.shiftKey && e.keyCode == editMgr.showKey)
				this.addChild(uiEditor);
			else if(uiEditor.parent && e.shiftKey && e.keyCode == Keyboard.BACKSLASH)
				editMgr.loadCfg();
		}
		
		/**
		 * 显示待选子项
		 * @param tar
		 */
		public function showUnderDsp(dspc:DisplayObjectContainer):void
		{
			uiEditor.showUnderDsp(dspc);
		}
		
		/**
		 * 设置解析模式
		 */
		public function setParseMode(value:int):void
		{
			uiEditor.parseMode = value;
			if(value == 2)
				ReflPositionInfo.STRICT_JSON = true;
		}
	}
}
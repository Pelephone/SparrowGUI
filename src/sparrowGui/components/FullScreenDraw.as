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
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import sparrowGui.SparrowMgr;
	
	import utils.tools.StageTool;
	
	
	/**
	 * 全屏遮挡,跟据场景变化而改变宽高
	 * @author Pelephone
	 */
	public class FullScreenDraw extends Sprite
	{
		public function FullScreenDraw()
		{
			super();
			onSkinDraw();
			StageTool.addSkinInit(this,onChangeRect);
			addEventListener(Event.ADDED_TO_STAGE,onToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,onToStage);
		}
		
		/**
		 * 添加到舞台
		 * @param e
		 */
		private function onToStage(e:Event):void
		{
			switch(e.type)
			{
				case Event.ADDED_TO_STAGE:
//					StageMgr.getInstance().registerResizeListener(onChangeRect);
					SparrowMgr.mainDisp.stage.addEventListener(Event.RESIZE,onChangeRect);
					break;
				case Event.REMOVED_FROM_STAGE:
					SparrowMgr.mainDisp.stage.removeEventListener(Event.RESIZE,onChangeRect);
//					StageMgr.getInstance().removeResizeListener(onChangeRect);
					break;
			}
		}
		
		/**
		 * 左边界宽
		 */
		public var paddingLeft:int = -50;
		/**
		 * 右边界宽
		 */
		public var paddingRight:int = -50;
		/**
		 * 上边界宽
		 */
		public var paddingTop:int = -50;
		/**
		 * 下边界宽
		 */
		public var paddingButtom:int = -50;
		
		public function set padding(value:int):void 
		{
			paddingTop = value;
			paddingLeft = value;
			paddingButtom = value;
			paddingRight = value;
			onChangeRect();
		}
		
		/**
		 * 透明度
		 */
		public var showAlpha:Number = 0.3;
		
		private function onSkinDraw():void
		{
			var gp:Graphics = graphics;
			gp.clear();
			gp.beginFill(0x000000,1);
			
			gp.drawRect(0,0,10,10);
			gp.endFill();
			alpha = showAlpha;
		}
		
		/**
		 * 跟椐屏幕改变尺寸
		 * @param e
		 */
		private function onChangeRect(e:Event=null):void
		{
			width = SparrowMgr.stageWidth - paddingLeft - paddingRight;
			height = SparrowMgr.stageHeight - paddingTop - paddingButtom;
			x = paddingLeft;
			y = paddingTop;
		}
	}
}
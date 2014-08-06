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
package sparrowGui.components.base
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import sparrowGui.SparrowMgr;
	
	/**
	 * 显示对齐管理
	 * @author Pelephone
	 */
	public class AlignMgr
	{
		/**
		 * 0,0原点
		 */
		public static const oPoint:Point = new Point();
		
		/**
		 * B对象相对A右下浮动对齐,如果超出边限自动向左上显示
		 * @param tarDsp	对象显示(要被设置位置的显示对象)，此对象必须加入了舞台
		 * @param globalPt	参考的全局点
		 * @param refWidth	参照对象的宽
		 * @param refHeight	参照对象的高
		 */
		public static function rightDownAlignAuto(tarDsp:DisplayObject,globalPt:Point
													 ,refWidth:int=0,refHeight:int=0,toParent:DisplayObject=null):void
		{
			if(!toParent)
				toParent = tarDsp.parent;
			if(!toParent)
				return;
			// 参考对象相对全局的坐标
			var startPt:Point = toParent.globalToLocal(globalPt);
			// 场景右下角的点转相对父容易坐标
			var stageOutPt:Point = new Point(SparrowMgr.stageWidth,SparrowMgr.stageHeight);
			var soPt:Point = toParent.globalToLocal(stageOutPt);
			
			// x超过舞台边界,左对齐
			if((globalPt.x + refWidth + tarDsp.width)>SparrowMgr.stageWidth)
				tarDsp.x = startPt.x - tarDsp.width;
			else
				tarDsp.x = startPt.x + refWidth;
			
			// y超过舞台边界,上对齐
			if((globalPt.y + tarDsp.height + refHeight)>SparrowMgr.stageHeight)
				tarDsp.y = soPt.y - tarDsp.height;
			else
				tarDsp.y = startPt.y + refHeight;
		}
		
		/**
		 * 组合提示窗对齐
		 */
		public static function comboboxTipAlign(globalPt:Point,tarDsp:DisplayObject
												  ,refWidth:int=0,refHeight:int=0,toParent:DisplayObject=null):void
		{
			if(!toParent)
				toParent = tarDsp.parent;
			if(!toParent)
				return;
			// 参考对象相对全局的坐标
			var startPt:Point = toParent.globalToLocal(globalPt);
			// 场景右下角的点转相对父容易坐标
			var stageOutPt:Point = new Point(SparrowMgr.stageWidth,SparrowMgr.stageHeight);
			var soPt:Point = toParent.globalToLocal(stageOutPt);
			
			tarDsp.x = startPt.x;
			
			// y超过舞台边界,上对齐
			if((globalPt.y + tarDsp.height + refHeight)>SparrowMgr.stageHeight)
				tarDsp.y = startPt.y - tarDsp.height;
			else
				tarDsp.y = startPt.y + refHeight;
		}
	}
}
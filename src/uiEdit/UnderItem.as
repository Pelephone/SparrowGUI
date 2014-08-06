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
	import asSkinStyle.draw.RectDraw;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sparrowGui.components.item.SListItem;
	
	
	/**
	 * 子对象
	 * @author Pelephone
	 */
	public class UnderItem extends SListItem
	{
		public function UnderItem(uiVars:Object=null)
		{
			super(uiVars);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set data(value:Object):void
		{
			if(super.data == value)
				return;
			
			super.data = value;
			var dsp:DisplayObject = value as DisplayObject;
			if(dsp && !(dsp is Stage))
			{
				this.addEventListener(MouseEvent.ROLL_OVER,onDspDataEvt);
				this.addEventListener(MouseEvent.ROLL_OUT,onDspDataEvt);
			}
			else
			{
				this.removeEventListener(MouseEvent.ROLL_OVER,onDspDataEvt);
				this.removeEventListener(MouseEvent.ROLL_OUT,onDspDataEvt);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get label():String
		{
			if(_data && _data.name && _data.name.indexOf("instance")!=0)
				return String(_data.name);
			return String(_data);
		}
		
		/**
		 * 显示对象鼠标经过事件
		 * @param e
		 */
		private function onDspDataEvt(e:Event):void
		{
			var dsp:DisplayObject = super.data as DisplayObject;
			if(!dsp)
				return;
			switch(e.type)
			{
				case MouseEvent.ROLL_OUT:
					if(rectSp.parent)
						rectSp.parent.removeChild(rectSp);
					break;
				case MouseEvent.ROLL_OVER:
					rectSp.width = dsp.width;
					rectSp.height = dsp.height;
					var rt:Rectangle = dsp.getBounds(dsp.parent);
					rectSp.x = rt.x;
					rectSp.y = rt.y;
					dsp.parent.addChild(rectSp);
					break;
			}
		}
		
		/**
		 * 鼠标经过显示图形
		 */
		private static var OVER_RECT:RectDraw;
		
		private function get rectSp():RectDraw 
		{
			if(!OVER_RECT)
			{
				OVER_RECT = new RectDraw();
				OVER_RECT.bgAlpha = 0.01;
				OVER_RECT.border = 1;
				OVER_RECT.borderColor = 0xFF0000;
			}
			return OVER_RECT;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			super.dispose();
			
			var rectSp:DisplayObject = OVER_RECT;
			if(rectSp && rectSp.parent)
				rectSp.parent.removeChild(rectSp);
			this.removeEventListener(MouseEvent.ROLL_OVER,onDspDataEvt);
			this.removeEventListener(MouseEvent.ROLL_OUT,onDspDataEvt);
		}
	}
}
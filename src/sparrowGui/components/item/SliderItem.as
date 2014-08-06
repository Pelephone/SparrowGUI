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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sparrowGui.data.ItemState;
	
	/**
	 * 滚动条中间项
	 * @author Pelephone
	 */
	public class SliderItem extends SItem
	{
		public function SliderItem(uiVars:Object=null)
		{
			super(uiVars || defaultUIVar);
		}
		
		override protected function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
			
			this.buttonMode = true;
			this.hitArea = (hitTestState as Sprite);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultUIVar():Object
		{
			return "sliderItem";
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set currentState(value:String):void
		{
			if(selected)
				super.currentState = ItemState.SELECT;
			else if(!enabled)
				super.currentState = ItemState.ENABLED;
			else
				super.currentState = value;
		}

		
		//---------------------------------------------------
		// 事件
		//---------------------------------------------------
		
		protected function addSkinListen():void
		{
			// ROLL_OVER无视子对象事件,MOUSE_OVER相反
			this.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP,onEvtOut);
			this.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
		}
		
		protected function removeSkinListen():void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.removeEventListener(MouseEvent.MOUSE_UP,onEvtOut);
			this.removeEventListener(MouseEvent.ROLL_OVER,onRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT,onRollOut);
			if(!this.stage) return;
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onEvtOut);
			this.stage.removeEventListener(Event.MOUSE_LEAVE, onEvtOut);
		}
		
		/**
		 * 鼠标经过事件
		 * @param e
		 */
		protected function onRollOver(e:MouseEvent):void
		{
			if(!enabled || selected)
				return;
			
			currentState = ItemState.OVER;
		}
		
		/**
		 * 鼠标按下
		 * @param e
		 */
		protected function onMouseDown(e:MouseEvent):void
		{
			if(!enabled || selected)
				return;
			
			currentState = ItemState.DOWN;
			if(!this || !this.stage) return;
			
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onEvtOut);
			this.stage.addEventListener(Event.MOUSE_LEAVE,onEvtOut);
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.removeEventListener(MouseEvent.ROLL_OVER,onRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT,onRollOut);
		}
		
		/**
		 * 移开事件
		 * @param e
		 */
		protected function onEvtOut(e:Event):void
		{
			if(!enabled || selected)
				return;
			
			var me:MouseEvent = e as MouseEvent;
			var isOver:Boolean = (me && me.currentTarget==this);
			//				if(me.stageX>=pt.x && me.stageX<=(pt.x + skin.width)
			//				&& me.stageY>=pt.y && me.stageY<=(pt.y + skin.height))
			//					isOver = true;
			if(!isOver)
				currentState = ItemState.UP;
			else
				currentState = ItemState.OVER;
			
			if(!this || !this.stage) return;
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onEvtOut);
			this.stage.removeEventListener(Event.MOUSE_LEAVE, onEvtOut);
			
			this.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
		}
		
		/**
		 * 鼠标移开事件
		 */
		protected function onRollOut(e:MouseEvent):void
		{
			if(!enabled || selected)
				return;
			
			currentState = ItemState.UP;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			removeSkinListen();
			super.dispose();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function reset():void
		{
			super.reset();
			addSkinListen();	
		}
	}
}
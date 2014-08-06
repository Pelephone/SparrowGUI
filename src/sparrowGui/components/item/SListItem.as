package sparrowGui.components.item
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sparrowGui.data.ItemState;
	import sparrowGui.i.IRichItem;
	
	/**
	 * 列表项，有六状态，有经过移动事件，不过没有选中事件
	 * 
	 * 例子如下
	 * 
	 * var itm:SItem = new SListItem();
		itm.update("按钮文字");
		addChild(itm);
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class SListItem extends SButton implements IRichItem
	{
		
		/**
		 * 选中状态
		 */
		private var _selected:Boolean;
		
		public function SListItem(uiVars:Object=null)
		{
			super(uiVars || defaultUIVar);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultUIVar():Object
		{
			return "richItem";
		}
		
		override protected function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
			
			this.mouseChildren = false;
			
			_selectState = getChildByName(ItemState.SELECT);
			_enabledState = getChildByName(ItemState.ENABLED);
			
			enabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			if(isRendering)
			{
				if(_selectState)
					_selectState.width = _width;
				if(_enabledState)
					_enabledState.width = _width;
				
				if(_selectState)
					_selectState.height = _height;
				if(_enabledState)
					_enabledState.height = _height;
			}
			
			super.draw();
		}
		
		//----------------------------------------------------
		// 事件
		//----------------------------------------------------
		
		override protected function onEvtOut(e:Event):void
		{
			// 选中的时候把其它的事件过滤
			if(selected)
				return;
			
			super.onEvtOut(e);
		}
		
		override protected function onMouseDown(e:MouseEvent):void
		{
			if(selected) return;
			super.onMouseDown(e);
		}
		
		override protected function onRollOut(e:MouseEvent):void
		{
			if(selected) return;
			super.onRollOut(e);
		}
		
		override protected function onRollOver(e:MouseEvent):void
		{
			if(selected) return;
			super.onRollOver(e);
		}
		
		//----------------------------------------------------
		// 状态
		//----------------------------------------------------
		
		/**
		 * @inheritDoc
		 
		override protected function stateRender():void
		{
			if(!enabled)
			{
				changeStateShow(ItemState.ENABLED);
				return;
			}
			
			if(selected)
			{
				changeStateShow(ItemState.SELECT);
				return;
			}
			super.stateRender();
		}*/
		
		override protected function get states():Array
		{
			return super.states.concat([ItemState.SELECT,ItemState.ENABLED]);
		}
		
		protected var _selectState:DisplayObject;
		protected var _enabledState:DisplayObject;
		public function get selectState():DisplayObject
		{
			return _selectState;
		}

		public function get enabledState():DisplayObject
		{
			return _enabledState;
		}
	}
}
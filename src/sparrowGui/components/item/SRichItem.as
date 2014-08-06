package sparrowGui.components.item
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import sparrowGui.data.ItemState;
	import sparrowGui.event.ItemEvent;
	import sparrowGui.i.IRichItem;
	
	/** 项数据更新. **/
	[Event(name="item_update", 	type="sparrowGui.event.ItemEvent")]
	/** 项选中状态改变. **/
	[Event(name="item_select_change", 	type="sparrowGui.event.ItemEvent")]
	/** 项可用状态改变. **/
	[Event(name="item_ebable_change", 	type="sparrowGui.event.ItemEvent")]
	
	/**
	 * 富项,除了基本的鼠标四态外，还添了选中和不可选状态
	 * 操作跟RichMCBtn一样，不过本控件是visible控制的
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class SRichItem extends SItem implements IRichItem
	{
		protected var selectState:DisplayObject;
		protected var enabledState:DisplayObject;
		
		/**
		 * 选中状态
		 */
		private var _selected:Boolean;
		
		public function SRichItem(uiVars:Object=null)
		{
			super(uiVars || defaultUIVar);
		}
		
		override public function set data(o:Object):void
		{
			super.data = o;
			dispatchEvent(new ItemEvent(ItemEvent.ITEM_UPDATE));
		}
		
		override protected function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
			
			this.mouseChildren = false;
			
			selectState = getChildByName(ItemState.SELECT);
			enabledState = getChildByName(ItemState.ENABLED);
			
			_selected = false;
			super.enabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			selectState.width = _width;
			enabledState.height = _height;
			
			super.draw();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultUIVar():Object
		{
			return "richItem";
		}
		
		///////////////////////////////////
		// get/set
		//////////////////////////////////
		
		override protected function get states():Array
		{
			return [upState,overState,downState,selectState,enabledState];
		}
		
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
	}
}
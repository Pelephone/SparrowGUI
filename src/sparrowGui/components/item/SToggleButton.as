package sparrowGui.components.item
{
	import flash.events.MouseEvent;
	
	import sparrowGui.data.ItemState;
	import sparrowGui.event.ItemEvent;
	
	/** 项数据更新. **/
	[Event(name="item_update", 	type="sparrowGui.event.ItemEvent")]
	/** 项选中状态改变. **/
	[Event(name="item_select_change", 	type="sparrowGui.event.ItemEvent")]
	/** 项可用状态改变. **/
	[Event(name="item_ebable_change", 	type="sparrowGui.event.ItemEvent")]

	/**
	 * 六状开关按钮按钮,点第一次选中点第二次返选
	 * 
	 * 例子如下
	 * 
	 * var itm:SItem = new SToggleButton();
		itm.update("按钮文字");
		addChild(itm);
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class SToggleButton extends SListItem
	{
		/**
		 * 构造列表项
		 * @param uiVars
		 */
		public function SToggleButton(uiVars:Object=null)
		{
			super(uiVars || defaultUIVar);
		}
		
		/**
		 * @inheritDoc
		 
		override protected function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
			
		}*/
		
		/**
		 * @inheritDoc
		 
		override public function setUiStyle(uiVars:Object=null):void
		{
			super.setUiStyle(uiVars);
			
		}*/
		
		/**
		 * @inheritDoc
		 
		override protected function draw():void
		{
			super.draw();
			
		}*/
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			super.width = value;
			
		}
		
		/**
		 * @inheritDoc
		 
		override protected function stateRender():void
		{
			var osr:Boolean = isStateRendering;
			super.stateRender();
			if(selected != lastSelect)
				dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECT_CHANGE));
		}*/
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultUIVar():Object
		{
			return "toggleBtn";
		}
		
		override protected function addSkinListen():void
		{
			super.addSkinListen();
			addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		override protected function removeSkinListen():void
		{
			super.removeSkinListen();
			removeEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		protected function onMouseClick(e:MouseEvent):void
		{
			if(!enabled)
				return;
			
			selected = !selected;
		}
		
		/**
		 * 上次选中状态
		 */
		private var lastSelect:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		override public function set selected(value:Boolean):void
		{
			if(super.selected == value)
				return;
			super.selected = value;
			dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECT_CHANGE));
		}
	}
}
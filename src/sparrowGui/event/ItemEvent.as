package sparrowGui.event
{
	import flash.events.Event;

	/**
	 * 项事件
	 * @author Pelephone
	 */
	public class ItemEvent extends Event
	{
		/**
		 * 项更新
		 */
		public static const ITEM_UPDATE:String = "item_update";
		/**
		 * 项选中状态改变
		 */
		public static const ITEM_SELECT_CHANGE:String = "item_select_change";
		/**
		 * 项是否可用状态改变
		 */
		public static const ITEM_EBABLE_CHANGE:String = "item_ebable_change";
		
		/**
		 * 项折叠,树形项用
		 */
		public static const ITEM_FOLD_CHANGE:String = "item_fold_change";
		
		/**
		 * 用于更新的数据
		 
		private var itemData:Object;*/
		/**
		 * 更新的项
		 
		private var item:Item;*/
		
		public function ItemEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new ItemEvent(type, bubbles, cancelable);
		}
		override public function toString():String
		{
			return formatToString("ItemEvent", "type", "bubbles", "cancelable",
				"eventPhase");
		}
	}
}
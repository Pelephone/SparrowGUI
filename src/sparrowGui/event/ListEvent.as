package sparrowGui.event
{
	import flash.events.Event;
	
	import sparrowGui.i.IItem;
	
	public class ListEvent extends Event
	{
		/**
		 * 列表项初始
		 */
		public static const LIST_ITEM_INIT:String = "list_item_init";
		/**
		 * 列表项创建
		 */
		public static const LIST_ITEM_CREATE:String = "list_item_create";
		/**
		 * 列表项更新
		 */
		public static const LIST_ITEM_UPDATE:String = "list_item_update";
		/**
		 * 列表项移除
		 */
		public static const LIST_ITEM_REMOVE:String = "list_item_remove";
		/**
		 * 列表面缓存
		 */
		public static const LIST_ITEM_CACHE:String = "list_item_cache";
		/**
		 * 列表选中状态改变
		 */
		public static const LIST_ITEM_SELECT:String = "list_item_select";
		/**
		 * 树形组件折叠改变
		 */
		public static const LIST_ITEM_FOLD:String = "list_item_fold";
		
		/**
		 * 子项布局更新
		 */
		public static const LAYOUT_UPDATE:String = "layout_update";
		/**
		 * 所有项数据更新
		 */
		public static const UPDATE_ALL:String = "update_all";
		
		private var _item:IItem;
		private var _itemData:Object;
		
		/**
		 * 列表事件
		 * @param type
		 * @param oItemData		更新的项数据
		 * @param oItem			更新的项
		 * @param bubbles
		 * @param cancelable
		 */
		public function ListEvent(type:String,oItemData:Object=null,oItem:IItem=null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_item = oItem;
			_itemData = oItemData
		}
		override public function clone():Event
		{
			return new ListEvent(type, _itemData, _item, bubbles, cancelable);
		}
		override public function toString():String
		{
			return formatToString("ListEvent", "type", "bubbles", "cancelable",
				"eventPhase");
		}

		/**
		 * 列表当前操作的项
		 */
		public function get item():IItem
		{
			return _item;
		}
		
		
		/**
		 * 列表当前操作的项
		 */
		public function get itemData():Object
		{
			return _itemData;
		}
	}
}
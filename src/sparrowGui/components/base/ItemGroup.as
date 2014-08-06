package sparrowGui.components.base
{
	import flash.events.EventDispatcher;
	
	import sparrowGui.i.IItem;
	
	/**
	 * 项组映射管理组件。
	 * 对子项组进行增删改查管理
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class ItemGroup extends EventDispatcher
	{
		
		public function ItemGroup()
		{
			_itemLs = new Vector.<IItem>();
		}
		
		
		//----------------------------------------------------
		// 项增删改查
		//----------------------------------------------------
		
		protected var _itemLs:Vector.<IItem>;
		
		/**
		 * 项数组
		 */
		public function get itemLs():Vector.<IItem>
		{
			return _itemLs;
		}
		
		/**
		 * 添加项
		 * @param itm
		 * @return 
		 */
		public function addItem(itm:IItem):IItem
		{
			itm.itemIndex = itemLs.length;
			itemLs.push(itm);
			return itm;
		}
		
		/**
		 * 指定位置加入项
		 * @param itm
		 * @param index
		 */
		public function addItemAt(itm:IItem,index:int):IItem
		{
			if(index>=itemLs.length && index<0) return null;
			itemLs.splice(index, 0, itm);
			for (var i:int = index; i < itemLs.length; i++) 
			{
				var itm:IItem = itemLs[i];
				itm.itemIndex = i;
			}
			return itm;
		}
		
		/**
		 * 移出某位置上的项
		 * @param index
		 */
		public function removeItemAt(index:int):IItem
		{
			if(index>=itemLs.length && index<0) return null;
			var itm:IItem = itemLs.splice(index,1)[0];
			for (var i:int = index; i < itemLs.length; i++) 
			{
				itm = itemLs[i];
				itm.itemIndex = i;
			}
			return itm;
		}
		
		/**
		 * 移出某项
		 * @param itm
		 */
		public function removeItem(itm:IItem):IItem
		{
			var index:int = itemLs.indexOf(itm);
			return removeItemAt(index);
		}
		
		/**
		 * 通过项index获取项(data是数组的时候可用,如果data是哈希数据,可以用getItemByArgs)
		 */
		public function getItemAt(index:int):IItem
		{
			if(!itemLs || itemLs.length<=index || index<0)
				return null;
			return itemLs[index];
		}
		
		//---------------------------------------------------
		// 批量管理
		//---------------------------------------------------
		
		/**
		 * 批量添加子项
		 * @param itmLs
		 */
		public function addItemsByLs(itmLs:Vector.<IItem>):void
		{
			for each (var itm:IItem in itmLs) 
			{
				addItem(itm);
			}
		}
		
		/**
		 * 移除所有项
		 */
		public function removeAllItems():void
		{
			_itemLs = new Vector.<IItem>();
		}
		
		/**
		 * 子项长
		 * @return 
		 */
		public function get itemLength():int
		{
			return _itemLs.length;
		}

		/**
		 * 销毁
		 */
		public function dispose():void
		{
			_itemLs = new Vector.<IItem>();
		}
	}
}
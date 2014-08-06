package sparrowGui.data
{
	import flash.events.EventDispatcher;
	
	import sparrowGui.event.ListEvent;
	import sparrowGui.i.IListSelectionData;
	
	/**
	 * 选中数据(Model)
	 * 有添加删除选中项等方法
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class ListSelectionData extends EventDispatcher implements IListSelectionData
	{
		/** 项选中状态改变. **/
		[Event(name="list_item_select", 	type="sparrowGui.event.ListEvent")]
		
		/**
		 * 选中项index索引数组数据
		 */
		private var IndexLs:Vector.<int>;
		
		/**
		 * 构造选中项数据
		 * @param target
		 */
		public function ListSelectionData()
		{
			IndexLs = new Vector.<int>();
		}
		
		/**
		 * 设置选中项
		 * @param index
		 */
		public function setSelect(index:int):void
		{
			if(isSelect(index))
			{
				removeSelect(index);
				dispatchEvent(new ListEvent(ListEvent.LIST_ITEM_SELECT));
				return;
			}
			
			if(!multiSelect)
				IndexLs = Vector.<int>([index]);
			else
				IndexLs.push(index);
			
			dispatchEvent(new ListEvent(ListEvent.LIST_ITEM_SELECT));
		}
		
		/**
		 * 添加选项
		 * @param index
		 */
		public function addSelect(index:int):void
		{
			if(!multiSelect)
				setSelect(index);
			else if(multiSelect && IndexLs.indexOf(index)<0)
				IndexLs.push(index);
			dispatchEvent(new ListEvent(ListEvent.LIST_ITEM_SELECT));
		}
		
		/**
		 * 移除选项
		 * @param index
		 */
		public function removeSelect(index:int):void
		{
			// 至少选中一项
			if(mustSelect && IndexLs.length<=1)
				return;
			
			var vid:int = IndexLs.indexOf(index);
			if(vid>=0)
				IndexLs.splice(vid,1);
			
			dispatchEvent(new ListEvent(ListEvent.LIST_ITEM_SELECT));
		}
		
		/**
		 * 移除所有选中项
		 */
		public function removeAllSelect(isEvt:Boolean = true):void
		{
			// 至少选中一项
			if(mustSelect && IndexLs.length>1)
				IndexLs = IndexLs.splice(0,1);
			else
				IndexLs = new Vector.<int>();
			
			if(isEvt)
			dispatchEvent(new ListEvent(ListEvent.LIST_ITEM_SELECT));
		}
		
		public function addListSelectionListener(listener:Function):void
		{
			addEventListener(ListEvent.LIST_ITEM_SELECT,listener);
		}
		
		public function removeListSelectionListener(listener:Function):void
		{
			removeEventListener(ListEvent.LIST_ITEM_SELECT,listener);
		}
		
		/**
		 * 反选(此方法用时必须传一个最大项,即当前组件有多少项)
		 */
		public function invertSelect(max:int=0):void
		{
			var newValue:Vector.<int> = new Vector.<int>();
			for (var i:int = 0; i < max; i++) 
			{
				if(IndexLs.indexOf(i)<0)
					newValue.push(i);
			}
			IndexLs = newValue;
		}
		
		public function getSelectIndex():int
		{
			if(IndexLs.length)
				return IndexLs[0];
			else
				return -1;
		}
		
		public function getSelectIds():Vector.<int>
		{
			return IndexLs;
		}
		
		
		public function isSelect(index:int):Boolean
		{
			return IndexLs.indexOf(index)>=0;
		}
		
		/////////////////////////////////////////////////////
		// multiSelect
		/////////////////////////////////////////////////////
		
		private var _multiSelect:Boolean = false;
		
		/**
		 * 是否支持多选，默认只能单选
		 */
		public function get multiSelect():Boolean
		{
			return _multiSelect;
		}

		/**
		 * @private
		 */
		public function set multiSelect(value:Boolean):void
		{
			_multiSelect = value;
		}
		
		/////////////////////////////////////////////////////
		// mushSelect
		/////////////////////////////////////////////////////
		
		private var _mustSelect:Boolean = true;

		/**
		 * 至少有一个项被选中
		 */
		public function get mustSelect():Boolean
		{
			return _mustSelect;
		}

		/**
		 * @private
		 */
		public function set mustSelect(value:Boolean):void
		{
			_mustSelect = value;
		}
		
		public function hasSelected(index:int):Boolean
		{
			return (!_multiSelect && getSelectIndex()==index)
		}
	}
}
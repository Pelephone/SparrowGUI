package sparrowGui.components
{
	import flash.display.DisplayObject;
	
	import sparrowGui.SparrowMgr;
	import sparrowGui.components.item.STreeChildItem;
	import sparrowGui.components.item.STreeItem;
	import sparrowGui.data.TreeComposite;
	import sparrowGui.event.ItemEvent;
	import sparrowGui.event.ListEvent;
	import sparrowGui.i.IItem;
	
	/** 项数据更新. **/
	[Event(name="list_item_update", 	type="sparrowGui.event.ListEvent")]
	/** 项选中状态改变. **/
	[Event(name="list_item_select", 	type="sparrowGui.event.ListEvent")]
	/** 项可折叠. **/
	[Event(name="list_item_fold", 	type="sparrowGui.event.ListEvent")]
	
	/**
	 * 树形组件,仿资源管理器
	 * 收缩会取消选择所有项
	 * 
	 * <tree>
	 * 		<node id='' pid='' skinCls='' txtName='' selected='' />
	 * 		<node id='' pid='' skinCls='' txtName='' selected='' />
	 * </tree>
	 * 
	 * 还缺少键盘上下事件未实现
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class STree extends SList
	{
		// 根节点id
		private static const ROOT_ID:int = 0;
		
		public function STree(uiVars:Object=null)
		{
			super(uiVars || defaultUIVar);
			itemClass = STreeItem;
			itemWidth = -1;
		}
		
		
		/**
		 * 项组
		 
		 private var _group:ItemGroup;*/
		
		/**
		 * 将数据转为数组，用于获取选中项
		 
		 private var _dataAry:Array;*/
		/**
		 * id映射数据
		 */
		private var dataIdHm:Object;	//<int,TreeComposite>
		
		/**
		 * @inheritDoc
		 */
		override public function set data(value:Object):void
		{
			if(_data == value)
				return;
			
			for each (var tcItm:TreeComposite in _dataAry) 
			tcItm.remove(tcItm);
			
			_data = value;
			
			_dataAry = [];
			dataIdHm = {};
			dataIdHm[ROOT_ID] = new TreeComposite(null);
			for each (var itm:Object in value) 
			{
				var tc:TreeComposite = new TreeComposite(itm);
				_dataAry.push(tc);
				dataIdHm[tc.id] = tc;
			}
			
			for each (tcItm in _dataAry) 
			{
				var parentNode:TreeComposite = dataIdHm[tcItm.parendId] as TreeComposite;
				if(parentNode)
					parentNode.add(tcItm);
			}
			
			invalidateDraw();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeAllItems():void
		{
			for each (var itm:IItem in _group.itemLs) 
			{
				itm.removeEventListener(ItemEvent.ITEM_FOLD_CHANGE,onItemFoldEvt);
				itm.removeEventListener(ItemEvent.ITEM_SELECT_CHANGE,onItemClick);
			}
			super.removeAllItems();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function layoutItems():void
		{
			if(isActLayout)
			{
				isActLayout = false;
				var loGroup:Array = [];
				for each (var itm:IItem in _group.itemLs) 
				{
					var data:TreeComposite = itm.data as TreeComposite;
					if(!data)
						continue;
					if(!data.parent || !data.parent.folded || data.parendId == ROOT_ID)
					{
						itm.addToParent(this);
						loGroup.push(itm);
					}
					else
					{
						var dsp:DisplayObject = itm as DisplayObject;
						if(dsp && dsp.parent)
							dsp.parent.removeChild(dsp);
					}
				}
				
				if(_layout && _group.itemLs.length>0)
				{
					_layout.updateDisplayList(loGroup);
					dispatchEvent(new ListEvent(ListEvent.LAYOUT_UPDATE));
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createItem(data:Object):IItem
		{
			var tcp:TreeComposite = data as TreeComposite;
			if(!tcp || tcp.parendId == ROOT_ID)
				return super.createItem(data);
			else
			{
				var itm:IItem = SparrowMgr.getAndCreatePoolObj(childItemClass) as IItem;
				itm.data = data;
				return itm;
			}
		}
		
		/**
		 * 子项类类型
		 */
		public var childItemClass:Class = STreeChildItem;
		
		/**
		 * @inheritDoc
		 */
		override public function addItem(itm:IItem):void
		{
			_group.addItem(itm);
			itm.addEventListener(ItemEvent.ITEM_FOLD_CHANGE,onItemFoldEvt);
			itm.addEventListener(ItemEvent.ITEM_SELECT_CHANGE,onItemClick);
			
			if(updateFunc != null)
				updateFunc.apply(null,[itm]);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeItem(itm:IItem):void
		{
			itm.removeEventListener(ItemEvent.ITEM_FOLD_CHANGE,onItemFoldEvt);
			itm.removeEventListener(ItemEvent.ITEM_SELECT_CHANGE,onItemClick);
			super.removeItem(itm);
		}
		
		override protected function get defaultUIVar():Object
		{
			return "tree";
		}
		
		/**
		 * 合起事件
		 * @param e
		 */
		private function onItemFoldEvt(e:ItemEvent):void
		{
			var itm:IItem = e.currentTarget as IItem;
			if(!itm)
				return;
			var tcp:TreeComposite = itm.data as TreeComposite;
			if(!tcp)
				return;
			tcp.folded = !tcp.folded;
			// 如果是合起的话，选中项所有子项反项
			if(tcp.folded)
			{
				for (var i:int = 0; i < tcp.numChildren; i++) 
				{
					var tcItm:TreeComposite = tcp.getChildById(i);
					if(tcItm.selected)
					{
						selectModel.removeAllSelect();
						break;
					}
				}
			}
			
			invalidateLayout();
		}
	}
}
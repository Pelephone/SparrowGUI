package sparrowGui.components
{
	import asCachePool.interfaces.IRecycle;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sparrowGui.SparrowMgr;
	import sparrowGui.components.base.BaseUIComponent;
	import sparrowGui.components.base.ItemGroup;
	import sparrowGui.components.base.LayoutClip;
	import sparrowGui.components.item.SListItem;
	import sparrowGui.data.ItemState;
	import sparrowGui.data.ListSelectionData;
	import sparrowGui.event.ListEvent;
	import sparrowGui.i.IItem;
	import sparrowGui.i.IListSelectionData;
	import sparrowGui.utils.SparrowUtil;

	/**
	 * 列表选中状态改变
	 */
	[Event(name="list_item_select", 	type="sparrowGui.event.ListEvent")]
	/** 子项布局更新 */
	[Event(name="layout_update", type="sparrowGui.event.ListEvent")]
	
	/**
	 * 单选列表控件
	 * 跟SItemGroup有很多相似的功能,不同的是此组件的显示项是固定绑定的,并不是动态产生.
	 * 
	 * 例子如下
	 * 
		var ls:SList = new SList();
		ls.update([11,22,33,44]);
		addChild(ls);
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class SList extends BaseUIComponent
	{
		public function SList(uiVars:Object=null)
		{
			super(uiVars || defaultUIVar);
			
			_group = new ItemGroup();
			_selectModel = new ListSelectionData();
			newLayout();
			colNum = 1;
			_selectModel.addListSelectionListener(onSelectChange);
		}
		
		private var _selectModel:IListSelectionData;
		
		/**
		 * 选项数据
		 */
		public function get selectModel():IListSelectionData
		{
			return _selectModel;
		}
		
		/**
		 * @private
		 */
		public function set selectModel(value:IListSelectionData):void
		{
			if(value == _selectModel || value == null)
				return;
			_selectModel = value;
			invalidateDraw();
		}
		
		
		protected var _group:ItemGroup;
		
		/**
		 * 组项映射
		 */
		public function get group():ItemGroup
		{
			return _group;
		}
		
		protected var _layout:LayoutClip;
		
		/**
		 * 初始布局工具
		 * @return 
		 */
		protected function newLayout():LayoutClip
		{
			_layout = new LayoutClip();
			return _layout;
		}
		
		/**
		 * 布局工具
		 */
		public function get layout():LayoutClip
		{
			return _layout;
		}
		
		/**
		 * @private
		 */
		public function set layout(value:LayoutClip):void
		{
			if(value == _layout || value == null)
				return;
			_layout = value;
			invalidateDraw();
		}
		
		
		protected var _data:Object;
		
		/**
		 * 列表数据, 通过数据刷新列表组件
		 */
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			if(_data == value)
				return;
			
			_data = value;
			if(value is Array)
				_dataAry = value as Array;
			else
			{
				_dataAry = [];
				for each (var itm:Object in _data) 
					_dataAry.push(itm);
			}
			if(!selectModel.mustSelect)
				selectModel.removeAllSelect(false);
			invalidateDraw();
		}
		
		/**
		 * 将数据转为数组，用于获取选中项
		 */
		protected var _dataAry:Array;
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			if(_group)
			{
				// 清旧的项
				removeAllItems();
				
				for each (var itmData:Object in _dataAry) 
				{
					var itm:IItem = createItem(itmData);
					addItem(itm);
				}
				
				isActLayout = true;
				layoutItems();
				
				if(mustSelect && selectIndex==-1 && _dataAry && _dataAry.length)
					selectIndex = 0;
			}
			
			
			super.draw();
		}
		
		/**
		 * 是否正在布局
		 */
		protected var isActLayout:Boolean = true;
		
		/**
		 * 验证布局显示
		 */
		public function invalidateLayout():void
		{
			isActLayout = true;
			SparrowUtil.addNextCall(layoutItems);
		}
		
		/**
		 * 进行一次布局处理
		 */
		protected function layoutItems():void
		{
			if(isActLayout)
			{
				isActLayout = false;
				if(_layout && _group.itemLs.length>0)
					_layout.updateDisplayList(_group.itemLs);
				
				dispatchEvent(new ListEvent(ListEvent.LAYOUT_UPDATE));
			}
		}
		
		/**
		 * 清除所有子项
 		 */
		public function removeAllItems():void
		{
			for each (var itm:IItem in _group.itemLs) 
			{
				itm.removeEventListener(MouseEvent.CLICK,onItemClick);
				if(itm is IRecycle)
					(itm as IRecycle).dispose();
				SparrowMgr.removeInCLsCache(itm);
			}
			_group.removeAllItems();
		}
		
		//---------------------------------------------------
		// 子项
		//---------------------------------------------------
		
		/**
		 * 子项类
		 */
		public var itemClass:Class = SListItem;
		
		/**
		 * 子项参数
		 */
		public var itemStyle:Object = null;
		
		/**
		 * 处理子项更新的函数
		 */
		public var updateFunc:Function = null;
		
		/**
		 * 创建子项
		 * @param data
		 */
		protected function createItem(data:Object):IItem
		{
			var itm:IItem;
			if(itemStyle == null)
				itm = SparrowMgr.getAndCreatePoolObj(itemClass) as IItem;
			else
				itm = SparrowMgr.getAndCreatePoolObj(itemClass,itemStyle) as IItem;
			
			itm.data = data;
			return itm;
		}
		
		/**
		 * 添加子项
		 * @param itm
		 */
		public function addItem(itm:IItem):void
		{
			_group.addItem(itm);
			itm.addToParent(this);
			itm.addEventListener(MouseEvent.CLICK,onItemClick);
			if(updateFunc != null)
				updateFunc.apply(null,[itm]);
		}
		
		/**
		 * 清除项
		 * @param itm
		 */
		public function removeItem(itm:IItem):void
		{
			itm.removeEventListener(MouseEvent.CLICK,onItemClick);
			if(itm is IRecycle)
				(itm as IRecycle).dispose();
			SparrowMgr.removeInCLsCache(itm);
			_group.removeItem(itm);
		}
		
		//---------------------------------------------------
		// 选项
		//---------------------------------------------------
		
		public function get selectIndex():int
		{
			return _selectModel.getSelectIndex();
		}
		
		public function set selectIndex(value:int):void 
		{
			_selectModel.setSelect(value);
		}
		/**
		 * 是否支持多选，默认只能单选
		 */
		public function get multiSelect():Boolean
		{
			return _selectModel.multiSelect;
		}
		
		/**
		 * @private
		 */
		public function set multiSelect(value:Boolean):void
		{
			_selectModel.multiSelect = value;
		}
		
		/**
		 * 至少有一个项被选中
		 */
		public function get mustSelect():Boolean
		{
			return _selectModel.mustSelect;
		}
		
		/**
		 * @private
		 */
		public function set mustSelect(value:Boolean):void
		{
			_selectModel.mustSelect = value;
		}
		
		public function get selectIds():Vector.<int>
		{
			return _selectModel.getSelectIds();
		}
		
		/**
		 * 选中项数据
		 * @return 
		 */
		public function get selectData():*
		{
			if(selectIndex>=0 && _dataAry.length>selectIndex)
				return _dataAry[selectIndex];
			return null;
			
//			var itm:IItem = group.getItemAt(selectIndex);
//			if(itm)
//				return itm.data;
//			else
//				return null;
//			if(!_data || !_data.hasOwnProperty(selectIndex))
//				return null;
//			else
//				return _data[selectIndex];
		}
		
		/**
		 * 选中项
		 * @return 
		 */
		public function get selectItem():IItem 
		{
			return group.getItemAt(selectIndex);
		}
		
		//---------------------------------------------------
		// 布局相关
		//---------------------------------------------------
		
		/**
		 * 子项高
		 */
		public function get itemHeight():int
		{
			return _layout.itemHeight;
		}
		
		/**
		 * @private
		 */
		public function set itemHeight(value:int):void
		{
			_layout.itemHeight = value;
		}
		
		/**
		 * 子项宽
		 */
		public function get itemWidth():int
		{
			return _layout.itemWidth;
		}
		
		/**
		 * @private
		 */
		public function set itemWidth(value:int):void
		{
			_layout.itemWidth = value;
		}
		
		/**
		 * 每列有多少项,-1表示自动通过width和itemWidth计算每列个数
		 */
		public function get colNum():int
		{
			return _layout.colNum;
		}
		
		/**
		 * @private
		 */
		public function set colNum(value:int):void
		{
			_layout.colNum = value;
		}
		
		/**
		 * 行列子项间隔
		 */
		public function get spacing():int
		{
			return _layout.spacing;
		}
		
		/**
		 * @private
		 */
		public function set spacing(value:int):void
		{
			_layout.spacing = value;
		}
		
		/**
		 * 子项数量
		 * @return 
		 */
		public function get itemLength():int 
		{
			return group.itemLength;
		}
		
		//---------------------------------------------------
		// 事件
		//---------------------------------------------------
		
		/**
		 * 选中项改变
		 * @param e
		 */
		private function onSelectChange(e:ListEvent):void
		{
			var m:IListSelectionData = selectModel;
			var tarData:Object;
			var selectItm:IItem;
			for (var i:int = 0; i < itemLength; i++) 
			{
				var itm:IItem = _group.itemLs[i] as IItem;
				var itmSelected:Boolean = m.isSelect(i);
				itm.setState(ItemState.SELECT,itmSelected);
				if(itmSelected)
					selectItm = itm;
			}
			
			dispatchEvent(new ListEvent(ListEvent.LIST_ITEM_SELECT,selectData,selectItm));
		}
		
		/**
		 * 项点击事件
		 * @param e
		 */
		protected function onItemClick(e:Event):void
		{
			var itm:IItem = e.currentTarget as IItem;
			if(selectModel.hasSelected(itm.itemIndex))
				return;
			selectModel.setSelect(itm.itemIndex);
		}
	}
}
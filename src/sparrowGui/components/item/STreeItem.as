package sparrowGui.components.item
{
	import asCachePool.interfaces.IRecycle;
	import asCachePool.interfaces.IReset;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sparrowGui.components.base.BaseUIComponent;
	import sparrowGui.data.ItemState;
	import sparrowGui.data.TreeComposite;
	import sparrowGui.event.ItemEvent;
	import sparrowGui.i.IItem;
	import sparrowGui.i.ITreeNode;
	
	/** 项折叠状态改变. **/
	[Event(name="item_fold_change", 	type="sparrowGui.event.ItemEvent")]
	[Event(name="item_select_change", 	type="sparrowGui.event.ItemEvent")]
	
	/**
	 * 树形控件的型
	 * 多了开合起的按钮事件
	 * 
	 * 例子如下
	 * 
	 * var itm:SItem = new STreeItem();
		itm.update("按钮文字");
		addChild(itm);
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class STreeItem extends BaseUIComponent implements IItem,IRecycle,IReset
	{
		private static const FOLDBTN_NAME:String = "foldBtn";		//合起按钮
		private static const SELECTBTN_NAME:String = "selectBtn";		//选中区按钮
		
		/**
		 * 打开合起按钮
		 */
		protected var foldItem:SButton;
		/**
		 * 可选按钮
		 */
		protected var selectItem:SButton;
		
		private var _data:Object;
		
		/**
		 * 构造树形组件的项
		 * @param uiVars 皮肤变量
		 */
		public function STreeItem(uiVars:Object=null)
		{
			super(uiVars || defaultUIVar);
			isNextRender = false;
			reset();
		}
		
		/**
		 * 设置项数据 <TreeNodeVO>
		 * @param value
		 */
		public function set data(value:Object):void
		{
			if(_data == value)
				return;
			
			if(_data is TreeComposite)
				(_data as TreeComposite).removeEventListener(Event.CHANGE,onDataChange);
			
			_data = value;
			
			if(_data is TreeComposite)
				(_data as TreeComposite).addEventListener(Event.CHANGE,onDataChange);
			
			onDataChange();
//			foldItem.selected = !o.folded;
//			selectItem.selected = o.selected;
		}
		
		override protected function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
			
//			foldItem = new SListItem(skinDC.getChildByName(FOLDBTN_NAME));
//			selectItem = new SListItem(skinDC.getChildByName(SELECTBTN_NAME));
			
//			itm1.buildSetUI(skinDC.getChildByName(FOLDBTN_NAME));
//			itm2.buildSetUI(skinDC.getChildByName(SELECTBTN_NAME));
			
//			foldItem = SparrowMgr.getAndCreatePoolObj(SListItem,getChildByName(FOLDBTN_NAME));
//			selectItem = SparrowMgr.getAndCreatePoolObj(SListItem,getChildByName(SELECTBTN_NAME));
			
			foldItem = getChildByName(FOLDBTN_NAME) as SButton;
			selectItem = getChildByName(SELECTBTN_NAME) as SButton;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			super.draw();
			foldItem.x = 0;
			selectItem.x = foldItem.width + 3;
			
			if(_data is ITreeNode)
				selectItem.data = _data.txtName;
			else
				selectItem.data = _data;
			
			var cp:TreeComposite = _data as TreeComposite;
			
			if(cp)
			{
				selectItem.setState(ItemState.SELECT,cp.selected);
				foldItem.setState(ItemState.SELECT,!cp.folded);
			}
		}
		
		protected function addSkinListen():void
		{
			if(foldItem)
				foldItem.addEventListener(MouseEvent.CLICK,onFoldEvt);
			if(selectItem)
				selectItem.addEventListener(MouseEvent.CLICK,onSelectEvt);
		}
		
		protected function removeSkinListen():void
		{
			if(foldItem)
				foldItem.removeEventListener(MouseEvent.CLICK,onFoldEvt);
			if(selectItem)
				selectItem.removeEventListener(MouseEvent.CLICK,onSelectEvt);
		}
		
		/**
		 * 将合起事件向外转发
		 * @param e
		 */
		protected function onFoldEvt(e:MouseEvent):void
		{
			dispatchEvent(new ItemEvent(ItemEvent.ITEM_FOLD_CHANGE));
		}
		
		/**
		 * 选中项事件
		 * @param e
		 */
		protected function onSelectEvt(e:MouseEvent):void
		{
			dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECT_CHANGE));
		}
		
		/**
		 * 改变事件
		 * @param e
		 */
		private function onDataChange(e:Event=null):void
		{
			invalidateDraw();
		}
		
		//----------------------------------------------------
		// 池接口实现
		//----------------------------------------------------
		
		public function reset():void
		{
			addSkinListen();
		}
		
		override public function dispose():void
		{
			removeSkinListen();
			super.dispose();
		}
		
		///////////////////////////////////
		// get/set
		//////////////////////////////////
		
		
		override protected function get defaultUIVar():Object
		{
			return "treeItem";
		}
		
		public function set folded(value:Boolean):void
		{
			foldItem.setState(ItemState.SELECT,value);
			dispatchEvent(new ItemEvent(ItemEvent.ITEM_FOLD_CHANGE));
		}
		
/*		public function get folded():Boolean
		{
			return foldItem.selected;
		}*/
		
		public function set selected(value:Boolean):void
		{
			selectItem.setState(ItemState.SELECT,value);
			dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECT_CHANGE));
		}
		
/*		public function get selected():Boolean 
		{
			return selectItem.selected;
		}*/
		
		public function get data():Object
		{
			return _data;
		}
		
		//----------------------------------------------------
		// 状态
		//----------------------------------------------------
		
		private var _currentState:String;
		
		public function setState(stateName:String, value:Object=null):void
		{
			switch(stateName)
			{
				case ItemState.FOLD:
				{
					foldItem.setState(ItemState.SELECT,value);
					break;
				}
				case ItemState.SELECT:
				{
					selectItem.setState(ItemState.SELECT,value);
					break;
				}
				case ItemState.ENABLED:
				{
					selectItem.setState(ItemState.ENABLED,value);
					foldItem.setState(ItemState.ENABLED,value);
					break;
				}
			}
			_currentState = stateName;
		}
		
		public function get currentState():String
		{
			return _currentState;
		}
		
		//---------------------------------------------------
		// itemIndex
		//---------------------------------------------------
		
		private var _itemIndex:int = -1;
		
		/**
		 * 项索引
		 */
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		
		/**
		 * @private
		 */
		public function set itemIndex(value:int):void
		{
			_itemIndex = value;
		}
	}
}
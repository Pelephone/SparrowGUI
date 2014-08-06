package sparrowGui.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import sparrowGui.components.base.AlignMgr;
	import sparrowGui.components.base.BaseUIComponent;
	import sparrowGui.components.item.SItem;
	import sparrowGui.data.ItemState;
	import sparrowGui.event.ListEvent;
	
	/**
	 * 选中项改变
	 */
	[Event(name="list_item_select", 	type="sparrowGui.event.ListEvent")]
	/**
	 * 改变
	 */
	[Event(name="change", 	type="flash.events.Event")]
	/**
	 * 组合下拉控件,点击会弹出菜单按钮
	 * 
	 * 例子如下
	 * 
		var cbx:SCombobox = new SCombobox(this);
		cbx.update([11,22,33]);
		addChild(cbx);
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class SCombobox extends BaseUIComponent
	{
		/**
		 * 构造组合下拉控件
		 * @param tipParent		弹出的下拉列表的父容器
		 * @param uiVars		皮肤变量
		 * @param cellFactory 子项工厂，用于创建子项和子项皮肤，工厂里还有缓存的功能
		 */
		public function SCombobox(uiVars:Object=null)
		{
			_popTip = new SPopupMenu();
			_popTip.autoClose = false;
			_popTip.list.mustSelect = false;
			_popTip.showParent = this;
			
			super(uiVars || defaultUIVar);
		}
		
		/**
		 * 提示窗对齐
		 */
		private function onTipPosChange(e:Event=null):void
		{
			var pt:Point = _txtLabel.localToGlobal(AlignMgr.oPoint);
			AlignMgr.comboboxTipAlign(pt,_popTip,_txtLabel.width,_txtLabel.height);
			
			bg.height = popTip.height + oldBgHeight + 5;
			if(_popTip.y < 0)
				bg.y = popTip.y - 5;
		}
		
		private var bg:DisplayObject;
		private var _comboItem:SItem;
		protected var _txtLabel:TextField;
		
		/**
		 * @inheritDoc
		 */
		override protected function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
			bg = getChildByName("bg");
			_comboItem = getChildByName("comboItem") as SItem;
			_txtLabel = getChildByName("txtLabel") as TextField;
			
			bg.addEventListener(MouseEvent.CLICK,onMouseEvent);
			_comboItem.addEventListener(MouseEvent.CLICK,onMouseEvent);
			_popTip.addEventListener(Event.CHANGE,onTipPosChange);
			_popTip.addEventListener(ListEvent.LIST_ITEM_SELECT,onSelectEvt);
			_popTip.addEventListener(Event.CANCEL,onCancel);
		}
		
		// 原背景高度
		private var oldBgHeight:int;
		
		// 原背景背景y坐标
		private var oldBgY:int;
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			if(this)
			{
				bg.removeEventListener(MouseEvent.CLICK,onMouseEvent);
				_comboItem.removeEventListener(MouseEvent.CLICK,onMouseEvent);
			}
			if(popTip)
			{
				popTip.removeEventListener(Event.CANCEL,onCancel);
				popTip.removeEventListener(ListEvent.LIST_ITEM_SELECT,onSelectEvt);
			}
			super.dispose();
		}
		
		protected var _data:Object;
		
		/**
		 * 更新内容
		 */
		public function set data(o:Object):void
		{
			if(o is Array && o.length)
				_txtLabel.text = String(o[0]);
			else
				_txtLabel.text = "";
			
			_popTip.data = (o);
			
			_data = o;
		}
		
		/**
		 * 信息
		 */
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			
			if(isRendering)
			{
				var padding:int = 5;
				bg.width = _width;
				comboItem.x = _width - comboItem.width - padding;
				_txtLabel.x = padding;
				_txtLabel.width = _comboItem.x - padding;
				oldBgHeight = bg.height;
				oldBgY = bg.y;
				
				/*for (var i:int = 0; i < _popTip.list.numChildren; i++) 
				{
					var itm:DisplayObject = _popTip.list.getChildAt(i);
					itm.width = _width;
				}*/
			}
			super.draw();
			
		}
		
		private function onCancel(e:Event):void
		{
			bg.height = oldBgHeight;
			bg.y = oldBgY;
			_comboItem.setState(ItemState.SELECT,false);
		}
		
		/**
		 * 弹出选中
		 * @param e
		 */
		protected function onSelectEvt(e:ListEvent):void
		{
			if(data && selectIndex>=0 && selectIndex<data.length)
				_txtLabel.text = String(data[selectIndex]);
			else
				_txtLabel.text = "";
			
			bg.height = oldBgHeight;
			bg.y = oldBgY;
			
			dispatchEvent(e);
			
			closePop();
		}
		
		// 关闭弹窗
		protected function closePop():void
		{
			_selected = false;
			_popTip.clearUp();
		}
		
		/**
		 * 选中项数据
		 * @return 
		 */
		public function get selectData():* 
		{
			return _popTip.list.selectData;
		}
		
		/**
		 * 选中第N项
		 * @return 
		 */
		public function get selectIndex():int 
		{
			return _popTip.list.selectIndex;
		}
		
		/**
		 * 设置选中第N项
		 * @param value
		 */
		public function set selectIndex(value:int):void
		{
			_popTip.list.selectIndex = value;
		}
		
		/**
		 * 是否展开
		 */
		protected var _selected:Boolean = false;
		
		/**
		 * 监听鼠标事件
		 * @param e
		 */
		protected function onMouseEvent(e:MouseEvent):void
		{
			if(e.target == _popTip)
				_selected = false;
			else
				_selected = !_selected;
				
			showListRender();
		}
		
		/**
		 * 下拉显示
		 */
		protected function showListRender():void
		{
			if(_selected)
				popTip.show(_txtLabel);
			else
				closePop();
			
			_comboItem.setState(ItemState.SELECT,_selected);
		}
		
		
		protected var _popTip:SPopupMenu;

		/**
		 * 弹出列表提示组件
		 */
		public function get popTip():SPopupMenu
		{
			return _popTip;
		}

		/**
		 * 组件单项
		 */
		public function get comboItem():SItem
		{
			return _comboItem;
		}
		
		/**
		 * @private
		 */
		public function get showParent():DisplayObjectContainer
		{
			return popTip.showParent;
		}

		/**
		 * 显示提示窗的父级容器
		 */
		public function set showParent(value:DisplayObjectContainer):void
		{
			popTip.showParent = value;
		}

		override protected function get defaultUIVar():Object
		{
			return "combobox";
		}
	}
}
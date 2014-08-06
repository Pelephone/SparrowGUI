package sparrowGui.components.item
{
	import asCachePool.interfaces.IRecycle;
	import asCachePool.interfaces.IReset;
	
	import flash.display.DisplayObject;
	
	import sparrowGui.components.SList;
	import sparrowGui.components.base.BaseUIComponent;
	import sparrowGui.data.ItemState;
	import sparrowGui.i.IItem;
	import sparrowGui.utils.SparrowUtil;
	
	/**
	 * 基本项,带有基本的按钮四态，类似于SimplyButton
	 * (此组件并没绑定鼠标事件)
	 * 
	 * 例子如下
	 * 
	 * var itm:SItem = new SListItem();
		itm.update("按钮文字");
		addChild(itm);
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class SItem extends BaseUIComponent implements IItem,IRecycle,IReset
	{
		public function SItem(uiVars:Object=null)
		{
			_width = 80;
			_height = 24;

			super(uiVars || defaultUIVar);
			
			isNextRender = false;
			reset();
		}
		
		override protected function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
			
			this.mouseChildren = false;
			
			_upState = getChildByName(ItemState.UP);
			_overState = getChildByName(ItemState.OVER);
			_downState = getChildByName(ItemState.DOWN);
			_hitTestState = getChildByName(ItemState.HITTEST);
			
			currentState = ItemState.UP;
		}
		
		/**
		 * @inheritDoc
		 
		override public function setUiStyle(uiVars:Object=null):void
		{
			super.setUiStyle(uiVars);
			
			_width = _upState.width;
			_height = _upState.height;
		}*/
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			if(isRendering)
			{
				if(_hitTestState)
					_hitTestState.width = _width;
				if(_upState)
					_upState.width = _width;
				if(_overState)
					_overState.width = _width;
				if(_downState)
					_downState.width = _width;
				
				if(_hitTestState)
					_hitTestState.height = _height;
				if(_upState)
					_upState.height = _height;
				if(_overState)
					_overState.height = _height;
				if(_downState)
					_downState.height = _height;
				
				if(parent && parent is SList)
					(parent as SList).invalidateLayout();
			}
			
			super.draw();
		}
		
		protected var _data:Object;
		
		public function set data(value:Object):void
		{
			if(_data == value)
				return;
			
			_data = value;
			SparrowUtil.addNextCall(parseData);
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * 将数据解析到此项
		 */
		protected function parseData():void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultUIVar():Object
		{
			return "item";
		}
		
		private var _itemIndex:int = -1;
		
		public function set itemIndex(value:int):void
		{
			if(value == _itemIndex)
				return;
			_itemIndex = value;
		}
		
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		
		//---------------------------------------------------
		// 状态相关
		//---------------------------------------------------
		
		protected var _currentState:String;
		
		public function get currentState():String
		{
			return _currentState;
		}
		
		public function set currentState(value:String):void
		{
			if(_currentState == value)
				return;
			_currentState = value;
			intvalStateRender();
		}
		
		/**
		 * 验证渲染状态显示
		 */
		protected function intvalStateRender():void
		{
			isStateRendering = true;
			if(isNextRender)
				SparrowUtil.addNextCall(stateRender);
			else
				stateRender();
		}
		
		/**
		 * 状态是否正在渲染
		 */
		protected var isStateRendering:Boolean = true;
		
		/**
		 * 状态渲染
		 */
		protected function stateRender():void
		{
//			super.stateRender();
//			changeStateShow(currentState);
			if(isStateRendering)
			{
				isStateRendering = false;
				hiddenState();
				var stateDsp:DisplayObject = getChildByName(_currentState);
				
				if(stateDsp)
					stateDsp.visible = true;
				else if(upState)
					upState.visible = true;
			}
		}
		
		/**
		 * 隐藏其它状态，只显示其中一个
		 * @param state
		 
		protected function changeStateShow(state:String):void
		{
			hiddenState();
			var skinDC:DisplayObjectContainer = skin as DisplayObjectContainer;
			if(skinDC)
				var stateDsp:DisplayObject = getChildByName(state);
			
			if(stateDsp) stateDsp.visible = true;
			else if(upState)
				upState.visible = true;
		}*/
		override public function set enabled(value:Boolean):void
		{
			if(value == _enabled)
				return;
			_enabled = value;
			super.enabled = value;
			if(!value)
				currentState = ItemState.ENABLED;
			else
				currentState = ItemState.UP;
			
			intvalStateRender();
		}
		
		private var _selected:Boolean = false;
		
		/**
		 * @private
		 */
		public function get selected():Boolean
		{
			return _selected;
		}
		
		/**
		 * 是否已选择
		 * @param value
		 */
		public function set selected(value:Boolean):void
		{
			if(_selected == value)
				return;
			_selected = value;
			if(value)
				currentState = ItemState.SELECT;
			else
				currentState = ItemState.UP;
			intvalStateRender();
		}
		
		public function setState(stateName:String, value:Object=null):void
		{
			switch(stateName)
			{
				case ItemState.ENABLED:
				{
					enabled = value;
					break;
				}
				case ItemState.SELECT:
				{
					selected = value;
					break;
				}
				default:
				{
					if(states.indexOf(stateName)>=0)
						currentState = stateName;
					break;
				}
			}
		}
		
		/**
		 * 可以改变的状态数组
		 * @return 
		 */
		protected function get states():Array
		{
			return [ItemState.UP,ItemState.OVER,ItemState.DOWN];
		}
		
		/**
		 * 隐藏所有状态
		 */
		protected function hiddenState():void
		{
			for each(var sName:String in states)
			{
				var dp:DisplayObject = getChildByName(sName);
				if(dp)
					dp.visible = false;
			}
		}
		
		protected var _upState:DisplayObject;

		/**
		 * 抬起状态
		 * @return 
		 */
		public function get upState():DisplayObject
		{
			return _upState;
		}
		
		protected var _overState:DisplayObject;

		/**
		 * 经过状态
		 * @return 
		 */
		public function get overState():DisplayObject
		{
			return _overState;
		}
		
		protected var _downState:DisplayObject;

		/**
		 * 按下状态
		 * @return 
		 */
		public function get downState():DisplayObject
		{
			return _downState;
		}
		
		protected var _hitTestState:DisplayObject;
		
		/**
		 * 热区
		 * @return 
		 */
		public function get hitTestState():DisplayObject
		{
			return _hitTestState;
		}
		
		//---------------------------------------------------
		// 池用接口
		//---------------------------------------------------
		
		override public function dispose():void
		{
			itemIndex = -1;
			_data = null;
			if(this.parent)
				parent.removeChild(this);
			
			super.dispose();
		}
		
		public function reset():void
		{
			enabled = true;
			selected = false;
		}
	}
}
package sparrowGui.components.item
{
	import asCachePool.interfaces.IReset;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import sparrowGui.data.ItemState;
	
	/**
	 * 按钮组件，相比Item监听鼠标操作相关事件
	 * 
	 * 例子如下
	 * 
	 * var itm:SItem = new SButton();
		itm.update("按钮文字");
		addChild(itm);
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class SButton extends SItem implements IReset
	{
		private static const TXTFIELD_NAME:String = "txtLabel";	//文本名
		/**
		 * 构造按钮组件
		 * @param uiVars
		 */
		public function SButton(uiVars:Object=null)
		{
			super(uiVars || defaultUIVar);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
			
			labelText = getChildByName(TXTFIELD_NAME) as TextField;
			
			this.buttonMode = true;
			this.hitArea = (hitTestState as Sprite);
			
		}
		
		/**
		 * 是否根据文字内容改变宽高
		 */
		public var areaByText:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			if(isRendering)
			{
				if(labelText)
					labelText.width = _width;
			}
			super.draw();
		}
		
		/**
		 * 是否跟椐文本内容设置背景宽度
		 
		public var resizeText:Boolean = false;*/
		
		/**
		 * @inheritDoc
		 */
		override protected function parseData():void
		{
			super.parseData();
			
			if(labelText)
				labelText.text = label;
			
			if(areaByText)
			{
				width = labelText.textWidth + 10;
				height = labelText.textHeight + 10;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set data(value:Object):void
		{
			super.data = value;
			_label = String(value);
		}
		
		private var _label:String;
		
		/**
		 * 按钮文字显示文字
		 */
		public function get label():String
		{
			return _label;
		}

		/**
		 * @private
		 */
		public function set label(value:String):void
		{
			if(_label == value)
				return;
			_label = value;
			parseData();
		}
		
		/**
		 * 文字文本
		 */
		public var labelText:TextField;
		
		
		/**
		 * @inheritDoc
		 
		override public function setUiStyle(uiVars:Object=null):void
		{
			super.setUiStyle(uiVars);
			// 因为设置样式
			if(labelText)
				labelText.text = labelText.text;
		}*/
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultUIVar():Object
		{
			return "button";
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set currentState(value:String):void
		{
//			var oldState:String = super.currentState;
			if(selected)
				super.currentState = ItemState.SELECT;
			else if(!enabled)
				super.currentState = ItemState.ENABLED;
			else
				super.currentState = value;
//			if(oldState != super.currentState)
//				dispatchEvent(new Event(Event.CHANGE));
		}
		
		//---------------------------------------------------
		// 事件
		//---------------------------------------------------
		
		protected function addSkinListen():void
		{
			// ROLL_OVER无视子对象事件,MOUSE_OVER相反
			this.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP,onEvtOut);
			this.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
		}
		
		protected function removeSkinListen():void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.removeEventListener(MouseEvent.MOUSE_UP,onEvtOut);
			this.removeEventListener(MouseEvent.ROLL_OVER,onRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT,onRollOut);
			if(!this.stage) return;
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onEvtOut);
			this.stage.removeEventListener(Event.MOUSE_LEAVE, onEvtOut);
		}
		
		/**
		 * 鼠标经过事件
		 * @param e
		 */
		protected function onRollOver(e:MouseEvent):void
		{
			if(!enabled || selected)
				return;
			
			currentState = ItemState.OVER;
		}
		
		/**
		 * 鼠标按下
		 * @param e
		 */
		protected function onMouseDown(e:MouseEvent):void
		{
			if(!enabled || selected)
				return;
			
			currentState = ItemState.DOWN;
			if(!this || !this.stage) return;
			
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onEvtOut);
			this.stage.addEventListener(Event.MOUSE_LEAVE,onEvtOut);
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.removeEventListener(MouseEvent.ROLL_OVER,onRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT,onRollOut);
		}
		
		/**
		 * 移开事件
		 * @param e
		 */
		protected function onEvtOut(e:Event):void
		{
			if(!enabled || selected)
				return;
			
			var me:MouseEvent = e as MouseEvent;
			var isOver:Boolean = (me && me.currentTarget==this);
//				if(me.stageX>=pt.x && me.stageX<=(pt.x + skin.width)
//				&& me.stageY>=pt.y && me.stageY<=(pt.y + skin.height))
//					isOver = true;
			if(!isOver)
				currentState = ItemState.UP;
			else
				currentState = ItemState.OVER;
			
			if(!this || !this.stage) return;
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onEvtOut);
			this.stage.removeEventListener(Event.MOUSE_LEAVE, onEvtOut);
			
			this.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
		}
		
		/**
		 * 鼠标移开事件
		 */
		protected function onRollOut(e:MouseEvent):void
		{
			if(!enabled || selected)
				return;
			
			currentState = ItemState.UP;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			removeSkinListen();
			super.dispose();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function reset():void
		{
			super.reset();
			addSkinListen();	
		}
	}
}
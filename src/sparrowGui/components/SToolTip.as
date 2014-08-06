package sparrowGui.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import sparrowGui.components.base.BaseTip;
	
	/**
	 * 鼠标经过弹出提示(文本提示,固定宽,自动高)
	 * 
	 * 
	 * 下面例子是给某按钮添加鼠标经过弹字事件,一定要记住不用时removeTip回收掉
	 *	
	 * 	var sb:SimpleButton = new SimpleButton();
	 *	var tip:SToolTip = new SToolTip(stage);
		tip.addTip(abc,"测试一下");
		// 不用时回收 tip.removeTip(abc);
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class SToolTip extends BaseTip
	{
		/**
		 * 提示窗里的文本
		 */
		private static const TXTTIP_NAME:String = "txtTip";
		/**
		 * 提示窗里的背景
		 */
		private static const SKINBG_NAME:String = "skinBG";
		
		private var _txtTip:TextField;
		private var skinBG:DisplayObject;
		
		/**
		 * 响应鼠标的对象哈希
		 * 因为用显示对象做为主键，所以一定要用Dictionary，不能用Object
		 */
		protected var targetMap:Dictionary;
		
		/**
		 * 文本的边距
		 */
		private var padding:int = 5;
		
		/**
		 * 构造鼠标提示窗
		 * @param parentSkin
		 * @param argSkin
		 */
		public function SToolTip(uiVars:Object=null)
		{
			targetMap = new Dictionary();
			super(uiVars || defaultUIVar);
		}
		
		override protected function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
			isNextRender = false;
			
			txtTip = getChildByName(TXTTIP_NAME) as TextField;
			skinBG = getChildByName(SKINBG_NAME);
			this.mouseChildren = this.mouseEnabled = false;
			if(txtTip)
			{
				txtTip.addEventListener(TextEvent.TEXT_INPUT,onTxtChange);
				txtTip.addEventListener(Event.SCROLL,onTxtChange);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			if(txtTip)
			{
				txtTip.removeEventListener(TextEvent.TEXT_INPUT,onTxtChange);
				txtTip.removeEventListener(Event.SCROLL,onTxtChange);
			}
		}
		
		override public function show(tarDisp:DisplayObject=null):void
		{
			super.show(tarDisp);
			
			tarDisp.addEventListener(MouseEvent.MOUSE_OUT,onOutEvt);
		}
		
		/**
		 * 鼠标移开响应
		 */
		private function onOutEvt(e:Event):void
		{
//			e.currentTarget.removeEventListener(e.type, arguments.callee);
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT,onOutEvt);
			clearUp();
		}
		
		/**
		 * 给对象增加提示
		 * @param tarDisp 目标按钮
		 * @param data 弹出显示数据
		 */
		public function addTip(tarDisp:DisplayObject,data:String=null):void
		{
			targetMap[tarDisp] = data;
			tarDisp.addEventListener(MouseEvent.MOUSE_OVER,onOverEvt);
		}
		
		/**
		 * 移出提示事件
		 * @param tarDisp
		 */
		public function removeTip(tarDisp:DisplayObject):void
		{
			delete targetMap[tarDisp];
			tarDisp.removeEventListener(MouseEvent.MOUSE_OVER,onOverEvt);
		}
		
		/**
		 * 移出所有提示事件
		 * @param tarDisp
		 */
		public function removeAllTip():void
		{
			for (var tarDisp:Object in targetMap) 
			{
				removeTip(tarDisp as DisplayObject);
			}
		}
		
		private var _data:Object;
		
		override public function set data(dataValue:Object):void
		{
			txtTip.htmlText = String(dataValue);
			_data = dataValue;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get data():Object
		{
			return _data;
		}
		
		/**
		 * 监听鼠标事件
		 * @param e
		 */
		private function onOverEvt(e:MouseEvent):void
		{
			show(e.currentTarget as DisplayObject);
		}
		
		/**
		 * 文本框改变,背景也跟着变化
		 * @param e
		 */
		private function onTxtChange(e:Event=null):void
		{
			txtTip.x = txtTip.y = padding;
			skinBG.width = txtTip.width + padding*2;
			skinBG.height = txtTip.height + padding*2;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			super.draw();
			
			txtTip.width = _width;
			txtTip.height = _height;
			onTxtChange();
		}
		
		/**
		 * 提示窗宽
		 * @param value
		 
		override public function set width(value:Number):void 
		{
		}*/
		
		/**
		 * 提示窗高
		 * @param value
		 
		override public function set height(value:Number):void 
		{
			txtTip.height = value;
			onTxtChange();
		}*/

		/**
		 * 提示文本
		 */
		public function get txtTip():TextField
		{
			return _txtTip;
		}

		/**
		 * @private
		 */
		public function set txtTip(value:TextField):void
		{
			_txtTip = value;
		}
		
		override protected function get defaultUIVar():Object
		{
			return "toolTip";
		}
	}
}
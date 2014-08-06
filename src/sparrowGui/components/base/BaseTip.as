package sparrowGui.components.base
{
	import TimerUtils.FrameTimer;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	
	import sparrowGui.SparrowMgr;
	
	/**
	 * 基本提示窗,本控件只用于跟椐目标延时显示提示窗
	 * 鼠标经过对象提示,弹出菜单提示继承于此控件
	 * 
	 * 如要延时X秒显示某对象到按钮A的位置:
	 *	
	 * 	var sb:SimpleButton = new SimpleButton();
	 *	var tip:BaseTip = new BaseTip(stage);
	 *  tip.show(sb,"aabb");
	 *   
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	/** 位置改变. **/
	[Event(name="change", type="flash.events.Event")]
	
	public class BaseTip extends BaseUIComponent
	{
		
		private var _showPos:int;
		private var _offSet:Number;
		private var _delay:int;
		
		/**
		 * 构造基本提示窗工具
		 * @param parentSkin	必须填父级容器,不然弹出的提示不知道要置于哪层
		 * @param argSkin		被弹出的对象
		 */
		public function BaseTip(uiVars:Object=null)
		{
			showParent = SparrowMgr.tipLayer || SparrowMgr.mainDisp;
			super(uiVars || defaultUIVar);
		}
		
		/**
		 * 用于延迟处理的工具
		 */
		private var timer:FrameTimer = new FrameTimer(delay,1);
		
		/**
		 * 显示弹窗
		 * @param tarDisp
		 */
		public function show(tarDsp:DisplayObject=null):void
		{
			if(tarDsp != null)
			{
				var pt:Point = tarDsp.localToGlobal(AlignMgr.oPoint);
				AlignMgr.rightDownAlignAuto(this,pt,tarDsp.width,tarDsp.height,showParent);
			}
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,delayShowHandler);
			timer.reset();
			timer.start();
		}
		
		/**
		 * 延迟显示
		 * @param e
		 */
		private function delayShowHandler(e:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE,delayShowHandler);
			showParent.addChild(this);
			this.visible = true;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 显示到坐标
		 * @param posX
		 * @param posY
		 * @param data
		 */
		public function showByPos(posX:Number,posY:Number,dataValue:Object=null):void
		{
			var pt:Point = this.localToGlobal(new Point(posX,posY));
			AlignMgr.rightDownAlignAuto(this,pt,0,0,showParent);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,delayShowHandler);
			timer.reset();
			timer.start();
		}
		
		/**
		 * 移除提示对象
		 */
		public function clearUp():void
		{
//			showParent.stage.removeEventListener(Event.MOUSE_LEAVE,onMouseLeave);
//			this.removeEventListener(Event.ENTER_FRAME,onEnterEvt);
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE,delayShowHandler);
			if(this.parent) showParent.removeChild(this);
			this.visible = false;
		}
		
		//////////////////////////////////
		// get/set
		//////////////////////////////////

		/**
		 * 偏移
		 */
		public function get offSet():Number
		{
			return _offSet;
		}

		/**
		 * @private
		 */
		public function set offSet(value:Number):void
		{
			_offSet = value;
		}

		/**
		 * 延时毫秒数
		 */
		public function get delay():int
		{
			return _delay;
		}

		/**
		 * @private
		 */
		public function set delay(value:int):void
		{
			if(_delay == value)
				return;
			_delay = value;
			timer.delay = value;
		}
		
		public function get data():Object
		{
			return null;
		}

		public function set data(value:Object):void
		{
		}

		override protected function get defaultUIVar():Object
		{
			return "baseTip";
		}
		
		/**
		 * 显示提示窗的父级容器
		 */
		public var showParent:DisplayObjectContainer;
	}
}
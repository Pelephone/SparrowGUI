package sparrowGui.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import sparrowGui.SparrowMgr;
	import sparrowGui.components.item.SButton;
	import sparrowGui.components.base.BaseUIComponent;
	
	/** 滚动条值改变. **/
	[Event(name="change", 	type="flash.events.Event")]
	
	/**
	 * 滚动组件基类,用于继承,不能实例化
	 * 实现纵横向公共部份的功能
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	internal class ScrollBarBase extends BaseUIComponent
	{
		protected static const SLIDER_NAME:String	= "slider";
		protected static const SKINBG_NAME:String	= "skinbg";
		
		/**
		 * 向上按钮延迟命令
		 */
		protected static const DELAY_CMD_UPBTN:int = 0;
		/**
		 * 向下按钮延迟命令
		 */
		protected static const DELAY_CMD_DOWNBTN:int = 1;
		/**
		 * 向上皮肤延迟命令
		 */
		protected static const DELAY_CMD_UPBG:int = 2;
		/**
		 * 向下皮肤延迟命令
		 */
		protected static const DELAY_CMD_DOWNBG:int = 3;
		
		private var _stepPercent:Number;
		private var _minScrollValue:Number = 0;
		private var _maxScrollValue:Number = 0;
		private var _autoSlider:Boolean = true;
		private var _direction:String;
		
		
		// 暂存鼠标按slider时滚动的相对坐标
		protected var _sliderTrace:Number;	
		// 延迟移动的命令
		protected var _delayCMD:int;
		// 延迟移动开始的时间点
		protected var _delayTime:int;
		
		protected var _scrollPercent:Number = 0;
		
		protected var _slider:DisplayObject;
		protected var _skinbg:DisplayObject;
		
		public function ScrollBarBase(uiVars:Object=null)
		{
			_width = SparrowMgr.MIN_SCROLL_VALUE*0.5;
			_height = SparrowMgr.MIN_SCROLL_VALUE*0.5;
			super(uiVars || defaultUIVar);
		}
		
		override protected function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
			
			_slider = getChildByName(SLIDER_NAME);
			_skinbg = getChildByName(SKINBG_NAME);
			if(slider)
				slider.addEventListener(MouseEvent.MOUSE_DOWN,onSkinMouseEvt);
			if(skinbg)
				skinbg.addEventListener(MouseEvent.MOUSE_DOWN,onSkinMouseEvt);
		}
		
		/**
		 * @inheritDoc
		 
		override public function setUiStyle(uiVars:Object=null):void
		{
			super.setUiStyle(uiVars);
			
		}*/
		
		/**
		 * 跟椐最大最小滚动位重设滚动条按钮高宽
		 
		override protected function draw():void
		{
			super.draw();
		}*/
		
		protected function scrollChange():void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 效果同set scrollPercent改变中轴的位置,不过此方法不发送事件
		 * @param value
		 */
		public function setScrollSider(percent:Number):void
		{
			if(percent>1) _scrollPercent = 1;
			else if(percent<0) _scrollPercent = 0;
			else _scrollPercent = percent;
			freshSliderPosi();
		}
		
		/**
		 * 刷新slider的位置
		 */
		public function freshSliderPosi():void
		{
			if(!this.slider || !enabled) return;
			// 减少slider后,能滚动的范围
			var scrollDist:Number = canDist - this.slider.height;
			this.slider.y = scrollDist*this.scrollPercent;
		}
		
		/**
		 * 通过要移动的对象的最小位置和最大位置初始激活滚动条
		 * 中间滚动块在最左边的时间value是min,最右边时value是max
		 * @param min 		滚动条value为0时对应容器的最小位置,Vlist的maskDP.height
		 * @param max 		滚动条value为1时对应容器的最大位置,Vlist的contDP.height
		 * @param stepPercent 每点一次滚动率
		 */
		public function setSliderParams(min:Number, max:Number, stepValue:Number=0.05):void
		{
			this._minScrollValue = min;
			this._maxScrollValue = max;
			this._stepPercent = stepValue;
			
			if(min<max)
				enabled = true;
			
			invalidateDraw();
		}
		
		/////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			if(slider)
				slider.removeEventListener(MouseEvent.MOUSE_DOWN,onSkinMouseEvt);
			if(skinbg)
				skinbg.removeEventListener(MouseEvent.MOUSE_DOWN,onSkinMouseEvt);
			
			super.dispose();
		}
		
		protected function onEnterFrame(e:Event):void
		{
			
		}
		
		protected function onMoveSlider(e:MouseEvent):void
		{
			
		}
		
		protected function onSkinMouseEvt(e:MouseEvent):void
		{
			
		}
		
		/**
		 * 延迟一定时间后快速移动
		 */
		protected function delayMoveStart(cmdType:int):void
		{
			this._delayCMD = cmdType;
			this._delayTime = getTimer();
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_UP,dragOut);
			stage.addEventListener(Event.MOUSE_LEAVE,dragOut);
		}
		
		protected function dragOut(e:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMoveSlider);
			stage.removeEventListener(MouseEvent.MOUSE_UP,dragOut);
			stage.removeEventListener(Event.MOUSE_LEAVE,dragOut);
//			skin.stage.removeEventListener(Event.ENTER_FRAME,onMove);
			
			removeEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		///////////////////////////////////////
		
		/**
		 * 除掉上下按钮后可以滚动的距离
		 * @return 
		 */
		protected function get canDist():Number 
		{
			if(direction==SparrowMgr.VERTICAL)
				return this.height;
			else
				return this.width;
		}
		
		/**
		 * 判断返回滚动条是否可用
		 * 是否能滚动,当显示内容比可视内容的高宽小时,不能滚动
		 * @return 
		 */
		override public function get enabled():Boolean
		{
			if(!super.enabled)
				return super.enabled;
			if(minScrollValue>=maxScrollValue)
				enabled = false;
			else enabled = true;
			return super.enabled;
		}
		
/*		override public function set width(value:Number):void
		{
//			if(value<SkinStyleSheet.MIN_SCROLL_VALUE)
//				value = SkinStyleSheet.MIN_SCROLL_VALUE;
			this._width = value;
			draw();
		}
		
		override public function get width():Number
		{
			return this._width;
		}
		
		override public function set height(value:Number):void
		{
//			if(value<SkinStyleSheet.MIN_SCROLL_VALUE)
//				value = SkinStyleSheet.MIN_SCROLL_VALUE
			this._height = value;
			invalidateDraw();
		}
		
		override public function get height():Number
		{
			return this._height;
		}*/
		
		/**
		 * 表示当前滚动位置的数值。值介于 minScrollValue 和 maxScrollValue 之间（包括两者）。
		 */
		public function get scrollPosition():Number
		{
			return _scrollPercent * (maxScrollValue - minScrollValue) / canDist;
		}
		
		/**
		 * 0~1之间的数,表示被盖住的显示容器与遮照容器的坐标比
		 * 以组件父代大小百分比的方式指定组件高度。允许的值为 0-1。默认值为 NaN。
		 */
		public function get scrollPercent():Number
		{
			return _scrollPercent;
		}
		
		/**
		 * @private
		 */
		public function set scrollPercent(value:Number):void
		{
			if(value>1) _scrollPercent = 1;
			else if(value<0) _scrollPercent = 0;
			else _scrollPercent = value;
			invalidateDraw();
		}
		
		/**
		 * 最小滚动值
		 * 可以认为可视高度/宽度
		 */
		public function get minScrollValue():Number
		{
			return _minScrollValue;
		}
		
		/**
		 * @private
		 */
		public function set minScrollValue(value:Number):void
		{
			_minScrollValue = value;
			invalidateDraw();
		}
		
		/**
		 * 最大滚动位值
		 * 可以认为是内容实际高度/宽度
		 */
		public function get maxScrollValue():Number
		{
			return _maxScrollValue;
		}
		
		/**
		 * @private
		 */
		public function set maxScrollValue(value:Number):void
		{
			_maxScrollValue = value;
			invalidateDraw();
		}
		
		/** 
		 * 被分隔成N分,上下箭头每点击一次silder上下的比率
		 */
		public function get stepPercent():Number
		{
			return _stepPercent;
		}
		
		/**
		 * @private
		 */
		public function set stepPercent(value:Number):void
		{
			_stepPercent = value;
		}
		
		/**
		 * 是否跟椐位置信息自动设置slider的长宽
		 */
		public function get autoSlider():Boolean
		{
			return _autoSlider;
		}
		
		/**
		 * @private
		 */
		public function set autoSlider(value:Boolean):void
		{
			_autoSlider = value;
			invalidateDraw();
		}
		/**
		 * @private
		 */
		public function get direction():String
		{
			return _direction;
		}
		
		/**
		 * 滚动样方便,横向还是纵向(ScrollBarBase.HORIZONTAL,ScrollBarBase.VERTICAL)
		 */
		public function set direction(value:String):void
		{
			if(value==SparrowMgr.HORIZONTAL)
				this._direction = SparrowMgr.HORIZONTAL;
			else
				this._direction = SparrowMgr.VERTICAL;
		}

		public function get slider():DisplayObject
		{
			return _slider;
		}
		
		public function get skinbg():DisplayObject
		{
			return _skinbg;
		}
		
		override protected function get defaultUIVar():Object
		{
			return "vScroll";
		}
	}
}
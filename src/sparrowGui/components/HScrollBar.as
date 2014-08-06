package sparrowGui.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import sparrowGui.SparrowMgr;


	/**
	 * 纵向滚动条
	 * 
		var s:ScrollBarBase = new HScrollBar();
		s.width = 100;
	 *  //按钮停在最顶端时是1，最下端是是100
		s.setSliderParams(1,100);
		addChild(s);
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class HScrollBar extends ScrollBarBase
	{
		private static const LEFTBTN_NAME:String	= "leftBtn";
		private static const RIGHTBTN_NAME:String	= "rightBtn";
		
		private var _leftBtn:DisplayObject;
		private var _rightBtn:DisplayObject;
		
		public function HScrollBar(uiVars:Object=null)
		{
			super(uiVars || defaultUIVar);
		}
		
		override protected function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
			
			_leftBtn = getChildByName(LEFTBTN_NAME);
			_rightBtn = getChildByName(RIGHTBTN_NAME);

			if(leftBtn) leftBtn.addEventListener(MouseEvent.MOUSE_DOWN,onSkinMouseEvt);
			if(rightBtn) rightBtn.addEventListener(MouseEvent.MOUSE_DOWN,onSkinMouseEvt);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			if(leftBtn) leftBtn.removeEventListener(MouseEvent.MOUSE_DOWN,onSkinMouseEvt);
			if(rightBtn) rightBtn.removeEventListener(MouseEvent.MOUSE_DOWN,onSkinMouseEvt);
			
			super.dispose();
		}
		
		///////////////////////////////
		// 事件控制
		///////////////////////////////
		
		/**
		 * 监听滚动皮肤鼠标事件
		 * @param e
		 */
		override protected function onSkinMouseEvt(e:MouseEvent):void
		{
			switch(e.currentTarget.name)
			{
				case SLIDER_NAME:		//slider按钮
				{
					_sliderTrace = e.localX*slider.scaleX;
					stage.addEventListener(MouseEvent.MOUSE_MOVE,onMoveSlider);
					stage.addEventListener(MouseEvent.MOUSE_UP,dragOut);
					stage.addEventListener(Event.MOUSE_LEAVE,dragOut);
					break;
				}
				case LEFTBTN_NAME:		// 向上按钮
				{
					this.scrollPercent = this.scrollPercent - this.stepPercent;
					freshSliderPosi();
					delayMoveStart(DELAY_CMD_UPBTN);
					break;
				}
				case RIGHTBTN_NAME:		// 向下按钮
				{
					this.scrollPercent = this.scrollPercent + this.stepPercent;
					freshSliderPosi();
					delayMoveStart(DELAY_CMD_DOWNBTN);
					break;
				}
				case SKINBG_NAME:		// 背景
				{
					if(!enabled) break;
					_sliderTrace = skinbg.mouseX*skinbg.scaleX;
					if(_sliderTrace>slider.x)
					{
						this.scrollPercent = this.scrollPercent + (this.slider.width/(canDist - this.slider.width));
						delayMoveStart(DELAY_CMD_DOWNBG);
					}
					else
					{
						this.scrollPercent = this.scrollPercent - (this.slider.width/(canDist - this.slider.width));
						delayMoveStart(DELAY_CMD_UPBG);
					}
						
					break;
				}
			}
		}
		
		/**
		 * 听每帧事件,实现延迟快速移动效果
		 * @param e
		 */
		override protected function onEnterFrame(e:Event):void
		{
			// 延迟后快速移动
			if((getTimer() - _delayTime)< SparrowMgr.DELAY_WAIT_TIME) return;
			switch(this._delayCMD)
			{
				case DELAY_CMD_UPBTN:		// 上按钮
				{
					this.scrollPercent = this.scrollPercent - this.stepPercent;
					if(scrollPercent<=0)
						dragOut(null);
					break;
				}
				case DELAY_CMD_DOWNBTN:		// 下按钮
				{
					this.scrollPercent = this.scrollPercent + this.stepPercent;
					if(scrollPercent>=1)
						dragOut(null);
					break;
				}
				case DELAY_CMD_UPBG:		// 上皮肤
				{
					var nextVal:Number = slider.x;
					if(nextVal<_sliderTrace)
					{
						dragOut(null);
						break;
					}
					
					this.scrollPercent = this.scrollPercent - (this.slider.width/(canDist - this.slider.width));
					break;
				}
				case DELAY_CMD_DOWNBG:		// 下皮肤
				{
					nextVal = slider.x + slider.width;
					if(nextVal>_sliderTrace)
					{
						dragOut(null);
						break;
					}
					
					this.scrollPercent = this.scrollPercent + (this.slider.width/(canDist - this.slider.width));
					break;
				}
			}
			freshSliderPosi();
		}
		
		// 滚动条y坐标有变化
		override protected function onMoveSlider(e:MouseEvent):void
		{
			var fy:Number = this.leftBtn?(this.leftBtn.x + this.leftBtn.width):skinbg.x;
			var ey:Number = this.rightBtn?(this.rightBtn.x - this.slider.width):(this.width - this.slider.width);
			
			if((mouseX - this._sliderTrace)<fy)
				this.slider.x = fy;
			else if((mouseX - this._sliderTrace)>ey)
				this.slider.x = ey;
			else this.slider.x = mouseX - this._sliderTrace;
			
			this._scrollPercent = (this.slider.x - fy)/(canDist-this.slider.width);
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		///////////////////////////////
		// get/set 设置参数
		///////////////////////////////
		
		/**
		 * 跟椐最大最小滚动位重设滚动条按钮高宽
		 */
		override protected function draw():void
		{
			if(this.leftBtn)
				this.leftBtn.x = 0;
			if(this.rightBtn)
				this.rightBtn.x = this.width - this.rightBtn.width;
			if(this.skinbg)
				this.skinbg.width = this.width;
			
			if(this.slider && enabled){
				// 最大范围
				if(this.autoSlider){
					var autoVal:Number = this.minScrollValue*canDist/this.maxScrollValue;
					if(autoVal<SparrowMgr.MIN_SLIDER_VALUE)
						autoVal = SparrowMgr.MIN_SLIDER_VALUE;
					this.slider.width = autoVal;
				}
				freshSliderPosi();
			}
			
			scrollChange();
			super.draw();
		}
		
		/**
		 * 刷新slider的位置
		 */
		override public function freshSliderPosi():void
		{
			if(!this.slider || !enabled)
				return;
			// 减少slider后,能滚动的范围
			var scrollDist:Number = canDist - this.slider.width;
			this.slider.x = (this.leftBtn?this.leftBtn.width:0) + scrollDist*this.scrollPercent;
		}
		
		/**
		 * 除掉上下按钮后可以滚动的距离
		 * @return 
		 */
		override protected function get canDist():Number 
		{
			return this.width - (this.leftBtn?this.leftBtn.width:0) - (this.leftBtn?this.rightBtn.width:0);;
		}
		
		/**
		 * 是否可用
		 * @param value
		 */
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			if(this.leftBtn)
				leftBtn.alpha = value ? 1.0 : 0.5;
			if(this.rightBtn)
				rightBtn.alpha = value ? 1.0 : 0.5;
			if(slider)
				this.slider.visible = value;
		}
		
		override public function set width(value:Number):void
		{
			if(value<SparrowMgr.MIN_SCROLL_VALUE)
				value = SparrowMgr.MIN_SCROLL_VALUE
			super.width = value;
		}

		/**
		 * 左按钮
		 */
		public function get leftBtn():DisplayObject
		{
			return _leftBtn;
		}

		/**
		 * @private
		 */
		public function set leftBtn(value:DisplayObject):void
		{
			_leftBtn = value;
		}

		/**
		 * 右按钮
		 */
		public function get rightBtn():DisplayObject
		{
			return _rightBtn;
		}
		
		override protected function get defaultUIVar():Object
		{
			return "hScroll";
		}
	}
}
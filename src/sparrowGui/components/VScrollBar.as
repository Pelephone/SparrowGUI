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
	 * 例子如下
	 * 
		var s:ScrollBarBase = new VScrollBar();
		s.height = 100;
	 *  //按钮停在最左端时是1，最右端是是100
		s.setSliderParams(1,100);
		addChild(s);
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class VScrollBar extends ScrollBarBase
	{
		private static const UPBTN_NAME:String	= "upBtn";
		private static const DOWNBTN_NAME:String	= "downBtn";
		
		private var _upBtn:DisplayObject;
		private var _downBtn:DisplayObject;
		
		/**
		 * 构造纵向滚动条
		 * @param uiVars 皮肤变量
		 */
		public function VScrollBar()
		{
			super();
			reset();
		}
		
		override protected function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
			
			_upBtn = getChildByName(UPBTN_NAME);
			_downBtn = getChildByName(DOWNBTN_NAME);
//				new SButton(_upBtn);
//				new SButton(_downBtn);
		}
		
		public function reset():void
		{
			if(upBtn)
				upBtn.addEventListener(MouseEvent.MOUSE_DOWN,onSkinMouseEvt);
			if(downBtn)
				downBtn.addEventListener(MouseEvent.MOUSE_DOWN,onSkinMouseEvt);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			if(upBtn)
				upBtn.removeEventListener(MouseEvent.MOUSE_DOWN,onSkinMouseEvt);
			if(downBtn)
				downBtn.removeEventListener(MouseEvent.MOUSE_DOWN,onSkinMouseEvt);
			super.dispose();
		}
		
/*		override protected function create(uiVars:Object=null):void
		{
			argSkin = argSkin || SkinStyleSheet.getIns().vScrollSkin;
			
//			_upBtn = argSkin[UPBTN_NAME];
//			_downBtn = argSkin[DOWNBTN_NAME];
			
//			vars = vars || SkinStyleSheet.getIns().vScrollBarVars;
			super.create(argSkin);
			
			height = argSkin.height;
		}*/
		
		/**
		 * 将滚动条里的显示对象添加Item事件变成item
		 
		public function changeItems():void
		{
			
		}*/
		
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
					_sliderTrace = e.localY*slider.scaleY;
					stage.addEventListener(MouseEvent.MOUSE_MOVE,onMoveSlider);
					stage.addEventListener(MouseEvent.MOUSE_UP,dragOut);
					stage.addEventListener(Event.MOUSE_LEAVE,dragOut);
					break;
				}
				case UPBTN_NAME:		// 向上按钮
				{
					this.scrollPercent = this.scrollPercent - this.stepPercent;
					freshSliderPosi();
					delayMoveStart(DELAY_CMD_UPBTN);
					break;
				}
				case DOWNBTN_NAME:		// 向下按钮
				{
					this.scrollPercent = this.scrollPercent + this.stepPercent;
					freshSliderPosi();
					delayMoveStart(DELAY_CMD_DOWNBTN);
					break;
				}
				case SKINBG_NAME:		// 背景
				{
					if(!enabled) break;
					_sliderTrace = skinbg.mouseY*skinbg.scaleY;//e.localY*skinbg.scaleY;
					if(_sliderTrace>slider.y)
					{
						this.scrollPercent = this.scrollPercent + (this.slider.height/(canDist - this.slider.height));
						delayMoveStart(DELAY_CMD_DOWNBG);
					}
					else
					{
						this.scrollPercent = this.scrollPercent - (this.slider.height/(canDist - this.slider.height));
						delayMoveStart(DELAY_CMD_UPBG);
					}
						
					break;
				}
			}
		}
		
		/**
		 * 延迟一定时间后快速移动
		 
		protected function delayMoveStart(cmdType:int):void
		{
			this._delayCMD = cmdType;
			this._delayTime = getTimer();
			skin.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			skin.stage.addEventListener(MouseEvent.MOUSE_UP,dragOut);
			skin.stage.addEventListener(Event.MOUSE_LEAVE,dragOut);
		}*/
		
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
					var nextVal:Number = slider.y;// - slider.height;
					if(nextVal<_sliderTrace)
					{
						dragOut(null);
						break;
					}
					
					this.scrollPercent = this.scrollPercent - (this.slider.height/(canDist - this.slider.height));
					break;
				}
				case DELAY_CMD_DOWNBG:		// 下皮肤
				{
					nextVal = slider.y + slider.height;
					if(nextVal>_sliderTrace)
					{
						dragOut(null);
						break;
					}
					
					this.scrollPercent = this.scrollPercent + (this.slider.height/(canDist - this.slider.height));
					break;
				}
			}
			freshSliderPosi();
		}
		
		// 滚动条y坐标有变化
		override protected function onMoveSlider(e:MouseEvent):void
		{
			var fy:Number = this.upBtn?(this.upBtn.x + this.upBtn.height):skinbg.y;
			var ey:Number = this.downBtn?(this.downBtn.y - this.slider.height):(this.height - this.slider.height);
			
			if((mouseY - this._sliderTrace)<fy)
				slider.y = fy;
			else if((mouseY - this._sliderTrace)>ey)
				slider.y = ey;
			else slider.y = mouseY - this._sliderTrace;
			
			this._scrollPercent = (this.slider.y - fy)/(canDist-this.slider.height);
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
/*		protected function dragOut(e:Event):void
		{
			if(!skin || !skin.stage) return;
			skin.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMoveSlider);
			skin.stage.removeEventListener(MouseEvent.MOUSE_UP,dragOut);
			skin.stage.removeEventListener(Event.MOUSE_LEAVE,dragOut);
//			skin.stage.removeEventListener(Event.ENTER_FRAME,onMove);
			
			skin.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
		}*/
		
		/**
		 * @inheritDoc
		 
		override public function setUiStyle(uiVars:Object=null):void
		{
			super.setUiStyle(uiVars);
			trace("滚动进场景");
		}*/
		
		/**
		 * 跟椐最大最小滚动位重设滚动条按钮高宽
		 */
		override protected function draw():void
		{
			if(this.upBtn)
				this.upBtn.y = 0;
			if(this.downBtn)
				this.downBtn.y = this.height - this.downBtn.height;
			if(this.skinbg)
				this.skinbg.height = this.height;
			
			if(this.slider && enabled)
			{
				// 最大范围
				if(this.autoSlider)
				{
					var autoVal:Number = this.minScrollValue*canDist/this.maxScrollValue;
					if(autoVal<SparrowMgr.MIN_SLIDER_VALUE)
						autoVal = SparrowMgr.MIN_SLIDER_VALUE;
					this.slider.height = autoVal;
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
			var scrollDist:Number = canDist - this.slider.height;
			this.slider.y = (this.upBtn?this.upBtn.height:0) + scrollDist*this.scrollPercent;
		}
		
		///////////////////////////////
		// get/set 设置参数
		///////////////////////////////
		
		/**
		 * 除掉上下按钮后可以滚动的距离
		 * @return 
		 */
		override protected function get canDist():Number 
		{
			return this.height - (this.upBtn?this.upBtn.height:0) - (this.upBtn?this.downBtn.height:0);
		}
		
		/**
		 * 是否可用
		 * @param value
		 */
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			if(this.upBtn)
				this.upBtn.alpha = value ? 1.0 : 0.5;
			if(this.downBtn)
				this.downBtn.alpha = value ? 1.0 : 0.5;
			if(slider)
				this.slider.visible = value;
		}
		
		override public function set height(value:Number):void
		{
			if(value<SparrowMgr.MIN_SCROLL_VALUE)
				value = SparrowMgr.MIN_SCROLL_VALUE;
			super.height = value;
		}

		/**
		 * 上按钮
		 */
		public function get upBtn():DisplayObject
		{
			return _upBtn;
		}

		/**
		 * 下按钮
		 */
		public function get downBtn():DisplayObject
		{
			return _downBtn;
		}
		
		
		override protected function get defaultUIVar():Object
		{
			return "vScroll";
		}

		/**
		 * @private
		 
		public function set scrollPosition(value:Number):void
		{
			_scrollPosition = value;
		}*/
	}
}
package sparrowGui.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sparrowGui.components.base.BaseUIComponent;
	import sparrowGui.utils.SparrowUtil;
	
	/**
	 * 带滚动条的面板
	 * 
	 * 例子如下
	 * 
			
		var sp:ScrollPanel = new ScrollPanel();
		sp.x = 300;
		sp.source = cb;
		addChild(sp);
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class ScrollPanel extends BaseUIComponent
	{
		/**
		 * 纵向滚动条的名字
		 */
		public static const VER_SCROLL_NAME:String = "vScroll";
		/**
		 * 横向滚动条的名字
		 */
		public static const HOR_SCROLL_NAME:String = "hScroll";
		
		private var contDP:Sprite;
		
		/**
		 * 用于庶照的显示对象
		 */		
		private var maskDP:Sprite;
		
		private var _vScroll:VScrollBar;
		private var _hScroll:HScrollBar;
		
		private var _autoScroll:Boolean = true;
		
		/**
		 * 构造滚动面板
		 * @param uiVars 皮肤相关
		 */
		public function ScrollPanel(uiVars:Object=null)
		{
			_width = 80;
			_height = 80;
			
			contDP = new Sprite();
			maskDP = new Sprite();
			contDP.mask = maskDP;
			
			_vScroll = new VScrollBar();
			_hScroll = new HScrollBar();
			
			addChild(contDP);
			addChild(maskDP);
			addChild(_vScroll);
			addChild(_hScroll);
			
			super(uiVars || defaultUIVar);
			
			reset();
		}
		
		/**
		 * @inheritDoc
		 */
		public function reset():void
		{
			addSkinListen();
		}
		
		/**
		 * 增加滚动条监听
		 */
		protected function addSkinListen():void
		{
			if(vScroll)
				vScroll.addEventListener(Event.CHANGE,onScrollVEvent);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			if(hScroll)
				hScroll.addEventListener(Event.CHANGE,onScrollHEvent);
		}
		
		/**
		 * 移除滚动条监听
		 */
		protected function removeSkinListen():void
		{
			if(vScroll)
				vScroll.removeEventListener(Event.CHANGE,onScrollVEvent);
			removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			if(hScroll)
				hScroll.removeEventListener(Event.CHANGE,onScrollHEvent);
		}
		
		/**
		 * 监听纵向滚动条事件
		 * @param e
		 */
		private function onScrollVEvent(e:Event):void
		{
			var scrollNum:Number = contDP.height - maskDP.height;
			contDP.y = -1 * vScroll.scrollPercent * scrollNum;
		}
		
		/**
		 * 监听纵向滚动条事件
		 * @param e
		 */
		private function onScrollHEvent(e:Event):void
		{
			var scrollNum:Number = contDP.width - maskDP.width;
			contDP.x = -1 * hScroll.scrollPercent * scrollNum;
		}
		
		/**
		 * 滚轮事件
		 * @param event
		 */
		private function onMouseWheel(event:MouseEvent):void
		{
			var scrollDist:Number = sourceHeight - maskDP.height;
			vScroll.scrollPercent -= event.delta/scrollDist*2;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			var scrollWidth:Number = this.width;
			var scrollHeight:Number = this.height;
			// 是否显示纵向滚动条的判断
			if(contDP.height<=this.height)
			{
				if(autoVhidden)
					vScroll.visible = false;
				else
				{
					vScroll.visible = true;
					vScroll.enabled = false;
					
					scrollWidth = this.width - (autoScroll?vScroll.width:0);
				}
			}
			else
			{
				vScroll.visible = true;
				vScroll.setSliderParams(this.height,contDP.height);
				
				scrollWidth = this.width - (autoScroll?vScroll.width:0);
			}
			if(autoScroll)
				vScroll.x = this.width - vScroll.width;
			
			if(!vScroll.visible)
				vScroll.scrollPercent = 0;
			
			if(!hScroll)
			{
				if(autoScroll) vScroll.height = height;
				drawMask(scrollWidth,scrollHeight);
				return;
			}
			// 是否显示横向滚动条的判断
			if(contDP.width<=scrollWidth)
			{
				if(autoHhidden)
					hScroll.visible = false;
				else
				{
					hScroll.visible = true;
					hScroll.enabled = false;
					scrollHeight = this.height - (autoScroll?hScroll.height:0);
				}
			}
			else
			{
				hScroll.visible = true;
				hScroll.setSliderParams(scrollWidth,contDP.width);
				scrollHeight = this.height - (autoScroll?hScroll.height:0);
			}
			// 自动跟椐长宽改变滚动条位置
			if(autoScroll)
			{
				hScroll.y = this.height - hScroll.height;
				
				vScroll.height = this.height - (hScroll.visible?hScroll.height:0);
				hScroll.width = this.width - (vScroll.visible?vScroll.width:0);
			}
			
			if(!hScroll.visible)
				hScroll.scrollPercent = 0;
			
			drawMask(scrollWidth,scrollHeight);
			super.draw();
		}
		
		/**
		 * 绘制遮照
		 * @param w
		 * @param h
		 */
		private function drawMask(w:Number,h:Number):void
		{
			maskDP.visible = true;
			maskDP.graphics.clear();
			maskDP.graphics.beginFill(0xFFFF00);
			maskDP.graphics.drawRect(0,0,w,h);
			maskDP.graphics.endFill();
		}
		
		/**
		 * 重新调整滚动条位置
		 */
		public function activeScroll():void
		{
			invalidateDraw();
		}
		
		///////////////////////////////////////
		// get/set
		///////////////////////////////////////
		
		//////// source //////////////////////
		
		/**
		 * 被滚动的对象
		 */
		private var _source:DisplayObject;
		
		/**
		 * 显示要滚动的对象
		 * @param picDP
		 */
		public function set source(picDP:DisplayObject):void
		{
			SparrowUtil.clearDisp(contDP);
			contDP.addChild(picDP);
			_source = picDP;
			activeScroll();
		}
		
		public function get source():DisplayObject 
		{
			return _source;
		}
		
		////// autoVhidden //////////////////////
		
		private var _autoVhidden:Boolean = true;
		
		/**
		 * 自动显示隐藏纵向滚动条
		 */
		public function get autoVhidden():Boolean
		{
			return _autoVhidden;
		}

		/**
		 * @private
		 */
		public function set autoVhidden(value:Boolean):void
		{
			_autoVhidden = value;
		}
		
		////// autoHhidden ///////////////////////
		
		private var _autoHhidden:Boolean = true;

		/**
		 * 自动显示隐藏纵向滚动条
		 */
		public function get autoHhidden():Boolean
		{
			return _autoHhidden;
		}

		/**
		 * @private
		 */
		public function set autoHhidden(value:Boolean):void
		{
			_autoHhidden = value;
		}

		/**
		 * 纵向滚动条
		 */
		public function get vScroll():VScrollBar
		{
			return _vScroll;
		}

		/**
		 * 通过滚动条皮肤初始纵向滚动条
		 
		public function setVScroll(scrollSkin:Sprite):void
		{
			_vScroll = new VScrollBar(scrollSkin);
		}*/

		/**
		 * 横向滚动条
		 */
		public function get hScroll():HScrollBar
		{
			return _hScroll;
		}
		
		/**
		 * 通过滚动条皮肤初始横向滚动条
		 
		public function setHScroll(scrollSkin:Sprite):void
		{
			_hScroll = new HScrollBar(scrollSkin);
		}*/
		
		//////// width //////////////////

		override public function get width():Number
		{
			return _width;
		}

		override public function set width(value:Number):void
		{
			_width = value;
			activeScroll();
		}
		
		//////// height //////////////////

		override public function get height():Number
		{
			return _height;
		}

		override public function set height(value:Number):void
		{
			_height = value;
			activeScroll();
		}
		
		/**
		 * 被滚动的显示对象宽
		 * @return 
		 */
		public function get sourceWidth():Number
		{
			return contDP.width;
		}
		
		/**
		 * 被滚动的显示对象高
		 * @return 
		 */
		public function get sourceHeight():Number
		{
			return contDP.height;
		}

		/**
		 * 是否自动改变滚动条位置
		 */
		public function get autoScroll():Boolean
		{
			return _autoScroll;
		}

		/**
		 * @private
		 */
		public function set autoScroll(value:Boolean):void
		{
			_autoScroll = value;
		}
		
		/**
		 * 用于存放被拖动的显示对象的容器
		 
		public function get contDP():Sprite
		{
			return _contDP;
		}*/
		
		override protected function get defaultUIVar():Object
		{
			return "scrollPanel"
		}
	}
}

package sparrowGui.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import sparrowGui.components.base.BaseUIComponent;
	
	/**
	 * 带滚动条的文本组件
	 * 
	 * 例子如下
	 * 
		var ta:STextArea = new STextArea();
		ta.width = 100;
		ta.height = 100;
		ta.update("asd\n222222\n333\n444\n555\n666\n777\n222222\n333\n444\n555\n666\n7" +
			"77\n222222\n333\n444\n555\n666\n777\n222222\n333\n444\n555\n666\n777");
		
		addChild(ta);
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class STextArea  extends BaseUIComponent
	{
		private static const TXTFIELD_NAME:String = "txtLabel";	//文本名
		/**
		 * 滚动文本的名字
		 
		private static const TXT_NAME:String = "txt_area";*/
		
		private var _txtField:TextField;
		
		private var _vScroll:VScrollBar;
//		private var _hScroll:HScrollBar;
		
		private var _autoVhidden:Boolean = true;
		private var _autoScroll:Boolean = true;
		
		// 滚动条是否正在滚动，是的话屏掉文本的滚动
//		private var isScrolling:Boolean = false;
		
		/**
		 * 构造可滚动的文本组件
		 * @param uiVars 皮肤变量
		 */
		public function STextArea(uiVars:Object=null)
		{
			_width = 80;
			_height = 80;
			super(uiVars || defaultUIVar);
		}
		
		override protected function buildSetUI(uiVars:Object=null):void
		{
			if(uiVars is TextField)
			{
				_txtField = uiVars as TextField;
//				_skin = _txtField.parent;
			}
			else
				super.buildSetUI(uiVars);
			
			createVScroll();
			
			_txtField = getChildByName(TXTFIELD_NAME) as TextField;
			addChild(_vScroll);
			addSkinListen();
		}
		
/*		override protected function create(txtSkin:Sprite=null):void
		{
			txtSkin = txtSkin || new Sprite();
//			vars = vars || SkinStyleSheet.getIns().textAreaVars;
			
			if(!_txtField) _txtField = SkinStyleSheet.getIns().textAreaTxt;

			if(!_txtField.parent || _txtField.parent != txtSkin)
				txtSkin.addChild(_txtField);
			
			if(!_vScroll){
				_vScroll = new VScrollBar(SkinStyleSheet.getIns().textAreaScrollSkin);
				_vScroll.addSkinToParent(txtSkin);
			}
			
			// 初始纵向滚动条
//			if(vars.vScrollSkin){
//				_vScroll = new VScrollBar(vars.vScrollSkin);
//				_vScroll.addToParent(txtSkin);
//			}
//			delete vars.vScrollSkin;
			
			super.create(txtSkin);
			
			width = _txtField.width;
			height = _txtField.height;
		}*/
		
		/**
		 * 添加事件监听
		 */
		protected function addSkinListen():void
		{
			if(_txtField)
			{
				_txtField.addEventListener(Event.SCROLL,onTxtScroll);
				_txtField.addEventListener(TextEvent.TEXT_INPUT,onTxtInput);
			}
			if(vScroll)
				vScroll.addEventListener(Event.CHANGE,onScrollVEvent);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		/**
		 * 移除事件监听
		 */
		protected function removeSkinListen():void
		{
			if(_txtField)
			{
				_txtField.removeEventListener(Event.SCROLL,onTxtScroll);
				_txtField.removeEventListener(TextEvent.TEXT_INPUT,onTxtInput);
			}
			if(vScroll)
				vScroll.removeEventListener(Event.CHANGE,onScrollVEvent);
			removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		/**
		 * 更新文本数据
		 */
		public function update(txt:String):void
		{
			_txtField.text = txt;
			activeScroll();
		}
		
		/**
		 * 监听横向滚动条事件
		 * @param e
		 */
		private function onScrollVEvent(e:Event):void
		{
			//　为了不跟文本本身的scroll事件冲突，滚动前先关掉文本滚动
			_txtField.removeEventListener(Event.SCROLL,onTxtScroll);
			_txtField.scrollV = _txtField.maxScrollV * vScroll.scrollPercent + 1;
			_txtField.addEventListener(Event.SCROLL,onTxtScroll);
//			isScrolling = false;
		}
		
		/**
		 * 滚轮事件
		 * @param event
		 */
		private function onMouseWheel(e:MouseEvent):void
		{
			if(e.target == _txtField) return;
			vScroll.scrollPercent -= e.delta/_txtField.maxScrollV;
//			isScrolling = false;
		}
		
		/**
		 * 文本输入文字改变
		 * @param e
		 */
		private function onTxtInput(e:Event):void
		{
			activeScroll();
			vScroll.scrollPercent = (_txtField.scrollV - 1) /(_txtField.maxScrollV - 1);
		}
		
		/**
		 * 文本滚动
		 * @param event
		 */
		private function onTxtScroll(e:Event):void
		{
			vScroll.removeEventListener(Event.CHANGE,onScrollVEvent);
			vScroll.scrollPercent = (_txtField.scrollV - 1) /(_txtField.maxScrollV - 1);
			vScroll.addEventListener(Event.CHANGE,onScrollVEvent);
		}
		
		/**
		 * 激活滚动条
		 */
		public function activeScroll():void
		{
			var dpWidth:Number = width;
			var dpHeight:Number = height;
			
			// 是否显示纵向滚动条的判断
			if(_txtField.maxScrollV==1){
				if(autoVhidden)
					vScroll.visible = false;
				else
				{
					vScroll.visible = true;
					vScroll.enabled = false;
					
					dpWidth = this.width - (autoScroll?vScroll.width:0);
				}
			}
			else
			{
				vScroll.visible = true;
				var stepValue:Number = 1/(_txtField.maxScrollV-1);
				vScroll.setSliderParams(1,_txtField.maxScrollV,stepValue);
				
				dpWidth = this.width - (autoScroll?vScroll.width:0);
			}
			
			_txtField.width = dpWidth;
			_txtField.height = dpHeight;
			
			if(autoScroll)
			{
				vScroll.x = _txtField.width;
				vScroll.y = _txtField.y;
				vScroll.height = height;
			}
		}
		
		////////////////////////////////////////////
		// get/set
		///////////////////////////////////////////
		
		public function set htmlText(value:String):void 
		{
			_txtField.htmlText = value;
			activeScroll();
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function set width(value:Number):void
		{
			_width = value;
			activeScroll();
		}

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
		 * 纵向滚动条
		 */
		public function get vScroll():VScrollBar
		{
			return _vScroll;
		}
		
		/**
		 * 通过滚动条皮肤初始纵向滚动条
		 */
		public function createVScroll():void
		{
			_vScroll = new VScrollBar();
		}

		override protected function get defaultUIVar():Object
		{
			return "textArea";
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			removeSkinListen();
			super.dispose();
		}
	}
}
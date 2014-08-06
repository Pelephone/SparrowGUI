package sparrowGui.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import sparrowGui.components.item.SButton;
	import sparrowGui.components.base.BaseUIComponent;
	
	/** 页码改变. **/
	[Event(name="page_change", type="sparrowGui.components.PageBox")]
	/** 页码改变. **/
	[Event(name="max_page_change", type="sparrowGui.components.PageBox")]
	/**
	 * 翻页按钮组,和列表组合使用
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class PageBox extends BaseUIComponent
	{
		/**
		 * 页码改变
		 */
		public static const PAGE_CHANGE:String = "page_change";
		/**
		 * 最大页数改变
		 */
		public static const MAX_PAGE_CHANGE:String = "max_page_change";
		
		private var _currentPage:int;
		
		private var _langShow:String = "{currentPage}/{maxPage}";
		
		public function PageBox(uiVars:Object=null)
		{
			super(uiVars || defaultUIVar);
			flushPage();
		}
		
		override protected function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
//			if(skinDC){
//				new SButton(btn_first);
//				new SButton(btn_go);
//				new SButton(btn_prev);
//				new SButton(btn_next);
//				new SButton(btn_last);
//			}
			addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		/**
		 * 点击事件
		 * @param e
		 */
		private function onMouseClick(e:MouseEvent):void
		{
			switch(e.target.name)
			{
				case BTN_GO_NAME:
				{
					currentPage = int(txt_inputNum.text) - 1;
					break;
				}
				case BTN_PREV_NAME:
				{
					if(currentPage>0)
						currentPage--;
					break;
				}
				case BTN_NEXT_NAME:
				{
					if(currentPage<totalPage)
						currentPage++;
					break;
				}
				case BTN_LAST_NAME:
				{
					currentPage = totalPage;
					break;
				}
				case BTN_FIRST_NAME:
				{
					currentPage = 0;
					break;
				}
			}
		}
		
		/**
		 * 更新页码显示
		 */
		private function flushPage():void
		{
			if(txt_inputNum)
			{
				txt_inputNum.text = String(currentPage+1);
			}
			if(txt_showNum)
			{
				var str:String = langShow.replace(/{currentPage}/g,(this.currentPage+1));
				str = str.replace(/{maxPage}/g,(this.totalPage+1));
				txt_showNum.text = str;
			}
		}

		/**
		 * 当前页
		 */
		public function get currentPage():int
		{
			return _currentPage;
		}

		/**
		 * @private
		 */
		public function set currentPage(value:int):void
		{
			_currentPage = value;
			flushPage();
			sendNote(PAGE_CHANGE);
		}
		
		private var _totalPage:int = 1;
		
		/**
		 * 最大页数
		 */
		public function get totalPage():int
		{
			return _totalPage;
		}

		/**
		 * @private
		 */
		public function set totalPage(value:int):void
		{
			if(_totalPage == value)
				return;
			_totalPage = value;
			flushPage();
		}

		/**
		 * 显示文字的语言包
		 */
		public function get langShow():String
		{
			return _langShow;
		}

		/**
		 * @private
		 */
		public function set langShow(value:String):void
		{
			_langShow = value;
			flushPage();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			removeEventListener(MouseEvent.CLICK,onMouseClick);
			super.dispose();
		}

		
		// 组件里面的字符 //////
		
		private static const BTN_GO_NAME:String	= "btn_go";
		private static const BTN_PREV_NAME:String		= "btn_prev";
		private static const BTN_NEXT_NAME:String		= "btn_next";
		private static const BTN_LAST_NAME:String		= "btn_last";
		private static const BTN_FIRST_NAME:String		= "btn_first";
		private static const TXT_INPUTNUM_NAME:String	= "txt_inputNum";
		private static const TXT_SHOWNUM_NAME:String	= "txt_showNum";
//		private static const TXT_PERNUM:String	= "txt_perNum";
//		private static const COMBOBOX_PAGE:String	= "combobox_Page";
		
		public function get btn_go():DisplayObject
		{ return getChildByName("btn_go") as DisplayObject };
		public function get btn_prev():DisplayObject
		{ return getChildByName("btn_prev") as DisplayObject };
		public function get btn_next():DisplayObject
		{ return getChildByName("btn_next") as DisplayObject };
		public function get btn_last():DisplayObject
		{ return getChildByName("btn_last") as DisplayObject };
		public function get btn_first():DisplayObject
		{ return getChildByName("btn_first") as DisplayObject };
		public function get txt_inputNum():TextField
		{ return getChildByName("txt_inputNum") as TextField };
		public function get txt_showNum():TextField
		{ return getChildByName("txt_showNum") as TextField };
		
		override protected function get defaultUIVar():Object
		{
			return "pageBox";
		}
	}
}
package sparrowGui.components
{
	import flash.events.Event;
	
	import sparrowGui.i.IItemFactory;
	
	/**
	 * 带翻页功能的列表组件(同pageBox一起使用)
	 * 
		var pl:PageList = new PageList();
		addChild(pl);
		
		var pb:DisplayObject = UIStyleMgr.getIns().createSkinUI("pageBox");//new PageBox();
		addChild(pb);
		
		pl.setPageBox(pb);
		pl.update([11,22,33,44,55,66,77,88,99,00,111,112,113,114,115]);
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class PageList extends SList
	{
		public var pageBox:PageBox;
		private var _pageNum:int = 8;
		
		private var _totalDatas:Object;
		
		/**
		 * 构造翻页列表组件
		 * @param uiVars 皮肤变量
		 * @param cellFactory 子项工厂，用于创建子项和子项皮肤，工厂里还有缓存的功能
		 * 
		 */
		public function PageList(uiVars:Object=null)
		{
			super(uiVars || defaultUIVar);
			
			colNum = 1;
		}
		
		/**
		 * 更新数据
		 * @param o
		 */
		override public function set data(o:Object):void
		{
			_totalDatas = o;
			if(!pageBox)
			{
				super.data = totalDatas;
				return;
			}
			pageBox.totalPage = this.totalPage;
			pageBox.currentPage = 0;
			var startId:int = pageBox.currentPage*pageNum;
			var pageData:Array = totalDatas.slice(startId,(startId+pageNum));
			super.data = pageData;
		}
		
		/**
		 * 通过皮肤初始列表翻页组件
		 * @param pageSkin
		 */
		public function setPageBox(pageBoxClip:PageBox):void
		{
			pageBox = pageBoxClip;
			pageBox.addEventListener(PageBox.PAGE_CHANGE,onPageEvt);
		}
		
		/**
		 * 翻页事件响应
		 * @param e
		 */
		private function onPageEvt(e:Event):void
		{
			var startId:int = pageBox.currentPage*pageNum;
			var pageData:Array = totalDatas.slice(startId,(startId+pageNum));
			super.data = pageData;
		}
		
		public function get totalPage():int 
		{
			if(!totalDatas) return 0;
			return int(totalDatas.length/_pageNum-(((totalDatas.length%_pageNum)>0)?0:1));
		}

		/**
		 * 完整数据(列表里的是其中一页的数据)
		 */
		public function get totalDatas():Object
		{
			return _totalDatas;
		}

		/**
		 * 每页记录数
		 */
		public function get pageNum():int
		{
			return _pageNum;
		}

		/**
		 * @private
		 */
		public function set pageNum(value:int):void
		{
			_pageNum = value;
		}
		
		/**
		 * 当前页
		 * @return 
		 */
		public function get currentPage():int
		{
			return pageBox.currentPage;
		}
		
		override protected function get defaultUIVar():Object
		{
			return "pageList";
		}
	}
}
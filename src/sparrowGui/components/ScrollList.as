package sparrowGui.components
{
	import flash.events.Event;
	
	import sparrowGui.components.base.BaseUIComponent;
	import sparrowGui.event.ComponentEvent;

	/**
	 * 带滚动条和列表组件的列表数据组件
	 * 
		var rls:ScrollList = new ScrollList();
		rls.update([11,22,33,44,55,66,77]);
		addChild(rls);
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class ScrollList extends BaseUIComponent
	{
		private var scrollPan:ScrollPanel;
		
		/**
		 * 构造滚动列表
		 * @param uiVars
		 * @param cellFactory 子项工厂，用于创建子项和子项皮肤，工厂里还有缓存的功能
		 */
		public function ScrollList(uiVars:Object=null)
		{
			super(uiVars || defaultUIVar);
			
			scrollPan = newScrollPanel();
			addChild(scrollPan);
			list = newList();
			addChild(list);
			
			scrollPan.source = list;
		}
		
		/**
		 * 创建滚动面板
		 * @return 
		 */
		protected function newScrollPanel():ScrollPanel
		{
			return  new ScrollPanel();
		}
		
		/////////////////////////////////////////////////////
		// list
		/////////////////////////////////////////////////////
		
		/**
		 * 创建列表组件
		 * @param cellFactory
		 * @return 
		 */
		protected function newList():SList
		{
			var ls:SList = new SList();
//			ls.colNum = 1;
			return ls;
		}
		
		private var _list:SList;
		
		/**
		 * 列表组件
		 * @return 
		 */
		public function get list():SList 
		{
			return _list;
		}
		
		/**
		 * @private
		 */
		public function set list(ls:SList):void
		{
			if(_list)
				_list.removeEventListener(ComponentEvent.DRAW,onReDraw);
			
			_list = ls;
			
			if(_list)
				_list.addEventListener(ComponentEvent.DRAW,onReDraw);
		}
		
		/**
		 * 刷新组件
		 * @param e
		 */
		private function onReDraw(e:Event):void
		{
//			SparrowUtil.addNextCall(draw);
			invalidateDraw();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			scrollPan.activeScroll();
			super.draw();
		}
		
		/**
		 * 更新内容
		 * @param data
		 */
		public function set data(value:Object):void
		{
			list.data = value;
		}
		
		/**
		 * @private
		 */
		public function get data():Object 
		{
			return list.data;
		}
		
		/////////////////////////////////////////////////////
		// 滚动
		/////////////////////////////////////////////////////
		
		/**
		 * 是否自动改变滚动条位置
		 */
		public function get autoScroll():Boolean
		{
			return scrollPan.autoScroll;
		}
		
		/**
		 * @private
		 */
		public function set autoScroll(value:Boolean):void
		{
			scrollPan.autoScroll = value;
		}
		
		/**
		 * 自动显示隐藏纵向滚动条
		 */
		public function get autoVhidden():Boolean
		{
			return scrollPan.autoVhidden;
		}
		
		/**
		 * @private
		 */
		public function set autoVhidden(value:Boolean):void
		{
			scrollPan.autoVhidden = value;
		}
		
		/**
		 * 自动显示隐藏纵向滚动条
		 */
		public function get autoHhidden():Boolean
		{
			return scrollPan.autoHhidden;
		}
		
		/**
		 * @private
		 */
		public function set autoHhidden(value:Boolean):void
		{
			scrollPan.autoHhidden = value;
		}
		
		/**
		 * 被滚动的显示对象宽
		 * @return 
		 */
		public function get sourceWidth():Number
		{
			return scrollPan.sourceWidth;
		}
		
		/**
		 * 被滚动的显示对象高
		 * @return 
		 */
		public function get sourceHeight():Number
		{
			return scrollPan.sourceHeight;
		}
		
		override public function set height(value:Number):void
		{
			scrollPan.height = value;
		}
		
		override public function set width(value:Number):void
		{
			scrollPan.width = value;
		}
		
		override public function get width():Number
		{
			return scrollPan.height;
		}
		
		override protected function get defaultUIVar():Object
		{
			return "scrollList";
		}
		
		override public function dispose():void
		{
			if(list)
				list.removeEventListener(ComponentEvent.DRAW,onReDraw);
			scrollPan.dispose();
		}
	}
}
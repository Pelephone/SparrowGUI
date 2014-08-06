package sparrowGui.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import sparrowGui.components.base.BaseUIComponent;
	import sparrowGui.event.ComponentEvent;
	import sparrowGui.event.ListEvent;
	import sparrowGui.utils.SparrowUtil;

	/**
	 * 带滚动条和列表组件的列表数据组件
	 * 
	 * 例子如下
	 * 
		var tr:ScrollTree = new ScrollTree();
		var xml:XML = XML(
			<tree>
					<node nodeId='1' pid='' skinCls='' txtName='11' selected='' />
			 		<node nodeId='2' pid='' skinCls='' txtName='22' selected='' />
			 		<node nodeId='3' pid='1' skinCls='' txtName='33' selected='' />
			 		<node nodeId='4' pid='1' skinCls='' txtName='44' selected='' />
			 		<node nodeId='5' pid='1' skinCls='' txtName='44' selected='' />
			</tree>
			);
		
		addChild(tr);
		tr.update(xml);
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class ScrollTree extends BaseUIComponent
	{
		private var scrollPan:ScrollPanel;
		
		/**
		 * 构造滚动列表
		 * @param uiVars 皮肤变量
		 * @param cellFactory 子项工厂，用于创建子项和子项皮肤，工厂里还有缓存的功能
		 */
		public function ScrollTree(uiVars:Object=null)
		{
			super(uiVars || defaultUIVar);
			
			scrollPan = newScrollPanel();
			addChild(scrollPan);
			tree = newTree();
			
			scrollPan.source = _tree;
			
			tree.addEventListener(ListEvent.LIST_ITEM_FOLD,onFoldEvt);
		}
		
		private function onFoldEvt(e:Event):void
		{
//			scrollPan.activeScroll();
			invalidateDraw();
		}
		
		/**
		 * 创建滚动面板
		 * @return 
		 */
		protected function newScrollPanel():ScrollPanel
		{
			return  new ScrollPanel();
		}
		
		/**
		 * 创建列表组件
		 * @param cellFactory
		 * @return 
		 */
		protected function newTree():STree
		{
//			cellFactory = cellFactory || new TreeItemFactory(STreeItem,"treeItem","richItem");
			var ls:STree = new STree();
			ls.colNum = 1;
			return ls;
		}
		
		/////////////////////////////////////////////////////
		// tree
		/////////////////////////////////////////////////////
		
		private var _tree:STree;
		
		/**
		 * 返回列表组件
		 * @return 
		 */
		public function get tree():STree 
		{
			return _tree;
		}
		
		/**
		 * @private
		 */
		public function set tree(value:STree):void 
		{
			if(_tree)
			{
				_tree.removeEventListener(ComponentEvent.DRAW,onReDraw);
				_tree.removeEventListener(ListEvent.LAYOUT_UPDATE,onReDraw);
			}
			
			_tree = value;
			
			if(_tree)
			{
				_tree.addEventListener(ComponentEvent.DRAW,onReDraw);
				_tree.addEventListener(ListEvent.LAYOUT_UPDATE,onReDraw);
			}
		}
		
		/**
		 * 刷新组件
		 * @param e
		 */
		private function onReDraw(e:Event=null):void
		{
			invalidateDraw();
//			SparrowUtil.addNextCall(draw);
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
			tree.data = value;
//			scrollPan.activeScroll();
		}
		
		/////////////////////////////////////////////////////
		// scroll
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
		
		override public function set width(value:Number):void
		{
			scrollPan.width = value;
		}
		
		override public function get width():Number
		{
			return scrollPan.width;
		}
		
		override public function set height(value:Number):void
		{
			scrollPan.height = value;
		}
		
		override public function get height():Number
		{
			return scrollPan.height;
		}
		
		override protected function get defaultUIVar():Object
		{
			return "scrollTree";
		}
		
		override public function dispose():void
		{
			if(tree)
			{
				tree.removeEventListener(ListEvent.LIST_ITEM_FOLD,onFoldEvt);
				tree.removeEventListener(ComponentEvent.DRAW,onReDraw);
				tree.dispose();
			}
			if(scrollPan)
				scrollPan.dispose();
		}
	}
}
package sparrowGui.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import sparrowGui.components.base.BaseTip;
	import sparrowGui.event.ListEvent;
	
	[Event(name="list_item_select", 	type="sparrowGui.event.ListEvent")]
	
	/**
	 * 弹出菜单,类似鼠标右键
	 * 
	 * 例子如下
	 * 
	 * var actBtn:simplyButton;
		actBtn.addEventListener(MouseEvent.CLICK,onBtnClick);
		var pop:SPopupMenu = new SPopupMenu(this);
		pop.addEventListener(ListEvent.LIST_ITEM_SELECT,onListSelect);
		
		function onBtnClick(e:MouseEvent):void
		{
			pop.show([11,22,33,44,55],actBtn);
		}
		function onBtnClick(e:ListEvent):void
		{
			trace(e.target);
		}
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class SPopupMenu extends BaseTip
	{
		/**
		 * 列表组件
		 */
		public var list:SList;
		
		/**
		 * 构造弹窗菜单组件
		 * @param showParent 列表弹出到的容器
		 * @param uiVars 皮肤变量
		 * @param itemFactory 子项工厂，用于创建子项和子项皮肤，工厂里还有缓存的功能
		 */
		public function SPopupMenu(uiVars:Object=null)
		{
			list = new SList();
			list.colNum = 1;
//			list.itemClass = SButton;
			addChild(list);
			
			super(uiVars || defaultUIVar);
			
			list.addEventListener(ListEvent.LIST_ITEM_SELECT,onSelectEvt);
//			list.addEventListener(MouseEvent.CLICK,onMouseClick);
//			showPos = TIPS_POSI_AUTO_UP;
		}
		
		/**
		 * @inheritDoc
		 
		override protected function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
		}*/
		
		override public function set data(data:Object):void
		{
			list.data = data;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get data():Object
		{
			return list.data;
		}
		
		override public function show(tarDisp:DisplayObject=null):void
		{
			tarDisp = tarDisp || list;
			super.show(tarDisp);
			
			if(autoClose)
			showParent.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		override public function showByPos(posX:Number, posY:Number, data:Object=null):void
		{
			super.showByPos(posX,posY,data);
			
			if(autoClose)
			showParent.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		/**
		 * 在鼠标周围显示
		 * @param offsetX
		 * @param offsetY
		 */
		public function showToMouse(offsetX:int=0,offsetY:int=0):void
		{
			super.showByPos((mouseX + offsetX),(mouseY + offsetY),data);
			
			if(autoClose)
			showParent.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			var clickTars:Array = this.getObjectsUnderPoint(new Point(e.stageX,e.stageY));
			if(clickTars && clickTars.length>0) return;
			clearUp();
		}
		
		private function onSelectEvt(e:Event):void
		{
			dispatchEvent(e);
		}
		
		/*private function onMouseClick(event:MouseEvent):void
		{
			clearUp();
		}*/
		
		/**
		 * 点非弹窗部份，是否自动关闭
		 */
		public var autoClose:Boolean = true;
		
		/**
		 * 是否选中完成之后关闭
		 
		public var isSelectCancel:Boolean = true;*/
		
		override public function clearUp():void
		{
			super.clearUp();
			
			if(showParent && showParent.stage)
			showParent.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			
			dispatchEvent(new Event(Event.CANCEL));
		}
		
		/**
		 * 选中项索引
		 */
		public function get selectIndex():int
		{
			return list.selectIndex;
		}
		
		/**
		 * 选中项索引
		 */
		public function set selectIndex(value:int):void 
		{
			list.selectIndex = value;
		}
		
		/**
		 * 选中项内容
		 * @return 
		 */
		public function get selectData():*
		{
			return list.selectData;
		}
	}
}
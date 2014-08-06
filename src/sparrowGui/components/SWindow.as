package sparrowGui.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import sparrowGui.components.base.BaseUIComponent;
	import sparrowGui.components.item.SItem;
	import sparrowGui.components.item.SToggleButton;
	
	/**
	 * 窗体组件
	 * 有拖动,合起展开功能
	 * 
	 * 
		var w:SWindow = new SWindow();
		addChild(w);
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class SWindow extends BaseUIComponent
	{
		private static const DRAGBG_NAME:String	= "dragBG";
		private static const FOLDBTN_NAME:String	= "foldSkin";
		private static const CLOSEBTN_NAME:String	= "closeSkin";
		private static const CONTDP_NAME:String	= "contDP";
		private static const SKINBG_NAME:String	= "skinBG";
		private static const TXTTITLE_NAME:String	= "txtTitle";
		
		protected var dragBG:DisplayObject;
		protected var foldSkin:SItem;
		protected var closeSkin:DisplayObject;
		private var skinBG:DisplayObject;
		public var contDP:DisplayObjectContainer;
		public var txtTitle:TextField;
		
		/**
		 * 合起按钮
		 
		private var foldBtn:SToggleButton;
		private var closeBtn:SButton;*/
		/**
		 * 构造窗体组件
		 * @param uiVars 皮肤变量
		 */		
		public function SWindow(uiVars:Object=null)
		{
			_width = 150;
			_height = 120;
			super(uiVars || defaultUIVar);
			reset();
		}
		
		override protected function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
			
			dragBG = this.getChildByName(DRAGBG_NAME);
			foldSkin = this.getChildByName(FOLDBTN_NAME) as SToggleButton;
			closeSkin = this.getChildByName(CLOSEBTN_NAME);
			skinBG = this.getChildByName(SKINBG_NAME);
			contDP = this.getChildByName(CONTDP_NAME) as DisplayObjectContainer;
			txtTitle = this.getChildByName(TXTTITLE_NAME) as TextField;
				
//				foldBtn = foldSkin;//new SToggleButton(foldSkin);
//				closeBtn = closeSkin;//new SButton(closeSkin);
		}
		
		/**
		 * 标题文字
		 */
		public function get title():String
		{
			if(txtTitle)
				return txtTitle.text;
			return null;
		}

		/**
		 * @private
		 */
		public function set title(value:String):void
		{
			if(txtTitle)
				txtTitle.htmlText = value;
		}
		
		
		/**
		 * @inheritDoc
		 
		override public function setUiStyle(uiVars:Object=null):void
		{
			super.setUiStyle(uiVars);
			
		}*/
		
		public function reset():void
		{
			if(dragBG)
				dragBG.addEventListener(MouseEvent.MOUSE_DOWN,onEvt);
			if(foldSkin)
				foldSkin.addEventListener(MouseEvent.CLICK,onFoldChange);
//				foldSkin.addEventListener(Event.CHANGE,onFoldChange);
			if(closeSkin)
				closeSkin.addEventListener(MouseEvent.CLICK,onClose);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			if(dragBG)
				dragBG.removeEventListener(MouseEvent.MOUSE_DOWN,onEvt);
			if(foldSkin)
				foldSkin.removeEventListener(MouseEvent.CLICK,onFoldChange);
			if(closeSkin)
				closeSkin.removeEventListener(MouseEvent.CLICK,onClose);
			super.dispose();
		}
		
		/**
		 * 关上合起按钮事件
		 * @param e
		 */
		protected function onFoldChange(e:Event):void
		{
			if(foldSkin.selected)
			{
				contDP.visible = false;
				skinBG.visible = false;
			}
			else
			{
				contDP.visible = true;
				skinBG.visible = true;
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 监听鼠标事件
		 * @param e
		 */
		private function onEvt(e:Event):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
				{
					var gp:Point = this.parent.globalToLocal(new Point());
					var rect:Rectangle = new Rectangle(gp.x,gp.y,(this.stage.stageWidth-dragBG.height),(this.stage.stageHeight - 20));
					
					this.startDrag(false,rect);
					
					this.stage.addEventListener(MouseEvent.MOUSE_UP,onEvt);
					this.stage.addEventListener(Event.MOUSE_LEAVE,onEvt);
					break;
				}
				case MouseEvent.MOUSE_UP:
				case Event.MOUSE_LEAVE:
					this.stopDrag();
					break;
			}
		}
		
		protected function onClose(e:Event):void
		{
			removeFromParent();
		}
		
		/**
		 * 包含容器添加显示对象
		 * @param child
		 */
		public function addContChild(child:DisplayObject):DisplayObject
		{
			return contDP.addChild(child);
		}
		
		/**
		 * 从包含容器里面获取对象
		 * @param name
		 */
		public function getContChildByName(name:String):DisplayObject
		{
			return contDP.getChildByName(name);
		}
		
/*		private function get skinSP():Sprite
		{
			return skin as Sprite;
		}*/
		
		override protected function get defaultUIVar():Object
		{
			return "window";
		}
		
		/**
		 * @inheritDoc
		 
		override public function setUiStyle(uiVars:Object=null):void
		{
			super.setUiStyle(uiVars);
		}*/
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			// 按钮间距
			var padding:int = 3;
			
			dragBG.width = _width;
			skinBG.width = _width;
			skinBG.height = _height;
			closeSkin.x = _width - closeSkin.width - padding;
			foldSkin.x = _width - closeSkin.width - foldSkin.width - padding*2;
			
			txtTitle.width = foldSkin.x - padding;
			txtTitle.x = padding;
			
			super.draw();
		}
		
		override public function get height():Number
		{
			if(!foldSkin.selected)
				return super.height;
			else
				return dragBG.height;
		}
		
		/**
		 * 禁掉缩放
		 
		override public function set scaleX(value:Number):void
		{
		}*/
		
		/**
		 * 禁掉缩放
		 
		override public function set scaleY(value:Number):void
		{
		}*/
	}
}
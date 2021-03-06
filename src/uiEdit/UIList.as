package uiEdit
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import TimerUtils.FrameTimer;
	
	import asSkinStyle.ReflPositionInfo;
	
	/**
	 * 列表组件
	 * @author Pelephone
	 */
	public class UIList extends Sprite
	{
		public function UIList()
		{
			super();
			
			height = 120;
		}
		
		private var _itemSrc:String;

		public function get bgSrc():String
		{
			if(tmpSrc)
				return tmpSrc;
			return _itemSrc;
		}

		public function set bgSrc(value:String):void
		{
//			if(_itemSrc == value)
//				return;
			_itemSrc = value;
			
			var eMgr:EditMgr = EditMgr.getInstance();
			tmpSrc = value.replace(/\\/g,"/");
			tmpSrc = tmpSrc.replace(eMgr.rootPath,"");
			
			var r:String = eMgr.rootPath;
			if(!eMgr.useRootPath || tmpSrc.indexOf(":/")>=0)
				r = "";
			var u2:String = r + tmpSrc;
			var ur:URLRequest = new URLRequest(u2);
			itemLoader.load(ur);
		}
		
		private var tmpSrc:String;

		private var _itemLoader:URLLoader;

		public function get itemLoader():URLLoader
		{
			if(_itemLoader == null)
			{
				_itemLoader = new URLLoader();
				_itemLoader.addEventListener(Event.COMPLETE,onItemComplete);
				_itemLoader.addEventListener(IOErrorEvent.IO_ERROR,onItemComplete);
			}
			return _itemLoader;
		}
		
		
		private function onItemComplete(e:Event):void
		{
			if(e.type == Event.COMPLETE)
			{
				createitem();
				FrameTimer.delayCall(1000,recreateItems);
			}
			else
				trace("UIList.bgSrc:",_itemSrc,"加载错误");
		}
		
		public var rowHeight:int;
		
		public var colWidth:int;
		
		public var spaceX:int = 10;
		
		public var spaceY:int = 10;
		
		public var colNum:int = 0;
		
		private var _spacing:int;

		public function get spacing():int
		{
			return _spacing;
		}

		public function set spacing(value:int):void
		{
			spaceX = value;
			spaceY = value;
			_spacing = value;
		}
		
		
		/**
		 * 重新创建子项
		 */
		private function recreateItems(d:*=null):void
		{
			var preItem:URLScale9Img = getChildByName("item_0") as URLScale9Img;
			while(this.numChildren)
				this.removeChildAt(0);
			
			var tmpY:int = 0;
			var tmpX:int = 0;
			var i:int = 0;
			
			var itemWidth:int = 0;
			if(colWidth != 0)
				itemWidth = colWidth;
			var itemHeight:int = 0;
			if(rowHeight != 0)
				itemHeight = rowHeight;
			
			if(itemWidth == 0 && preItem)
				itemWidth = preItem.width;
			if(itemHeight == 0 && preItem)
				itemHeight = preItem.height;
			
			while(true)
			{
				var itm:DisplayObject = createitem();
				
				if(i && colNum>0 && i%colNum==0)
				{
					tmpY = tmpY + spaceY + itemHeight;
					tmpX = 0;
				}
				else if(i && colNum == 0 && (tmpX + itemWidth)>width)
				{
					tmpY = tmpY + spaceY + itemHeight;
					tmpX = 0;
				}
				itm.x = tmpX;
				tmpX = tmpX + itemWidth + spaceX;
				itm.y = tmpY;
				
				if(tmpY > _height || ++i>50)
					break;
			}
		}
		
		private function createitem():URLScale9Img
		{
			var itm:URLScale9Img = new URLScale9Img();
			itm.name = "item_" + numChildren;
			itm.uiType = "custom";
			
			var deXml:XML = XML(itemLoader.data);
			var itemX:Object;
			for each (itemX in deXml.children()) 
			{
				ReflPositionInfo.decodeXmlToChild(itm,itemX);
			}
			addChild(itm);
			return itm;
		}
		
		public var uiType:String = "list";
		
		private var _height:Number = 0;
		
		override public function get height():Number
		{
			if(_height == 0)
				return super.height;
			else
				return _height;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			scrollRect = new Rectangle(0,0,width,_height);
		}
		
		private var _width:Number = 120;
		
		override public function get width():Number
		{
			if(_width == 0)
				return super.width;
			else
				return _width;
			scrollRect = new Rectangle(0,0,width,_height);
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
		}
	}
}
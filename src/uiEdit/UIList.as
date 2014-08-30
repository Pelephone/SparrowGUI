package uiEdit
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * 列表组件
	 * @author Pelephone
	 */
	public class UIList extends Sprite
	{
		public function UIList()
		{
			super();
		}
		
		public var itemSrc:String;
		
		public var itemHeight:int;
		
		public var itemWidth:int;
		
		public var spaceX:int;
		
		public var spaceY:int;
		
		/**
		 * 重新创建子项
		 */
		private function recreateItems():void
		{
			while(this.numChildren)
				this.removeChildAt(0);
			
			var tmpY:int = 0;
			var tmpX:int = 0;
			var i:int = 0;
			while(true)
			{
				var itm:URLScale9Img = new URLScale9Img();
				itm.bgSrc = itemSrc;
				itm.x = tmpX;
				itm.y = tmpY;
				if(itemWidth > 0)
					tmpX += itemWidth + spaceX;
				else
					tmpX += itm.width + spaceX;
				if(itemHeight > 0)
					tmpY += itemHeight + spaceY;
				else
					tmpY += itm.height + spaceY;
				this.addChild(itm);
				
				if(tmpX > _width || tmpY > _height || ++i>50)
					break;
			}
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
		
		private var _width:Number = 0;
		
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
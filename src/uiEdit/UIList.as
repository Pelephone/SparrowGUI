package uiEdit
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import sparrowGui.utils.SparrowUtil;
	
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
			
			SparrowUtil.addNextCall(recreateItems);
		}
		
		private var _bgSrc:String;

		public function get bgSrc():String
		{
			return _bgSrc;
		}

		public function set bgSrc(value:String):void
		{
//			if(_itemSrc == value)
//				return;
			_bgSrc = value;
			recreateItems();
		}

		
		public var rowHeight:int;
		
		public var colWidth:int;
		
		public var spaceX:int = 10;
		
		public var spaceY:int = 10;
		
		public var colNum:int = 0;
		
		
		/**
		 * 重新创建子项
		 */
		private function recreateItems():void
		{
			while(this.numChildren)
				this.removeChildAt(0);
			
			if(colNum == 0)
				colNum = 1;
			var tmpY:int = 0;
			var tmpX:int = 0;
			var i:int = 0;
			var lineHeight:int;	//其中一行子项高度最高的项高
			while(true)
			{
				var itm:URLScale9Img = new URLScale9Img();
				itm.uiType = "custom";
				itm.bgSrc = _bgSrc;
				addChild(itm);
				if(i && (i%colNum)==0)
				{
					tmpY = tmpY + spaceY + (rowHeight?rowHeight:lineHeight);
					tmpX = 0;
					lineHeight = itm.height;
				}
				itm.x = tmpX;
				tmpX = tmpX + (colWidth || itm.width) + spaceX;
				itm.y = tmpY;
				if(itm.height>lineHeight)
					lineHeight = itm.height;
				
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
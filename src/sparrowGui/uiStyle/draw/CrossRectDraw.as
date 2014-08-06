package sparrowGui.uiStyle.draw
{
	import asSkinStyle.draw.RectDraw;

	/**
	 * 十字图形
	 * @author Pelephone
	 */
	public class CrossRectDraw extends RectDraw
	{
		/**
		 * 十字符号
		 */
		public static const TYPE_CROSS:int = 0;
		
		/**
		 * 减号
		 */
		public static const TYPE_MINUS:int = 1;
		
		/**
		 * 叉叉 
		 */
		public static const TYPE_CLOSE:int = 2;
		
		private var _inBorder:int = 2;
		private var _inBorderColor:int = 0x202020;
		
		private var _type:int = 0;
		
		private var _padding:int = 3;
		/**
		 * 多选框选中时打勾图形
		 */
		public function CrossRectDraw()
		{
			super();
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if(inBorder>0){
				var lineAlpha:Number = (inBorder>0)?1:0;
				this.graphics.lineStyle(inBorder, inBorderColor,lineAlpha);
				
				
				if(type==TYPE_CROSS){
					this.graphics.moveTo(padding,height*0.5);
					this.graphics.lineTo((width-padding),height*0.5);
					this.graphics.moveTo(width*0.5,padding);
					this.graphics.lineTo(width*0.5,(height-padding));
				}
				else if(type == TYPE_MINUS)
				{
					this.graphics.moveTo(padding,height*0.5);
					this.graphics.lineTo((width-padding),height*0.5);
				}
				else if(type == TYPE_CLOSE)
				{
					this.graphics.moveTo(padding,padding);
					this.graphics.lineTo((width - padding),(height - padding));
					this.graphics.moveTo((width - padding),padding);
					this.graphics.lineTo(padding,(height - padding));
				}
			}
		}

		/**
		 * 内图形边距
		 */
		override public function get padding():int
		{
			return _padding;
		}

		/**
		 * @private
		 */
		override public function set padding(value:int):void
		{
			if(_padding == value)
				return;
			_padding = value;
			reDraw();
		}

		/**
		 * 内图形的粗细
		 */
		public function get inBorder():int
		{
			return _inBorder;
		}

		/**
		 * @private
		 */
		public function set inBorder(value:int):void
		{
			if(_inBorder == value)
				return;
			_inBorder = value;
			reDraw();
		}

		/**
		 * 内图形的颜色
		 */
		public function get inBorderColor():int
		{
			return _inBorderColor;
		}

		/**
		 * @private
		 */
		public function set inBorderColor(value:int):void
		{
			if(_inBorderColor == value)
				return;
			_inBorderColor = value;
			reDraw();
		}

		/**
		 * 类型，十字，或者减号
		 */
		public function get type():int
		{
			return _type;
		}

		/**
		 * @private
		 */
		public function set type(value:int):void
		{
			if(_type == value)
				return;
			_type = value;
			reDraw();
		}
	}
}
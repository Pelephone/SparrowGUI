package sparrowGui.uiStyle.draw
{
	import asSkinStyle.draw.CircleDraw;

	/**
	 * 单选框选中时选中图形
	 * @author Pelephone
	 */
	public class RadioCircleDraw extends CircleDraw
	{
		private var _inCirleColor:int = 0x202020;
		private var _inBorder:int = 0;
		private var _inBorderColor:int = 0;
		private var _padding:int = 4;
		
		/**
		 * 单选框选中时选中图形
		 */
		public function RadioCircleDraw(uiName:String="draw")
		{
			super(uiName);
		}
		
		override protected function draw():void
		{
			super.draw();
			var lineAlpha:Number = (inBorder>0)?1:0;
			graphics.lineStyle(this.inBorder,this.inBorderColor,lineAlpha);
			if(this.inCirleColor>=0)
			{
				graphics.beginFill(this.inCirleColor);
			
				var inWidth:Number = width - padding*2;
				var inHeight:Number = height - padding*2;
				inWidth = (inWidth>=0)?inWidth:0;
				inHeight = (inHeight>=0)?inHeight:0;
				if(width==height)
					graphics.drawCircle(width/2,height/2,inWidth/2);
				else
					graphics.drawEllipse(width/2,height/2,inWidth,inHeight);
			
				graphics.endFill();
			}
		}

		/**
		 * 内圆颜色
		 */
		public function get inCirleColor():int
		{
			return _inCirleColor;
		}

		/**
		 * @private
		 */
		public function set inCirleColor(value:int):void
		{
			_inCirleColor = value;
			reDraw();
		}

		/**
		 * 内圆边宽
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
			_inBorder = value;
			reDraw();
		}

		/**
		 * 内圆边色
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
			_inBorderColor = value;
			reDraw();
		}

		/**
		 *内圆与外圆边距 
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
			_padding = value;
			reDraw();
		}
	}
}
package sparrowGui.uiStyle.draw
{
	import asSkinStyle.draw.RectDraw;

	/**
	 * 多选框选中时打勾图形
	 * @author Pelephone
	 */
	public class HookRectDraw extends RectDraw
	{
		private var _hookThick:int = 2;
		private var _hookThickColor:int = 0x202020;
		private var _padding:int = 3;
		/**
		 * 多选框选中时打勾图形
		 */
		public function HookRectDraw()
		{
			super();
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if(hookThick>0){
				var lineAlpha:Number = (hookThick>0)?1:0;
				this.graphics.lineStyle(hookThick, hookThickColor,lineAlpha);
				this.graphics.moveTo(padding,height/2);
				this.graphics.lineTo(width/2, (height - padding));
				this.graphics.lineTo((width - padding), padding);
			}
		}

		/**
		 * 勾粗细
		 */
		public function get hookThick():int
		{
			return _hookThick;
		}

		/**
		 * @private
		 */
		public function set hookThick(value:int):void
		{
			_hookThick = value;
			reDraw();
		}

		/**
		 * 勾的颜色
		 */
		public function get hookThickColor():int
		{
			return _hookThickColor;
		}

		/**
		 * @private
		 */
		public function set hookThickColor(value:int):void
		{
			_hookThickColor = value;
			reDraw();
		}

		/**
		 * 勾边距
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
package sparrowGui.uiStyle.draw
{
	import asSkinStyle.draw.RectDraw;

	/**
	 * 带箭头的四矩形
	 * @author Pelephone
	 */
	public class ArrowRectDraw extends RectDraw
	{
		/**
		 * 箭头向上
		 */
		public static const ARROW_DIRCTION_UP:int = 0;
		/**
		 * 箭头向下
		 */
		public static const ARROW_DIRCTION_DOWN:int = 1;
		/**
		 * 箭头向左
		 */
		public static const ARROW_DIRCTION_LEFT:int = 2;
		/**
		 * 箭头向右
		 */
		public static const ARROW_DIRCTION_RIGHT:int = 3;
		
		private var _arrowBorder:int = 0;
		private var _arrowBorderColor:int = -1;
		private var _arrowColor:int = 0x202020;
		
		private var _arrowDirct:int;
		
		/**
		 * 带箭头的四矩形
		 * @param uiName
		 * @param arrowDirct	箭头方向
		 * 
		 */
		public function ArrowRectDraw(arrDirct:int=0)
		{
			_arrowDirct = arrDirct;
			super();
		}
		
		override protected function draw():void
		{
			super.draw();
			
			var linAlpha:Number = (arrowBorder>0)?1:0;
			graphics.lineStyle(arrowBorder,arrowBorderColor,linAlpha);
			
			if(arrowColor>=0)
				this.graphics.beginFill(arrowColor);
			
			//指向上
			if(arrowDirct==0)
			{
				this.graphics.moveTo(width/2,padding);
				this.graphics.lineTo(padding,(height-padding));
				this.graphics.lineTo((width-padding),(height-padding));
			}
			//指向下
			else if(arrowDirct==1)
			{
				this.graphics.moveTo(padding,padding);
				this.graphics.lineTo((width-padding),padding);
				this.graphics.lineTo(width/2,(height-padding));
			}
			//指向左
			else if(arrowDirct==2)
			{
				this.graphics.moveTo(padding,(height/2));
				this.graphics.lineTo((width-padding),padding);
				this.graphics.lineTo((width-padding),(height-padding));
			}
			//指向右
			else if(arrowDirct==3)
			{
				this.graphics.moveTo(padding,padding);
				this.graphics.lineTo(padding,(height-padding));
				this.graphics.lineTo((width-padding),height/2);
			}
			
			if(arrowColor>=0)
				this.graphics.endFill();
		}

		/**
		 * 箭头指向方向
		 */
		public function get arrowDirct():int
		{
			return _arrowDirct;
		}

		/**
		 * @private
		 */
		public function set arrowDirct(value:int):void
		{
			_arrowDirct = value;
			reDraw();
		}
		private var _padding:int = 2;

		override public function get padding():int
		{
			return _padding;
		}

		override public function set padding(value:int):void
		{
			_padding = value;
			reDraw();
		}

		/**
		 * 箭头边粗细
		 */
		public function get arrowBorder():int
		{
			return _arrowBorder;
		}

		/**
		 * @private
		 */
		public function set arrowBorder(value:int):void
		{
			_arrowBorder = value;
			reDraw();
		}

		/**
		 * 箭头边颜色
		 */
		public function get arrowBorderColor():int
		{
			return _arrowBorderColor;
		}

		/**
		 * @private
		 */
		public function set arrowBorderColor(value:int):void
		{
			_arrowBorderColor = value;
		}

		/**
		 * 箭头颜色
		 */
		public function get arrowColor():int
		{
			return _arrowColor;
		}

		/**
		 * @private
		 */
		public function set arrowColor(value:int):void
		{
			_arrowColor = value;
			reDraw();
		}
	}
}
/**
 * Copyright(c) 2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */
package sparrowGui.components.base
{
	import flash.events.EventDispatcher;
	
	import sparrowGui.event.ListEvent;
	import sparrowGui.utils.SparrowUtil;
	
	/** 子项布局更新 */
	[Event(name="layout_update", type="sparrowGui.event.ListEvent")]
	
	/**
	 * 布局小组件<br/>
	 * 本gui考虑以简单为主，本人并没有追写多个VerticalLayout,HorizontalLayout<br/>
	 * 要实现垂直，水平，流水布局，只需要改一下此对象属性,详细见colNum,width,height等属性注释<br/>
	 * Pelephone
	 */
	public class LayoutClip extends EventDispatcher
	{
		/**
		 * 垂直布局
		 */
		public static const LAYOUT_VERTICAL:String = "layout_vertical";	
		/**
		 * 水平布局
		 */
		public static const LAYOUT_HORIZONTAL:String = "layout_horizontal";
		
		/**
		 * 按行列二维排列容器里的项,先从左到右，再从上到下排.<br/>
		 * 此方法能实现水平，垂直，流水所有这些有规律的布局
		 * 
		 * @param targetGroup 要排列布局的对象组
		 * @param perColNum 每列有x项,如果为0则一排,横排
		 * @param colWidth 每列的列宽,如果为0则按item的宽度自动排列,即列宽==项宽
		 * @param rowHeight 每列的列高度,如果为0则按item的高度自动向下排列,即行高==项高
		 
		protected static function layoutUtil(targetGroup:Object,perColNum:int=1,
											 colWidth:int=0,rowHeight:int=0,spacing:int=0):void
		{
			var tmpY:int=0,tmpX:int=0;
			var i:int = 0;
			var lineHeight:int;	//其中一行子项高度最高的项高
			for each (var dp:Object in targetGroup) 
			{
				if(i && !(i%perColNum) && perColNum!=0)
				{
					tmpY = tmpY + spacing + (rowHeight?rowHeight:lineHeight);
					tmpX = 0;
					lineHeight = dp.height;
				}
				dp.x = tmpX;
				tmpX = tmpX + (colWidth || dp.width) + spacing;
				dp.y = tmpY;
				if(dp.height>lineHeight)
					lineHeight = dp.height;
				i++;
			}
		}*/
		
		/**
		 * 构造
		 */
		public function LayoutClip()
		{
			super();
		}
		
		/**
		 * 设置布局方式,见本类上部枚举<br/>
		 * @param value
		 */
		public function setLayoutDirection(value:String):void
		{
			switch(value)
			{
				case LAYOUT_HORIZONTAL:
				{
					colNum = 0;
					break;
				}
				case LAYOUT_VERTICAL:
				{
					colNum = 1;
					break;
				}
			}
		}
		
		/**
		 * 布局显示对象
		 * @param targetGroup 要布局的对象组(子项必须要x,y,width,height属性)
		 */
		public function updateDisplayList(targetGroup:Object):void
		{
			if(!targetGroup)
				return;
			var tmpY:int=0,tmpX:int=0;
			var i:int = 0;
			
			if(_colNum == -1)
			{
				var cnum:int = width/(itemWidth + spacing);
				if(!cnum) cnum = 0;
			}
			else cnum = _colNum;
			
//			layoutUtil(targetGroup,cnum,itemWidth,itemHeight,spacing);
			SparrowUtil.layoutUtil(targetGroup,cnum,itemWidth,itemHeight,spacing);
			
			dispatchEvent(new ListEvent(ListEvent.LAYOUT_UPDATE));
		}
		
		/////////////////////////////////////////
		// set/get
		/////////////////////////////////////////
		
		private var _spacing:int;
		
		private var _itemHeight:int;
		private var _itemWidth:int;
		
		private var _width:int;
		private var _height:int;
		
		protected var _colNum:int = -1;

		/**
		 * 行列子项间隔
		 */
		public function get spacing():int
		{
			return _spacing;
		}

		/**
		 * @private
		 */
		public function set spacing(value:int):void
		{
			_spacing = value;
		}

		/**
		 * 子项高
		 */
		public function get itemHeight():int
		{
			return _itemHeight;
		}

		/**
		 * @private
		 */
		public function set itemHeight(value:int):void
		{
			_itemHeight = value;
		}

		/**
		 * 子项宽
		 */
		public function get itemWidth():int
		{
			return _itemWidth;
		}

		/**
		 * @private
		 */
		public function set itemWidth(value:int):void
		{
			_itemWidth = value;
		}

		/**
		 * 布局宽,当colNum==-1时，用于计算每列个数用
		 */
		public function get width():int
		{
			return _width;
		}

		/**
		 * @private
		 */
		public function set width(value:int):void
		{
			_width = value;
		}

		/**
		 * 布局高,当colNum==-1时，用于计算每列个数用
		 */
		public function get height():int
		{
			return _height;
		}

		/**
		 * @private
		 */
		public function set height(value:int):void
		{
			_height = value;
		}

		/**
		 * 每列有多少项,-1表示自动通过width和itemWidth计算每列个数
		 */
		public function get colNum():int
		{
			return _colNum;
		}

		/**
		 * @private
		 */
		public function set colNum(value:int):void
		{
			_colNum = value;
		}
	}
}
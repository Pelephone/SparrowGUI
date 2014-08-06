/*
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
* WITHOUT WARRANTIES 
*/
package sparrowGui.components.base
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import sparrowGui.event.ComponentEvent;
	import sparrowGui.uiStyle.UIStyleCss;
	import sparrowGui.utils.SparrowUtil;
	
	
	/**
	 * 基本组件
	 * @author Pelephone
	 */
	public class BaseComponent extends Sprite
	{
		public function BaseComponent(uiVars:Object=null)
		{
			super();
			buildSetUI(uiVars);
		}

		/**
		 * 创建默认UI皮肤,并设置样式
		 * @param uiVars
		 */
		public function buildSetUI(uiVars:Object=null):void
		{
			// 生成默认皮肤
			if(uiVars is DisplayObjectContainer)
			{
				var dc:DisplayObjectContainer = uiVars as DisplayObjectContainer;
				for (var i:int = 0; i < dc.numChildren; i++) 
				{
					addChild(dc.getChildAt(i));
				}
			}
			else if(uiVars is String)
				UIStyleCss.getInstance().createStyleSkin(String(uiVars),this);
			else if(uiVars == null)
				UIStyleCss.getInstance().createStyleSkin(defaultSkinId,this);
			else
			{
				for each (var itm:Object in uiVars) 
				{
					if(!itm is DisplayObject)
						continue;
					addChild(itm as DisplayObject);
				}
			}
		}
		
		/**
		 * 清除所有显示子项
		 */
		public function clearSkinChild():void
		{
			while(numChildren)
				removeChildAt(0);
		}
		
		/**
		 * 默认样式id
		 */
		public function get defaultSkinId():String
		{
			return "component";
		}

		/**
		 * 验证重绘,会在下帧渲染的时候调用draw方法
		 */
		public function invalidateDraw(args:*=null):void
		{
			SparrowUtil.addNextCall(draw);
		}
		
		/**
		 * 跟椐数据绘制组件(一般会结合下帧执行方法调用)
		 */
		protected function draw():void
		{
			dispatchEvent(new ComponentEvent(ComponentEvent.DRAW));
		}
		
		protected var _width:Number = 0;
		
		/**
		 * @inheritDoc
		 * 如果_width变量>0则返回_width,否则返回显示宽
		 */
		override public function get width():Number
		{
			if(_width > 0)
				return _width;
			else
				return super.width;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			if(_width > 0 && value > 0)
				_width = value;
			else
				super.width = value;
		}
		
		protected var _height:Number = 0;
		
		/**
		 * @inheritDoc
		 * 如果_height变量>0则返回_height,否则返回显示高
		 */
		override public function get height():Number
		{
			if(_height > 0)
				return _height;
			else
				return super.height;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			if(_height > 0 && value > 0)
				_height = value;
			else
				super.height = value;
		}
	}
}
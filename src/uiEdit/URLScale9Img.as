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
package uiEdit
{
	import bitmapEngine.Scale9GridBitmap;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import utils.tools.BitmapTool;
	
	
	/**
	 * 九切片链接图标
	 * @author Pelephone
	 */
	public class URLScale9Img extends Sprite
	{
		public function URLScale9Img()
		{
			super();
			
			bg.name = "bg";
			uiLoader.name = "uiLoader";
			uiLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onImgEvent);
//			uiLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onImgEvent);
		}
		
		private var _uitype:String;

		/**
		 * UI类型
		 */
		public function get uiType():String
		{
			return _uitype;
		}

		/**
		 * @private
		 */
		public function set uiType(value:String):void
		{
			if(_uitype == value)
				return;
			_uitype = value;
			if(_uitype == "scale9")
				isScale9 = true;
			else
				isScale9 = false;
			draw();
		}

		private var _bgSrc:String;

		/**
		 * 背景图片路径
		 */
		public function get bgSrc():String
		{
			if(tmpSrc)
				return tmpSrc;
			
			return _bgSrc;
		}

		/**
		 * @private
		 */
		public function set bgSrc(value:String):void
		{
			if(_bgSrc == value)
				return;
			_bgSrc = value;
			
			if(value)
			tmpSrc = value.replace(EditMgr.getInstance().rootPath,"");
			
			uiLoader.load(new URLRequest(value));
		}
		
		private var tmpSrc:String;

		public var isScale9:Boolean = false;
		
		//---------------------------------------------------
		// 加载显示
		//---------------------------------------------------
		
		public var bg:Scale9GridBitmap = new Scale9GridBitmap();
		
		public var uiLoader:Loader = new Loader();
		
		/**
		 * 图片加载完成
		 * @param e
		 */
		private function onImgEvent(e:Event = null):void
		{
			if(e.type == Event.COMPLETE)
			{
				var dx:int = uiLoader.content.width/3;
				var dy:int = uiLoader.content.height/3;
				var rect:Rectangle = new Rectangle(dx,dy,dx*2,dy*2);
				bg.scale9Grid = rect;
				if(uiLoader.content is Bitmap)
					bg.source = uiLoader.content;
				else
					bg.source = BitmapTool.toBitmap(uiLoader);
				_width = uiLoader.content.width;
				_height = uiLoader.content.height;
				oldWidth = _width;
				oldHeight = _height;
				draw();
			}
		}
		
		private var oldWidth:int;
		
		private var oldHeight:int;
		
		// 计算加载完成之后的图片
		private function draw():void
		{
			if(isScale9)
			{
				if(uiLoader.parent)
					uiLoader.parent.removeChild(uiLoader);
				addChild(bg);
			}
			else
			{
				if(bg.parent)
					bg.parent.removeChild(bg);
				addChild(uiLoader);
			}
			
			bg.width = _width;
			bg.height = _height;
			
			uiLoader.width = _width;
			uiLoader.height = _height;
		}
		
		private var _width:Number;

		override public function get width():Number
		{
			if(_width == 0)
				return super.width;
			return _width;
		}

		override public function set width(value:Number):void
		{
			if(_width == value)
				return;
			_width = value;
			draw();
		}

		
		private var _height:Number = 0;

		override public function get height():Number
		{
			if(_height == 0)
				return super.height;
			return _height;
		}

		override public function set height(value:Number):void
		{
			if(_height == value)
				return;
			_height = value;
			draw();
		}

		override public function get scaleX():Number
		{
			if(oldWidth>0)
				return width/oldWidth;
			else
				return super.scaleX;
		}

		override public function set scaleX(value:Number):void
		{
			width = oldWidth*value;
		}

		override public function get scaleY():Number
		{
			if(oldHeight>0)
				return height/oldHeight;
			else
				return super.scaleY;
		}

		override public function set scaleY(value:Number):void
		{
			height = oldHeight*value;
		}
	}
}
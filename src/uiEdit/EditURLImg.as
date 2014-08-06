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
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	
	/**
	 * 通过链接路径获显示图片
	 * @author Pelephone
	 */
	public class EditURLImg extends Sprite
	{
		public function EditURLImg()
		{
			super();
			
			ul = new Loader();
			ul.contentLoaderInfo.addEventListener(Event.COMPLETE,onImgComplete);
			ul.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onErrHandler);
			addChild(ul);
			
			mouseChildren = false;
		}
		
		private function onErrHandler(event:IOErrorEvent=null):void
		{
			/*var dsp:DisplayObject = getChildByName("dsp");
			if(dsp)
				removeChild(dsp);*/
		}
		
		/**
		 * 是否居中对齐
		 */
		public var isMidXY:Boolean = true;
		
		private function onImgComplete(event:Event = null):void
		{
			/*var dsp:DisplayObject = ul.content;
			if(dsp)
			{
				dsp.name = "dsp";
				addChild(dsp);
			}*/
			
			var preImg:DisplayObject = this;
			preImg.scaleX = preImg.scaleY = 1;
			var padding:int = 2;
			var bw:int = bWidth - padding;
			var bh:int = bHeight - padding;
			
			var brect:Rectangle = preImg.getBounds(preImg);
			
			var oddW:Number = preImg.width/bw;
			var oddH:Number = preImg.height/bh;
			
			if(oddW>1 || oddH>1)
			{
				if(oddW>oddH)
				{
					preImg.width = bw;
					preImg.scaleY = preImg.scaleX;
				}
				else
				{
					preImg.height = bh;
					preImg.scaleX = preImg.scaleY;
				}
				
			}
			
			if(isMidXY)
			{
				preImg.x = bWidth*0.5 - preImg.width*0.5;
				preImg.y = bHeight*0.5 - preImg.height*0.5;
			}
		}
		
		
		private var ul:Loader;
		
		private var _src:String;

		public function get src():String
		{
			return _src;
		}

		public function set src(value:String):void
		{
			if(_src == value)
				return;
			_src = value;
			ul.load(new URLRequest(src));
		}
		
		/**
		 * 加载完毕之后自动缩放适合的大小
		 
		private var autoScale:Boolean = true;*/
		
		public var bWidth:int;
		
		public var bHeight:int;
	}
}
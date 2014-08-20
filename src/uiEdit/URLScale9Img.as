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
	import asSkinStyle.ReflPositionInfo;
	
	import bitmapEngine.Scale9GridBitmap;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import utils.tools.BitmapTool;
	
	
	/**
	 * 九切片链接图标
	 * @author Pelephone
	 */
	public dynamic class URLScale9Img extends Sprite
	{
		public function URLScale9Img()
		{
			super();
			
			bg.name = "bg";
			uiLoader.name = "uiLoader";
			uiLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onImgEvent);
			uiLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onImgEvent);
			dLoader.addEventListener(Event.COMPLETE,onDataLoadComplete);
			dLoader.addEventListener(IOErrorEvent.IO_ERROR,onDataLoadComplete);
			
			labelLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLabelComplete);
			labelLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLabelComplete);
			addChild(labelLoader);
			
			this.mouseChildren = false;
			this.mouseEnabled = true;
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
			if(_uitype == "scale9" || _uitype == "button2")
				isScale9 = true;
			else
				isScale9 = false;
			draw();
		}

		public var _bgSrc:String;

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
			
			if(value == null || value.length == 0)
			{
				return;
			}
			
			var eMgr:EditMgr = EditMgr.getInstance();
			tmpSrc = value.replace(/\\/g,"/");
			tmpSrc = tmpSrc.replace(eMgr.rootPath,"");
			
			var r:String = eMgr.rootPath;
			if(!eMgr.useRootPath || tmpSrc.indexOf(":/")>=0)
				r = "";
			var u2:String = r + tmpSrc;
			var ur:URLRequest = new URLRequest(u2);
			if(uiType == "custom")
				dLoader.load(ur);
			else
				uiLoader.load(ur);
		}
		
		private var tmpSrc:String;
		
		public var isScale9:Boolean = false;
		
		private function onDataLoadComplete(e:Event):void
		{
			if(e.type == Event.COMPLETE)
			{
				if(uiLoader.parent)
					uiLoader.parent.removeChild(uiLoader);
				if(bg.parent)
					bg.parent.removeChild(bg);
				
				var deXml:XML = XML(dLoader.data);
				var itemX:Object;
				for each (itemX in deXml.children()) 
				{
					ReflPositionInfo.decodeXmlToChild(this,itemX);
				}
			}
			else
				trace(_bgSrc + "加载错误");
		}
		
		//---------------------------------------------------
		// 标签文字
		//---------------------------------------------------
		
		private var _labelNormal:String;
		
		public function get labelNormal():String
		{
			return _labelNormal;
		}
		
		public function set labelNormal(value:String):void
		{
			if(_labelNormal == value)
				return;
			_labelNormal = value;
		}
		
		private var labelLoader:Loader = new Loader();
		
		private function onLabelComplete(event:Event=null):void
		{
			if(Event.COMPLETE)
			{
				labelLoader.x = width * 0.5 - labelLoader.width * 0.5;
				labelLoader.y = height * 0.5 - labelLoader.height * 0.5;
			}
			else
				trace(_labelNormal + "加载失败");
		}
		
		private var _label:String = null;

		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			if(_label == value)
				return;
			
			_label = value;
			showTxt();
		}
		
		private function showTxt():void
		{
			if(!txt && _label!=null)
			{
				txt = new TextField();
				txt.autoSize = TextFieldAutoSize.LEFT;
				addChild(txt);
			}
			if(!txt)
				return;
			txt.text = _label;
			txt.x = width*0.5 - txt.width*0.5;
			txt.y = height*0.5 - txt.height*0.5;
		}

		private var txt:TextField;
		
		//---------------------------------------------------
		// 加载显示
		//---------------------------------------------------
		
		public var bg:Scale9GridBitmap = new Scale9GridBitmap();
		
		public var uiLoader:Loader = new Loader();
		private var dLoader:URLLoader = new URLLoader();
		
		/**
		 * 图片加载完成
		 * @param e
		 */
		private function onImgEvent(e:Event):void
		{
			if(e.type == Event.COMPLETE)
			{
				var dx:int = uiLoader.content.width/3;
				var dy:int = uiLoader.content.height/3;
				var rect:Rectangle = new Rectangle(dx,dy,dx,dy);
				bg.scale9Grid = rect;
				if(uiLoader.content is Bitmap)
					bg.source = uiLoader.content;
				else
					bg.source = BitmapTool.toBitmap(uiLoader);
//				_width = uiLoader.content.width;
//				_height = uiLoader.content.height;
				oldWidth = uiLoader.content.width;
				oldHeight = uiLoader.content.height;
				
				if(_labelNormal != null)
				{
					var eMgr:EditMgr = EditMgr.getInstance();
					var r:String = eMgr.rootPath;
					if(!eMgr.useRootPath)
						r = "";
					labelLoader.load(new URLRequest(r + _labelNormal));
				}
				draw();
			}
			else
				trace(bgSrc + "加载错误");
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
				addChildAt(bg,0);
			}
			else
			{
				if(bg.parent)
					bg.parent.removeChild(bg);
				addChildAt(uiLoader,0);
			}
			
			if(_width>0)
				bg.width = _width;
			if(_height>0)
				bg.height = _height;
			
			if(uiLoader.content)
			{
				if(_width > 0)
					uiLoader.content.width = _width;
				if(_height > 0)
					uiLoader.content.height = _height;
			}
			
			onLabelComplete();
			showTxt();
		}
		
		private var _width:Number = 0;

		override public function get width():Number
		{
			if(_width == 0)
			{
				if(bg.width>0)
					return bg.width;
				else if(uiLoader.content && uiLoader.content.width>0)
					return uiLoader.content.width;
				else
					return super.width;
			}
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
			{
				
				if(bg.height>0)
					return bg.height;
				else if(uiLoader.content && uiLoader.content.height>0)
					return uiLoader.content.height;
				else
				return super.height;
			}
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
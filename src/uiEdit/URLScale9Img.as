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
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import TimerUtils.FrameTimer;
	
	import asSkinStyle.ReflPositionInfo;
	
	import bitmapEngine.Scale9GridBitmap;
	
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
			
			this.mouseChildren = false;
			this.mouseEnabled = true;
		}
		
		override public function set name(value:String):void
		{
			super.name = value;
		}
		
		private var uLs:UIList = null;
		
		private var _uitype:String;
		// 创建宽高属性
		public var doWH:Boolean = false;

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
			
			bg.visible = false;
			uiLoader.visible = false;
			if(txt)
			txt.visible = false;
			if(resSp)
			resSp.visible = false;
			if(uLs)
			uLs.visible = false;
			labelLoader.visible = false;

			doWH = false;
			isScale9 = false;
			
			_uitype = value;
			if(_uitype == "scale9" || _uitype == "button2" || _uitype == "progress")
			{
				if(_uitype == "button2")
				{
					addChild(labelLoader);
					labelLoader.visible = true;
				}
				
				doWH = true;
				bg.visible = true;
				uiLoader.visible = true;
				isScale9 = true;
			}
			else if(_uitype == "text")
			{
				if(!txt)
				{
					txt = new TextField();
					txt.text = "这是系统字";
					txt.border = true;
					txt.borderColor = 0x00FF00;
					addChild(txt);
				}
				doWH = true;
				txt.visible = true;
			}
			else if(_uitype == "resText")
			{
				if(!resSp)
				{
					resSp = new Sprite()
					addChild(resSp);
				}
				resSp.visible = true
			}
			else if(_uitype == "list")
			{
				if(!uLs)
				{
					uLs = new UIList();
					uLs.name = "uLs";
					addChild(uLs);
				}
				uLs.visible = true;
				doWH = true;
			}
			else
			{
				bg.visible = true;
				uiLoader.visible = true;
			}
			
			draw();
		}

		public var _bgSrc:String;

		/**
		 * 背景图片路径
		 */
		public function get bgSrc():String
		{
			if(uiType == "text")
				return null;
			
			if(uiType == "resText")
				return linkageVars;
			
			if(tmpSrc)
				return tmpSrc;
			
			return _bgSrc;
		}
		
		public var linkageVars:String;

		/**
		 * @private
		 */
		public function set bgSrc(value:String):void
		{
			if(_bgSrc == value)
				return;
			_bgSrc = value;
			bg.name = value;
			
			var str2:String = value.replace("_0.png","_$1.png");
			linkageVars = str2;
			
			if(uiType == "resText")
			{
				_label = "0";
				showTxt();
				return;
			}
			else if(uiType == "list")
			{
				uLs.bgSrc = value;
				return;
			}
			
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
		
		private var _labelNormal:String = null;
		
		public function get labelNormal():String
		{
			if(uiType != "resText" && uiType != "button2")
				return null;
			return _labelNormal;
		}
		
		public function set labelNormal(value:String):void
		{
			if(_labelNormal == value)
				return;
			if(uiType == "resText")
			{
				label = value;
				return;
			}
			if(uiType != "button2")
				return;
			_labelNormal = value;
			
			if(_labelNormal != null)
			{
				var eMgr:EditMgr = EditMgr.getInstance();
				var r:String = eMgr.rootPath;
				if(!eMgr.useRootPath)
					r = "";
				labelLoader.load(new URLRequest(r + _labelNormal));
			}
		}
		
		private var labelLoader:Loader = new Loader();
		
		private function onLabelComplete(event:Event=null):void
		{
			if(!labelLoader || !labelLoader.visible)
			{
				return;
			}
			if(!delayLabel)
			{
				delayLabel = new FrameTimer();
				delayLabel.addEventListener(TimerEvent.TIMER_COMPLETE,onLabelPosi);
			}
			delayLabel.restart(1000,1);
		}
		
		private function onLabelPosi(e:TimerEvent):void
		{
			labelLoader.x = width * 0.5 - labelLoader.width * 0.5;
			labelLoader.y = height * 0.5 - labelLoader.height * 0.5;
		}
		
		private var delayLabel:FrameTimer = null;
		
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
		
		private var txtNum:int = 0;
		
		private function showTxt():void
		{
			if(uiType == "resText")
			{
				var eMgr:EditMgr = EditMgr.getInstance();
				if(_label == null || _label.length == 0)
					return;
				clearResText();
				txtNum = _label.length;
				for (var i:int = 0; i < _label.length; i++) 
				{
					var ld:Loader = new Loader();
					ld.contentLoaderInfo.addEventListener(Event.COMPLETE,onTxtBmpEvt);
					ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onTxtBmpEvt);
					var r:String = eMgr.rootPath;
					tmpSrc = linkageVars.replace("$1",_label.charAt(i));
					tmpSrc = tmpSrc.replace(/\\/g,"/");
					tmpSrc = tmpSrc.replace(eMgr.rootPath,"");
					if(!eMgr.useRootPath || tmpSrc.indexOf(":/")>=0)
						r = "";
					var u2:String = r + linkageVars.replace("$1",_label.charAt(i));
					ld.load(new URLRequest(u2));
					resSp.addChild(ld);
				}
				
				return;
			}
			
			if(!txt)
				return;
			if(_label != null)
			{
				txt.text = _label;
				txt.x = width*0.5 - txt.width*0.5;
				txt.y = height*0.5 - txt.height*0.5;
			}
		}
		
		public var itemWidth:int = 0;
		
		private var resSp:Sprite = null;
		
		private function onTxtBmpEvt(e:Event):void
		{
			var tar:LoaderInfo = e.currentTarget as LoaderInfo;
			tar.removeEventListener(Event.COMPLETE,onTxtBmpEvt);
			tar.removeEventListener(IOErrorEvent.IO_ERROR,onTxtBmpEvt);
			txtNum = txtNum - 1;
			if(txtNum <= 0)
			{
				var lastX:int = 0;
				for (var i:int = 0; i < resSp.numChildren; i++) 
				{
					var dsp:DisplayObject = resSp.getChildAt(i);
					dsp.x = lastX;
					lastX = (itemWidth>0)?(lastX + itemWidth):(lastX + dsp.width);
				}
			}
		}
		
		private function clearResText():void
		{
			for (var i:int = 0; i < resSp.numChildren; i++) 
			{
				var dsp:DisplayObject = resSp.getChildAt(i);
				if(dsp.loaderInfo)
				{
					dsp.loaderInfo.removeEventListener(Event.COMPLETE,onTxtBmpEvt);
					dsp.loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onTxtBmpEvt);
				}
			}
			resSp.removeChildren();
			txtNum = 0;
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
			{
				bg.width = _width;
				if(uLs)
					uLs.width = _width;
				if(txt && txt.visible)
					txt.width = _width;
					
			}
			if(_height>0)
			{
				bg.height = _height;
				if(uLs)
					uLs.height = _height;
				if(txt && txt.visible)
					txt.height = _height;
			}
			
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
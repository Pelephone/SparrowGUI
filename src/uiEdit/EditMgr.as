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
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import sparrowGui.SparrowMgr;
	import sparrowGui.components.base.BaseTip;
	
	/** 扫描文件加载完成 */
	[Event(name="SCAN_COMPLETE", type="uiEdit.EditMgr")]
	/** 配置加载完成 */
	[Event(name="CFG_COMPLETE", type="uiEdit.EditMgr")]
	/** 拖动元素选中 */
	[Event(name="DRAG_LIB_DOWN", type="uiEdit.EditMgr")]
	/** 显示输出信息 */
	[Event(name="SHOW_OUT_INFO", type="uiEdit.EditMgr")]
	/** 反向文件保存完毕 */
	[Event(name="DECODE_SAVE_COMPLETE", type="uiEdit.EditMgr")]
	/** 加载完反向文件 */
	[Event(name="DECODE_LOAD_COMPLETE", type="uiEdit.EditMgr")]
	
	
	/**
	 * 数据
	 * @author Pelephone
	 */
	public class EditMgr extends EventDispatcher
	{
		/**
		 * 扫描文件加载完成
		 */
		public static const SCAN_COMPLETE:String = "SCAN_COMPLETE";
		
		/** 配置加载完成 */
		public static const CFG_COMPLETE:String = "CFG_COMPLETE";
		
		/** 拖动元素选中 */
		public static const DRAG_LIB_DOWN:String = "DRAG_LIB_DOWN";
		
		/** 显示输出信息 */
		public static const SHOW_OUT_INFO:String = "SHOW_OUT_INFO";
		/** 反向文件保存完毕  */
		public static const DECODE_SAVE_COMPLETE:String = "DECODE_SAVE_COMPLETE";
		/** 加载完反向文件 */
		public static const DECODE_LOAD_COMPLETE:String = "DECODE_LOAD_COMPLETE";
		
		
		
		public function EditMgr()
		{
			if(instance)
				throw new Error("EditModel is singleton class and allready exists!");
			
			init();
			instance = this;
		}
		
		/**
		 * 单例
		 */
		private static var instance:EditMgr;
		/**
		 * 获取单例
		 */
		public static function getInstance():EditMgr
		{
			if(!instance)
				instance = new EditMgr();
			
			return instance;
		}
		
		private function init():void
		{
			searchKeyLs = new <String>["all","key1"];
			uiTypeLs = new <String>["img","scale9"];
			
			curDragDsp.isMidXY = false;
			curDragDsp.bHeight = 200;
			curDragDsp.bWidth = 200;
			curDragDsp.mouseChildren = false;
			curDragDsp.mouseEnabled = true;
			
			scanLoader.addEventListener(Event.COMPLETE,onScanEvent);
			scanLoader.addEventListener(IOErrorEvent.IO_ERROR,onScanEvent);
			
			cfgLoader.addEventListener(Event.COMPLETE,onCfgEvt);
			cfgLoader.addEventListener(IOErrorEvent.IO_ERROR,onCfgEvt);
			
			skinCfgLoader.addEventListener(Event.COMPLETE,onSkinCfgEvent);
			skinCfgLoader.addEventListener(IOErrorEvent.IO_ERROR,onSkinCfgEvent);
			
			fileCfg.addEventListener(Event.COMPLETE,onFileSaveEvent);
			fileCfg.addEventListener(Event.CANCEL,onFileSaveEvent);
			
			langLoader.addEventListener(Event.COMPLETE,onLangComplete);
		}
		
		private function onLangComplete(event:Event):void
		{
			var str:String = String(langLoader.data);
			var ary:Array = str.split("\n");
			var itStr:String;
			for each (itStr in ary) 
			{
				if(itStr.charAt(0) == "#")
					continue;
				var ary2:Array = itStr.split("=");
				if(ary2.length<2)
					continue;
				var val:String = String(ary2[1]).replace("\r","");
				ReflPositionInfo.langMap[ary2[0]] = ary2[1];
			}
		}
		
		public var langObj:Object = {};
		
		private var langLoader:URLLoader = new URLLoader();
		
		/**
		 * 扫描关键词
		 */
		public var searchKeyLs:Vector.<String>;
		/**
		 * ui类型
		 */
		public var uiTypeLs:Vector.<String>;
		
		
		//---------------------------------------------------
		// 加载配置
		//---------------------------------------------------
		
		private var cfgLoader:URLLoader = new URLLoader();
		
		public var cfgData:*;
		
		public var showKey:int = 84;
		
		/**
		 * 解析方式，0,解析xml; 1,解析成as的数组格式; 2,解析json;
		 */
		public var parseMode:int;
		
		/**
		 * 皮肤路径地址
		 */
		public var skinCfgPath:String = "assets/skinCfg/$1.xml";
		
		/**
		 * 是否可编辑子项
		 */
		public var isChild:Boolean = false;
		/**
		 * 是否调用内置反向代码
		 */
		public var isAutoDecode:Boolean = true;
		
		/**
		 * 加载一次配置信息
		 */
		public function loadCfg():void
		{
			var urlLd:URLRequest = new URLRequest("editCfg.xml?random=" + int(Math.random()*1000));
			cfgLoader.load(urlLd);
			
			langLoader.load(new URLRequest("lang.txt?random=" + int(Math.random()*1000)));
		}
		
		/**
		 * 是否用根路径
		 */
		public var useRootPath:Boolean = true;
		
		private function onCfgEvt(event:Event):void
		{
			if(event.type == Event.COMPLETE)
			{
				cfgData = cfgLoader.data;
				var xml:XML = XML(cfgLoader.data);
				parseMode = int(xml.parseMode);
				ReflPositionInfo.IS_NEAR = String(xml.IS_NEAR) != "0";
				ReflPositionInfo.INIT_ATTR_LS = Vector.<String>(String(xml.INIT_ATTR_LS).split(","));
				ReflPositionInfo.REF_ATTR_LS = Vector.<String>(String(xml.REF_ATTR_LS).split(","));
				ReflPositionInfo.IS_DO_DEFAULT = int(xml.IS_DO_DEFAULT) == 1;
				ReflPositionInfo.isAttrCode = int(xml.isAttrCode) == 0;
				ReflPositionInfo.isCreateChild = String(xml.isCreateChild) != "0";
				ReflPositionInfo.isChangeValue = String(xml.isChangeValue) != "0";
				
				useRootPath = String(xml.useRootPath) != "0";
				
				UIEditor.VAR_STRING = String(xml.var_tpl);
				UIEditor.VAR_DO_STRING = String(xml.var_tpl2);
				
				skinCfgPath = String(xml.skinCfgPath);
				
				if(int(xml.showKey)!=0)
				showKey = int(xml.showKey);
				isChild = int(xml.isChild) == 1;
				isAutoDecode = String(xml.isAutoDecode) != "0";
				
				searchKeyLs = Vector.<String>(String(xml.searchKeyLs).split(","));
				uiTypeLs = Vector.<String>(String(xml.uiTypeLs).split(","));
				
				loadScanFille(String(xml.scanFile));
				
				sendModelNote(EditMgr.CFG_COMPLETE);
				
				var istr:String;
				for each (istr in uiTypeLs) 
				{
					if(istr == "text")
						ReflPositionInfo.regRefValue(istr,UIText);
					else
						ReflPositionInfo.regRefValue(istr,URLScale9Img);
				}
			}
			else if(event.type == IOErrorEvent.IO_ERROR)
			{
			}
		}
		
		//---------------------------------------------------
		// 扫描文件加载
		//---------------------------------------------------
		
		/**
		 * 扫描文件所以目录做为根路径
		 */
		public var rootPath:String;
		
		// 扫描文件路径
		private var scanFileSrc:String;
		
		// 扫描文件加载器
		private var scanLoader:URLLoader = new URLLoader();
		
		/**
		 * 加载扫描
		 */
		private function loadScanFille(src:String):void
		{
			if(scanFileSrc == src)
				return;
			scanFileSrc = src;
			var tid:int = src.lastIndexOf("/");
			if(tid>0)
				rootPath = src.substring(0,(tid+1));
			else
				rootPath = src;

			var urlLd:URLRequest = new URLRequest(src + "?random=" + int(Math.random()*1000));
			scanLoader.load(urlLd);
		}
		
		/**
		 * 扫描结果
		 */
		public var scanLs:Vector.<String>;
		
		// 扫描文件加载事件
		private function onScanEvent(event:Event):void
		{
			switch(event.type)
			{
				case Event.COMPLETE:
				{
					// 角色扫描文件
					scanLs = new Vector.<String>();
					var str:String = scanLoader.data;
					scanLs = Vector.<String>(str.split("\n"));
					sendModelNote(EditMgr.SCAN_COMPLETE);
					break;
				}
					
				default:
				{
					trace("扫描文件加载错误");
					break;
				}
			}
		}
		
		//---------------------------------------------------
		// 拖库元素
		//---------------------------------------------------
		
		private var _dragLibSrc:String;

		/**
		 * 拖动库元件对象的src
		 */
		public function get dragLibSrc():String
		{
			return _dragLibSrc;
		}

		/**
		 * @private
		 */
		public function set dragLibSrc(value:String):void
		{
			if(!(editTarget is DisplayObjectContainer))
			{
				removeDrag();
				sendModelNote(SHOW_OUT_INFO,"未选中可添加子项的容器");
				return;
			}
			if(_dragLibSrc == value)
				return;
			_dragLibSrc = value;
			curDragDsp.src = value;
			if(value)
			{
				SparrowMgr.mainDisp.addChild(curDragDsp);
				curDragDsp.x = curDragDsp.parent.mouseX;
				curDragDsp.y = curDragDsp.parent.mouseY;
				var stg:DisplayObject = SparrowMgr.mainDisp.stage;
				stg.addEventListener(MouseEvent.MOUSE_MOVE,onNavEvent);
				stg.addEventListener(Event.MOUSE_LEAVE,onNavEvent);
				stg.addEventListener(MouseEvent.MOUSE_UP,onNavEvent);
			}
			else 
			{
				removeDrag();
			}
			
			sendModelNote(EditMgr.DRAG_LIB_DOWN);
		}
		
		private function removeDrag():void
		{
			if(curDragDsp.parent)
				curDragDsp.parent.removeChild(curDragDsp);
			
			var stg:DisplayObject = SparrowMgr.mainDisp.stage;
			stg.removeEventListener(MouseEvent.MOUSE_MOVE,onNavEvent);
			stg.removeEventListener(Event.MOUSE_LEAVE,onNavEvent);
			stg.removeEventListener(MouseEvent.MOUSE_UP,onNavEvent);
			_dragLibSrc = null;
		}
		
		// 拖动元件事件
		private function onNavEvent(e:Event):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_MOVE:
				{
					curDragDsp.x = curDragDsp.parent.mouseX;
					curDragDsp.y = curDragDsp.parent.mouseY;
					
					break;
				}
				case MouseEvent.MOUSE_UP:
				{
					if(!isInEditPanel(e.target as DisplayObject))
					{
						var dspc:DisplayObjectContainer = editTarget as DisplayObjectContainer;
						var child:URLScale9Img = new URLScale9Img();
						child.uiType = "img";
						child.bgSrc = curDragDsp.src;
						var pt:Point = dspc.globalToLocal(new Point(curDragDsp.x,curDragDsp.y));
						child.x = pt.x;
						child.y = pt.y;
						dspc.addChild(child);
						
						var outSrc:String = child.bgSrc.replace(rootPath,"");
						dspc.stage.dispatchEvent(new EditEvent("dragLibObject",[outSrc,child,cfgData]));
					}
				}
				default:
				{
					removeDrag();
					break;
				}
			}
		}
		
		public var curDragDsp:EditURLImg = new EditURLImg();
		
		public var uiEditView:UIEditor;
		
		/**
		 * 按下对象是否在编辑面板
		 */
		public function isInEditPanel(tar:DisplayObject):Boolean
		{
			var isIn:Boolean = isTargetInPanel(tar,uiEditView);
			if(isIn)
				return true;
			isIn = isTargetInPanel(tar,uiEditView.navView);
			if(isIn)
				return true;
			return false;
		}
		
		/**
		 * 判断对象是否在这个面板里面
		 */
		public function isTargetInPanel(target:DisplayObject,thisPanel:DisplayObject=null):Boolean
		{
			if(thisPanel == null)
				thisPanel = uiEditView;
			var upPanel:DisplayObject = target;
			while(upPanel)
			{
				if(upPanel == thisPanel || upPanel is BaseTip)
				{
					return true;
				}
				upPanel = upPanel.parent;
			}
			return false;
		}
		
		//---------------------------------------------------
		// 编辑元素
		//---------------------------------------------------
		
		private var _editTarget:DisplayObject;
		
		// 对象原来的滤镜
		private var targetOldFilters:Array;
		
		// 选中时的发光滤镜
		private static var glowFilter:Array = [new GlowFilter(0xFF0000,1,2,2,1)];
		
		/**
		 * 当前正在编辑的对象
		 */
		public function get editTarget():DisplayObject
		{
			return _editTarget;
		}
		
		/**
		 * @private
		 */
		public function set editTarget(value:DisplayObject):void
		{
			if(value == _editTarget)
				return;
			
			if(value is Stage)
				value = null;
			
			if(_editTarget)
				_editTarget.filters = targetOldFilters;
			
			_editTarget = value;
			
			if(value)
			{
				targetOldFilters = value.filters;
				_editTarget.filters = glowFilter;
			}
		}

		//---------------------------------------------------
		// 保存文件
		//---------------------------------------------------
		
		private var skinCfgLoader:URLLoader = new URLLoader();
		
		private var saveData:String;
		
		private var saveName:String;
		
		private var fileCfg:FileReference = new FileReference();
		
		/**
		 * 将str数据保存到配置文件路径
		 * 1.加载指定路径文件，存在则取出xml.auto部份进行覆盖
		 * 2.如果指定路径无文件则添加新文件
		 */
		public function saveFileToSkinCfg(str:String,path:String):void
		{
			saveData = str;
			var tid:int = path.lastIndexOf("/");
			if(tid>0)
				saveName = path.substring(tid+1);
			else
				saveName = path;
			skinCfgLoader.load(new URLRequest(path));
		}
		
		private function onFileSaveEvent(e:Event):void
		{
			sendModelNote(DECODE_SAVE_COMPLETE);
		}
		
		// 配置文件事件
		private function onSkinCfgEvent(e:Event):void
		{
			var d:ByteArray = new ByteArray();
			var xml:XML = XML(skinCfgLoader.data);
			// 解析xml
			if(parseMode == 0 && e.type == Event.COMPLETE)
			{
				delete xml.deCode;
				var x2:XML = XML(saveData);
//				xml.appendChild(x2);
				if(xml.children().length()<=0)
					xml.appendChild(x2);
				else
					xml.insertChildBefore(xml.children()[0],x2);
					
				
				d.writeUTFBytes(xml);
				saveStr = String(xml);
				fileCfg.save(d,saveName);
			}
			else
			{
				xml = XML(<root/>);
				x2 = XML(saveData);
				xml.appendChild(x2);
				d.writeUTFBytes(xml);
				saveStr = xml;
				fileCfg.save(d,saveName);
			}
			System.setClipboard(saveStr);
			sendModelNote(EditMgr.DECODE_LOAD_COMPLETE);
		}
		
		/**
		 * 保存的数据文字
		 */
		public var saveStr:String;
		
		public function sendModelNote(type:String,data:Object=null):void
		{
			dispatchEvent(new EditEvent(type,data));
		}
	}
}
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
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.getQualifiedClassName;
	
	import asSkinStyle.ReflPositionInfo;
	
	import sparrowGui.SparrowMgr;
	import sparrowGui.components.SButtonText;
	import sparrowGui.components.SCombobox;
	import sparrowGui.components.STextField;
	import sparrowGui.components.SWindow;
	import sparrowGui.components.ScrollList;
	import sparrowGui.components.item.SCheckButton;
	import sparrowGui.components.item.SListItem;
	import sparrowGui.components.item.SToggleButton;
	import sparrowGui.event.ItemEvent;
	import sparrowGui.event.ListEvent;
	import sparrowGui.utils.SparrowUtil;
	
	import utils.tools.DisplayTool;
	
	/**
	 * UI编辑控制器,可对场景上的UI对象进行调整坐标等属性
	 * 键盘ctrl+1,2,3,4分别带表界面上四个按钮点击的效果。
	 * 键盘上下左右键可调节选中对象的x,y坐标；+-键可调节选中对象的长宽
	 * delete 删除单个子项

	 * shrit + \ 重新开始这份配置
	 * ctrl + alt + E/D，通过当前项的父类选上一个/下一个UI对象
	 * ctrl + alt + C 列出所有子项
	 * ctrl + alt + T 移除容器所有子项
	 * ctrl + alt + R 清空容器后立刻反向一次代码
	 * ctrl + alt 上下 向上向下元素换位置
	 
	 * wr2 + "子项代码"：生成文件到skinCfgPath对应的路径
	 * wr:$1 + "子项代码"：生成文件到$1对应的路径
	 * call + "子项"：列出当前对象的所有子项供选择(或者ctrl+c快捷键)
	 * src:$1 + "反向代码":读取$1路径的内容显示反向代码
	 * src2 + "反向代码"：读取skinCfgPath对应的路径反向代码(或者ctrl+9快捷键)
	 * clear + "删除元素"：清选中容器下的所有对象
	 * @author Pelephone
	 */
	public class UIEditor extends SWindow
	{
		public function UIEditor()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE,onThisToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onThisToStage);
		}
		
		/**
		 * 解析方式 0.xml解析 1.json解析
		 */
		public var parseMode:int = 0;
		
		//
		private var cbMode:SCheckButton;
		private var txtXYLabel:STextField;
		private var txtLabel1:STextField;
		private var txtWHLabel:STextField;
		private var txtLabel2:STextField;
		private var btnFather:SButtonText;
		private var btnDeCode:SButtonText;
		private var btnChild:SButtonText;
		private var btnCode:SButtonText;
		private var btnVar:SButtonText;
		private var txtTip:STextField;
		private var txtInput:STextField;
		private var txtX:STextField;
		private var txtY:STextField;
		private var txtWidth:STextField;
		private var txtHeight:STextField;
		private var txtName:STextField;
		
		
		// 子项模式对象
		private var childModeSP:Sprite;
		// ui类型
		private var labelUIType:STextField;
		private var cbUIType:SCombobox;
		// 背景图信息
		private var labelBgSrc:STextField;
		private var txtBgSrc:STextField;
		// 移除元素
		private var btnRemove:SButtonText;
		
		// 编辑模式切换
		private var btnEditMode:SToggleButton;
		
		/**
		 * 选中点下子项列表
		 */
		private var underPointLs:ScrollList;
		
		/**
		 * @inheritDoc
		 */
		override protected function buildSetUI(uiVars:Object=null):void
		{
			width = 380;
			height = 238;
			var padding:int = 5;
			
			var btnAry:Array = [];
			
			super.buildSetUI(uiVars);

			var tfm:TextFormat;
			// 代码生成于:ui.fla>编辑场景对象面板
			
			// 设置属性
			
			cbMode = new SCheckButton();
			cbMode.name = "cbMode";
			cbMode.x = 225;
			cbMode.y = 8;
			contDP.addChild(cbMode);
			
			btnEditMode = new SToggleButton();
			btnEditMode.name = "btnEditMode";
			btnEditMode.y = 5;
			btnEditMode.x = 308;
			btnEditMode.width = 60;
			btnEditMode.data = "编辑子项";
			contDP.addChild(btnEditMode);
			
			// x×y:
			txtXYLabel = new STextField();
			txtXYLabel.name = "txtXYLabel";
			txtXYLabel.x = padding;
			txtXYLabel.y = 33;
			txtXYLabel.selectable = false;
			txtXYLabel.width = 30;
			txtXYLabel.height = 22;
			contDP.addChild(txtXYLabel);
			
			// ×
			txtLabel1 = new STextField();
			txtLabel1.name = "txtLabel1";
			txtLabel1.x = 74;
			txtLabel1.y = 34;
			txtLabel1.selectable = false;
			txtLabel1.width = 26;
			txtLabel1.height = 22;
			tfm = new TextFormat();
			tfm.align = TextFormatAlign.CENTER;
			tfm.size = 12;
			txtLabel1.defaultTextFormat = tfm;
			contDP.addChild(txtLabel1);
			
			// 宽×高:
			txtWHLabel = new STextField();
			txtWHLabel.name = "txtWHLabel";
			txtWHLabel.x = 150;
			txtWHLabel.y = 33;
			txtWHLabel.selectable = false;
			txtWHLabel.width = 48;
			txtWHLabel.height = 22;
			contDP.addChild(txtWHLabel);
			
			// ×
			txtLabel2 = new STextField();
			txtLabel2.name = "txtLabel2";
			txtLabel2.x = 225.95;
			txtLabel2.y = 34;
			txtLabel2.selectable = false;
			txtLabel2.width = 26;
			txtLabel2.height = 22;
			tfm = new TextFormat();
			tfm.align = TextFormatAlign.CENTER;
			tfm.size = 12;
			txtLabel2.defaultTextFormat = tfm;
			contDP.addChild(txtLabel2);
			
			btnFather = new SButtonText();
			btnFather.name = "btnFather";
			btnFather.x = padding;
			btnFather.y = 148;
			contDP.addChild(btnFather);
			btnAry.push(btnFather);
			
			btnChild = new SButtonText();
			btnChild.name = "btnChild";
			btnChild.x = 75;
			btnChild.y = 148;
			contDP.addChild(btnChild);
			btnAry.push(btnChild);
			
			btnDeCode = new SButtonText();
			btnDeCode.name = "btnDeCode";
			btnDeCode.x = 225;
			btnDeCode.y = 148;
			contDP.addChild(btnDeCode);
			btnAry.push(btnDeCode);
			
			btnCode = new SButtonText();
			btnCode.name = "btnCode";
			btnCode.x = 160;
			btnCode.y = 148;
			contDP.addChild(btnCode);
			btnAry.push(btnCode);
			
			btnVar = new SButtonText();
			btnVar.name = "btnVar";
			btnVar.x = 160;
			btnVar.y = 148;
			contDP.addChild(btnVar);
			btnAry.push(btnVar);
			
			// 选中
			txtTip = new STextField();
			txtTip.name = "txtTip";
			txtTip.x = padding;
			txtTip.y = 8;
			txtTip.border = true;
			txtTip.width = 210;
			txtTip.height = 22;
			contDP.addChild(txtTip);
			
			// id:asd
			txtInput = new STextField();
			txtInput.name = "txtInput";
			txtInput.x = padding;
			txtInput.y = 60;
			txtInput.type = "input";
			txtInput.border = true;
			txtInput.width = width - padding * 2;
			txtInput.height = 120;
			contDP.addChild(txtInput);
			
			// 9999
			txtX = new STextField();
			txtX.name = "txtX";
			txtX.x = 37;
			txtX.y = 33;
			txtX.type = "input";
			txtX.border = true;
			txtX.width = 37;
			txtX.height = 20;
			tfm = new TextFormat();
			tfm.align = TextFormatAlign.CENTER;
			tfm.size = 12;
			txtX.defaultTextFormat = tfm;
			contDP.addChild(txtX);
			
			// 9999
			txtY = new STextField();
			txtY.name = "txtY";
			txtY.type = "input";
			txtY.x = 97;
			txtY.y = 33;
			txtY.border = true;
			txtY.width = 37;
			txtY.height = 20;
			tfm = new TextFormat();
			tfm.align = TextFormatAlign.CENTER;
			tfm.size = 12;
			txtY.defaultTextFormat = tfm;
			contDP.addChild(txtY);
			
			// 9999
			txtWidth = new STextField();
			txtWidth.name = "txtWidth";
			txtWidth.x = 189;
			txtWidth.type = "input";
			txtWidth.y = 33;
			txtWidth.border = true;
			txtWidth.width = 37;
			txtWidth.height = 20;
			tfm = new TextFormat();
			tfm.align = TextFormatAlign.CENTER;
			tfm.size = 12;
			txtWidth.defaultTextFormat = tfm;
			contDP.addChild(txtWidth);
			
			// 9999
			txtHeight = new STextField();
			txtHeight.name = "txtHeight";
			txtHeight.type = "input";
			txtHeight.x = 248;
			txtHeight.y = 33;
			txtHeight.border = true;
			txtHeight.width = 37;
			txtHeight.height = 20;
			tfm = new TextFormat();
			tfm.align = TextFormatAlign.CENTER;
			tfm.size = 12;
			txtHeight.defaultTextFormat = tfm;
			contDP.addChild(txtHeight);
			
			txtName = new STextField();
			txtName.name = "txtName";
			txtName.type = "input";
			txtName.x = 300;
			txtName.y = 33;
			txtName.border = true;
			txtName.width = 68;
			txtName.height = 20;
			contDP.addChild(txtName);
			
			underPointLs = new ScrollList();
			underPointLs.list.itemClass = UnderItem;
			underPointLs.list.colNum = 4;
			underPointLs.list.spacing = 2;
			underPointLs.visible = false;
			underPointLs.x = 12;
			underPointLs.y = 78;
			underPointLs.width = 350;
			underPointLs.height = 62;
			contDP.addChild(underPointLs);
			
			contDP.y = 20;
			txtInput.multiline = true;
			
			childModeSP = new Sprite();
			childModeSP.name = "childModeSP";
			childModeSP.visible = false;
			childModeSP.y = 58;
			contDP.addChild(childModeSP);
			
			labelUIType = new STextField();
			labelUIType.width = 38;
			labelUIType.name = "labelUIType";
			childModeSP.addChild(labelUIType);
			
			cbUIType = new SCombobox();
			cbUIType.name = "cbUIType";
			cbUIType.popTip.list.mustSelect = true;
			childModeSP.addChild(cbUIType);
			
			labelBgSrc = new STextField();
			labelBgSrc.width = 55;
			labelBgSrc.name = "labelBgSrc";
			childModeSP.addChild(labelBgSrc);
			
			txtBgSrc = new STextField();
			txtBgSrc.name = "txtBgSrc";
			txtBgSrc.border = true;
			txtBgSrc.selectable = false;
			childModeSP.addChild(txtBgSrc);
			
			btnRemove = new SButtonText();
			btnRemove.name = "btnRemove";
			childModeSP.addChild(btnRemove);
			
			
			labelUIType.text = "ui类型";
			labelBgSrc.text = "背景路径";
			btnRemove.text = "删除元素";
			txtXYLabel.text = "x×y:";
			txtLabel1.text = "×";
			txtWHLabel.text = "宽×高:";
			txtLabel2.text = "×";
			txtInput.text = "选中对象的信息";
			txtInput.wordWrap = true;

			cbMode.label = "多选模式";
			
			btnChild.text = "　子项　";
			btnFather.text = "　父项　";
			btnCode.text = "子项代码";
			btnDeCode.text = "反向代码";
			btnVar.text = "生成变量";
			
			DisplayTool.sortContainer(childModeSP,99,0,0,5);
			
			var txts:Vector.<TextField> = new <TextField>[txtX,txtY,txtWidth,txtHeight];
			for each (var txtItm:TextField in txts) 
			{
				txtItm.restrict = "0-9";
				txtItm.addEventListener(Event.CHANGE,onInpTxtChange);
			}
			
//			contDP.scrollRect = new Rectangle(0,0,width,height);
			var i:int = 0;
			var item:DisplayObject;
			for each (item in btnAry) 
			{
				item.y = txtInput.y + txtInput.height + padding;
				item.x = i*70 + padding;
				i = i + 1;
			}
			
			
			txtName.addEventListener(Event.CHANGE,onInpTxtChange);
			underPointLs.list.addEventListener(ListEvent.LIST_ITEM_SELECT,onUnderItemSelect);
			cbMode.addEventListener(ItemEvent.ITEM_SELECT_CHANGE,onModeChange);
			btnCode.addEventListener(MouseEvent.CLICK,onCodeClick);
			btnDeCode.addEventListener(MouseEvent.CLICK,onDeCodeClick);
			btnChild.addEventListener(MouseEvent.CLICK,onChildClick);
			btnFather.addEventListener(MouseEvent.CLICK,onFatherClick);
			deCodeLoader.addEventListener(Event.COMPLETE,onDeLoaderEvt);
			deCodeLoader.addEventListener(IOErrorEvent.IO_ERROR,onDeLoaderEvt);
			btnVar.addEventListener(MouseEvent.CLICK,createVarString);
			btnEditMode.addEventListener(ItemEvent.ITEM_SELECT_CHANGE,onEditModeChange);
			editMgr.addEventListener(EditMgr.SHOW_OUT_INFO,onShowOutInfo);
			editMgr.addEventListener(EditMgr.CFG_COMPLETE,onCfgComplete);
			editMgr.addEventListener(EditMgr.DECODE_SAVE_COMPLETE,onDecodeComplete);
			editMgr.addEventListener(EditMgr.DECODE_LOAD_COMPLETE,onDecodeComplete);
			txtBgSrc.addEventListener(MouseEvent.MOUSE_DOWN,onDragBgSrc);
			cbUIType.addEventListener(ListEvent.LIST_ITEM_SELECT,onUITypeChange);
			btnRemove.addEventListener(MouseEvent.CLICK,onRemoveTarget);
			
			editMgr.uiEditView = this;
			
			title = "UI编辑器";
			showModeUpdate();
			
			this.mouseEnabled = false;
		}
		
		// 保存完毕
		private function onDecodeComplete(event:Event):void
		{
			this.mouseChildren = true;
			txtInput.text = editMgr.saveStr;
		}
		
		private function onRemoveTarget(event:MouseEvent):void
		{
			if(!editMgr.editTarget)
				return;
			var dspc:DisplayObjectContainer = editMgr.editTarget as DisplayObjectContainer;
			// 清除所有子项
			if(txtInput.text == "clear" && dspc)
			{
				DisplayTool.clearDisp(dspc);
				return;
			}
			if(editMgr.editTarget.parent)
				editMgr.editTarget.parent.removeChild(editMgr.editTarget);
			
			setEditTarget(null);
		}
		
		private function onUITypeChange(e:Event):void
		{
			if(!editMgr.editTarget)
				return;
			if(editMgr.editTarget.hasOwnProperty("uiType"))
				editMgr.editTarget["uiType"] = String(cbUIType.selectData);
		}
		
		private var lineSp:Shape = new Shape();
		
		// 拖动改变背景字符
		private function onDragBgSrc(e:Event):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
				{
					this.stage.addChild(lineSp);
					this.stage.addEventListener(MouseEvent.MOUSE_UP,onDragBgSrc);
					this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onDragBgSrc);
					this.stage.addEventListener(Event.MOUSE_LEAVE,onDragBgSrc);
					break;
				}
				case MouseEvent.MOUSE_MOVE:
				{
					var pt:Point = txtBgSrc.parent.localToGlobal(new Point(txtBgSrc.x + 40,txtBgSrc.y + 15));
					lineSp.graphics.clear();
					lineSp.graphics.lineStyle(2,0xFF0000);
					lineSp.graphics.moveTo(pt.x,pt.y);
					lineSp.graphics.lineTo(this.stage.mouseX,this.stage.mouseY);
					break;
				}
				case MouseEvent.MOUSE_UP:
				{
					var tar:SListItem = e.target as SListItem;
					var bgSrc:String = null;
					if(tar && editMgr.isTargetInPanel(tar,navView))
						bgSrc = editMgr.rootPath + String(tar.data);
					else if(editMgr.isTargetInPanel(e.target as DisplayObject,navView))
						bgSrc = navView.preImg.src;
					
					if(bgSrc)
					{
						txtBgSrc.text = bgSrc;
						txtBgSrc.scrollH = (bgSrc.length - 1)*12;
						if(editMgr.editTarget.hasOwnProperty("bgSrc"))
							editMgr.editTarget["bgSrc"] = bgSrc;
						var outSrc:String = bgSrc.replace(editMgr.rootPath,"");
						this.stage.dispatchEvent(new EditEvent("dragLibObject",[outSrc,editMgr.editTarget,editMgr.cfgData]));
					}
				}
				default:
				{
					if(lineSp.parent)
						lineSp.parent.removeChild(lineSp);
					lineSp.graphics.clear();
					this.stage.removeEventListener(MouseEvent.MOUSE_UP,onDragBgSrc);
					this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onDragBgSrc);
					this.stage.removeEventListener(Event.MOUSE_LEAVE,onDragBgSrc);
					break;
				}
			}
		}
		
		private function onCfgComplete(event:Event):void
		{
			cbUIType.data = editMgr.uiTypeLs;
			btnEditMode.visible = editMgr.isChild;
			cbMode.visible = editMgr.isChild
		}
		
		private function onShowOutInfo(e:EditEvent):void
		{
			txtInput.text = e.dataStr;
		}
		
		public var navView:NavLibView = new NavLibView();
		
		// 编辑模式 改变
		private function onEditModeChange(e:Event):void
		{
			if(btnEditMode.selected)
			{
				btnEditMode.data = "自由编辑";
				txtInput.y = 92;
				txtInput.height = 88;
				var aa:* = SparrowMgr.mainDisp;
				if(SparrowMgr.mainDisp != null)
					SparrowMgr.mainDisp.addChild(navView);
			}
			else
			{
				btnEditMode.data = "编辑子项";
				txtInput.height = 120;
				txtInput.y = 60;
				
				if(navView.parent != null)
					navView.parent.removeChild(navView);
			}
			childModeSP.visible = btnEditMode.selected;
		}
		
		/**
		 * 选子项
		 * @param event
		 */
		private function onChildClick(e:Event=null):void
		{
			var dspc:DisplayObjectContainer = editMgr.editTarget as DisplayObjectContainer;
			if (!dspc || !dspc.parent)
				return;
			
			var cname:String = txtInput.text;
			if(cname == "call")
			{
				setEditTarget(null);
				underPointLs.visible = true;
				var dspLs:Array = [dspc];
				for (var i:int = 0; i < dspc.numChildren; i++)
				{
					dspLs.push(dspc.getChildAt(i));
				}
				
				underPointLs.data = dspLs;

			}
			// 清除所有子项
			else if(txtInput.text == "clear" && dspc)
			{
				DisplayTool.clearDisp(dspc);
				return;
			}
			else
			{
				var childDsp:DisplayObject = dspc.getChildByName(cname);
				if(!childDsp)
				{
					var tid:int = int(cname);
					if(tid >= dspc.numChildren)
						tid = dspc.numChildren - 1;
					if(dspc.numChildren > 0)
						childDsp = dspc.getChildAt(tid);
				}
			
				if(!childDsp)
					txtInput.text = ("当前显示对象无\""+cname+"\"子项");
				else
					setEditTarget(childDsp);
			}
		}
		
		
		/**
		 * 选父项
		 * @param event
		 */
		private function onFatherClick(event:MouseEvent=null):void
		{
			if(editMgr.editTarget && editMgr.editTarget.parent)
				setEditTarget(editMgr.editTarget.parent);
		}
		
		/**
		 * 生成代码
		 * @param event
		 */
		private function onCodeClick(event:MouseEvent=null):void
		{
			if(!(editMgr.editTarget is DisplayObjectContainer))
				return;
			if(parseMode == 0)
				var str:String = ReflPositionInfo.encodeChildToXml(editMgr.editTarget as DisplayObjectContainer);
			else
				str = ReflPositionInfo.encodeChildToJson(editMgr.editTarget as DisplayObjectContainer);
//			var str:Object = ReflPositionInfo.encodeChildToObj(editTarget as DisplayObjectContainer);
			
			if(txtInput.text == "wt2")
			{
				var src2:String = getTarCName(editMgr.editTarget);
				src2 = editMgr.skinCfgPath.replace("$1",src2);
				
				editMgr.saveFileToSkinCfg(str,src2);
				this.mouseChildren = false;
			}
			else if(txtInput.text == "wt:")
			{
				var src:String = src2.replace("wt:","");
				editMgr.saveFileToSkinCfg(str,src2);
				this.mouseChildren = false;
			}
			txtInput.text = str;
		}
		
		/**
		 * 反向代码
		 * @param event
		 */
		private function onDeCodeClick(event:MouseEvent=null):void
		{
			if(!(editMgr.editTarget is DisplayObjectContainer))
				return;
			var destr:String = txtInput.text;
			if(destr == "call")
				onChildClick();
			else if(destr.indexOf("src:")==0)
			{
				var src:String = destr.replace("src:","");
				loadSrc(src);
			}
			else if(destr.indexOf("src2")==0)
			{
				if(destr.length == 4)
					src = getTarCName(editMgr.editTarget);
				else
					src = destr.substr(5);
				src = editMgr.skinCfgPath.replace("$1",src);
				loadSrc(src);
			}
			else if(destr && destr.length)
			{
				if(parseMode == 0)
				{
					var deXml:XML = XML(destr);
					ReflPositionInfo.decodeXmlToChild(editMgr.editTarget as DisplayObjectContainer,deXml);
				}
				else if(parseMode == 5)
					loadSrc(editMgr.skinCfgPath);
				else
					ReflPositionInfo.decodeJsonToChild(editMgr.editTarget as DisplayObjectContainer,destr);
				updateEditUI();
			}
		}
		
		// 通过对象获取对应皮肤名
		private function getTarCName(tar:Object):String
		{
			if(tar.hasOwnProperty("skinName"))
				return tar["skinName"];
			if(tar.hasOwnProperty("openName"))
				return tar["openName"];
			if(tar.name.indexOf("instance")!=0)
				return tar.name;
			
			var src:String = getQualifiedClassName(tar);
			var tid2:int = src.indexOf("::");
			if(tid2>0)
				src = src.substr(tid2 + 2);
			return src;
		}
		
		/**
		 * 加载外部数据
		 * @param src
		 */
		private function loadSrc(src:String):void
		{
//			deCodeLoader.dataFormat = URLLoaderDataFormat.BINARY;
			loadingSrc = src;
			var ul:URLRequest = new URLRequest(src);
			deCodeLoader.load(ul);
			this.mouseChildren = false;
		}
		
		/**
		 * 当前正在加载的对象
		 */
		private var loadingSrc:String;
		
		/**
		 * 加载出来的数据
		 */
		public var loadingContent:*;
		/**
		 * 加部加载完成
		 * @param event
		 */
		private function onDeLoaderEvt(event:Event):void
		{
			switch(event.type)
			{
				case Event.COMPLETE:
				{
					loadingContent = deCodeLoader.data;
					if(editMgr.isAutoDecode)
					{
						var sData:String = String(deCodeLoader.data);
						if(parseMode == 0)
						{
							var deXml:XML = XML(sData);
							ReflPositionInfo.decodeXmlToChild(editMgr.editTarget as DisplayObjectContainer,deXml.decode);
							ReflPositionInfo.decodeXmlToChild(editMgr.editTarget as DisplayObjectContainer,deXml.other);
						}
						else if(parseMode == 5)
						{
						}
						else
							ReflPositionInfo.decodeJsonToChild(editMgr.editTarget as DisplayObjectContainer,sData);
					}
					
					updateEditUI();
					
					if(parseMode == 0)
						txtInput.text = deXml;
					else
						txtInput.text = sData;
					
					trace(loadingSrc,"加载完成");
					this.dispatchEvent(new Event("ReCreateView"));
					break;
				}
					
				default:
				{
					txtInput.text = loadingSrc + "加载错误";
					break;
				}
			}
			this.mouseChildren = true;
		}
		
		/**
		 * 外部代码加载器
		 */
		private var deCodeLoader:URLLoader = new URLLoader();
		
		/**
		 * 输入数字改变
		 */
		private function onInpTxtChange(event:Event):void
		{
			const editTarget:DisplayObject = editMgr.editTarget;
			if(!editTarget)
				return;
			editTarget.x = int(txtX.text);
			editTarget.y = int(txtY.text);
			editTarget.width = int(txtWidth.text);
			editTarget.height = int(txtHeight.text);
			editTarget.name = txtName.text;
		}
		
		/**
		 * 子项选中
		 * @param event
		 */
		private function onUnderItemSelect(e:ListEvent):void
		{
			var dsp:DisplayObject = e.itemData as DisplayObject;
			setEditTarget(dsp);
			underPointLs.visible = false;
		}
		
		/**
		 * 选中模式改变
		 * @param event
		 */
		private function onModeChange(event:ItemEvent=null):void
		{
			showModeUpdate();
			setEditTarget(null);
		}
		
		/**
		 * 模式改变
		 */
		private function showModeUpdate():void
		{
			if(cbMode && cbMode.selected)
				txtTip.text = "点选,并从列表中选取该点下的对象";
			else
			{
				txtTip.text = "点选场景上的UI对象，对其进行编辑";
				underPointLs.visible = false;
			}
		}
		
		/**
		 * 对象添加和离开舞台
		 * @param event
		 */
		private function onThisToStage(event:Event):void
		{
			if(event.type == Event.ADDED_TO_STAGE)
			{
				SparrowUtil.addNextCall(onNextStageEvent);
			}
			if(event.type == Event.REMOVED_FROM_STAGE)
			{
				this.stage.removeEventListener(MouseEvent.CLICK,onStageClick);
				this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onkeyUpHandler);
			}
		}
		
		/**
		 * 延迟一帧处理鼠标事件,防止马上监听，马上触发onStageClick
		 */
		private function onNextStageEvent(e:*=null):void
		{
			if(this.stage)
			{
				this.stage.addEventListener(MouseEvent.CLICK,onStageClick);
				this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onkeyUpHandler);
			}
		}
		
		/**
		 * 键盘事件
		 * @param event
		 */
		private function onkeyUpHandler(event:KeyboardEvent):void
		{
			const editTarget:DisplayObject = editMgr.editTarget;
			var hasParent:Boolean = editTarget != null && editTarget.parent != null;
			if (event.shiftKey)
			{
				var xOffext:int = 0;
				var yOffext:int = 0;
				var wOffset:int = 0;
				var hOffset:int = 0;
				if (event.keyCode == Keyboard.LEFT)
					xOffext = -10;
				if (event.keyCode == Keyboard.RIGHT)
					xOffext = 10;
				if (event.keyCode == Keyboard.UP)
					yOffext = -10;
				if (event.keyCode == Keyboard.DOWN)
					yOffext = 10;
				else if (event.keyCode == Keyboard.NUMPAD_SUBTRACT)
					hOffset = -10;
				else if (event.keyCode == Keyboard.NUMPAD_ADD)
					hOffset = 10;
				else if (event.keyCode == Keyboard.NUMPAD_DIVIDE)
					wOffset = -10;
				else if (event.keyCode == Keyboard.NUMPAD_MULTIPLY)
					wOffset = 10;
			}
			else if (event.ctrlKey)
			{
				// 各按钮点击
				if (event.keyCode == Keyboard.NUMBER_1)
					onFatherClick();
				else if (event.keyCode == Keyboard.NUMBER_2)
					onChildClick();
				else if (event.keyCode == Keyboard.NUMBER_3)
					onCodeClick();
				else if (event.keyCode == Keyboard.NUMBER_4)
					onDeCodeClick();
				else if (event.keyCode == Keyboard.NUMBER_0)
				{
					if(parseMode == 0)
					{
						txtInput.text = "切换为json解析模式";
						parseMode = 1;
					}
					else
					{
						txtInput.text = "切换为xml解析模式";
						parseMode = 0;
					}
				}
				else if (event.keyCode == Keyboard.NUMBER_9)
				{
					txtInput.text = "src2";
					onDeCodeClick();
				}
				// 将界面上的元素名生成变量
				else if (event.keyCode == Keyboard.NUMBER_5)
				{
					createVarString();
				}
				if(event.altKey)
				{
					// 列出子项供选择
					if (event.keyCode == Keyboard.C)
					{
						txtInput.text = "call";
						onChildClick();
					}
					// 重挑下一个子项
					else if (event.keyCode == Keyboard.D)
					{
						if(hasParent)
						{
							var tid:int = editTarget.parent.getChildIndex(editTarget);
							tid = tid + 1;
							if(tid >= editTarget.parent.numChildren)
								tid = 0;
							setEditTarget(editTarget.parent.getChildAt(tid));
						}
					}
						// 重挑上一个子项
					else if (event.keyCode == Keyboard.E)
					{
						if(hasParent)
						{
							tid = editTarget.parent.getChildIndex(editTarget);
							tid = tid - 1;
							if(tid < 0)
								tid = editTarget.parent.numChildren;
							setEditTarget(editTarget.parent.getChildAt(tid));
						}
					}
						// 删除所有子项
					else if (event.keyCode == Keyboard.T)
					{
						txtInput.text = "clear";
						onRemoveTarget(null);
					}
						// 删除所有子项后立刻进行一次反向代码
					else if (event.keyCode == Keyboard.R)
					{
						txtInput.text = "clear";
						onRemoveTarget(null);
						txtInput.text = "src2";
						onDeCodeClick();
					}
				}
			}
				// 删除单个子项
			else if (event.keyCode == Keyboard.DELETE)
			{
				if(hasParent)
					editMgr.editTarget.parent.removeChild(editMgr.editTarget);
				
				setEditTarget(null);
			}
			else if (event.keyCode == Keyboard.LEFT)
				xOffext = -1;
			else if (event.keyCode == Keyboard.RIGHT)
				xOffext = 1;
			else if (event.keyCode == Keyboard.UP)
				yOffext = -1;
			else if (event.keyCode == Keyboard.DOWN)
				yOffext = 1;
			else if (event.keyCode == Keyboard.NUMPAD_SUBTRACT)
				hOffset = -1;
			else if (event.keyCode == Keyboard.NUMPAD_ADD)
				hOffset = 1;
			else if (event.keyCode == Keyboard.NUMPAD_DIVIDE)
				wOffset = -1;
			else if (event.keyCode == Keyboard.NUMPAD_MULTIPLY)
				wOffset = 1;
				// 对象向上向下换位置
			else if (event.keyCode == Keyboard.PAGE_DOWN)
			{
				if(hasParent)
				{
					tid = editTarget.parent.getChildIndex(editTarget);
					var tid2:int = tid - 1;
					if(tid2 >= 0)
						editTarget.parent.swapChildrenAt(tid,tid2);
				}
			}
			else if (event.keyCode == Keyboard.PAGE_UP)
			{
				if(hasParent)
				{
					tid = editTarget.parent.getChildIndex(editTarget);
					tid2 = tid + 1;
					if(tid2<editTarget.parent.numChildren)
						editTarget.parent.swapChildrenAt(tid,tid2);
				}
			}
			
			if(xOffext !=0 || yOffext != 0)
			{
				editTarget.x += xOffext;
				editTarget.y += yOffext;
				updateEditUI();
			}
			if(wOffset !=0 || hOffset != 0)
			{
				editTarget.width += wOffset;
				editTarget.height += hOffset;
				updateEditUI();
			}
		}
		
		/**
		 * 生成变量字符串
		 */
		public static var VAR_STRING:String = "private var $1:$2;";
		/**
		 * 变量斌值字符串
		 */
		public static var VAR_DO_STRING:String = "$1 = this.getChildByName(\"$2\") as $3;";
		
		/**
		 * 当前选中对象生成变量字符串
		 */
		private function createVarString(e:Event=null):void
		{
			var ect:DisplayObjectContainer = editMgr.editTarget as DisplayObjectContainer;
			if(!ect)
				return;
			var item:DisplayObject;
			var str:String = "";
			var str2:String = "";
			for (var i:int = 0; i < (editMgr.editTarget as DisplayObjectContainer).numChildren; i++) 
			{
				item = (editMgr.editTarget as DisplayObjectContainer).getChildAt(i);
				var typeStr:String = getQualifiedClassName(item);
				var tid:int = typeStr.lastIndexOf("::");
				if(tid>0)
					typeStr = typeStr.substr(tid + 2);
				
				var str3:String = VAR_STRING.replace("$1",item.name);
				str3 = str3.replace("$2",typeStr);
				
				var str4:String = VAR_DO_STRING.replace("$1",item.name);
				str4 = str4.replace("$2",item.name);
				str4 = str4.replace("$3",typeStr);
				
				str = str + str3 + "\n";
				str2 = str2 + str4 + "\n";
			}
			
			txtInput.text = str + "\n" + str2;
		}
		
		override protected function onFoldChange(e:Event):void
		{
			super.onFoldChange(e);
			
			if(foldSkin.selected)
			{
				setEditTarget(null);
			}
		}
		
		/**
		 * 跟椐显示编辑对象刷新显示界面
		 */
		private function updateEditUI():void
		{
			const editTarget:DisplayObject = editMgr.editTarget;
			if (editTarget)
			{
				var cls:String = getQualifiedClassName(editTarget);
				txtX.text = editTarget.x.toString();
				txtY.text = editTarget.y.toString();
				txtWidth.text = editTarget.width.toString();
				txtHeight.text = editTarget.height.toString();
				txtTip.text = "ClassName: " + cls;
				txtTip.scrollH = txtTip.text.length;
				txtName.text = editTarget.name;
				
				if(editTarget.hasOwnProperty("uiType"))
				{
					var uitype:String = editTarget["uiType"];
					var tid:int = editMgr.uiTypeLs.indexOf(uitype);
					if(tid>=0)
					{
						if(cbUIType.selectIndex != tid)
							cbUIType.selectIndex = tid;
					}
					else
						cbUIType.selectIndex = 0;
				}
				else
					cbUIType.selectIndex = 0;
				
				if(editTarget.hasOwnProperty("bgSrc") || editTarget.hasOwnProperty("_bgSrc"))
				{
					var bgstr:String;
					if(editTarget.hasOwnProperty("bgSrc"))
						bgstr = String(editTarget["bgSrc"]);
					if(editTarget.hasOwnProperty("_bgSrc"))
						bgstr = String(editTarget["_bgSrc"]);
					txtBgSrc.text = bgstr;
					txtBgSrc.scrollH = (bgstr.length - 1)*12;
				}
				else
					txtBgSrc.text = null;
				
				var str:String = "";
				if(editTarget is DisplayObjectContainer)
					str = "\n子项个数" + (editTarget as DisplayObjectContainer).numChildren;
				txtInput.text = "当前选中的对象的Class是:" + cls + "\n对象的name是:" + editTarget.name + str;
			}
			else
			{
				txtX.text = "";
				txtY.text = "";
				txtWidth.text = "";
				txtHeight.text = "";
				txtInput.text = "";
				txtName.text = "";
				cbUIType.selectIndex = 0;
				txtBgSrc.text = "";
				showModeUpdate();
			}
		}
		
		/**
		 * @private
		 */
		public function setEditTarget(value:DisplayObject):void
		{
			var isInMe:Boolean = editMgr.isInEditPanel(value);
			if(isInMe)
				return;
			
			editMgr.editTarget = value;
			updateEditUI();
		}
		
		private var editMgr:EditMgr = EditMgr.getInstance();
		
		/**
		 * 增加舞台点击事件
		 * @param event
		 */
		private function onStageClick(event:MouseEvent):void
		{
			var tar:DisplayObject = event.target as DisplayObject;
			if(!tar)
				return;
			
			var isInMe:Boolean = editMgr.isInEditPanel(tar);
			if(isInMe)
				return;
			
			// 选中方式
			if(cbMode && cbMode.selected && tar is DisplayObjectContainer)
			{
				showUnderDsp(tar as DisplayObjectContainer);
			}
			else
			{
				setEditTarget(tar);
			}
		}
		
		/**
		 * 显示子项
		 * @param tar
		 */
		public function showUnderDsp(tar:DisplayObjectContainer):void
		{
			if(tar == null)
				return;
			
			var pdsp:DisplayObjectContainer = tar.stage;
			setEditTarget(null);
			underPointLs.visible = true;
			var dspLs:Array = pdsp.getObjectsUnderPoint(new Point(pdsp.mouseX,pdsp.mouseY));
			var item:DisplayObject;
			for each (item in dspLs) 
			{
				if(editMgr.isInEditPanel(item))
				return;
			}
			
			dspLs.unshift(tar);
			underPointLs.data = dspLs;
		}
	}
}
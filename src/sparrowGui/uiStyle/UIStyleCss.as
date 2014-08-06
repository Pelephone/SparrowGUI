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
package sparrowGui.uiStyle
{
	import asSkinStyle.SkinXMLCss;
	import asSkinStyle.data.StyleModel;
	import asSkinStyle.draw.RectSprite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	import sparrowGui.components.STextField;
	import sparrowGui.components.item.ArrowButton;
	import sparrowGui.components.item.FoldItem;
	import sparrowGui.components.item.SButton;
	import sparrowGui.components.item.SCloseButton;
	import sparrowGui.components.item.SItem;
	import sparrowGui.components.item.SListItem;
	import sparrowGui.components.item.SToggleButton;
	import sparrowGui.components.item.SliderItem;
	import sparrowGui.uiStyle.draw.ArrowRectDraw;
	import sparrowGui.uiStyle.draw.CloseRectDraw;
	import sparrowGui.uiStyle.draw.CrossRectDraw;
	import sparrowGui.uiStyle.draw.HookRectDraw;
	import sparrowGui.uiStyle.draw.RadioCircleDraw;
	
	/**
	 * 样式管理
	 * @author Pelephone
	 */
	public class UIStyleCss extends SkinXMLCss
	{
		public function UIStyleCss(styleModel:StyleModel=null)
		{
			super(styleModel);
			if(instance)
				throw new Error("UIStyleCss is singleton class and allready exists!");
			
			initReg();
			initDefaultStyle();
			
			instance = this;
		}
		
		/**
		 * 单例
		 */
		protected static var instance:UIStyleCss;
		/**
		 * 获取单例
		 */
		public static function getInstance():UIStyleCss
		{
			if(!instance)
				instance = new UIStyleCss();
			
			return instance;
		}
		
		/**
		 * 初始注册样式类
		 */
		override protected function initReg():void
		{
			super.initReg();
			registerClass("hookRect",HookRectDraw);
			registerClass("crossRect",CrossRectDraw);
			registerClass("radioCircle",RadioCircleDraw);
			registerClass("arrowRect",ArrowRectDraw);
			registerClass("sprite",Sprite);
			registerClass("text",STextField);
			
			registerClass("listItem",SListItem);
			registerClass("foldItem",FoldItem);
			registerClass("closeBtn",SCloseButton);
			registerClass("slider",SliderItem);
			registerClass("toggleButton",SToggleButton);
			registerClass("button",SButton);
			registerClass("item",SItem);
			registerClass("closeDraw",CloseRectDraw);
//			registerClass("trectBmp",TitleRectDraw);
			registerClass("arrowItem",ArrowButton);
			registerClass("rectBmp",RectSprite);
//			registerClass("rectBmp",RectDrawBmp);
		}
		
		/**
		 * 初始默认样式
		 */
		protected function initDefaultStyle():void
		{
			var skinXML:XML = XML(
				<root>
					<!-- <new clzTag="rectBmp" name="component" /> -->
					<!-- 按钮相关的创建标签 -->
					<new clzTag="sprite" name="item">
						<new clzTag="rect" name="hitTestState" />
						<new clzTag="rectBmp" name="downState" />
						<new clzTag="rectBmp" name="overState" />
						<new clzTag="rectBmp" name="upState" />
					</new>
					<new clzTag="sprite" name="button" reference="item">
						<new clzTag="text" name="txtLabel" />
					</new>

					<new clzTag="sprite" name="closeBtn">
						<new clzTag="rect" name="hitTestState" />
						<new clzTag="closeDraw" name="downState" />
						<new clzTag="closeDraw" name="overState" />
						<new clzTag="closeDraw" name="upState" />
					</new>
				
					<new clzTag="sprite" name="txtItem" reference="item">
						<new clzTag="text" name="txtLabel" />
					</new>
					<new clzTag="sprite" name="alertBtn" reference="txtItem" />
					<new clzTag="sprite" name="richItem">
						<new clzTag="rect" name="hitTestState" />
						<new clzTag="rectBmp" name="upState" />
						<new clzTag="rectBmp" name="overState" />
						<new clzTag="rectBmp" name="downState" />
						<new clzTag="rectBmp" name="selectState" />
						<new clzTag="rectBmp" name="enabledState" />
						<new clzTag="text" name="txtLabel" />
					</new>
					<new clzTag="sprite" name="richButton" reference="richItem" />
					<new clzTag="sprite" name="toggleBtn" reference="richItem" />
				
				<!-- 单选多选 -->
					<new clzTag="sprite" name="radioItem">
						<new clzTag="rect" name="hitTestState" />
						<new clzTag="radioCircle" name="upState" />
						<new clzTag="radioCircle" name="overState" />
						<new clzTag="radioCircle" name="downState" />
						<new clzTag="radioCircle" name="selectState" />
						<new clzTag="radioCircle" name="enabledState" />
						<new clzTag="text" name="txtLabel" />
					</new>
					<new clzTag="sprite" name="checkItem">
						<new clzTag="rect" name="hitTestState" />
						<new clzTag="hookRect" name="upState" />
						<new clzTag="hookRect" name="overState" />
						<new clzTag="hookRect" name="downState" />
						<new clzTag="hookRect" name="selectState" />
						<new clzTag="hookRect" name="enabledState" />
						<new clzTag="text" name="txtLabel" />
					</new>
				
					<new clzTag="sprite" name="arrowItem">
						<new clzTag="rect" name="hitTestState" />
						<new clzTag="arrowRect" name="upState" />
						<new clzTag="arrowRect" name="overState" />
						<new clzTag="arrowRect" name="downState" />
					</new>
					<new clzTag="sprite" name="downArrow" reference="arrowItem" />
					<new clzTag="sprite" name="upArrow" reference="arrowItem" />
					<new clzTag="sprite" name="leftArrow" reference="arrowItem" />
					<new clzTag="sprite" name="rightArrow" reference="arrowItem" />
				
				
				<!-- combobox下拉组件 -->
					<new clzTag="sprite" name="combobox" width="90" height="20">
						<new clzTag="rectBmp" name="bg" />
						<new clzTag="text" name="txtLabel" />
						<new clzTag="arrowItem" name="comboItem" />
					</new>
					<new clzTag="sprite" name="comboboxItem" reference="item">
						<new clzTag="rectBmp" name="selectState" />
					</new>

					<new clzTag="sprite" name="searchCombobox" reference="combobox" />
				
				<!-- 滚动条相关 -->
					<new clzTag="sprite" name="hScroll">
						<new clzTag="rectBmp" name="skinbg" />
						<new clzTag="slider" name="slider" />
						<new clzTag="arrowItem" name="leftBtn" />
						<new clzTag="arrowItem" name="rightBtn" />
					</new>
					<new clzTag="sprite" name="vScroll">
						<new clzTag="rectBmp" name="skinbg" />
						<new clzTag="slider" name="slider" />
						<new clzTag="arrowItem" name="upBtn" />
						<new clzTag="arrowItem" name="downBtn" />
					</new>
					<new clzTag="sprite" name="sliderItem">
						<new clzTag="rect" name="hitTestState" />
						<new clzTag="rect" name="downState" />
						<new clzTag="rect" name="overState" />
						<new clzTag="rect" name="upState" />
					</new>
				
				<!-- 列表相关 -->
					<new clzTag="sprite" name="radioGroup" />
					<new clzTag="sprite" name="checkBox" />
					<new clzTag="sprite" name="itemList" />
					<new clzTag="sprite" name="pageList" />
					<new clzTag="sprite" name="tree" />
					<new clzTag="sprite" name="pageBox">
						<new clzTag="button" name="btn_first" />
						<new clzTag="button" name="btn_prev" />
						<new clzTag="button" name="btn_next" />
						<new clzTag="button" name="btn_last" />
						<new clzTag="text" name="txt_inputNum" />
						<new clzTag="text" name="txt_showNum" />
						<new clzTag="button" name="btn_go" />
					</new>
				
				<!-- 树形控件相关 -->
					<new clzTag="sprite" name="foldItem" >
						<new clzTag="rect" name="hitTestState" />
						<new clzTag="crossRect" name="overState" />
						<new clzTag="crossRect" name="downState" />
						<new clzTag="crossRect" name="selectState" />
						<new clzTag="crossRect" name="enabledState" />
						<new clzTag="crossRect" name="upState" />
					</new>
				
					<new clzTag="sprite" name="treeItem" >
						<new clzTag="foldItem" name="foldBtn" />
						<new clzTag="listItem" name="selectBtn" />
					</new>
				
				<!-- 滚动面板相关 -->
					<new clzTag="sprite" name="scrollPanel" />
					<new clzTag="sprite" name="scrollList" reference="scrollPanel" />
					<new clzTag="sprite" name="scrollTree" reference="scrollPanel" />
				
				<!-- 滚动面板相关 -->
					<new clzTag="sprite" name="toolTip">
						<new clzTag="rectBmp" name="skinBG" />
						<new clzTag="text" name="txtTip" />
					</new>
				
				<!-- 窗口相关 -->
					<new clzTag="sprite" name="window">
						<new clzTag="rectBmp" name="skinBG" />
						<new clzTag="sprite" name="contDP" />
						<new clzTag="rectBmp" name="dragBG" />
						<new clzTag="toggleButton" name="foldSkin" />
						<new clzTag="closeBtn" name="closeSkin" />
						<new clzTag="text" name="txtTitle" />
					</new>
				
				<!-- 警告窗相关 -->
					<new clzTag="rectSR" name="translucent" />
					<new clzTag="rectBmp" name="alert">
						<new clzTag="rectBmp" name="bg" />
						<new clzTag="text" name="txtAlert" />
						<new clzTag="sprite" name="posBtn" />
					</new>
					<new clzTag="rectBmp" name="inputAlert">
						<new clzTag="text" name="txtAlert" />
						<new clzTag="text" name="txtInput" />
						<new clzTag="rectBmp" name="posBtn" />
					</new>
				
				<!-- 文本组件 -->
					<new clzTag="sprite" name="richText">
						<new clzTag="text" name="txtLabel" />
					</new>
					<new clzTag="sprite" name="textArea" reference="richText" />
				</root>
			);
			
			encodeStyleClip.encodeBuilder(skinXML);
			
			
			// 文本居中
			var tformat:TextFormat = new TextFormat();
			tformat.align = "center";
			
			var lformat:TextFormat = new TextFormat();
			lformat.align = "left";
			
			registerObject("centerFMT",tformat);
			registerObject("leftFMT",lformat);
			
			var styleXml:XML = XML(
				<root>
					<!-- 基本组件 
					<get name="component"
						bgColor="0xFFFFFF"
						width="20"
						height="20" />-->
				
					<!-- 基本项 -->
					<get name="baseItem"
						bgColor="0xFFFFFF"
						width="80"
						height="24"
						border="1"
						borderColor="0x717171" />

					<!-- 项 -->
					<get name="item">
						<get name="hitTestState" reference="baseItem" alpha="0" />
						<get name="downState" reference="baseItem" bgColor="0xC0CBCB" borderColor="0x3C7FB1" />
						<get name="overState" reference="baseItem" bgColor="0xFFFFFF" borderColor="0x3778a2"
 							inBgColor="0xdaf0f0" paddingTop="2" paddingLeft="2"/>
						<get name="upState" reference="baseItem"/>
					</get>

					<!-- 富项 -->
					<get name="txtItem" reference="item">
						<get name="upState" bgColor="0xFFFFFF" inBgColor="0xEBEBEB" paddingTop="2" paddingLeft="2" />
						<get name="txtLabel" width="80" y="2" height="20" mouseEnabled="0" defaultTextFormat="$centerFMT" />
					</get>
					<get name="alertBtn" reference="txtItem" width="60" />
				
					<get name="richItem" reference="item" >
						<get name="selectState" reference="baseItem" bgColor="0xC6D0D0" />
						<get name="enabledState" reference="baseItem" bgColor="0xCCCCCC" />
						<get name="txtLabel" width="80" y="2" height="20" mouseEnabled="0" defaultTextFormat="$centerFMT" />
					</get>
				
					<get name="toggleBtn" reference="richItem" />
				
					<get name="richButton" reference="richItem">
						<get name="upState" bgColor="0xEBEBEB" />
					</get>
					<get name="button" reference="item" width="80" height="24" >
						<get name="upState" bgColor="0xFFFFFF" inBgColor="0xEBEBEB" paddingTop="2" paddingLeft="2" />
						<get name="txtLabel" y="2" height="20" width="80" mouseEnabled="0" defaultTextFormat="$centerFMT" />
					</get>

					<!-- 单选多选项 -->
					<get name="radioItemBase"
							bgColor="0xFFFFFF"
							border="1"
							borderColor="0x707070"
							width="12"
							height="12"
							inCirleColor="-1"
							inBorder="0"
							hookThick="0"
							y="4"
						/>
				
					<get name="radioItem" width="100" height="20">
						<get name="hitTestState" reference="baseItem" alpha="0" />
						<get name="overState" reference="radioItemBase" bgColor="0xEFEFEF" borderColor="0x3C7FB1" />
						<get name="downState" reference="radioItemBase" bgColor="0xCCD5D5" borderColor="0x3C7FB1" />
						<get name="selectState" reference="radioItemBase" bgColor="0xEFEFEF"
							inCirleColor="0x202020" padding="3" />
						<get name="enabledState" reference="radioItemBase" bgColor="0xCCCCCC" />
						<get name="upState" reference="radioItemBase" />
						<get name="txtLabel" width="46" height="20" x="14"/>
					</get>
				
					<get name="checkItem" reference="radioItem">
						<get name="selectState" hookThick="2" bgColor="0xEFEFEF"
							hookThickColor="0x202020" padding="3" />
					</get>
				
					<!-- 滚动条相关 -->
					<get name="arrowBase"
						bgColor="0xFFFFFF"
						border="1"
						borderColor="0x707070"
						width="14"
						height="14"
						isNextDraw="0"
						padding="3"
						/>

					<get name="arrowItem" width="14" height="14">
						<get name="hitTestState" reference="baseItem" width="14" height="14" alpha="0" />
						<get name="upState" reference="arrowBase" arrowColor="0x202020" />
						<get name="overState" reference="arrowBase" bgColor="0xEFEFEF" arrowColor="0x202020" />
						<get name="downState" reference="arrowBase" bgColor="0xCCD5D5" arrowColor="0x000000" />
					</get>
				
					<get name="upArrow" reference="arrowItem">
						<get name="upState" arrowDirct="0" />
						<get name="overState" arrowDirct="0" />
						<get name="downState" arrowDirct="0" />
					</get>
				
					<get name="downArrow" reference="arrowItem">
						<get name="upState" arrowDirct="1" />
						<get name="overState" arrowDirct="1" />
						<get name="downState" arrowDirct="1" />
					</get>
				
					<get name="leftArrow" reference="arrowItem">
						<get name="upState" arrowDirct="2" />
						<get name="overState" arrowDirct="2" />
						<get name="downState" arrowDirct="2" />
					</get>
				
					<get name="rightArrow" reference="arrowItem">
						<get name="upState" arrowDirct="3" />
						<get name="overState" arrowDirct="3" />
						<get name="downState" arrowDirct="3" />
					</get>
				
					<get name="vScroll">
						<get name="upBtn" reference="upArrow" />
						<get name="downBtn" reference="downArrow" />
						<get name="slider" width="14" height="14" visible="0"/>
						<get name="skinbg" bgColor="0xF0F0F0"	border="0" borderColor="0" width="14" height="14" />
					</get>
				
					<get name="hScroll">
						<get name="leftBtn" reference="arrowItem">
							<get name="upState" arrowDirct="2" />
							<get name="overState" arrowDirct="2" />
							<get name="downState" arrowDirct="2" />
						</get>
						<get name="rightBtn" reference="arrowItem">
							<get name="upState" arrowDirct="3" />
							<get name="overState" arrowDirct="3" />
							<get name="downState" arrowDirct="3" />
						</get>
						<get name="slider" width="14" height="14" visible="0" />
						<get name="skinbg" bgColor="0xF0F0F0"	border="0" borderColor="0" width="14" height="14" />
					</get>
				
					<get name="sliderBase"
						bgColor="0xFFFFFF"
						width="14"
						height="14"
						border="1"
						borderColor="0x717171" />
				
					<get name="sliderItem">
						<get name="hitTestState" reference="sliderBase" alpha="0" />
						<get name="upState" reference="sliderBase" bgColor="0xFFFFFF" inBgColor="0xEBEBEB" paddingTop="2" paddingLeft="2" />
						<get name="overState" reference="sliderBase" bgColor="0xEFEFEF" borderColor="0x3C7FB1" />
						<get name="downState" reference="sliderBase" bgColor="0xCCD5D5" borderColor="0x3C7FB1" />
					</get>

					<!-- 滚动控件 -->
					<get name="scrollPanel">
						<get name="vScroll" reference="vScroll" />
						<get name="hScroll" reference="hScroll" />
					</get>
					<get name="scrollList">
						<get name="vScroll" reference="vScroll" />
						<get name="hScroll" reference="hScroll" />
					</get>
					<get name="scrollTree">
						<get name="vScroll" reference="vScroll" />
						<get name="hScroll" reference="hScroll" />
					</get>

					<!-- 下拉组件 -->
					<get name="cbxBase" 
						bgColor="0xFFFFFF"
						border="1"
						borderColor="0x707070"
						width="14"
						height="14"
						isNextDraw="0"
						padding="3"
						y="3"
						x="63"
						/>
				
					<get name="combobox">
						<get name="bg" border="1" bgColor="0xEFEFEF" 
							borderColor="0xBBBBBB" isNextDraw="0" width="80" height="20" />
						<get name="comboItem" reference="downArrow" y="3" x="60" width="14" height="14" />
						<get name="txtLabel" width="80" height="20" x="5" selectable="0" mouseEnabled="0" />
					</get>
				
					<get name="comboboxItem" reference="item" width="80" height="20" >
						<get name="selectState" reference="baseItem" bgColor="0xC6D0D0" />
					</get>
				
					<get name="searchCombobox" reference="combobox" >
						<get name="txtLabel" selectable="1" mouseEnabled="1" />
					</get>
				
					<!-- 树形按钮 -->
					<get name="crossBase"
						bgColor="0xFFFFFF"
						width="14"
						height="14"
						border="1"
						borderColor="0x707070"
						inBorder="1"
						inBorderColor="0x202020"
						isNextDraw="0"
						type="0"
						y="3"
						padding="3"
					/>
				
					<get name="foldItem">
						<get name="hitTestState" reference="baseItem" width="14" height="14" alpha="0" />
						<get name="upState" reference="crossBase" bgColor="0xEBEBEB" inBorderColor="0x202020" />
						<get name="overState" reference="crossBase" bgColor="0xFFFFFF" inBorderColor="0x202050" />
						<get name="downState" reference="crossBase" bgColor="0xCCD5D5" inBorderColor="0x000000" />
						<get name="selectState" reference="crossBase" bgColor="0xCCD5D5" type="1" inBorderColor="0x000000" />
						<get name="enabledState" reference="crossBase" bgColor="0xCCCCCC"  />
					</get>
				
					<get name="treeItem">
						<get name="foldBtn" width="14" height="14" />
						<get name="selectBtn" x="20" />
					</get>

					<!-- 提示窗 -->
					<get name="toolTip">
						<get name="txtTip" autoSize="left" textColor="0x000000" wordWrap="0" height="20" />
						<get name="skinBG" bgColor="0xE9E9F2" border="1" borderColor="0xA0A0A0" />
					</get>

					<!-- 窗体组件 -->
					<get name="window">
						<get name="skinBG" bgColor="0xFFFFFF" border="3" borderColor="0x9DAEAA" width="150" height="120" />
						<get name="dragBG" width="150" height="20" border='1' borderColor="0x66656D" 
							bgColor="0xE5F5F9" inBgColor="0x8DD3E4" paddingTop="2"/>
						<get name="foldSkin" x="117" y="3" width="14" height="14">
							<get name="hitTestState" width="14" height="14" />
						</get>
						<get name="txtTitle" height="22" x="2" selectable="0" mouseEnabled="0" defaultTextFormat="$leftFMT" />
						<get name="closeSkin" y="3" x="133" width="14" height="14"/>
					</get>
				
					<get name="closeBtn" reference="item">
						<get name="hitTestState"  alpha="0" width="14" height="14" />
						<get name="downState" inPadding="3" width="14" height="14" />
						<get name="overState" inPadding="3" width="14" height="14"/>
						<get name="upState" inPadding="3" width="14" height="14"/>
					</get>

					<!-- 警告窗 -->
					<get name="translucent" bgColor="0x000000" bgAlpha="0.3" mouseEnabled="1" mouseChildren="0" />
				
					<get name="alert" width="200" height="150">
						<get name="bg" bgColor="0xFFFFFF" border="1" borderColor="0x7F9BA6"/>
						<get name="txtAlert" height="80" x="5" y="5" selectable="0" multiline="1"
							mouseEnabled="0" wordWrap="1" defaultTextFormat="$centerFMT" />
						<get name="posBtn" x="100" y="145" />
					</get>
				
					<get name="inputAlert" reference="alert" >
						<get name="txtAlert" y="18" />
					</get>
				
					<get name="pageTxt" width="80" height="20" y="2" />
				
					<get name="pageBox" >
						<get name="btn_first" label="首页" y="30" />
						<get name="btn_last" x="85" y="30" label="末页" />
						<get name="btn_prev" label="上一页" />
						<get name="btn_go" x="255" label="跳转" />
						<get name="btn_next" x="85" label="下一页" />
						<get name="txt_inputNum" reference="pageTxt" restrict="0-9" text="1" type="input" border="1" x="170" />
						<get name="txt_showNum" reference="pageTxt" selectable="0" mouseEnabled="0" border="1" x="170" y="30" />
					</get>
				
					<get name="richText" >
						<get name="txtLabel" width="80" height="80" multiline="1" wordWrap="1" />
					</get>
				
					<get name="textArea" reference="richText" />
				
				</root>
				);
			encodeStyleClip.encodeStyle(styleXml);
			
		}
		
		/**
		 * 将数据样式编码成解析结构
		 */
		public function encodeBuildStyle(dat:Object):void
		{
			encodeStyleClip.encodeBuilder(dat);
			encodeStyleClip.encodeStyle(dat);
		}
		
		/**
		 * 创建并将样式解析到指定显示对象
		 * @param idPath
		 * @param skin
		 * @return 
		 */
		public function createStyleSkin(idPath:String,skin:DisplayObject=null):DisplayObject
		{
			skin = decodeStyleClip.decodeBuildStyle(idPath,skin);
			decodeStyleClip.decodeSetStyle(idPath,skin);
			return skin;
		}
	}
}
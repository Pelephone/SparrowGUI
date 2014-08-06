package sparrowGui.uiStyle
{
	import asSkinStyle.parser.ArrayToStyleParser;
	import asSkinStyle.parser.AsSkinStyle;
	import asSkinStyle.parser.XMLSkinBuilder;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import sparrowGui.uiStyle.draw.ArrowRectDraw;
	import sparrowGui.uiStyle.draw.CrossRectDraw;
	import sparrowGui.uiStyle.draw.HookRectDraw;
	import sparrowGui.uiStyle.draw.RadioCircleDraw;
	
	/**
	 * 皮肤样式管理器(目前不用这个)
	 * @author Pelephone
	 */
	public class UIStyleMgr extends AsSkinStyle
	{
		// 单例
		private static var instance:UIStyleMgr = new UIStyleMgr();
		
		/**
		 * 构造样式管理器
		 */
		public function UIStyleMgr()
		{
			var skinTag:XML = getSkinTag();
			var styleArr:Array = getStyleArr();
			
			super(skinTag, styleArr, new XMLSkinBuilder(), new ArrayToStyleParser());
		}
		
		//获取单例
		public static function getIns():UIStyleMgr {
			if (instance == null) instance = new UIStyleMgr();
			return instance;
		}
		
		/**
		 * 初始注册标签
		 */
		override protected function initRegisterTags():void
		{
			super.initRegisterTags();
//			registerTag("rect",RectDraw);
//			registerTag("circle",CircleDraw);
			registerTag("hookRect",HookRectDraw);
			registerTag("crossRect",CrossRectDraw);
			registerTag("radioCircle",RadioCircleDraw);
			registerTag("arrowRect",ArrowRectDraw);
			registerTag("sprite",Sprite);
			registerTag("text",TextField);
//			registerTag("fourState",ItemSkin);
//			registerTag("sixState",RichItemSkin);
//			registerTag("radioItem",RadioItemSkin);
//			registerTag("checkItem",CheckItemSkin);
//			registerTag("hScroll",HScrollSkin);
//			registerTag("vScroll",VScrollSkin);
		}
		
		/**
		 * 生成皮肤结构的xml
		 * @return 
		 */
		private function getSkinTag():XML
		{
			var skinXML:XML = XML(
				<root>
					<rect name="component" />
					<!-- 按钮相关的创建标签 -->
					<sprite name="item">
						<rectSR name="hitTestState" />
						<rect name="upState" />
						<rect name="overState" />
						<rect name="downState" />
					</sprite>
					<sprite name="button" reference="item">
						<text name="txtField" />
					</sprite>
					<sprite name="txtItem" reference="item">
						<text name="txtField" />
					</sprite>
					<sprite name="richItem">
						<rectSR name="hitTestState" />
						<rect name="upState" />
						<rect name="overState" />
						<rect name="downState" />
						<rect name="selectState" />
						<rect name="enabledState" />
						<text name="txtField" />
					</sprite>
					<sprite name="richButton" reference="richItem" />
				
				<!-- 单选多选 -->
					<sprite name="radioItem">
						<rectSR name="hitTestState" />
						<radioCircle name="upState" />
						<radioCircle name="overState" />
						<radioCircle name="downState" />
						<radioCircle name="selectState" />
						<radioCircle name="enabledState" />
						<text name="txtField" />
					</sprite>
					<sprite name="checkItem">
						<rectSR name="hitTestState" />
						<hookRect name="upState" />
						<hookRect name="overState" />
						<hookRect name="downState" />
						<hookRect name="selectState" />
						<hookRect name="enabledState" />
						<text name="txtField" />
					</sprite>
				
				<!-- combobox下拉组件 -->
					<sprite name="combobox" reference="arrowItem">
						<arrowRect name="enabledState" />
						<arrowRect name="selectState" />
						<text name="txtField" />
					</sprite>
					<sprite name="comboboxItem" reference="richItem" />
				
				<!-- 滚动条相关 -->
					<sprite name="arrowItem">
						<rectSR name="hitTestState" />
						<arrowRect name="upState" />
						<arrowRect name="overState" />
						<arrowRect name="downState" />
					</sprite>
					<sprite name="hScroll">
						<rectSR name="skinbg" />
						<sprite name="slider" reference="item" />
						<sprite name="leftBtn" reference="arrowItem" />
						<sprite name="rightBtn" reference="arrowItem" />
					</sprite>
					<sprite name="vScroll">
						<rectSR name="skinbg" />
						<sprite name="slider" reference="item" />
						<sprite name="upBtn" reference="arrowItem" />
						<sprite name="downBtn" reference="arrowItem" />
					</sprite>
				
				<!-- 列表相关 -->
					<sprite name="radioGroup" />
					<sprite name="checkBox" />
					<sprite name="itemList" />
					<sprite name="pageList" />
					<sprite name="tree" />
					<sprite name="scrollList" reference="scrollPanel" />
					<sprite name="scrollTree" reference="scrollPanel" />
					<sprite name="pageBox">
						<sprite name="btn_first" reference="txtItem" />
						<sprite name="btn_prev" reference="txtItem" />
						<sprite name="btn_next" reference="txtItem" />
						<sprite name="btn_last" reference="txtItem" />
						<text name="txt_inputNum" />
						<text name="txt_showNum" />
						<sprite name="btn_go" reference="txtItem" />
					</sprite>
				
				<!-- 树形控件相关 -->
					<sprite name="foldItem" >
						<rectSR name="hitTestState" />
						<crossRect name="upState" />
						<crossRect name="overState" />
						<crossRect name="downState" />
						<crossRect name="selectState" />
						<crossRect name="enabledState" />
					</sprite>
				
					<sprite name="treeItem" >
						<sprite name="foldBtn" reference="foldItem" />
						<sprite name="selectBtn" reference="richItem" />
					</sprite>
				
				<!-- 滚动面板相关 -->
					<sprite name="scrollPanel">
						<sprite name="vScroll" reference="vScroll" />
						<sprite name="hScroll" reference="hScroll" />
					</sprite>
				
				<!-- 滚动面板相关 -->
					<sprite name="toolTip">
						<rect name="skinBG" />
						<text name="txtTip" />
					</sprite>
				
				<!-- 窗口相关 -->
					<sprite name="window">
						<rect name="skinBG" />
						<sprite name="contDP" />
						<rectSR name="dragBG" />
						<sprite name="foldSkin" reference="foldItem" />
						<sprite name="closeSkin" reference="foldItem" />
					</sprite>
				
				<!-- 警告窗相关 -->
					<rectSR name="translucent" />
					<rectSR name="alert">
						<text name="txtAlert" />
						<rect name="posBtn" />
					</rectSR>
					<rectSR name="inputAlert">
						<text name="txtAlert" />
						<text name="txtInput" />
						<rect name="posBtn" />
					</rectSR>
				
				<!-- 文本组件 -->
					<sprite name="richText">
						<text name="txtField" />
					</sprite>
					<sprite name="textArea" reference="richText" />
				</root>
				);
			return skinXML;
		}
		
		/**
		 * 样式数组
		 * @return 
		 */
		protected function getStyleArr():Array
		{
			// 文本居中
			var tformat:TextFormat = new TextFormat();
			tformat.align = "center";
			var lformat:TextFormat = new TextFormat();
			lformat.align = "left";
			var grid:Rectangle = new Rectangle(5, 5, 4, 4);
			
			// 下部重名的样式会覆盖上部样式
			var defaultUI:Array = [
				// 基本组件
				"component",{
					bgColor:0xFFFFFF,
					width:20,
					height:20
				}
				
				/////////////////////////////////////////////////
				// 项,按钮相关样式
				,"baseItem",{
					bgColor:0xFFFFFF,
					width:60,
					height:20,
					border:1,
					borderColor:0x707070
				}
				,"item upState",{
					reference:"baseItem"
				}
				,"item hitTestState",{
					alpha:0,
					reference:"baseItem"
				}
				,"item overState",{
					bgColor:0xCCD5D5,
					borderColor:0x3C7FB1,
					reference:"baseItem"
				}
				,"item downState",{
					borderColor:0x3C7FB1,
					bgColor:0xC0CBCB,
					reference:"baseItem"
				}
				,"txtItem,richItem,button",{
					reference:"item"
				}
				,"txtItem txtField",{
					width:60,
					height:20,
					mouseEnabled:false,
					defaultTextFormat:tformat
				}
				,"richItem selectState",{
					reference:"baseItem",
					bgColor:0xAFBDBD
				}
				,"richItem enabledState",{
					reference:"baseItem",
					bgColor:0xCCCCCC
				}
				,"richItem txtField",{
					width:60,
					height:20,
					defaultTextFormat:tformat
				}
				,"richButton",{
					reference:"richItem"
				}
				
				/////////////////////////////////////////////////
				// 单选多选项
				,"radioItemBase",{
					bgColor:0xFFFFFF,
					border:1,
					borderColor:0x707070,
					width:12,
					height:12,
					inCirleColor:-1,
					inBorder:0,
					hookThick:0,
					y:3
				}
				,"radioItem upState",{
					reference:"radioItemBase"
				}
				,"radioItem hitTestState",{
					reference:"baseItem",
					alpha:0
				}
				,"radioItem overState",{
					reference:"radioItemBase",
					bgColor:0xEFEFEF,
					borderColor:0x3C7FB1
				}
				,"radioItem downState",{
					reference:"radioItemBase",
					bgColor:0xCCD5D5,
					borderColor:0x3C7FB1
				}
				,"radioItem selectState",{
					reference:"radioItemBase",
					bgColor:0xEFEFEF,
					inCirleColor:0x202020,
					padding:3
				}
				,"radioItem enabledState",{
					reference:"radioItemBase",
					bgColor:0xCCCCCC
				}
				,"radioItem txtField",{
					x:14,
					width:46,
					height:20
				}
				,"checkItem",{
					reference:"radioItem"
				}
				,"checkItem selectState",{
					bgColor:0xEFEFEF,
					hookThick:2,
					hookThickColor:0x202020,
					padding:3
				}
				
				/////////////////////////////////////////////////
				// 下拉组件
				,"cbxBase",{
					bgColor:0xFFFFFF,
					border:1,
					borderColor:0x707070,
					width:14,
					height:14,
					isNextDraw:false,
					padding:3,
					y:3,
					x:(80-3-14)
				}
				,"combobox upState",{
					reference:"cbxBase",
					arrowColor:0x202020
				}
				,"combobox overState",{
					reference:"cbxBase",
					bgColor:0xEFEFEF,
					arrowColor:0x202050
				}
				,"combobox downState",{
					reference:"cbxBase",
					bgColor:0xCCD5D5,
					arrowColor:0x000000
				}
				,"combobox hitTestState",{
					reference:"baseItem",
					width:80,
					height:20
				}
				,"combobox selectState",{
					reference:"cbxBase",
					bgColor:0xCCD5D5,
					arrowColor:0x202020
				}
				,"combobox txtField",{
					width:80,
					height:20,
					selectable:false,
					mouseEnabled:false
				}
				// 下箭头按钮
				,"combobox upState,combobox overState,combobox downState,combobox selectState",{
					arrowDirct:1
				}
				
				,"comboboxItem",{
					reference:"richItem",
					width:80,
					height:20
				}
				,"comboboxItem txtField",{
					defaultTextFormat:lformat
				}
				
				/////////////////////////////////////////////////
				// 滚动条相关
				,"arrowBase",{
					bgColor:0xFFFFFF,
					border:1,
					borderColor:0x707070,
					width:14,
					height:14,
					isNextDraw:false,
					padding:3
				}
				,"arrowItem upState",{
					reference:"arrowBase",
					arrowColor:0x202020
				}
				,"arrowItem overState",{
					reference:"arrowBase",
					bgColor:0xEFEFEF,
					arrowColor:0x202050
				}
				,"arrowItem downState",{
					reference:"arrowBase",
					bgColor:0xCCD5D5,
					arrowColor:0x000000
				}
				,"arrowItem hitTestState",{
					reference:"baseItem",
					width:14,
					height:14,
					alpha:0
				}
				,"upArrow,downArrow,leftArrow,rightArrow",{
					reference:"arrowItem"
				}
				
				// 上箭头按钮
				,"upArrow upState,upArrow overState,upArrow downState",{
					arrowDirct:0
				}
				// 下箭头按钮
				,"downArrow upState,downArrow overState,downArrow downState",{
					arrowDirct:1
				}
				// 左箭头按钮
				,"leftArrow upState,leftArrow overState,leftArrow downState",{
					arrowDirct:2
				}
				// 右箭头按钮
				,"rightArrow upState,rightArrow overState,rightArrow downState",{
					arrowDirct:3
				}
				,"vScroll upBtn",{
					reference:"upArrow"
				}
				,"vScroll downBtn",{
					reference:"downArrow"
				}
				,"hScroll leftBtn",{
					reference:"leftArrow"
				}
				,"hScroll rightBtn",{
					reference:"rightArrow"
				}
				,"sliderBase",{
					bgColor:0xFFFFFF,
					border:1,
					borderColor:0x707070,
					width:14,
					isNextDraw:false,
					height:14
				}
				,"sliderItem",{
//					scale9Grid:grid
				}
				,"sliderItem upState",{
					reference:"sliderBase"
				}
				,"sliderItem hitTestState",{
					reference:"baseItem",
					width:14,
					height:14,
					alpha:0
				}
				,"sliderItem overState",{
					reference:"sliderBase",
					bgColor:0xEFEFEF,
					borderColor:0x3C7FB1
				}
				,"sliderItem downState",{
					reference:"sliderBase",
					bgColor:0xCCD5D5,
					borderColor:0x3C7FB1
				}
				,"sliderItem slider,hScroll slider,vScroll slider",{
					reference:"sliderItem"
				}
//				,"vScroll slider,hScroll slider",{}
				
				,"vScroll skinbg,hScroll skinbg",{
					bgColor:0xF0F0F0,
					border:0,
					borderColor:0,
					width:14,
					height:14
				}
				
				// 滚动控件
				,"scrollPanel vScroll,scrollList vScroll,scrollTree vScroll",{
					reference:"vScroll"
				}
				// 滚动控件
				,"scrollPanel hScroll,scrollList hScroll,scrollTree hScroll",{
					reference:"hScroll"
				}
				
				// 树形按钮
				,"crossBase",{
					bgColor:0xFFFFFF,
					width:14,
					height:14,
					border:1,
					borderColor:0x707070,
					inBorder:1,
					inBorderColor:0x202020,
					isNextDraw:false,
					type:0,
					y:3,
					padding:3
				}
				,"foldItem hitTestState",{
					reference:"baseItem",
					width:14,
					height:14,
					alpha:0
				}
				,"foldItem upState",{
					reference:"crossBase",
					bgColor:0xFFFFFF,
					inBorderColor:0x202020
				}
				,"foldItem overState",{
					reference:"crossBase",
					bgColor:0xEFEFEF,
					inBorderColor:0x202050
				}
				,"foldItem downState",{
					reference:"crossBase",
					bgColor:0xCCD5D5,
					inBorderColor:0x000000
				}
				,"foldItem selectState",{
					reference:"crossBase",
					bgColor:0xCCD5D5,
					type:1,
					inBorderColor:0x000000
				}
				,"foldItem enabledState",{
					reference:"crossBase",
					bgColor:0xCCCCCC
				}
				,"treeItem foldBtn",{
					reference:"foldItem"
				}
				,"treeItem selectBtn",{
					reference:"richItem",
					x:20
				}
				
				// 提示窗
				,"toolTip txtTip",{
					autoSize:TextFieldAutoSize.LEFT,
					textColor:0x000000,
					wordWrap:false
				}
				,"toolTip skinBG",{
					bgColor:0xE9E9F2,
					border:1,
					borderColor:0xA0A0A0
				}
				
				// 窗体组件
				,"window skinBG",{
					bgColor:0xFFFFFF,
					border:1,
					borderColor:0x66656D,
					width:150,
					height:120
				}
				,"window dragBG",{
					bgColor:0x77A0B2,
					border:1,
					borderColor:0x7F9BA6,
					width:150,
					height:20
				}
				,"window contDP",{
					y:18
				}
				,"window foldSkin",{
					reference:"foldItem",
					width:14,
					height:14,
					x:118,
					y:2
				}
				,"window foldSkin hitTestState",{
					width:14,
					height:14
				}
				,"window closeSkin",{
					reference:"foldItem",
//					y:1,
					x:(150-14-2)
				}
				,"window closeSkin hitTestState",{
					width:14,height:14
				}
				
				// 警告窗
				,"translucent",{
					bgColor:0x000000,
					bgAlpha:0.3
				}
				,"alert",{
					width:200,
					height:150,
					bgColor:0xFFFFFF,
					border:1,
					borderColor:0x7F9BA6
				}
				,"alert txtAlert",{
					height:80,
					x:5,
					y:5,
					selectable:false,
					mouseEnabled:false,
					defaultTextFormat:tformat
				}
				,"alert posBtn",{
					x:100,
					y:145
				}
				,"inputAlert",{
					reference:"alert"
				}
				,"inputAlert txtAlert",{
					y:85
				}
				,"pageBox btn_first",{
					reference:"txtItem",
					y:25
				}
				,"pageBox btn_last",{
					reference:"txtItem",
					x:65,
					y:25
				}
				,"pageBox btn_prev",{
					reference:"txtItem"
				}
				,"pageBox btn_next",{
					reference:"txtItem",
					x:65
				}
				,"pageTxt",{
					width:60,
					height:20
				}
				,"pageBox txt_inputNum",{
					reference:"pageTxt",
					restrict:"0-9",
					text:"1",
					type:TextFieldType.INPUT,
					border:true,
					x:130
				}
				,"pageBox txt_showNum",{
					reference:"pageTxt",
					border:true,
					selectable:false,
					mouseEnabled:false,
					x:130,
					y:25
				}
				,"pageBox btn_prev,pageBox btn_go,pageBox btn_next,pageBox btn_first," +
					"pageBox btn_last,pageBox btn_go",{
					reference:"txtItem"
				}
				,"pageBox btn_go",{
					x:195
				}
				,"pageBox btn_prev txtField",{
					text:"上一页"
				}
				,"pageBox btn_next txtField",{
					text:"下一页"
				}
				,"pageBox btn_first txtField",{
					text:"首页"
				}
				,"pageBox btn_last txtField",{
					text:"末页"
				}
				,"pageBox btn_go txtField",{
					text:"跳转"
				}
				,"richText txtField",{
					width:80,
					height:80,
					multiline:true,
					wordWrap:true
				}
				,"textArea",{
					reference:"richText"
				}
			];
			
			return defaultUI;
		}
	}
}
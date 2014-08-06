package sparrowGui.components
{
	import asCachePool.ClassObjectPool;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import sparrowGui.components.base.BaseUIComponent;
	import sparrowGui.event.RichEvent;
	import sparrowGui.utils.SparrowUtil;
	
	/**
	 * 带表情功能的文本组件
	 * 
	 * 	.表情功能:
	 * 
	 * 		.html格式: <disp cls=%s mcFrame=%d dispName=%s />, 其中
	 * 			cls = 类名, 由 registerClass 中注册, 不指定时, 为默认类.  // 类名格式, 当前仅支持与 AS3 中标示符相同的格式, 即不包含空白字符
	 * 			mcFrame = 帧编号, 当 cls 类指定的是一个 MovieClip 时才有效
	 * 			dispName = 自定义数据, 表情对象的名称,方便通过getChildByName找到
	 * 
	 * 		.最简单的例子: "<disp />"	// 显示默认类的默认帧编号, 不指定 data
	 * 
	 * 
	 * 例子如下:
	 * 
		var rt:SRichTextField = new SRichTextField();
		rt.registerClass(TestMC,"tmc");
		rt.htmlText = "asdf asdf asdf<br/>adsf" +
			"asdfasdf as<disp cls='tmc' mcFrame='1' dispName='mcName' />dfa dfasd" +
			"fasdf" +
			"asdfasdfasdfsdf asdf sad fs asdf";
		addChild(rt);
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class SRichTextField extends BaseUIComponent
	{
		public static const TXTFIELD_NAME:String = "txtField";	//文本名
		public static const IMGDISP_NAME:String = "imgDisp";		//文本上面的表情层
		
		public static const ITEM_CLS_UPDATE:String = "item_cls_update";
		
		// 匹配<disp />标签
		static private const REP_TAG_DISP:RegExp 	= /(< *disp.*? *\/>)/gi;
		// 匹配回车
		static private const REP_ENTER:RegExp	= /\r/g;
		// 匹配换标签后空格,图片下的位置
		static public var TAG_DISP_TXT:String			= "";		// 替换文本, 单字符非空格
		static public var REP_TAG_DISP_TXT:RegExp		= new RegExp(TAG_DISP_TXT, "g");
		//
		static private const DEFAULT_CLASS:String = "default class";
		
		private var _txtField:TextField;
		/**
		 * 用于放表情的容器层
		 */
		private var imgDisp:DisplayObjectContainer;
		
		/**
		 * 原字符串
		 */
		private var rawTxt:String;
		/**
		 * 换标签后的字符串
		 */
		private var newTxt:String;
		/**
		 * 标签对象图片列表, 保存了每个图片的信息
		 */
		private var imgTagList:Array;
		
		/**
		 * 注册能用的表情类
		 */
		private var clsMap:Object;
		
		// 缓存显示对象
		private var cacheLink:ClassObjectPool;
		
		/**
		 * 构造带表情功能的文本组件
		 * @param uiVars 皮肤变量，可以是显示对象，也可以是文本
		 */
		public function SRichTextField(txt:TextField=null,cachePool:ClassObjectPool=null)
		{
			cacheLink = cachePool || newCachePool();
			clsMap = {};
			_txtField = txt;
			super();
		}
		
		/**
		 * 初始缓存池
		 * @return 
		 */
		protected function newCachePool():ClassObjectPool
		{
			return new ClassObjectPool();
		}
		
		override protected function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
			
			if(!_txtField)
			{
				if(uiVars is TextField)
				{
					_txtField = uiVars as TextField;
				}
				else
					super.buildSetUI(uiVars);
			
				_txtField = getChildByName(TXTFIELD_NAME) as TextField;
			}
			
			imgDisp = new Sprite();
			imgDisp.x = _txtField.x;
			imgDisp.y = _txtField.y;
			imgDisp.mouseEnabled = imgDisp.mouseChildren = false;
			//表情层要在文本层上面
			var imgId:int = _txtField.parent.getChildIndex(_txtField) + 1;
			_txtField.parent.addChildAt(imgDisp,imgId);
			
			if(_txtField)
			{
				_txtField.addEventListener(TextEvent.TEXT_INPUT, onTextChange);
				_txtField.addEventListener(Event.SCROLL, onTextChange);
			}
		}
		
		/**
		 * 更新文本
		 * @param txt
		 */
		public function update(txt:String):void
		{
			_txtField.text = txt;
		}
		
		public function set htmlText(txt:String):void
		{
			buildTxt(txt);
			_txtField.htmlText = newTxt;
		}
		
		public function get htmlText():String 
		{
			return rawTxt;
		}
		
		/**
		 * 移出所有表情图标
		 */
		public function removeAllImg():void
		{
			while(imgDisp.numChildren){
				var dp:DisplayObject = imgDisp.getChildAt(0);
				disposeImg(dp);
			}
		}
		
		/**
		 * 跟椐文本内容绘制表情
		 */
		override protected function draw():void
		{
			sortTxtTag(_txtField.text);
			
			removeAllImg();
			
			// 设置滚动偏移,... 
			if(_txtField.scrollV > _txtField.maxScrollV) _txtField.scrollV = 1;
			imgDisp.x = _txtField.x;
			imgDisp.y = _txtField.y - getLineYPosition( _txtField.scrollV );
			
			// 得到字符范围, [char0, char1)
			const line0:int = _txtField.scrollV - 1;				// 0-based
			const char0:int = _txtField.getLineOffset( line0 );	// 0-based
			const line1:int = _txtField.bottomScrollV + 1 - 1;	// next line, 0-based
			const char1:int = (line1 >= _txtField.numLines? 0x7fffffff: _txtField.getLineOffset( line1 ));
			
			// 根据 builder 中的每个 item, 建立每个对应的 disp
			for each(var item:TagItem in imgTagList)
			{
				if(item.indexInText<char0 || item.indexInText>=char1) continue;	// 范围之外, 不显示
				
				var txtRect:Rectangle = _txtField.getCharBoundaries(item.indexInText);
				if(!txtRect) continue;
				
				// 根据 item.cls 类名建立 disp
				var clsName:String = item.cls;
				
				var disp:DisplayObject = newImg(clsName);
				if(disp == null) continue;
				
				// 得到 disp 对应的范围 border, 并移动到该位置
				if(! moveToChar(disp, txtRect, item) ) continue;
				
				// 加上一个把事件托管出去的方法,如果帧了方法就可以对当前对象进行解析了
				// 如果指定了fid, 且 disp 是 MovieClip, 则设置帧号
				if(item.mcframe!=0 && (disp is MovieClip))
				{
					(disp as MovieClip).gotoAndStop( item.mcframe );
				}
				dispatchEvent(new RichEvent(ITEM_CLS_UPDATE,[disp,item]));
				
				imgDisp.addChild( disp );
			}
		}
		
		/**
		 * 通过id建立表情
		 * @param clsName
		 */
		protected function newImg(clsName:String):DisplayObject
		{
			clsName = clsName || DEFAULT_CLASS;			// 使用默认类
			var tClass:Class = clsMap[ clsName ];		// 获得构造函数
			if(tClass == null) return null;
			
			var disp:DisplayObject = cacheLink.getObj(tClass) as DisplayObject;
			if(disp == null) disp = new tClass() as DisplayObject;
			return disp;
		}
		
		/**
		 * 移除表情图标
		 * @param dp
		 */
		protected function disposeImg(img:DisplayObject):void
		{
			cacheLink.putInPool(img);
			imgDisp.removeChild(img);
		}
		
		/**
		 * 返回指定行的 y 坐标
		 * 因为每行的行高不一样，所以只能一行行的遍历，计算出y坐标
		 */
		private function getLineYPosition(lineIndex:int):Number
		{
			var ypos:Number = 0;
			for(var i:int=0; i<lineIndex-1; i++){
				ypos += _txtField.getLineMetrics(i).height;
			}
			return ypos;
		}
		
		// 把 disp 移动到字符 charIndex 位置
		private function moveToChar(disp:DisplayObject, rect:Rectangle, itm:TagItem):Boolean
		{
			if(!itm || (!itm.width && !itm.height)){
				// 字体的尺寸由 size 决定, 表示绝对像素宽度, 根据该值, 等比例缩放 disp
				disp.width = rect.width;
				disp.scaleY = disp.scaleX;
			}else{
				disp.width = itm.width;
				disp.height = itm.height;
			}
			if(itm.dispName) disp.name = String(itm.dispName);
			disp.x = rect.x;
			disp.y = rect.y;
			return true;
		}
		
		/**
		 * 跟椐标签建立表情组
		 * @param txt
		 */
		private function buildTxt(txt:String):void
		{
			rawTxt = txt;
			
			// 替换 rep 为空格, 因为 rep 作为保留字使用
			// 替换原文本里面的"　"和"\r" 为 "", 因为回车不使用
			txt = txt.replace(REP_TAG_DISP_TXT, " ");
			txt = txt.replace(REP_ENTER, "");
			
			imgTagList = [];
			
			newTxt = txt.replace(REP_TAG_DISP, onCatchTxt);
		}
		
		/**
		 * 正则表达式替换标签的函数
		 * @param match
		 */
		private function onCatchTxt (match:String, desc:String, index:int, str:String):String
		{
			var itm:TagItem = SparrowUtil.parseXMLByClass(XML(desc),TagItem)
			imgTagList.push( itm );
			return TAG_DISP_TXT;
		};
		
		/**
		 *  排列按 text
		 */
		private function sortTxtTag(text:String):void
		{
			
			// 设置每个项目中的 index 属性
			var iItem:int = 0;
			var index:int = -1;
			while(true)
			{
				index = text.indexOf(TAG_DISP_TXT, index+1);
				if(index < 0) break;
				
				//
				var item:TagItem = imgTagList[ iItem++ ] as TagItem;
				if(item) item.indexInText = index;
			} 
		}
		
		/**
		 * 注册表情类, 如果是第一个类, 则设置为默认类
		 * @param tClass	类对象, 可以为 Class 或者连接类的 constructor
		 * @param name		类名, 在html代码的 "[disp cls=name]"  中指定类名
		 */
		public function registerClass(tClass:Object, name:String=null):void
		{
			if(name == null) name = DEFAULT_CLASS;
			clsMap[name] = tClass;
			if(clsMap[DEFAULT_CLASS] == null) clsMap[DEFAULT_CLASS] = tClass;
		}
		
		// 当文本滚动/输入时
		private function onTextChange(event:Event):void
		{
			invalidateDraw();
//			SparrowUtil.addNextCall(draw);
		}
		
		override public function dispose():void
		{
			clsMap = null;
			imgTagList = null;
			rawTxt = null;
			newTxt = null;
			if(_txtField)
			{
				_txtField.removeEventListener(TextEvent.TEXT_INPUT, onTextChange);
				_txtField.removeEventListener(Event.SCROLL, onTextChange);
			}
			SparrowUtil.clearDisp(imgDisp);
			super.dispose();
		}
		
		/////////////////////////////////
		// get/set
		/////////////////////////////////
		
		/**
		 * 跟椐disp标签里面的dispName找到对象的表情ui
		 */
		public function getImageReference(dispName:String):DisplayObject
		{
			return imgDisp.getChildByName(dispName);
		}
		
		override public function set width(value:Number):void
		{
			_txtField.width = value;
		}
		
		override public function set height(value:Number):void
		{
			_txtField.height = value;
		}
		
		/**
		 *  是否已经注册了表情类
		 */
		public function hasClass(name:String):Boolean{
			return clsMap[name] != null;
		}
		
		/**
		 * 设置缓存的最大容量
		 * @param value
		 */
		public function set cacheSize(value:int):void
		{
			cacheLink.capacity = value;
		}
		
		/**
		 * 缓存的最大容量
		 */
		public function get cacheSize():int 
		{
			return cacheLink.capacity;
		}
		
		override protected function get defaultUIVar():Object
		{
			return "richText";
		}
	}
}

// disp 项目, 负责从 <disp /> 描述中得到 cls/fid/data 的属性值, 并保存该 disp 在文本中的 indexInText 索引
class TagItem{
	public var cls:String;
	public var mcframe:int;		//mc帧
	public var dispName:String;	//显示对象名
	
	public var width:int;
	public var height:int;
	
	// 由外部直接设置
	public var indexInText:int;
	
	//
	public function toString():String{
		return "Item(@" + indexInText + "): cls:" + cls + " fid:" + mcframe + " data:" + dispName;
	}
}
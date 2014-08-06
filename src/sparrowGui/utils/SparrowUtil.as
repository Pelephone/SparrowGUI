package sparrowGui.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.describeType;
	
	/**
	 * 工具包
	 * @author Pelephone
	 */
	public class SparrowUtil
	{
		/// 字符串处理 ///////////
		/**
		 * 转语言包对象字符串缓存对象
		 */
		private static var cacheLangObj:Object;
		
		/**
		 * 通过变量字符设置语言包
		 * 例如{aa}对{bb}说asdf,通过obj的aa,bb属性转成 A对B说asdf
		 */
		public static function langByObj(langStr:String,obj:Object):String
		{
			cacheLangObj = obj;
			var exp:RegExp = /{\w+}/g;
			var reStr:String = langStr.replace(exp, langToken);
			cacheLangObj = null;
			return reStr;
		}
		
		/**
		 * 解析字符
		 */
		private static function langToken(...args):String
		{
			var attr:String = args[0];
			attr = attr.substr(1,attr.length-2);
			var valStr:String = cacheLangObj.hasOwnProperty(attr)?String(cacheLangObj[attr]):"";
			return valStr;
		}
		
		/**
		 * 遍历复制动态对象的动态属性到reObj对象上
		 * @param reObj
		 * @param vars
		 * @param ignoreProps
		 */
		public static function copyDynamicCopy(reObj:Object,dynamicVars:Object,ignoreProps:Array=null):*
		{
			for (var propName:String in dynamicVars)
			{
				if(ignoreProps && ignoreProps.indexOf(propName)>=0) continue;
				setObjectValue(reObj,propName,dynamicVars[propName]);
			}
			return reObj;
		}
		
		/**
		 * 复制对象属性
		 * @param Jobj		要解析的Object对象
		 * @param voClz		要转成的vo对象的类名
		 */
		public static function copyObject(reObj:Object,vars:Object,ignoreProps:Array=null):*
		{
			var desc:XML = describeType( vars );
			// 设置 obj 的每个属性 prop
			for each(var prop:XML in desc.variable)
			{
				var propName:String = prop.@name;			// 变量名
				var propType:String = prop.@type;			// 变量类型
				
				// 忽略了
				if(ignoreProps && ignoreProps.indexOf(propName)>=0) continue;
				setObjectValue(reObj,propName,vars[propName]);
			}
			// 设置 obj 的每个属性 set/get
			for each(prop in desc.accessor)
			{
				propName = prop.@name;			// 变量名
				propType = prop.@type;			// 变量类型
				
				// 忽略了
				if(ignoreProps && ignoreProps.indexOf(propName)>=0) continue;
				setObjectValue(reObj,propName,vars[propName]);
			}
			copyDynamicCopy(reObj,vars,ignoreProps);
			
			return reObj;
		}
		
		/**
		 * 通过属性名,和值,设置对象属性
		 */
		private static function setObjectValue(obj:Object,propName:String,val:*):void
		{
			try
			{
				if(!obj.hasOwnProperty(propName)) return;
				obj[propName] = val;
			} 
			catch(error:Error) 
			{
				trace("设置",obj,"的",propName,"属性有问题!");
				throw error;
			}
		}
		
		/**
		 * 设置按钮中的文字
		 * @param btn		目标按钮
		 * @param text		新的文字, 当为 null 时, 不设置新文本(仅返回原先的文本)
		 * @param isHtml	是否是html文本
		 * @return			返回新的文本内容
		 */
		static public function setButtonText(btn:DisplayObject, text:String=null, isHtml:Boolean = false):String
		{
			//
			var prevText:String = "";
			text = text || "";
			
			//
			var list:Array = [ btn["upState"], btn["downState"], btn["overState"], btn["hitTestState"],btn];
			if(btn.hasOwnProperty("selectState")) list.push(btn["selectState"]);
			if(btn.hasOwnProperty("disableState")) list.push(btn["disableState"]);
			for each(var disp:DisplayObject in list)
			{
				var tf:TextField = disp as TextField;
				if(tf == null){
					var cont:DisplayObjectContainer = disp as DisplayObjectContainer;
					if(cont) tf = findChild(cont, TextField) as TextField;
				}
				if(tf){
					if(isHtml){
						tf.htmlText = text;
					}else{
						tf.text = text;
					}
					prevText = tf.text;
				} 
			}
			
			//
			return text || prevText;
		}
		
		/**
		 * 返回指定类型的孩子
		 * @param node		被寻找的父节点
		 * @param tClass	子类孩子的过滤, 如果为 null, 则返回第一个孩子
		 */
		static public function findChild(node:DisplayObjectContainer, tClass:Class=null):DisplayObject
		{
			if(tClass == null) tClass = DisplayObject;
			for(var i:int=0; i<node.numChildren; i++){
				var disp:DisplayObject = node.getChildAt(i);
				if(disp is tClass) return disp;
			}
			return null;
		}
		
		
		/**
		 * 清除容器里面的所有显示对象
		 * @param s
		 */		
		static public function clearDisp(s:DisplayObjectContainer):void
		{
			if(s) while(s.numChildren) s.removeChildAt(0);
		}
		
		////////////////////////////////////////////////
		// xml解析部分
		///////////////////////////////////////////////
		
		/**
		 * 将xml上的属性信息解析到单个对象
		 * @param xml			要解析的xml
		 * @param obj	  		要将xml解析到对象类
		 * @param ignoreProps	忽略的属性名列表
		 * @return 
		 */		
		static public function parseXMLItem(xml:Object, obj:Object, ignoreProps:Array=null):*
		{
			if(xml) xml = xml[0];		// 调整到子结点
			if(xml==null || !XML(xml).length()) return;
			
			var desc:XMLList = describeType( obj )["variable"];
			// 设置 obj 的每个属性 prop
			for each(var prop:XML in desc)
			{
				var propName:String = prop.@name;			// 变量名
				var propType:String = prop.@type;			// 变量类型
				
				// 忽略了
				if(ignoreProps && ignoreProps.indexOf(propName)>=0) continue;
				
				var list:XMLList = xml.attribute(propName);
				// 先判断是否有此属性,没有再判断是否有些节点
				if(!list.length()) list = xml.child(propName);
				// 如果无节点或者节点是数组则不解析
				if(!list.length() || list.length()>1) continue;
				
				switch(propType)
				{
					// 基本类型
					case "Boolean":
						obj[propName] = Boolean(int(list))
						break;
					case "int":
					case "uint":
					case "String":
					case "Number":
					{
						obj[propName] = list;		// 变量名 和 xml节点名 必须相同 
					}
						break;
				}
			}
			return obj;
		}
		
		/**
		 * 解析xml并生成新的对象返回
		 * @param xml		  要解析的xml
		 * @param tClass	  要将xml解析生成的类
		 * @param ignoreProps 忽略的属性名列表
		 * @return 
		 */		
		static public function parseXMLByClass(xml:Object, tClass:Class, ignoreProps:Array=null):*
		{
			if(xml) xml = xml[0];		// 调整到子结点
			if(xml==null || !XML(xml).length()) return;
			var obj:Object = new (tClass)();
			parseXMLItem(xml,obj,ignoreProps);
			return obj;
		}
		
		/**
		 * 将xml解析到数组对象里面,不包括子节点
		 * @param xmlList
		 * @param defaultClass
		 * @param ignoreProps
		 * @return 
		 */		
		static public function parseXMLList(xmlList:XMLList, defaultClass:Class, ignoreProps:Array=null):Array
		{
			if(xmlList==null || defaultClass==null) return null;
			var arr:Array = new Array;
			for each(var xml:XML in xmlList)
			{
				var obj:Object = parseXMLByClass(xml, defaultClass, ignoreProps);
				arr.push( obj ); 
			}
			return arr;
		}
		
		//////////////////////////////////////////
		// 下帧播放方法
		/////////////////////////////////////////
		
		
		private static var _shape:Shape = new Shape();
		
		/**
		 * 下帧执行的方法,用个数组来存是为了不让同一下帧方法执行两次或多次
		 */
		private static const nextFuncLs:Vector.<Function> = new Vector.<Function>();
		/**
		 * 缓存当前正在处理的函数列
		 */
		private static var curFuncLs:Vector.<Function> = new Vector.<Function>();
		
		/**
		 * 下帧调用某方法(同一方法添加多次，下帧也只会执行一次)<br/>
		 * 此方法可以提示图形解析效率。如数据改变很多次，只会在下帧对视图进行一次解析
		 * @param backFun
		 * @param isSafeCall 是否安全添加,为真的话如果当前帧已有要添方法则不添下帧执行,可防止无限递归；<br/>
		 * 					 如果为假则忽略当帧是否有同样方法，为假时要注意小心无限递归
		 */
		public static function addNextCall(backFun:Function,isSafeCall:Boolean=true):void
		{
			var tid:int = curFuncLs.indexOf(backFun);
			// 过滤当前帧函数是为了防止无限下帧递回
			if(tid>=0 && isSafeCall)
			{
				if(tid<=curFunIndex)
					curFunIndex = curFunIndex - 1;
				
				// 移至队尾
				curFuncLs.splice(tid,1);
				curFuncLs.push(backFun);
				return;
			}
			
			if(nextFuncLs.indexOf(backFun)>=0)
				return;
			
			if(!nextFuncLs.length)
				_shape.addEventListener(Event.ENTER_FRAME,onNextTransit);
			
			nextFuncLs.push(backFun);
		}
		
		/**
		 * 当前帧执行到了第N条函数
		 */
		private static var curFunIndex:int;
		
		/**
		 * 调用下帧执行的方法中转
		 */
		private static function onNextTransit(e:Event):void
		{
			curFuncLs = nextFuncLs.splice(0,nextFuncLs.length);

			for (curFunIndex = 0; curFunIndex < curFuncLs.length; curFunIndex++) 
			{
				var fun:Function = curFuncLs[curFunIndex] as Function;
				fun.apply(null,[]);
			}
			
			curFuncLs.splice(0,curFuncLs.length);
			
			if(nextFuncLs.length == 0)
				_shape.removeEventListener(Event.ENTER_FRAME,onNextTransit);
		}
		
		
		/**
		 * 使显示对象加入舞台后执行一次toStageFun方法<br/>
		 * 此方法可减轻显示对象初始的压力<br/>
		 * 如果显示对象有很多对象要创建时，new出的时候并不创建，而在显示对象放入舞台时才创建
		 * @param disp 显示对象
		 * @param toStageFun 加入舞台方法
		 */
		public static function addSkinInit(dsp:DisplayObject,toStageFun:Function):void
		{
			if(dsp.stage)
			{
				toStageFun.apply(null,[]);
				return;
			}
			dsp.addEventListener(Event.ADDED_TO_STAGE,onSkinToStage);
			// 监听舞台加入舞台时的事件，用监听函数存可以不用管回收
			function onSkinToStage(e:Event):void
			{
				dsp.removeEventListener(Event.ADDED_TO_STAGE,onSkinToStage);
				toStageFun.apply(null,[]);
			}
		}
		
		/**
		 * 监听显示对象的加入舞台和移出舞台事件(注，此方法是没有回收的,监听了就没法取消)
		 * @param dsp 被监听的显示对象
		 * @param inStageCall 加入舞台时执行的方法
		 * @param outStageCall 移出舞台时执行的方法
		 */
		public static function addSkinStageInOut(dsp:DisplayObject,inStageCall:Function,outStageCall:Function):void
		{
			dsp.addEventListener(Event.ADDED_TO_STAGE,onSkinInStage);
			// 监听加入和移除舞台处理，用监听函数存可以不用管回收
			function onSkinInStage(e:Event):void
			{
				dsp.removeEventListener(Event.ADDED_TO_STAGE,onSkinInStage);
				dsp.addEventListener(Event.REMOVED_FROM_STAGE,onOut);
				inStageCall.apply(null,[]);
			}
			function onOut(e:Event):void
			{
				dsp.addEventListener(Event.ADDED_TO_STAGE,onSkinInStage);
				dsp.removeEventListener(Event.REMOVED_FROM_STAGE,onOut);
				outStageCall.apply(null,[]);
			}
		}
		
		
		/**
		 * 按行列二维排列容器里的项,先从左到右，再从上到下排.<br/>
		 * 此方法能实现水平，垂直，流水所有这些有规律的布局
		 * 
		 * @param targetGroup 要排列布局的对象组
		 * @param perColNum 每列有x项,如果为0则一排,横排
		 * @param colWidth 每列的列宽,如果为0则按item的宽度自动排列,即列宽==项宽
		 * @param rowHeight 每列的列高度,如果为0则按item的高度自动向下排列,即行高==项高
		 */
		public static function layoutUtil(targetGroup:Object,perColNum:int=1,
											 colWidth:int=0,rowHeight:int=0,spacing:int=0):void
		{
			var tmpY:int=0,tmpX:int=0;
			var i:int = 0;
			var lineHeight:int;	//其中一行子项高度最高的项高
			for each (var dp:Object in targetGroup) 
			{
				if(i && !(i%perColNum) && perColNum!=0)
				{
					tmpY = tmpY + spacing + (rowHeight?rowHeight:lineHeight);
					tmpX = 0;
					lineHeight = dp.height;
				}
				if(colWidth>=0)
					dp.x = tmpX;
				tmpX = tmpX + (colWidth || dp.width) + spacing;
				if(rowHeight>=0)
					dp.y = tmpY;
				if(dp.height>lineHeight)
					lineHeight = dp.height;
				i++;
			}
		}
	}
}
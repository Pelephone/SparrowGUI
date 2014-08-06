package sparrowGui.components
{
	import asCachePool.interfaces.IRecycle;
	import asCachePool.interfaces.IReset;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import sparrowGui.SparrowMgr;
	import sparrowGui.components.base.BaseUIComponent;
	import sparrowGui.components.item.SButton;
	import sparrowGui.event.AlertEvent;
	import sparrowGui.i.IItem;
	
	/** 关闭警告窗 */
	[Event(name="alert_close", 	type="sparrowGui.event.AlertEvent")]
	/** 警告更新窗 */
	[Event(name="alert_update", 	type="sparrowGui.event.AlertEvent")]
	/**
	 * 警告窗
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class SAlert extends BaseUIComponent implements IReset,IRecycle
	{
		/**
		 * 按钮默认字
		 */
		private static const BTN_DEFAULT_STRING:String = "ok";
		/**
		 * 按钮前缀
		 */
		private static const BTN_PREFIX:String = "btn_prefix$";
//		private var _btnCls:Class;
		
		// 半透明背景
		private var translucent:DisplayObject;
		
		
		/**
		 * 按钮哈希对象<String,IItem>
		 */
		private var btnMap:Object;
		
		/**
		 * 项创建工厂
		 
		private var btnFactory:IItemFactory;*/
		
		//提示窗文字文本
		private var txtAlert:TextField;
		//动态按钮坐标
		private var posBtn:Point;
		/**
		 * 背景
		 */
		private var bg:DisplayObject;
		//提示输入文本
		private var txtInput:TextField;
		
		/**
		 * 构造提示窗
		 * @param argSkin
		 */
		public function SAlert(uiVars:Object=null)
		{
			translucent = newTranslucent();
			super(uiVars || defaultUIVar);
			reset();
		}
		
		override protected function buildSetUI(uiVars:Object=null):void
		{
			super.buildSetUI(uiVars);
			btnMap = {};
			btnStrArr = Vector.<String>([BTN_DEFAULT_STRING]);
			
			txtAlert = getChildByName("txtAlert") as TextField;
			txtInput = getChildByName("txtInput") as TextField;
			bg = getChildByName("bg");
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setUiStyle(uiVars:Object=null):void
		{
			super.setUiStyle(uiVars);
			
			var posDsp:DisplayObject = getChildByName("posBtn");
			if(posDsp)
			{
				posBtn = new Point(posDsp.x,posDsp.y);
				posDsp.parent.removeChild(posDsp);
			}
		}
		
		/**
		 * 监听鼠标事件
		 */
		protected function onBtnClick(e:MouseEvent):void
		{
			var btnName:String = e.target.name;
			
			if(btnName.indexOf(BTN_PREFIX)==0)
			{
				var btnIndex:int = int(btnName.replace(BTN_PREFIX,""));
				close(btnIndex);
			}
		}
		
		/**
		 * 更新
		 * @param data
		 */
		public function update(data:Object):void
		{
			if(txtAlert)
				txtAlert.text = String(data);
			
			dispatchEvent(new AlertEvent(AlertEvent.ALERT_UPDATE));
		}
		
		/**
		 * 弹出警告窗
		 * @param alertTxt
		 * @param btnStr
		 * @param backFun 此方法是一次性的，窗体关闭后会立刻回收删除
		 */
		public function show(alertTxt:Object,btnStr:String="确定",backFun:Function=null):void
		{
			if(!btnStr)
				btnStr = BTN_DEFAULT_STRING;

			btnStrArr = Vector.<String>(btnStr.split("|"));
			
			parentContainer.addChild(translucent);
			parentContainer.addChild(this);
			invalidateDraw();
			update(alertTxt);
			
			if(backFun==null)
				return;
			
			addEventListener(AlertEvent.ALERT_CLOSE,backCall);
			
			function backCall(e:Event):void
			{
				removeEventListener(AlertEvent.ALERT_CLOSE,backCall);
				backFun.apply(null,[e]);
			}
		}
		
		/**
		 * 重设新的显示父类，并将警告窗显示上去
		 * @param newParent
		 */
		public function showToParent(newParent:DisplayObjectContainer=null):void
		{
			if(newParent)
				parentContainer = newParent;
			
			parentContainer.addChild(translucent);
			parentContainer.addChild(this);
		}
		
		/**
		 * 跟dispose不同，close只是关掉，并不断开引用
		 * @param index 点第N个按钮关闭
		 */
		public function close(index:int=0):void
		{
			if(translucent.parent)
				translucent.parent.removeChild(translucent);
			
			if(this.parent)
				this.parent.removeChild(this);
			
			removeAllBtns();
			
			var inpTxt:String = (txtInput)?txtInput.text:null;
			dispatchEvent(new AlertEvent(AlertEvent.ALERT_CLOSE,index,inpTxt));
		}
		
		/**
		 * 通过字符数据生成按钮
		 */
		public function updateBtns():void
		{
			btnMap = {};
			
			var itm:IItem;
			for each (itm in btnMap) 
			{
				SparrowMgr.removeInCLsCache(itm);
			}
			
			
			for (var i:int = 0; i < btnStrArr.length; i++) 
			{
				itm = newBtn();
				itm.name = BTN_PREFIX + i;
				itm.data = btnStrArr[i];
				btnMap[itm.name] = itm;
				
				if(!posBtn) continue;
				var itmSkin:DisplayObject = itm as DisplayObject;
				if(!itmSkin)
					return;
				addChild(itmSkin);
				var lx:int = itmSkin.width*btnStrArr.length*0.5 + spacing*(btnStrArr.length-1)*0.5;
				itmSkin.x = posBtn.x - lx + (itmSkin.width+spacing)*i;
				itmSkin.y = posBtn.y - itmSkin.height;
			}
		}
		
		/**
		 * 移除所有警告窗按钮
		 */
		private function removeAllBtns():void
		{
			for each (var item:IItem in btnMap) 
			{
//				btnFactory.disposeItem(itm);
				
				if(item is IRecycle)
					(item as IRecycle).dispose();
				
				SparrowMgr.removeInCLsCache(item);
			}
			btnMap = {};
		}
		
		/**
		 * 创建半透明背景层
		 * @return 
		 */
		protected function newTranslucent():DisplayObject
		{
			return SparrowMgr.getIns().screenDrawLayer;
		}
		
		/**
		 * 按钮类型
		 */
		public var btnClass:Class = SButton;
		
		/**
		 * 从缓存链表中生成item
		 * @return 
		 */
		protected function newBtn():IItem
		{
			return SparrowMgr.getAndCreatePoolObj(btnClass);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			if(isRendering)
			{
				if(bg)
				{
					bg.width = _width;
					bg.height = _height;
				}
				if(posBtn)
				{
					posBtn.x = _width * 0.5;
				}
				var padding:int = 5;
				if(txtAlert)
				{
					txtAlert.x = padding;
					txtAlert.y = padding;
					txtAlert.width = _width - padding*2;
				}
				if(txtInput)
				{
					txtInput.x = padding;
					txtInput.y = padding;
					txtInput.width = _width - padding*2;
				}
				
				updateBtns();
				
				// 将皮肤居中显示
//				translucent.width = SparrowMgr.stageWidth;
//				translucent.height = SparrowMgr.stageHeight;
				this.x = SparrowMgr.stageWidth*0.5 - this.width*0.5;
				this.y = SparrowMgr.stageHeight*0.5 - this.height*0.5;
			}
			super.draw();
		}
		
		///////////////////////////////////
		// get/set
		//////////////////////////////////
		
		
		override protected function get defaultUIVar():Object
		{
			return "alert";
		}
		
		protected function getTranslucentDefaultUI():String
		{
			return "translucent";
		}
		
		public function reset():void
		{
			addEventListener(MouseEvent.CLICK,onBtnClick);
		}

		/**
		 * 断开引用并回收
		 */
		override public function dispose():void
		{
			removeEventListener(MouseEvent.CLICK,onBtnClick);
			close();
			super.dispose();
		}
		
		//---------------------------------------------------
		// get/set
		//---------------------------------------------------
		
		/**
		 * 警告窗是否显示
		 */
		public function get isShow():Boolean 
		{
			return parent!=null;
		}
		
		private var _btnStrArr:Vector.<String>;
		
		/**
		 * 用于生成按钮的字符数组
		 */
		public function get btnStrArr():Vector.<String>
		{
			return _btnStrArr;
		}
		
		/**
		 * @private
		 */
		public function set btnStrArr(value:Vector.<String>):void
		{
			if(_btnStrArr == value)
				return;
			
			_btnStrArr = value;
		}
		
		private var _parentContainer:DisplayObjectContainer;

		/**
		 * 父级容器 
		 */
		public function get parentContainer():DisplayObjectContainer
		{
			return _parentContainer || SparrowMgr.tipLayer || SparrowMgr.mainDisp;
		}

		/**
		 * @private
		 */
		public function set parentContainer(value:DisplayObjectContainer):void
		{
			_parentContainer = value;
		}
		
		private var _spacing:int = 5;
		
		/**
		 * @private
		 */
		public function set spacing(value:int):void
		{
			_spacing = value;
		}
		
		/**
		 * 按钮间距
		 */
		public function get spacing():int
		{
			return _spacing;
		}
		
/*		private var _autoClose:Boolean = true;		//是否自动关闭。
		
		public function get autoClose():Boolean
		{
			return _autoClose;
		}

		public function set autoClose(value:Boolean):void
		{
			_autoClose = value;
		}*/
		
/*		public function set BtnClass(value:Class):void 
		{
			btnFactory.itemClass = value;
		}
		
		public function get BtnClass():Class 
		{
			return btnFactory.itemClass;
		}
		
		public function set BtnSkinClass(value:Class):void 
		{
			btnFactory.itemClass = value;
		}
		
		public function get BtnSkinClass():Class 
		{
			return btnFactory.itemClass;
		}*/
		
		/**
		 * 设置默认输入文本
		 * @param value
		 */
		public function set inputStr(value:String):void 
		{
			if(txtInput)
				txtInput.text = value;
		}
	}
}

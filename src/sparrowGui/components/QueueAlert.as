package sparrowGui.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import sparrowGui.SparrowMgr;
	import sparrowGui.event.AlertEvent;
	
	/**
	 * 队列警告弹窗管理.
	 * 能弹窗组件是单例的,即当场景只会弹一个,如果是多个提示信息会轮流弹窗
	 * 
	 * 例子如下
	 * 
	 * // 使用前先初始单例
	 *  new QueueAlert(this);
		
		btn.addEventListener(MouseEvent.CLICK,onBtnClick);
		function onBtnClick(e:MouseEvent):void
		{
			QueueAlert.getIns().alertYesNo("asd22f",back);
		}
		
		function back(e:AlertEvent):void
		{
			trace(e);
		}
	 * 
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class QueueAlert
	{
		protected static var instance : QueueAlert; 
		/**
		 * 警告窗数据队列,这里用静态.[SAlert]
		 */
		private var alertQueue:Vector.<SAlert>;
		/**
		 * 当前弹窗对象
		 
		private var _curAlert:SAlert;*/
		/**
		 * 默认使用的弹窗警告
		 */
		private var _defaultAlert:SAlert;

		
		/**
		 * 通过提示窗皮肤和你容器构造警告窗体
		 * @param showParent 显示到容器
		 * @param alertUiVars 警告窗皮肤变量
		 * @param itemFactory 子项工厂，用于创建子项和子项皮肤，工厂里还有缓存的功能
		 */
		public function QueueAlert(showParent:DisplayObjectContainer=null
								   ,alertUiVars:Object=null)
		{
			if (instance != null) throw Error("此单例已经存在了");
			
			alertQueue = new Vector.<SAlert>();
//			btnFactory = itemFactory || new ItemFactory(AlertButton);
			
//			defaultSkin = UIStyleCss.getInstance().createStyleSkin("alert");
			parentCont = showParent || SparrowMgr.tipLayer || SparrowMgr.mainDisp;
			_defaultAlert = new SAlert(alertUiVars);
			_defaultAlert.parentContainer = showParent;
			
			instance = this;
		}
		
		//获取单例
		public static function getIns():QueueAlert
		{
			if (instance == null) instance = new QueueAlert( );
			return instance;
		}
		
		/**
		 * 窗体关闭时数值还有警告数据就提示下一项
		 * @param e
		 */
		private function onAlertClose(e:AlertEvent):void
		{
			var alt:SAlert = e.currentTarget as SAlert;
			alt.removeEventListener(e.type, onAlertClose);
			_curAlert = null;
			
			showNext();
		}
		
		/**
		 * 显示下一警告窗
		 */
		private function showNext():void
		{
			if(!alertQueue.length)
				return;
			showAlert(alertQueue.shift());
		}
		
		/**
		 * 提示下一组警告信息(不管上一显示对象是否提示完，强行警告下一弹窗)
		 */
		public function callNext():void
		{
			if(_curAlert)
				_curAlert.close();
			
			showNext();
		}
		
		/**
		 * 只有一个确定按钮的提示框
		 * @param txt 弹窗文本内容
		 * @param backFun 点击按钮时返回接收函数
		 */
		public static function alertOk(txt:String,backFun:Function=null):SAlert
		{
			return getIns().alert(txt,backFun,"确定");
		}
		
		/**
		 * 选择按钮提示框
		 * @param txt 弹窗文本内容
		 * @param backFun 点击按钮时返回接收函数
		 */
		public static function alertYesNo(txt:String,backFun:Function=null):SAlert
		{
			return getIns().alert(txt,backFun,"确定|取消");
		}
		
		/**
		 * 输入文本弹窗
		 * @param txt 弹窗文本内容
		 * @param backFun 点击按钮时返回接收函数
		 * @param defaultStr 默认输入文本里面的文字
		 
		public function alertInput(txt:String,backFun:Function=null,defaultStr:String="请输入数字",btnStr:String="确定"):SAlert
		{
			var alt:SAlert = alert(txt,backFun,btnStr);	
			alt.inputStr = defaultStr;
			return alt;
		}*/
		
		/**
		 * 加按钮参数的警告
		 * @param txt 弹窗文本内容
		 * @param backFun 点击按钮时返回接收函数
		 * @param btnStr 按钮上的文字，用"|"分隔按钮
		 */
		public function alert(txt:String,backFun:Function=null,btnStr:String="确定"):SAlert
		{
			if(!_curAlert && _defaultAlert)
			{
				_defaultAlert.show(txt,btnStr,backFun);
				_defaultAlert.addEventListener(AlertEvent.ALERT_CLOSE,onAlertClose);
				_curAlert = _defaultAlert;
				return _curAlert;
			}
			
			var alt:SAlert = new SAlert();
			alt.parentContainer = parentCont;
			alt.update(txt);
			if(backFun!=null)
				alt.addEventListener(AlertEvent.ALERT_CLOSE,backFun);
//				alt.addCloseCall(backFun);
			alt.btnStrArr = Vector.<String>(btnStr.split("|"));
			alertQueue.push(alt);
			return alt;
		}
		
		/**
		 * 通过alert对象加入警告提示
		 * @param alert
		 */
		public function showAlert(alert:SAlert):SAlert
		{
			if(!_curAlert)
			{
				alert.showToParent(parentCont);
				alert.addEventListener(AlertEvent.ALERT_CLOSE,onAlertClose);
				_curAlert = alert;
				return alert;
			}
			alertQueue.push(alert);
			return alert;
		}
		
		//---------------------------------------------------
		// get/set
		//---------------------------------------------------
		
		private var _curAlert:SAlert;

		/**
		 * 当前弹窗对象
		 */
		public function get curAlert():SAlert
		{
			return _curAlert;
		}

		/**
		 * 当前弹窗对象
		 * @return 
		 
		private function get curAlert():SAlert
		{
			if(alertQueue.length==0)
				return null;
			else
				return alertQueue[0];
		}*/
		
		private var _parentCont:DisplayObjectContainer;

		/**
		 * 提示窗要显示到的父容器
		 */
		public function get parentCont():DisplayObjectContainer
		{
			return _parentCont;
		}

		/**
		 * @private
		 */
		public function set parentCont(value:DisplayObjectContainer):void
		{
			_parentCont = value;
		}
		
		/**
		private var _btnFactory:IItemFactory;
		
		
		 * 项创建工厂
		 
		public function get btnFactory():IItemFactory
		{
			return _btnFactory;
		}*/
		
		/**
		 * @private
		 
		public function set btnFactory(value:IItemFactory):void
		{
			_btnFactory = value;
		}*/
		
		private var _defaultSkin:DisplayObject;
		
		/**
		 * 默认警告窗皮肤
		 */
		public function get defaultSkin():DisplayObject
		{
			return _defaultSkin;
		}
		
		/**
		 * @private
		 */
		public function set defaultSkin(value:DisplayObject):void
		{
			_defaultSkin = value;
		}
	}
}
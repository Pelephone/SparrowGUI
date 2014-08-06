package sparrowGui
{
	import asCachePool.ClassObjectPool;
	import asCachePool.interfaces.IReset;
	
	import flash.display.Sprite;
	
	import sparrowGui.components.FullScreenDraw;

	/**
	 * 本GUI的配置文件，某些组件需要通过此单例的舞台信息等。
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 * @email pelephone@163.com
	 */	
	public class SparrowMgr
	{
		////////////////////////////////////////
		// 静态参数
		////////////////////////////////////////
		
		public static var version:Number = 2.01;
		
		/**
		 *  纵向滚动
		 */
		public static const HORIZONTAL:String = "horizontal";
		
		/**
		 *  横向滚动
		 */
		public static const VERTICAL:String = "vertical";
		
		/**
		 * 滚动条的最小宽/高度(上下按钮高相加)
		 */		
		public static const MIN_SCROLL_VALUE:int = 28;
		/**
		 * 中轴最小宽/高度
		 */
		public static const MIN_SLIDER_VALUE:int = 8;
		/**
		 * 延迟x秒跑快速移动
		 */
		public static const DELAY_WAIT_TIME:int = 500;
		
		/**
		 * 主容器
		 */
		public static var mainDisp:Sprite;
		/**
		 * 提示层
		 */
		public static var tipLayer:Sprite;
		
		/**
		 * 用于遮挡鼠标点击事件的层
		 */
		public var screenDrawLayer:FullScreenDraw;
		
		public static var stageWidth:int;
		public static var stageHeight:int;
		
		protected static var instance : SparrowMgr; 
		
		/**
		 * 类缓存工具,用于缓存class生成的对象 
		 */
		private var classCache:ClassObjectPool;
		
		/**
		 * 使用本组件必须先初始相关参数
		 * @param s		舞台显示对象，警告窗组件用于addchild显示对象等用到
		 * @param sw	窗体宽,窗组件移动范围用到
		 * @param sh	窗体高,窗组件移动范围用到
		 * @uiManger	UI样式管理器
		 */
		public function SparrowMgr(s:Sprite=null,sw:int=500,sh:int=500)
		{
			if (instance != null) throw Error("此单例已经存在了");
//			if (s == null) throw Error("不能为空");
			mainDisp = s;
			stageWidth = sw;
			stageHeight = sh;
			
//			uiMgr = uiManger || new UIMgr();
			instance = this;
			
			init();
		}
		
		//获取单例
		public static function getIns():SparrowMgr {
			if (instance == null) instance = new SparrowMgr( );
			return instance;
		}
		
		protected function init():void
		{
			screenDrawLayer = new FullScreenDraw();
			classCache = new ClassObjectPool();
		}
		
		/**
		 * 将类生成的应实例对象放入缓存池
		 * @param obj 要存到池里面的对象
		 * @param key 存的对象主键，如果为空则会以obj对象的反射路径做为主键放入
		*/
		public static function removeInCLsCache(obj:Object,key:String=null):void
		{
			getIns().classCache.putInPool(obj,key);
		}
		
		/**
		 * 通过类从池获取创建对象,无则new一个生成
		 * @param clzKey
		 * @param args
		 */
		public static function getAndCreatePoolObj(clzKey:Object,...args):*
		{
			var ins:SparrowMgr = getIns();
			var res:* = ins.classCache.getObj(clzKey);
			if(!res && clzKey is Class)
				return ins.classCache.construct((clzKey as Class),args);
			
			if(res && res is IReset)
				(res as IReset).reset();
			
			return res;
		}
		
		/**
		 * 通过类型或者主键名从池里取出对象的实例
		 * @param clzKey 类类型,或者主键名
		 */
		public static function getPoolObj(clzKey:Object):*
		{
			return getIns().classCache.getObj(clzKey);
		}
	}
}

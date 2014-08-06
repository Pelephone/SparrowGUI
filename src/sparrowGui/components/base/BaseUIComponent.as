package sparrowGui.components.base
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import sparrowGui.event.ComponentEvent;
	import sparrowGui.i.ISkinChanger;
	import sparrowGui.uiStyle.UIStyleCss;
	import sparrowGui.utils.SparrowUtil;
	
	/** 缓制组件 */
	[Event(name="draw", type="sparrowGui.event.ComponentEvent")]
	/**
	 * 基本模块,基本UI适配器
	 * 主要设计思路是初始的时间将皮肤放入,然后对皮肤显示对象增加控制的事件的操作.
	 * 就将插件一样,想给皮肤什么功能就用插件直接插上去.
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class BaseUIComponent extends RichSprite implements ISkinChanger
	{
		/**
		 * 马上绘制一次
		 */
		public static const GO_DRAW:String = "go_draw";
		
		public function BaseUIComponent(uiVars:Object=null)
		{
			super();
			buildSetUI(uiVars || defaultUIVar);
			setUiStyle(uiVars || defaultUIVar);
		}
		
		/**
		 * 通过皮肤变量构造组件
		 * 如果输入的皮肤的parent皮肤为空的话会把皮肤addChild到本组件里面，反之不会addChild
		 * @param uiVars	支持三种类型(如果是DisplayObject就直接设为皮肤,字符串就会查皮肤表，空会生成默认皮肤)
		 */
		protected function buildSetUI(uiVars:Object=null):void
		{
			// 生成默认皮肤
			if(uiVars is DisplayObjectContainer)
			{
				var dc:DisplayObjectContainer = uiVars as DisplayObjectContainer;
				for (var i:int = 0; i < dc.numChildren; i++) 
				{
					var itm:DisplayObject = dc.getChildAt(i);
					addChild(itm);
				}
			}
			else if(uiVars is String)
			{
				UIStyleCss.getInstance().decodeBuildStyle(String(uiVars),this);
			}
		}
		
		
		/**
		 * 设置UI样式
		 * @param 样式名，或者样式对象，如果为空表示还原默认样式
		 */
		public function setUiStyle(uiVars:Object=null):void
		{
			var uiCss:UIStyleCss = UIStyleCss.getInstance();
			if(uiVars is String)
				uiCss.decodeSetStyle(String(uiVars),this);
			invalidateDraw();
		}
		
		/**
		 * 改变UI样式
		 * @param uiVars
		 */
		public function changeUI(uiVars:Object=null):void
		{
			dispose();
			buildSetUI(uiVars);
		}
		
		/**
		 * 验证重绘,会在下帧渲染的时候调用draw方法
		 */
		public function invalidateDraw(args:*=null):void
		{
			if(isRendering)
				return;
			// 不在舞台上就不渲染
			isRendering = true;
			if(isNextRender)
				SparrowUtil.addNextCall(draw);
			else
				draw();
		}
		
		/**
		 * 跟椐数据绘制组件(一般会结合下帧执行方法调用)
		 */
		protected function draw():void
		{
			if(isRendering)
			{
				isRendering = false;
				dispatchEvent(new ComponentEvent(ComponentEvent.DRAW));
			}
		}
		
		//---------------------------------------------------
		// get/set
		//---------------------------------------------------
		
		/**
		 * 获取默认皮肤名字，用于通过UI管理查找默认样式
		 * @return 
		 */
		protected function get defaultUIVar():Object
		{
			return "component";
		}
		
		/**
		 * 是否正在渲染(为下帧渲染使用)
		 */
		protected var isRendering:Boolean = false;
		/**
		 * 是否延迟渲染
		 */
		protected var isNextRender:Boolean = true;
		
		//---------------------------------------------------
		// 宽width
		//---------------------------------------------------
		
		protected var _width:int;

		override public function set width(value:Number):void
		{
			if(_width == value)
				return;
			
			_width = value;
			invalidateDraw();
		}
		
		override public function get width():Number
		{
			if(isRendering || super.width==0)
				return _width;
			else
				return super.width;
		}
		
		//---------------------------------------------------
		// 高height
		//---------------------------------------------------
		
		protected var _height:int;

		override public function set height(value:Number):void
		{
			if(_height == value)
				return;
			_height = value;
			invalidateDraw();
		}

		override public function get height():Number
		{
			if(isRendering || super.height==0)
				return _height;
			else
				return super.height;
		}

		
		//---------------------------------------------------
		// enabled
		//---------------------------------------------------
		
		protected var _enabled:Boolean = true;
		
		/**
		 * 是否可用
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}

		/**
		 * @private
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			this.mouseEnabled = value;
		}
	}
}
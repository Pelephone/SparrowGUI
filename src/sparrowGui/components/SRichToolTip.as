package sparrowGui.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import sparrowGui.data.ToolTipVO;
	import sparrowGui.event.ItemEvent;
	
	/**
	 * 富文本的提示工具,相比toolTip增加了表情功能
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class SRichToolTip extends SToolTip
	{
		/**
		 * 表情文本控件
		 */
		private var _richTxt:SRichTextField;
		/**
		 * 提示面板哈希数据，主键是目标按钮，值是对应面板<DisplayObject,ToolTipVO>
		 */
		protected var tipInfMap:Dictionary;
		
		/**
		 * 构造富文本提示工具
		 * @param showParent 用于显示提示窗的父类
		 * @param uiVars 皮肤变量
		 */
		public function SRichToolTip()
		{
			tipInfMap = new Dictionary();
			super();
			_richTxt = new SRichTextField(txtTip);
		}
		
		/**
		 * 加入特殊背景的提示面板
		 * @param tarDisp 目标提示按钮
		 * @param data 数据
		 * @param skinPan 皮肤面板
		 */
		public function addRichTip(tarDisp:DisplayObject,data:Object=null,skinPan:DisplayObject=null,parseFun:Function=null):void
		{
			// 暂时没想到要怎么实现
			targetMap[tarDisp] = data;
			var tipvo:ToolTipVO = new ToolTipVO();
			tipvo.tipData = data;
			tipvo.targetDisp = tarDisp;
			tipvo.parseFunction = parseFun;
			tipvo.tipSkin = skinPan;
			tipInfMap[tarDisp] = tipvo;
			tarDisp.addEventListener(MouseEvent.MOUSE_OVER,onRichOverEvt);
		}
		
		public function removeRichTip(tarDisp:DisplayObject):void
		{
			var tipvo:ToolTipVO = targetMap[tarDisp];
			tipvo.parseFunction = null;
			tipvo.targetDisp  = null;
			tipvo.tipData = null;
			tipvo.tipSkin = null;
			delete targetMap[tarDisp];
		}
		
		private function onRichOverEvt(e:MouseEvent):void
		{
			var currentTarget:DisplayObject = e.currentTarget as DisplayObject;
			var tipvo:ToolTipVO = targetMap[currentTarget];
			if(tipvo && tipvo.tipData && tipvo.tipSkin && tipvo.parseFunction!=null)
				tipvo.parseFunction.apply(null,[tipvo.tipData,tipvo.tipSkin]);
			else
			{
				show(currentTarget);
			}
			dispatchEvent(new ItemEvent(ItemEvent.ITEM_UPDATE));
			show(currentTarget);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set data(dataValue:Object):void
		{
			richTxt.htmlText = String(dataValue);
			invalidateDraw();
			dispatchEvent(new ItemEvent(ItemEvent.ITEM_UPDATE));
		}
		
		/**
		 * 注册表情类
		 * @param tClass
		 * @param name
		 */
		public function registerClass(tClass:Class,name:String):void
		{
			_richTxt.registerClass(tClass,name);
		}

		/**
		 * 富文本
		 */
		public function get richTxt():SRichTextField
		{
			return _richTxt;
		}
	}
}
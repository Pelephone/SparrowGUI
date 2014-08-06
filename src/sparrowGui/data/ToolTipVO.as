package sparrowGui.data
{
	import flash.display.DisplayObject;

	/**
	 * 提示工具，单个提示数据
	 * @author Pelephone
	 */
	public class ToolTipVO
	{
		/**
		 * 经过显示提示窗的激活按钮
		 */
		public var targetDisp:DisplayObject;
		
		/**
		 * 提示数据
		 */
		public var tipData:Object;
		
		/**
		 * 提示面板窗
		 */
		public var tipSkin:DisplayObject;
		
		/**
		 * 将数据解析到tipSkin的方法，此方法必须有两参数，第一个是数据，第二个是面板皮肤
		 */
		public var parseFunction:Function;
		
		
		public function ToolTipVO()
		{
		}
	}
}
package sparrowGui.event
{
	import flash.events.Event;
	
	/**
	 * 弹窗事件
	 * @author Pelephone
	 */	
	public class AlertEvent extends Event
	{
		public static const ALERT_CLOSE:String = "alert_close";	//关闭
		public static const ALERT_UPDATE:String = "alert_update";	//更新界面
		
		private var _inpText:String;
		private var _btnIndex:int;
//		private var _other:Object;
		public function AlertEvent(type:String, tbtnIndex:int=0, tInpText:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_inpText = tInpText;
			_btnIndex = tbtnIndex;
//			_other = otherData;
			super(type, bubbles, cancelable);
		}

		public function get inpText():String
		{
			return _inpText;
		}

		public function set inpText(value:String):void
		{
			_inpText = value;
		}

		public function get btnIndex():int
		{
			return _btnIndex;
		}

		public function set btnIndex(value:int):void
		{
			_btnIndex = value;
		}
		
		override public function toString():String
		{
			return formatToString("AlertEvent", "type", "bubbles", "cancelable",
				"eventPhase","btnIndex","inpText");
		}

/*		public function get other():Object
		{
			return _other;
		}*/
	}
}
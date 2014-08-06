package sparrowGui.event
{
	import flash.events.Event;

	/**
	 * 消息
	 * 扩展了Event事件,添加带参obj,用body可取
	 * @author pelephone
	 * @web http://cnblogs.com/pelephone
	 * @email pelephone@163.com
	 */		
	public class RichEvent extends Event
	{
		//消息参数
		private var _body:Object;
		
		public function RichEvent(type:String,obj:Object=null,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			this._body = obj;
			super(type,bubbles,cancelable);
		}
		
		public function get data():Object
		{
			return _body;
		}
		
		//将数据转换整型
		public function get dataInt():int
		{
			return int(_body);
		}
		
		//将数据转换布尔
		public function get dataBool():Boolean
		{
			return Boolean(_body);
		}
		
		//将数据转换数值
		public function get dataNum():Number
		{
			return Number(_body);
		}
		
		//将数据转换字符型
		public function get dataStr():String
		{
			return String(_body);
		}
		
		//将数据转换数组型
		public function get dataArr():Array
		{
			return (_body as Array);
		}
	}
}
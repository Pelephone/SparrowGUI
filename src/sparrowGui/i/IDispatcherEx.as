package sparrowGui.i
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * 带批量删除的事件拖管
	 * @author pelephone
	 * @web http://hi.baidu.com/pelephone
	 * @email pelephone@163.com
	 */	
	public interface IDispatcherEx
	{
//		function sendNote(s:String,args:Object=null,bubbles:Boolean=false,cancelable:Boolean=false):void;
//		function listenMap(obs:EventDispatcher,arr:Array):void;
		/**
		 * 移除某消息的所有监听者
		 * @param type
		 */
		function removeTypeListeners(type:String):void;
		/**
		 * 移除所有消息所有监听者(此接口会把外部的监听会移除，使用需小心)
		 */
		function removeAllListeners():void;
//		function handleNotes(n:EventEx=null):void;
		/**
		 * 销毁
		 */
		function dispose():void
	}
}
package sparrowGui.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import sparrowGui.i.IDispatcherEx;
	import sparrowGui.event.RichEvent;

	/**
	 * 自写的简单事件托管方法,跟官方不同的是此方法可以批量回收事件
	 * @author Pelephone
	 */
	public class RichEventDispatcher extends EventDispatcher implements IDispatcherEx
	{
		private var listenerMap:Object;
		public function RichEventDispatcher(target:IEventDispatcher=null)
		{
			super(target);
			listenerMap = {};
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			super.addEventListener(type,listener,useCapture,priority,useWeakReference);
			var ls:Array = listenerMap[type] as Array;
			if(!ls) listenerMap[type] = [];
			listenerMap[type].push(listener);
		}
		
/*		override public function dispatchEvent(event:Event):Boolean
		{
			var ls:Array = listenerMap[event.type] as Array;
			if(!ls) return false;
			for each (var listener:Function in ls) 
			{
				listener.apply(null,[event]);
			}
			return true;
		}*/
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			super.removeEventListener(type,listener,useCapture);
			var ls:Array = listenerMap[type] as Array;
			if(!ls) return;
			var lid:int = ls.indexOf(listener);
			if(lid>=0) ls.splice(lid,1);
			if(!ls.length) delete listenerMap[type];
		}
		
		public function removeTypeListeners(type:String):void
		{
			var listeners:Array = listenerMap[type] as Array;
			if(listeners && listeners.length){
				for each (var listener:Function in listenerMap) 
				{
					super.removeEventListener(type,listener);
				}
			}
			
			listenerMap[type] = null;
			delete listenerMap[type];
		}
		
		public function removeAllListeners():void
		{
			for each (var type:String in listenerMap) 
			{
				removeTypeListeners(type);
			}
			
			listenerMap = {};
		}
		
		public function sendNote(s:String, args:Object=null, bubbles:Boolean=false, cancelable:Boolean=false):void
		{
			dispatchEvent(new RichEvent(s,args,bubbles,cancelable));
		}
		
		public function dispose():void
		{
		}
	}
}
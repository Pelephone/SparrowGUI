package sparrowGui.components.base
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	import sparrowGui.event.RichEvent;
	
	/**
	 * 多功能的Sprite
	 * 增加了事件回收的机制,有效防止回收垃圾问题.
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	internal class RichSprite extends Sprite implements IEventDispatcher
	{
//		private var listenerMap:Object;
		
		public function RichSprite()
		{
//			listenerMap = {};
		}
		
		/**
		 * 发消息快捷方法
		 * @param type 消息类型
		 * @param args
		 * @param bubbles
		 * @param cancelable
		 */
		public function sendNote(type:String, args:Object=null, bubbles:Boolean=false, cancelable:Boolean=false):void
		{
			dispatchEvent(new RichEvent(type,args,bubbles,cancelable));
		}
		
		/**
		 * 将此对象加到场景
		 * @param parent
		 */
		public function addToParent(toParent:DisplayObjectContainer):void
		{
			if(toParent)
				toParent.addChild(this);
		}
		
		/**
		 * 对象移出场景
		 */
		public function removeFromParent():void
		{
			if(parent) parent.removeChild(this);
		}
		
		/**
		 * 销毁
		 */
		public function dispose():void
		{
			removeFromParent();
		}
	}
}
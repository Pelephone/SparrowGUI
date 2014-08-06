package sparrowGui.i
{
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	
	public interface IItem extends IEventDispatcher
	{
		/**
		 * 更新数据
		 
		function update(o:Object):void;*/
		/**
		 * 用字符改变状态可以解耦，比如在列表中想要添新状态可以继承SItem,SList 
		 * @param stateName
		 */
		function setState(stateName:String,value:Object=null):void;
		/**
		 * 当前状态，类型见ItemState
		 * @return 
		 */
		function get currentState():String;
//		function get skin():DisplayObject;
		/**
		 * 项数据
		 */
		function get data():Object;
		/**
		 * @private
		 */
		function set data(value:Object):void;
		
		/**
		 * 项名
		 * @param value
		 */
		function set name(value:String):void;
		
		/**
		 * @private 
		 */
		function get name():String;
		
		/**
		 * 项在组里的索引
		 * @param value
		 */
		function set itemIndex(value:int):void;
		
		/**
		 * @private 
		 */
		function get itemIndex():int;
		
		/**
		 * 将自己添加到父容器
		 * @param parent
		 */
		function addToParent(parentDSP:DisplayObjectContainer):void;
	}
}
package sparrowGui.i
{
	import flash.display.DisplayObjectContainer;

	/**
	 * 带显示对象UI模块
	 * @author Pelephone
	 */
	public interface IMgrUICompent
	{
		function set x(value:Number):void;
		function set y(value:Number):void;
//		function set width(value:Number):void;
//		function set height(value:Number):void;
		function set name(value:String):void;
		function set visible(value:Boolean):void;
		function set enabled(value:Boolean):void;
		
		function get x():Number;
		function get y():Number;
//		function get width():Number;
//		function get height():Number;
		function get name():String;
		function get visible():Boolean;
		function get enabled():Boolean;
		
		/**
		 * 不同组件有不同的组件名,用于从UIMgr里面查默认皮肤
		 * @return 
		 */
		function getDefaultUIName():String;
		
		/**
		 *  将皮肤装入父级容器
		 */
		function addSkinToParent(parent:DisplayObjectContainer):void;
		/**
		 * 将皮肤移出舞台
		 */
		function removeSkinFromParent():void;
		/**
		 * 通过css设置所有属性
		function setAttrByVars(vars:Object):void;*/
		/**
		 * 本人习惯上加一个销毁方法,清除所有引用
		 */
		function dispose():void;
	}
}
package sparrowGui.i
{
	import flash.display.DisplayObject;

	public interface IItemFactory
	{
		/**
		 * 新建项组件
		 * @return 
		 */
		function createNewItem(uiVars:Object=null) : IItem;
		
		/**
		 * 创建项皮肤
		 * @return 
		 */
		function createNewItemSkin():DisplayObject;
		
		/**
		 * 设置项类
		 * @param value
		 */
		function set itemClass(value:Class):void;
		function get itemClass():Class;
		
		/**
		 * 生成项皮肤的类，必须是继承DisplayObject的类(会把set itemSkinName覆盖)
		 
		function set itemSkinClass(value:Class):void;
		function get itemSkinClass():Class;*/
		
		/**
		 * 生成项皮肤绑在UIMgr上面的样式名(会把set itemSkinClass覆盖)
		 
		function set itemSkinName(value:String):void;*/
		/**
		 * 回收处理项(后期可以在这里添加缓存处理的逻辑)
		 * @param item
		 */
		function disposeItem(item:IItem):void;
		/**
		 * 回收处理项皮肤(后期可以在这里添加缓存处理的逻辑)
		 * @param item
		 
		function disposeItemSkin(skin:DisplayObject):void;*/
	}
}
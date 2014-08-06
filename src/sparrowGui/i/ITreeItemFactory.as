package sparrowGui.i
{
	import flash.display.DisplayObject;

	/**
	 * 树形项创建工厂
	 * @author Pelephone
	 */
	public interface ITreeItemFactory extends IItemFactory
	{
		/**
		 * 新建项组件
		 * @return 
		 */
		function createNewChildItem(uiVars:Object=null) : IItem;
		
		/**
		 * 创建项皮肤
		 * @return 
		 */
		function createNewChildItemSkin():DisplayObject;
		
		/**
		 * 生成项皮肤的类，必须是继承DisplayObject的类(会把set itemSkinName覆盖)
		 */
		function set childItemSkinClass(value:Class):void;
		function get childItemSkinClass():Class;
	}
}
package sparrowGui.i
{
	/**
	 * 项组管理
	 * 有项的生成,更新，排列等方法
	 * @author Pelephone
	 */
	public interface IItemGroup
	{
		/**
		 * 通过皮肤显示对象组生成项
		 * @param skinLs
		 
		function createItemsBySkins(skinLs:Array):void;*/
		/**
		 * 通过数据生成项(数据可以是1维数字，也可以哈希字典数据)
		 * @param size
		 */
		function createItemByData(data:Object):void;
		/**
		 * 通过数据更新项
		 * @param data
		 */
		function updateItems(data:Object):void;
		/**
		 * 排列已生成的项
		 */
		function layoutItems():void;
		
		/**
		 * 移除所有项
		 */
		function removeAllItems():void;
		/**
		 * 添加项
		 * @param itm
		 * @return 
		 */
		function addItem(itm:IItem):IItem;
		/**
		 * 指定位置加入项
		 * @param itm
		 * @param index
		 */
		function addItemAt(itm:IItem,index:int):IItem;
		/**
		 * 移出某项
		 * @param itm
		 */
		function removeItem(itm:IItem):IItem;
		/**
		 * 移出某位置上的项
		 * @param index
		 */
		function removeItemAt(index:int):IItem
		/**
		 * 新建项组件
		 * @return 
		 
		function createNewItem(uiVars:DisplayObject=null) : IItem;*/
		
		/**
		 * 创建项皮肤
		 * @return 
		 
		function createNewItemSkin():DisplayObject;*/
		
		/**
		 * 通过项index获取项(data是数组的时候可用,如果data是哈希数据,可以用getItemByArgs)
		 */
		function getItemAt(index:int):IItem;
		/**
		 * 通过名称查找对应的项
		 * @param itemName
		 */
		function getItemByName(itemName:String):IItem;
		
		/**
		 * 设置皮肤项
		 * @param value
		 
		function set itemSkinClass(value:Class):void;*/
	}
}
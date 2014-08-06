package sparrowGui.components.item
{
	import asCachePool.interfaces.IRecycle;
	
	import flash.display.DisplayObject;
	
	import sparrowGui.SparrowMgr;
	import sparrowGui.i.IItem;
	import sparrowGui.i.IItemFactory;
	import sparrowGui.i.ISkinChanger;
	import sparrowGui.uiStyle.UIStyleCss;

	/**
	 * 组件子项和子项皮肤创建工厂
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class ItemFactory implements IItemFactory
	{
		private var _itemClass:Class;
		/**
		 * 缓存项
		 */
		private var cacheItemSize:int;
		/**
		 * 项名字，用于从UIMgr上面找默认样式
		 */
		private var _itemUI:Object;
		
		/**
		 * 构造项创建工厂
		 * @param itemClz	项组件类	必须是SItem子类
		 * @param itemSkin	项皮肤名字，对应UIMgr上面的样式,也可以是显示对象class
		 */
		public function ItemFactory(itemClz:Class,itemSkin:Object="ListItem")
		{
			this.itemClass = itemClz;
			this._itemUI = itemSkin;
		}
		
		public function createNewItem(uiVars:Object=null) : IItem
		{
			var itm:IItem = SparrowMgr.getAndCreatePoolObj(_itemClass);
//			uiVars = (uiVars!=null)?uiVars:createNewItemSkin();
//			uiVars = (uiVars!=null)?uiVars:_itemUI;
//			if(itm is ISkinChange && uiVars is String)
//				(itm as ISkinChange).resetUI(uiVars as String);
			return itm;
		}
		
		/**
		 * 生成项皮肤
		 * @return 
		 */
		public function createNewItemSkin():DisplayObject
		{
			var resSkin:* = SparrowMgr.getAndCreatePoolObj(_itemUI);
			if(resSkin)
				return resSkin;
			else if(_itemUI is String)
				return UIStyleCss.getInstance().createStyleSkin(String(_itemUI));
			else
				return null;
		}

		/**
		 * 生成项的类，必须是继承SItem的类
		 */
		public function set itemClass(value:Class):void
		{
			_itemClass = value;
		}
		
		public function get itemClass():Class
		{
			return _itemClass;
		}

		/**
		 * 生成项皮肤的类，必须是继承DisplayObject的类(会把set itemSkinName覆盖)
		 
		public function set itemSkinClass(value:Class):void
		{
			_itemUI = value;
		}*/
		
		/**
		 * 生成项皮肤绑在UIMgr上面的样式名(会把set itemSkinClass覆盖)
		 
		public function set itemSkinName(value:String):void
		{
			_itemUI = value;
		}
		
		public function get itemSkinClass():Class
		{
			return _itemUI as Class;
		}*/
		
		/**
		 * 回收处理项(后期可以在这里添加缓存处理的逻辑)
		 * @param item
		 */
		public function disposeItem(item:IItem):void
		{
			if(item is IRecycle)
				(item as IRecycle).dispose();
			
			SparrowMgr.removeInCLsCache(item);
//			item.removeSkinFromParent();
		}
		
		/**
		 * 回收处理项皮肤(后期可以在这里添加缓存处理的逻辑)
		 * @param item
		 
		public function disposeItemSkin(skin:DisplayObject):void
		{
			skin.parent.removeChild(skin);
			if(_itemUI is String)
				SparrowMgr.putInClassCache(skin,(_itemUI as String));
			else
				SparrowMgr.putInClassCache(skin);
		}*/
	}
}
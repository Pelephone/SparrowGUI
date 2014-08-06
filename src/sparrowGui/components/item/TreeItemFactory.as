package sparrowGui.components.item
{
	import flash.display.DisplayObject;
	
	import sparrowGui.SparrowMgr;
	import sparrowGui.i.IItem;
	import sparrowGui.i.ITreeItemFactory;
	import sparrowGui.uiStyle.UIStyleCss;
	
	/**
	 * 树形项创建工厂
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class TreeItemFactory extends ItemFactory implements ITreeItemFactory
	{
		/**
		 * 子项类
		 */
		private var _childItemClass:Class;
		/**
		 * 子项皮肤类
		 */
		private var _childItemUI:Object;
		
		/**
		 * 构造树形项创建工厂
		 * @param itemClz 项类对象
		 * @param itemSkin 父项皮肤,对应UIMgr上面的样式,也可以是显示对象class
		 * @param childTreeSkin 子项皮肤,对应UIMgr上面的样式,也可以是显示对象class
		 */
		public function TreeItemFactory(itemClz:Class, itemSkin:Object="treeItem"
										,childTreeSkin:Object="richItem")
		{
			super(itemClz, itemSkin);
			
			_childItemClass = STreeChildItem;
			_childItemUI = childTreeSkin;
		}
		
		/**
		 * 创建生成子项Item控制组件
		 * @param uiVars
		 * @return 
		 */
		public function createNewChildItem(uiVars:Object=null):IItem
		{
			return SparrowMgr.getAndCreatePoolObj(_childItemClass) as IItem;
/*			if(uiVars is Class)
				uiVars = new uiVars();
			else if(uiVars is String)
				uiVars = UIStyleCss.getInstance().createStyleSkin(String(uiVars));
			else
				uiVars = createNewChildItemSkin();
			
			return new _childItemClass(uiVars);*/
		}
		
		/**
		 * 生成子项皮肤
		 * @return 
		 */
		public function createNewChildItemSkin():DisplayObject
		{
			if(_childItemUI is Class)
				return new _childItemUI();
			else if(_childItemUI is String)
				return UIStyleCss.getInstance().createStyleSkin(String(_childItemUI));
			else
				return null;
		}
		
		/**
		 * 生成项皮肤的类，必须是继承DisplayObject的类(会把set itemSkinName覆盖)
		 */
		public function set childItemSkinClass(value:Class):void
		{
			_childItemUI = value;
		}
		
		/**
		 * 生成项皮肤绑在UIMgr上面的样式名(会把set itemSkinClass覆盖)
		 */
		public function set childItemSkinName(value:String):void
		{
			_childItemUI = value;
		}
		
		public function get childItemSkinClass():Class
		{
			return _childItemUI as Class;
		}
	}
}
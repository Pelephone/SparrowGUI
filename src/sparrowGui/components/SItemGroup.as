package sparrowGui.components
{
	import asCachePool.interfaces.IRecycle;
	
	import flash.display.DisplayObject;
	
	import sparrowGui.SparrowMgr;
	import sparrowGui.components.base.BaseUIComponent;
	import sparrowGui.components.base.LayoutClip;
	import sparrowGui.components.item.SItem;
	import sparrowGui.event.ListEvent;
	import sparrowGui.i.IItem;
	
	
	/** 子项布局更新 */
	[Event(name="layout_update", type="sparrowGui.event.ListEvent")]
	
	/** 所有项数据更新 */
	[Event(name="update_all", type="sparrowGui.event.ListEvent")]
	
	/**
	 * 项组组件(和SList相比，此组件没有鼠标和选中某项的事件，是个经量级的子项管理显示对象)
	 * 有项的创建，更新，排列等方法。单多选组件扩展此对象
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class SItemGroup extends BaseUIComponent
	{
		
		/**
		 * 获取项主键的方法(必须以vo数据做为参数的函数)
		 */
		public var keyFunction:Function;
		
		/**
		 * 更新单个项的函数方法(必须以项做为参数的函数)
		 */
		public var updateFunction:Function;
		
		
		public function SItemGroup(uiVars:Object=null)
		{
			layout = createNewLayout();
			itemLs = new Vector.<DisplayObject>();
			itemMap = {};
			
			super(uiVars || defaultUIVar);
		}
		
		//----------------------------------------------------
		// data
		//----------------------------------------------------
		
		protected var _data:Object;
		
		/**
		 * 更新数据，不改变项
		 * @param data
		 */
		public function set data(value:Object):void
		{
			if(_data == value)
				return;
			_data = value;
			dispatchEvent(new ListEvent(ListEvent.UPDATE_ALL));
		}
		
		/**
		 * 数据源
		 * @return 
		 */
		public function get data():Object 
		{
			return _data;
		}
		
		//---------------------------------------------------
		// 用于复盖的默认组件创建，如果不需要组件可以覆盖后返回null
		//---------------------------------------------------
		
		/**
		 * 子项类，（必须是显示对象的类）
		 */
		public var itemClass:Class = SItem;
		/**
		 * 子项参数
		 */
		public var itemStyle:Object = null;
		
		/**
		 * 创建子项
		 * @param data
		 */
		protected function createItem(data:Object):DisplayObject
		{
			var itm:DisplayObject;
			if(itemStyle == null)
				itm = SparrowMgr.getAndCreatePoolObj(itemClass) as DisplayObject;
			else
				itm = SparrowMgr.getAndCreatePoolObj(itemClass,itemStyle) as DisplayObject;
			
			updateItem(itm,data);
			return itm;
		}
		
		/**
		 * 创建布局组件
		 * @return 
		 */
		protected function createNewLayout():LayoutClip
		{
			return new LayoutClip();
		}
		
		//---------------------------------------------------
		// 组创建更新
		//---------------------------------------------------
		
		/**
		 * 通过皮肤显示对象组生成项(通过此方法可以不用把子项镶入组件中也可以操作)<br/>
		 * 通过此方法注入的子项并不会发生布局排列
		 * @param skinLs
		 
		public function createItemsBySkins(skinLs:Array):void
		{
			itemLs = new Vector.<DisplayObject>();
			itemMap = {};
			for (var i:int = 0; i < skinLs.length; i++) 
			{
				var itmSkin:DisplayObject = skinLs[i] as DisplayObject;
				var itm:DisplayObject = createItem(itmSkin);
				itemLs.push(itm);
				itemMap[itm.name] = itm;
			}
		}*/
		
		/**
		 * 根据数据创建子项
		 * @param dataProvider
		 */
		public function createItemByData(dataProvider:Object):void
		{
			// 皮肤不是容器就不能生成
			itemLs = new Vector.<DisplayObject>();
			itemMap = {};
			var key:String;
			for each(var itmData:Object in dataProvider) 
			{
				var itm:DisplayObject = createItem(itmData);
				itm.name = getKey(itmData,itemLength);
				addItem(itm);
			}
		}
		
		/**
		 * 通过数据键获取项键名
		 * @param target
		 */
		protected function getKey(targetData:Object,index:int=-1):String
		{
			if(keyFunction!=null)
				return keyFunction.apply(null,[targetData]);
			
			if(index!=-1)
				return "itemIndex_" + index;

			return null;
		}
		
		/**
		 * 根据数据更新所有项
		 * @param data
		 */
		public function updateItems(dataProvider:Object):void
		{
			var i:int = 0;
			for (var oName:Object in dataProvider) 
			{
				var itm:DisplayObject;
				itm = getItemByName(getKey(dataProvider[oName],i));
				
				if(!itm) continue;
				var vo:Object = dataProvider[oName] as Object;
				updateItem(itm,vo);
				i++;
			}
			dispatchEvent(new ListEvent(ListEvent.UPDATE_ALL));
		}
		
		/**
		 * 排列所有项
		 */
		public function layoutItems():void
		{
			if(layout)
				layout.updateDisplayList(_itemLs);
/*			var tmpY:int=0,tmpX:int=0;
			var i:int = 0;
			for each (var itm:DisplayObject in itemLs) 
			{
				var dp:DisplayObject = itm.skin;
				if(!dp) continue;
				if(i && !(i%colNum) && colNum!=0){
					tmpY = tmpY + spacing + (itemHeight?itemHeight:dp.height);
					tmpX = 0;
				}
				dp.x = tmpX;
				tmpX = tmpX + (itemWidth || dp.width) + spacing;
				dp.y = tmpY;
				i++;
			}*/
		}
		
		/**
		 * 移除所有项
		 */
		public function removeAllItems():void
		{
			for each (var itm:DisplayObject in itemLs) 
			{
//				itemFactory.disposeItemSkin(itm.skin);
				if(itm is DisplayObject)
					(itm as DisplayObject).parent.removeChild(itm as DisplayObject);
//				itemFactory.disposeItem(itm);
				if(itm is IRecycle)
					(itm as IRecycle).dispose();
				
				SparrowMgr.removeInCLsCache(itm);
			}
			itemLs = new Vector.<DisplayObject>();
			itemMap = {};
		}
		
		/**
		 * 重设组子项名和itemIndex
		 */
		protected function reNameGroup():void
		{
			itemMap = {};
			for (var i:int = 0; i < itemLs.length; i++) 
			{
				var itm:DisplayObject = itemLs[i] as DisplayObject;
				itm.name = getKey(null,i);
				itemMap[itm.name] = itm;
				if(itm is IItem)
					(itm as IItem).itemIndex = i;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			layoutItems();
			super.draw();
		}
		
		////// 项增删改查 //////////////
		
		/**
		 * 添加项
		 * @param itm
		 * @return 
		 */
		public function addItem(itm:DisplayObject):DisplayObject
		{
			if(itm is IItem)
				(itm as IItem).itemIndex = itemLs.length;
			if(itm is DisplayObject)
				addChild(itm as DisplayObject);
			else
				addChild(itm as DisplayObject);
				
			itemLs.push(itm);
			itemMap[itm.name] = itm;
			invalidateDraw();
			return itm;
		}
		
		/**
		 * 更新子项数据
		 * @param itm
		 * @param data
		 */
		protected function updateItem(itm:DisplayObject,dataProvider:Object=null):void
		{
			if(updateFunction!=null)
				updateFunction.apply(null,[itm,dataProvider]);
			else
			{
				if(itm is IItem)
					(itm as IItem).data = dataProvider;
			}
		}
		
		/**
		 * 指定位置加入项
		 * @param itm
		 * @param index
		 */
		public function addItemAt(itm:DisplayObject,index:int):DisplayObject
		{
			if(index>=itemLs.length && index<0)
				return null;
			itemLs.splice(index, 0, itm);
			itemMap[itm.name] = itm;
			return itm;
		}
		
		/**
		 * 移出某位置上的项
		 * @param index
		 */
		public function removeItemAt(index:int):DisplayObject
		{
			if(index>=itemLs.length && index<0) return null;
			var itm:DisplayObject = itemLs.splice(index,1)[0];
			reNameGroup();
			invalidateDraw();
			return itm;
		}
		
		/**
		 * 移出某项
		 * @param itm
		 */
		public function removeItem(itm:DisplayObject):DisplayObject
		{
			var itm:DisplayObject = itemMap[itm.name];
			if(!itm) return null;
			var index:int = itemLs.indexOf(itm);
			return removeItemAt(index);
		}
		
		/**
		 * 通过名称查找对应的项
		 * @param itemName
		 */
		public function getItemByName(itemName:String):DisplayObject
		{
			return itemMap[itemName] as DisplayObject;
		}
		
		override public function dispose():void
		{
			if(_layout)
				_layout.removeEventListener(ListEvent.LAYOUT_UPDATE,onlayoutUpdate);
			
			super.dispose();
			itemLs = null;
			itemMap = null;
		}
		
		/////////////////////////////////////////
		// get/set
		/////////////////////////////////////////
		
		/**
		 * 通过项index获取项(data是数组的时候可用,如果data是哈希数据,可以用getItemByArgs)
		 */
		public function getItemAt(index:int):DisplayObject
		{
			if(!itemLs || itemLs.length<=index) return null;
			return itemLs[index] as DisplayObject;
		}
		
		////// 项组 ///////////////////
		
		/**
		 * 项名称绑定的哈希关系对象[DisplayObject]
		 */
		protected var itemMap:Object;
		
		protected var _itemLs:Vector.<DisplayObject>;
		
		/**
		 * 项列表数据
		 */
		protected function set itemLs(value:Vector.<DisplayObject>):void
		{
			_itemLs = value;
			if(layout)
				layout.updateDisplayList(_itemLs);
		}
		
		/**
		 * @private 
		 */
		protected function get itemLs():Vector.<DisplayObject>
		{
			return _itemLs;
		}
		
		override protected function get defaultUIVar():Object
		{
			return "ItemGroup";
		}
		
		/////// 布局 ////////////////////
		
		private var _layout:LayoutClip;
		
		/**
		 * 布局组件,默认用的是LayoutBase
		 */
		public function get layout():LayoutClip
		{
			return _layout;
		}
		
		/**
		 * @private
		 */
		public function set layout(value:LayoutClip):void
		{
			if(_layout)
				_layout.removeEventListener(ListEvent.LAYOUT_UPDATE,onlayoutUpdate);
			_layout = value;
			
			if(_layout)
				_layout.addEventListener(ListEvent.LAYOUT_UPDATE,onlayoutUpdate);
		}
		
		/**
		 * 子项布局更新
		 * @param e
		 */
		private function onlayoutUpdate(e:ListEvent):void
		{
			dispatchEvent(new ListEvent(ListEvent.LAYOUT_UPDATE));
		}

		/**
		 * 每列有多少项,-1表示自动通过width和itemWidth计算每列个数
		 */
		public function get colNum():int
		{
			if(!layout) return 0;
			return layout.colNum;
		}

		/**
		 * @private
		 */
		public function set colNum(value:int):void
		{
			if(!layout) return;
			layout.colNum = value;
		}

		/**
		 * 子项宽
		 */
		public function get itemWidth():int
		{
			if(!layout) return 0;
			return layout.itemWidth;
		}

		/**
		 * @private
		 */
		public function set itemWidth(value:int):void
		{
			if(!layout) return;
			layout.itemWidth = value;
		}

		/**
		 * 子项高
		 */
		public function get itemHeight():int
		{
			if(!layout) return 0;
			return layout.itemHeight;
		}

		/**
		 * @private
		 */
		public function set itemHeight(value:int):void
		{
			if(!layout) return;
			layout.itemHeight = value;
		}

		/**
		 * 行列子项间隔
		 */
		public function get spacing():int
		{
			if(!layout) return 0;
			return layout.spacing;
		}

		/**
		 * @private
		 */
		public function set spacing(value:int):void
		{
			if(!layout) return;
			layout.spacing = value;
		}
		
		///// 宽高 /////////////////
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			super.width = value;
			if(layout)
				layout.width = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			if(layout && layout.width>0)
				return layout.width;
			
			if(itemWidth>0)
				return (itemWidth + spacing)*itemLs.length;
			
			return super.width;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			super.height = value;
			if(layout)
				layout.height = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			if(layout && layout.height>0)
				return layout.height;
			
			if(itemHeight>0)
				return (itemHeight + spacing)*itemLs.length;
			
			return super.height;
		}
		
		/**
		 * 获取子项数量
		 * @return 
		 */
		public function get itemLength():int
		{
			return itemLs.length;
		}
	}
}
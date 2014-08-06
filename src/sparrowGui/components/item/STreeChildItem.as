package sparrowGui.components.item
{
	import flash.events.MouseEvent;
	
	import sparrowGui.data.TreeComposite;
	import sparrowGui.event.ItemEvent;
	import sparrowGui.i.ITreeNode;
	
	/**
	 * 列表项，有六状态，有经过移动事件，不过没有选中事件
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class STreeChildItem extends SListItem
	{
		/**
		 * 构造树形组件子项
		 * @param uiVars
		 * @return 
		 */
		public function STreeChildItem(uiVars:Object=null)
		{
			super(uiVars || defaultUIVar);
			super.x = 25;
		}
		
		/**
		 * 将数据解析到此项
		 */
		override protected function parseData():void
		{
			var strObj:String = (data is ITreeNode)?(data as ITreeNode).txtName:String(data);
			if(labelText)
				labelText.text = strObj;
		}
		
		override protected function addSkinListen():void
		{
			super.addSkinListen();
			addEventListener(MouseEvent.CLICK,onSelectEvt);
		}
		
		override protected function removeSkinListen():void
		{
			super.removeSkinListen();
			removeEventListener(MouseEvent.CLICK,onSelectEvt);
		}
		
		protected function onSelectEvt(e:MouseEvent):void
		{
			dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECT_CHANGE));
		}
		
		//----------------------------------------------------
		// selected
		//----------------------------------------------------
		
		/**
		 * 选中状态
		 */
		override public function set selected(value:Boolean):void
		{
			// 状态跟原状态不同时才重设
			if(selected != value)
			{
				super.selected = value;
				if(value)
					removeSkinListen();
				else
					addSkinListen();
				
				
				if(_data is TreeComposite)
					(_data as TreeComposite).selected = value;
			}
		}
	}
}
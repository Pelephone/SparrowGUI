package sparrowGui.i
{
	/**
	 * 选中数据(Model)
	 * 有添加删除选中项等方法
	 * @author Pelephone
	 */
	public interface IListSelectionData
	{
		/**
		 * 设置选中项
		 * @param index
		 */
		function setSelect(index:int):void;
		
		/**
		 * 添加选项
		 * @param index
		 */
		function addSelect(index:int):void;
		
		/**
		 * 移除选项
		 * @param index
		 */
		function removeSelect(index:int):void;
		
		/**
		 * 移除所有选中项
		 */
		function removeAllSelect(isEvt:Boolean=true):void;
		
		/**
		 * 反选(此方法用时必须传一个最大项,即当前组件有多少项)
		 */
		function invertSelect(max:int=0):void;
		
		/**
		 * 当前是否已经选中该项
		 * @return 
		 */
		function hasSelected(index:int):Boolean;
		
		/**
		 * 是否支持多选，默认只能单选
		 */
		function get multiSelect():Boolean;
		
		/**
		 * @private
		 */
		function set multiSelect(value:Boolean):void;
		
		/**
		 * 至少有一个项被选中
		 */
		function get mustSelect():Boolean;
		
		/**
		 * @private
		 */
		function set mustSelect(value:Boolean):void;
		
		/**
		 * 判断某项是否被选中
		 */
		function isSelect(index:int):Boolean;
		
		/**
		 * 监听数据选中事件
		 */  
		function addListSelectionListener(listener:Function):void;
		
		/**
		 * 移出数据选中事件
		 */
		function removeListSelectionListener(listener:Function):void;
		/**
		* 返回选中项位置,无选中项返回-1
		* @return 
		*/
		function getSelectIndex():int;
		/**
		 * 返回选中的所有项(多选时)
		 * @return 
		 */
		function getSelectIds():Vector.<int>;
	}
}
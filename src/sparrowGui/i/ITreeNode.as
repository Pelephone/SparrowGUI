package sparrowGui.i
{
	public interface ITreeNode
	{
		/**
		 * 节点唯一Id
		 */
		function get nodeId():int;
		function set nodeId(value:int):void;
		/**
		 * 父节点id
		 */
		function get pid():int;
		function set pid(value:int):void;
		/**
		 * 节点皮肤
		 */
		function get skinCls():String;
		function set skinCls(value:String):void;
		/**
		 * 节点项里的内容
		 */
		function get txtName():String;
		function set txtName(value:String):void;
		/**
		 * 是否被选中
		 
		function get selected():int;
		function set selected(value:int):void;*/
		/**
		 * 是否合起
		 */
		function get folded():int;
		function set folded(value:int):void;
		
//		// 是否有该属性
//		function hasOwnProperty(v*=null):Boolean;
	}
}
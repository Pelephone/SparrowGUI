package sparrowGui.data
{
	import sparrowGui.i.ITreeNode;

	/**
	 * 树形控件的vo数组
	 * <tree>
	 * 		<child myid='' pid='' skinCls='' txtName='' selected='' />
	 * 		<child myid='' pid='' skinCls='' txtName='' selected='' />
	 * </tree>
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class TreeNodeVO implements ITreeNode
	{
		private var _nodeId:int;
		private var _pid:int;
		private var _skinCls:String;
		private var _txtName:String;
		private var _selected:int = 0;
		private var _folded:int = 0;

		/**
		 * 节点唯一Id
		 */
		public function get nodeId():int
		{
			return _nodeId;
		}

		/**
		 * @private
		 */
		public function set nodeId(value:int):void
		{
			_nodeId = value;
		}

		/**
		 * 父节点id
		 */
		public function get pid():int
		{
			return _pid;
		}

		/**
		 * @private
		 */
		public function set pid(value:int):void
		{
			_pid = value;
		}

		/**
		 * 节点皮肤
		 */
		public function get skinCls():String
		{
			return _skinCls;
		}

		/**
		 * @private
		 */
		public function set skinCls(value:String):void
		{
			_skinCls = value;
		}

		/**
		 * 节点项里的内容
		 */
		public function get txtName():String
		{
			return _txtName;
		}

		/**
		 * @private
		 */
		public function set txtName(value:String):void
		{
			_txtName = value;
		}

		/**
		 * 是否被选中
		 */
		public function get selected():int
		{
			return _selected;
		}

		/**
		 * @private
		 */
		public function set selected(value:int):void
		{
			_selected = value;
		}

		/**
		 * 是否合起
		 */
		public function get folded():int
		{
			return _folded;
		}

		/**
		 * @private
		 */
		public function set folded(value:int):void
		{
			_folded = value;
		}


	}
}
package sparrowGui.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import sparrowGui.i.ITreeNode;
	
	/** 数据改变事件 */
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * 树形控件组合
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class TreeComposite extends EventDispatcher
	{
		private var _id:int;
		
		private var _folded:Boolean = false;
		private var _selected:Boolean = false;
		
		private var _parent:TreeComposite;
		private var _children:Vector.<TreeComposite>;
		/**
		 * 树形节点组件组合数据
		 */
		public function TreeComposite(vars:Object)
		{
			_children = new Vector.<TreeComposite>();
			
			data = vars;
		}
		
		/**
		 * 添子项引用
		 * @param node
		 */
		public function add(node:TreeComposite):void
		{
			if(_children.indexOf(node)>=0)
				return;
			node.parent = this;
			_children.push(node);
		}
		
		/**
		 * 通过索引获取其中一项
		 * @param index
		 * @return 
		 */
		public function getChildById(index:int):TreeComposite
		{
			if ((index >= 0) && (index < _children.length)) {
				return _children[index];
			} else {
				return null;
			}
		}
		
		/**
		 * 子项长度
		 * @return 
		 */
		public function get numChildren():int 
		{
			return _children.length;
		}
		
		public function remove(c:TreeComposite):void
		{
			if (c === this) {
				// 移出所有子节点
				for (var i:int = 0; i < _children.length; i++) {
					safeRemove(_children[i]); // 移出子节点
				}
				this._children = new Vector.<TreeComposite>(); // 移出子项的引用
				this.removeParentRef(); // 断开父类的引用
//				this._childrenNameHm = {};
			} else {
				for (var j:int = 0; j < _children.length; j++) {
					if (_children[j] == c) {
						safeRemove(_children[j]); // 移出子节点
						_children.splice(j, 1); // 移出引用
					}
				}
			}
		}
		
		/**
		 * 移除父节点
		 */
		private function removeParentRef():void { 
			this.parent = null;
		}
		
		/**
		 * 安全移除
		 * @param c
		 */
		private function safeRemove(c:TreeComposite):void
		{
			if (c) {
				c.remove(c);
			} else {
				c.removeParentRef();
			}
		}
		
		private var _data:Object;

		public function set data(value:Object):void
		{
			if(_data == value)
				return;
			_data = value;
			
			if(value is XML || value is XMLList)
			{
				id = value.@id;
				selected = Boolean(int(value.@selected));
				_label = value.@txtName;
				folded = Boolean(int(value.@folded));
				_parendId = value.@pid;
			}
			else if(value is ITreeNode)
			{
				var v2:ITreeNode = value as ITreeNode;
				id = v2.nodeId;
				folded = Boolean(v2.folded);
				_label = v2.txtName;
				_parendId = v2.pid;
			}
			else
			{
				if(value == null)
					return;
				
				if(value.hasOwnProperty("nodeId"))
					id = value.nodeId;
				
				if(value.hasOwnProperty("folded"))
					folded = value.folded;
				
				if(value.hasOwnProperty("txtName"))
					_label = value.txtName;
				
				if(value.hasOwnProperty("pid"))
					_parendId = value.pid;
				
				if(value.hasOwnProperty("selected"))
					_parendId = value.selected;
			}
		}
		
		/**
		 * 节点的vo数据
		 * @return 
		 */
		public function get data():Object
		{
			return _data;
		}
		
		private var _label:String;
		
		/**
		 * 显示在按钮上的文字
		 * @return 
		 */
		public function get label():String
		{
			return _label;
		}

		/**
		 * 唯一id
		 */
		public function get id():int
		{
			return _id;
		}

		/**
		 * @private
		 */
		public function set id(value:int):void
		{
			_id = value;
		}
		
		private var _parendId:int;

		/**
		 * 父节点id
		 */
		public function get parendId():int
		{
			return _parendId;
		}

		/**
		 * @private
		 */
		public function set parendId(value:int):void
		{
			_parendId = value;
		}


		/**
		 * 是否选中
		 */
		public function get selected():Boolean
		{
			return _selected;
		}

		/**
		 * @private
		 */
		public function set selected(value:Boolean):void
		{
			if(_selected == value)
				return;
			_selected = value;
			dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * 是否合起
		 */
		public function get folded():Boolean
		{
			return _folded;
		}

		/**
		 * @private
		 */
		public function set folded(value:Boolean):void
		{
			if(_folded == value)
				return;
			_folded = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 相对于根的深度
		 * @return 
		 */
		public function get depth():int
		{
			return getDepth(this);
		}
		
		/**
		 * 递归计算出该组合的深度
		 */
		private function getDepth(c:TreeComposite,dep:int=0):int
		{
			if(c.parent!=null)
				return getDepth(c.parent,(dep+1));
			else
				return dep;
		}

		public function get parent():TreeComposite
		{
			return _parent;
		}

		public function set parent(value:TreeComposite):void
		{
			_parent = value;
		}

		override public function toString():String
		{
			return _label;
		}
	}
}
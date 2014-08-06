package sparrowGui.components
{
	import sparrowGui.i.IItem;
	
	/**
	 * 多选控件
	 * 多选子项是一个个addItem到这里的,不用时记得remove
	 * @author Pelephone
	 * @website http://cnblogs.com/pelephone
	 */
	public class SCheckBox extends SRadioGroup
	{
		/**
		 * 多选组件控件
		 * @param argSkin
		 * @param vars
		 */
		public function SCheckBox(itmLs:Vector.<IItem>=null)
		{
			super(itmLs);
			selectModel.multiSelect = true;
			selectModel.mustSelect = false;
		}
	}
}
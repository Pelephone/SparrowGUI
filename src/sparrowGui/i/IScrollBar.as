package sparrowGui.i
{
	import flash.events.MouseEvent;

	public interface IScrollBar extends IBaseComponent
	{
		function setSliderParams(min:Number, max:Number, stepValue:Number=0):void;
		function onMoveSlider(e:MouseEvent):void;
		// 滚动轴滚动到的百分比
		function get value():Number;
		function set value(v:Number):void;
//		function get sliderMaxY():Number;
	}
}
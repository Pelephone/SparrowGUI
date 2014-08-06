package sparrowGui.i
{
	public interface IBaseComponent
	{
		function setXY(xpos:Number, ypos:Number):void;
		function setSize(w:Number, h:Number):void;
		// 是否整型经x,y坐标;
		function set isIntXY(val:Boolean):void;
		function set enabled(value:Boolean):void;
		function get enabled():Boolean;
		function dispose():void;
	}
}
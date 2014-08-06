/*
* Copyright(c) 2011 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES 
*/
package sparrowGui.i
{
	
	/**
	 * 可更换皮肤样式的显示对象
	 * @author Pelephone
	 */
	public interface ISkinCsser
	{
		
		/**
		 * 创建并且设置皮肤样式
		 * @param uiVars
		 */
		 function buildSetUI(uiVars:Object=null):void;
		 
		/**
		 * 改变皮肤样式
		 * @param uiVars
		 */
		function changeStyle(uiVars:String=null):void;
	}
}
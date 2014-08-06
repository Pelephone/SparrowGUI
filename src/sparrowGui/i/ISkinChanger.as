/**
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
	 * 能改变皮肤的对象
	 * Pelephone
	 */
	public interface ISkinChanger
	{
		/**
		 * 改变皮肤
		 * @param uiVars
		 */
		function changeUI(uiVars:Object=null):void;
		
		/**
		 * 重设UI长宽高等参数
		 * @param skinIdName 对应默认皮肤参数的id
		 
		function resetUI(skinIdName:String):void;*/
		
		
		/**
		 * 创建并且设置皮肤样式
		 * @param uiVars
		 
		function buildSetUI(uiVars:Object):void;*/
	}
}
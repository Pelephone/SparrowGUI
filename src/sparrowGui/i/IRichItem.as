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
	 * 富项，带选中和是否可用状态的项
	 * Pelephone
	 */
	public interface IRichItem extends IItem
	{
		/**
		 * 选中
		 * @param value
		 */
		function set selected(value:Boolean):void;
		
		/**
		 * @private 
		 */
		function get selected():Boolean;
		
		/**
		 * 是否可用
		 * @param value
		 */
		function set enabled(value:Boolean):void;
		
		/**
		 * @private 
		 */
		function get enabled():Boolean;
	}
}
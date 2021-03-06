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
package sparrowGui.components.item
{
	
	/**
	 * 向下箭头图标的按钮,滚动用条用
	 * @author Pelephone
	 */
	public class DownArrowButton extends SListItem
	{
		public function DownArrowButton()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultUIVar():Object
		{
			return "downArrow";
		}
	}
}
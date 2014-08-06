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
	import sparrowGui.event.ComponentEvent;
	
	/**
	 * 单选项
	 * @author Pelephone
	 */
	public class SRadioButton extends SToggleButton
	{
		public function SRadioButton(uiVars:Object=null)
		{
			super(uiVars || defaultUIVar);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			if(isRendering)
			{
				if(_hitTestState)
				{
					_hitTestState.width = _width;
					_hitTestState.height = _height;
				}
				
				if(labelText)
				{
					labelText.x = upState.width + 3;
					labelText.width = _width - labelText.x;
				}
				isRendering = false;
			}
			dispatchEvent(new ComponentEvent(ComponentEvent.DRAW));
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultUIVar():Object
		{
			return "radioItem";
		}
	}
}
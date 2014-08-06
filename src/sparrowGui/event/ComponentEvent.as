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
package sparrowGui.event
{
	import flash.events.Event;
	
	
	/**
	 * 组件项基本事件
	 * Pelephone
	 */
	public class ComponentEvent extends Event
	{
		/**
		 * 缓制组件
		 */
		public static const DRAW:String = "draw";
		
		public function ComponentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
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
package uiEdit
{
	import flash.events.Event;
	
	/**
	 * 参数事件
	 * @author Pelephone
	 */
	public class EditEvent extends Event
	{
		//消息参数
		private var _body:Object;
		
		public function EditEvent(type:String, body:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_body = body;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * 获取数组参数的第N个参数
		 */
		public function getDataParam(paramName:String="0"):*
		{
			if(!data.hasOwnProperty("paramName"))
				return null;
			return data[paramName];
		}
		
		public function get data():Object
		{
			return _body;
		}
		
		/**
		 * 将数据转换整型
		 */
		public function get dataInt():int
		{
			return int(_body);
		}
		
		/**
		 * 将数据转换布尔
		 */
		public function get dataBool():Boolean
		{
			return Boolean(_body);
		}
		
		/**
		 * 将数据转换数值
		 */
		public function get dataNum():Number
		{
			return Number(_body);
		}
		
		/**
		 * 将数据转换字符型
		 */
		public function get dataStr():String
		{
			return String(_body);
		}
		
		/** 
		 * 将数据转换数组型
		 */
		public function get dataArr():Array
		{
			return (_body as Array);
		}
		
		/**
		 * 将数据转换成任意数据
		 * @return 
		 */
		public function get dataO():*
		{
			return _body;
		}
		
		/**
		 * 获取数组第N个参数
		 */
		public function getAryByIndex(index:int):*
		{
			if(!dataArr)
				return;
			if((dataArr.length-1)<index)
				return null;
			return dataArr[index];
		}
	}
}
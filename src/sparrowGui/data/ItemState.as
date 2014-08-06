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
package sparrowGui.data
{
	/**
	 * 项状态枚举
	 * Pelephone
	 */
	public class ItemState
	{
		/**
		 * 弹起状态
		 */
		static public const UP:String = "upState";
		
		/**
		 * 经过状态
		 */		
		static public const OVER:String = "overState";
		
		/**
		 * 按下状态
		 */
		static public const DOWN:String = "downState";
		
		/**
		 * 热区
		 */
		static public const HITTEST:String = "hitTestState";
		
		/**
		 * 是否可用状态
		 */
		static public const ENABLED:String = "enabledState";
		
		/**
		 * 选中状态.五态按钮SListItem,SRichItem用到
		 */
		public static const SELECT:String = "selectState";
		
		/**
		 * 合起状态,STreeItem用到
		 */
		public static const FOLD:String = "foldState";
	}
}
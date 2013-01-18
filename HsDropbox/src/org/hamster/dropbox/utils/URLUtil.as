////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2004-2007 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package org.hamster.dropbox.utils
{
	/**
	 * Copied from mx.utils.URLUtil, to ensure the api works under a non-flex environment.
	 */
	public class URLUtil
	{
		public function URLUtil()
		{
		}
		
		public static function objectToString(object:Object, separator:String=';',
											  encodeURL:Boolean = true):String
		{
			var s:String = internalObjectToString(object, separator, null, encodeURL);
			return s;
		}
		
		private static function internalObjectToString(object:Object, separator:String, prefix:String, encodeURL:Boolean):String
		{
			var s:String = "";
			var first:Boolean = true;
			
			for (var p:String in object)
			{
				if (first)
				{
					first = false;
				}
				else
					s += separator;
				
				var value:Object = object[p];
				var name:String = prefix ? prefix + "." + p : p;
				if (encodeURL)
					name = encodeURIComponent(name);
				
				if (value is String)
				{
					s += name + '=' + (encodeURL ? encodeURIComponent(value as String) : value);
				}
				else if (value is Number)
				{
					value = value.toString();
					if (encodeURL)
						value = encodeURIComponent(value as String);
					
					s += name + '=' + value;
				}
				else if (value is Boolean)
				{
					s += name + '=' + (value ? "true" : "false");
				}
				else
				{
					if (value is Array)
					{
						s += internalArrayToString(value as Array, separator, name, encodeURL);
					}
					else // object
					{
						s += internalObjectToString(value, separator, name, encodeURL);
					}
				}
			}
			return s;
		}
		
		private static function internalArrayToString(array:Array, separator:String, prefix:String, encodeURL:Boolean):String
		{
			var s:String = "";
			var first:Boolean = true;
			
			var n:int = array.length;
			for (var i:int = 0; i < n; i++)
			{
				if (first)
				{
					first = false;
				}
				else
					s += separator;
				
				var value:Object = array[i];
				var name:String = prefix + "." + i;
				if (encodeURL)
					name = encodeURIComponent(name);
				
				if (value is String)
				{
					s += name + '=' + (encodeURL ? encodeURIComponent(value as String) : value);
				}
				else if (value is Number)
				{
					value = value.toString();
					if (encodeURL)
						value = encodeURIComponent(value as String);
					
					s += name + '=' + value;
				}
				else if (value is Boolean)
				{
					s += name + '=' + (value ? "true" : "false");
				}
				else
				{
					if (value is Array)
					{
						s += internalArrayToString(value as Array, separator, name, encodeURL);
					}
					else // object
					{
						s += internalObjectToString(value, separator, name, encodeURL);
					}
				}
			}
			return s;
		}
		
		
	}
}
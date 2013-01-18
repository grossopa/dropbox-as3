package org.hamster.dropbox.models
{
	/**
	 * The basic dropbox model class
	 * 
	 * @author yinzeshuo
	 */
	public class DropboxModelSupport
	{
		/**
		 * the original result object, usually be plain text.
		 */
		protected var _sourceObject:Object;
		
		public function DropboxModelSupport()
		{
		}
		
		public function decode(result:Object):void
		{
			this._sourceObject = result;
		}
		
		public function toString():String
		{
			return "";
		}
		
	}
}
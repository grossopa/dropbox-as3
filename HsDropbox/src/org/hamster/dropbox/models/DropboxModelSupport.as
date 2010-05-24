package org.hamster.dropbox.models
{
	import mx.utils.ObjectUtil;

	public class DropboxModelSupport
	{
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
			return ObjectUtil.toString(this);
		}
		
	}
}
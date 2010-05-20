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
		
		public function encode():Object
		{
//			if (this._sourceObject != null) {
//				return this._sourceObject;
//			} else {
//				//TODO: return a generated 
//			}
			return null;
		}
		
		public function toString():String
		{
			return ObjectUtil.toString(this);
		}
		
	}
}
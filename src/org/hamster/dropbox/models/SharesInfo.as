package org.hamster.dropbox.models
{
	public class SharesInfo extends DropboxModelSupport
	{
		public var url:String;
		public var expires:String;
		
		public function SharesInfo()
		{
			super();
		}
		
		/**
		 * decode a object
		 *  
		 * @param result
		 */
		override public function decode(result:Object):void
		{
			super.decode(result);
			
			this.url = result['url'];
			this.expires = result['expires'];
		}
		
		override public function toString():String 
		{
			var s:String = "SharesInfo [";
			s	+=  ", url=" + (url == null || url.length == 0 ? "null" : url);
			s	+=  ", expires=" + (expires == null || expires.length == 0 ? "null" : expires) + "]";
			return s;
		}
	}
}
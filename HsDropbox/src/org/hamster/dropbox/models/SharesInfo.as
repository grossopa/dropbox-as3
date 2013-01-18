package org.hamster.dropbox.models
{
	/**
	 * SharesInfo
	 * 
	 * @author yinzeshuo
	 */
	public class SharesInfo extends DropboxModelSupport
	{
		private var _url:String;
		private var _expires:Date;
		
		public function set expires(value:Date):void
		{
			this._expires = value;
		}
		
		/**
		 * Expired date of the shared url.
		 * 
		 * <p><b>All links are currently set to expire far enough in the future 
		 * so that expiration is effectively not an issue.</b></p>
		 */
		public function get expires():Date
		{
			return this._expires;
		}
		
		public function set url(value:String):void
		{
			this._url = value;
		}
		
		/**
		 * The sharing url.
		 */
		public function get url():String
		{
			return this._url;
		}
		
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
			this.expires = new Date(result['expires']);
		}
		
		override public function toString():String 
		{
			var s:String = "SharesInfo [";
			s	+=  "url=" + (url == null || url.length == 0 ? "null" : url);
			s	+=  ", expires=" + (expires == null ? "null" : expires.toString()) + "]";
			return s;
		}
	}
}
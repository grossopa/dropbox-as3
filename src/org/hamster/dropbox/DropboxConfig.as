
package org.hamster.dropbox
{
	/**
	 * Dropbox Client configuration
	 * 
	 * @author yinzeshuo
	 * 
	 */
	public class DropboxConfig
	{
		public static const API_VERSION:int = 1;
		public static const SERVER:String = 'https://api.dropbox.com';
		public static const CONTENT_SERVER:String = 'https://api-content.dropbox.com';
		public static const PORT:int = 80;
//		public static const REQUEST_TOKEN_URL:String = 'http://api.dropbox.com/0/oauth/request_token';
//		public static const ACCESS_TOKEN_URL:String = 'http://api.dropbox.com/0/oauth/access_token';
//		public static const AUTHORIZATION_URL:String = 'https://www.dropbox.com/0/oauth/authorize';
//		public static const TOKEN_URL:String = 'https://api.dropbox.com/0/token';
		public static const REQUEST_TOKEN_URL:String = 'https://api.dropbox.com/1/oauth/request_token';
		public static const ACCESS_TOKEN_URL:String = 'https://api.dropbox.com/1/oauth/access_token';
		public static const AUTHORIZATION_URL:String = 'https://www.dropbox.com/1/oauth/authorize';
		public static const TOKEN_URL:String = 'https://api.dropbox.com/1/token';
		public static const SANDBOX:String = 'sandbox';
		public static const DROPBOX:String = 'dropbox';
		/**
		 * xperiments UPDATE 
		 */
		public static const ACCOUNT_CREATE_URL:String = 'https://api.dropbox.com/1/account';		
		
		public var consumerKey:String;
		public var consumerSecret:String;
		public var requestTokenKey:String;
		public var requestTokenSecret:String;
		public var accessTokenKey:String;
		public var accessTokenSecret:String;
		/**
		 *  Optional, do not manually set it only if Dropbox API changed.
		 */
		public var apiVersion:int;
		/**
		 *  Optional, do not manually set it only if Dropbox API changed.
		 */
		public var server:String;
		/**
		 *  Optional, do not manually set it only if Dropbox API changed.
		 */
		public var contentServer:String;
		/**
		 *  Optional, do not manually set it only if Dropbox API changed.
		 */
		public var port:int;
		/**
		 *  Optional, do not manually set it only if Dropbox API changed.
		 */
		public var requestTokenUrl:String;
		/**
		 *  Optional, do not manually set it only if Dropbox API changed.
		 */
		public var accessTokenUrl:String;
		/**
		 *  Optional, do not manually set it only if Dropbox API changed.
		 */
		public var authorizationUrl:String;
		
		/**
		 * Token URL for getting access token by user's email and password. 
		 */
		public var tokenUrl:String;
		/**
		 * xperiments UPDATE 
		 * Account Create URL for getting for registering a new account by user's name, first name, email password. 
		 */
		public var accountCreateUrl:String;	
		
		/**
		 * * Added In Version 1
		 * locale for response language
		 */
		public var locale:String = "en_US";
		
		/**
		 * Constructor
		 *  
		 * @param consumerKey
		 * @param consumerSecret
		 * @param requestTokenKey optional
		 * @param requestTokenSecret optional
		 * @param accessTokenKey optional
		 * @param accessTokenSecret optional
		 */
		public function DropboxConfig(
			consumerKey:String, consumerSecret:String,
			requestTokenKey:String = "", requestTokenSecret:String = "",
			accessTokenKey:String = "", accessTokenSecret:String = "", locale:String = "en_US")
		{
			this.setConsumer(consumerKey, consumerSecret);
			this.setRequestToken(requestTokenKey, requestTokenSecret);
			this.setAccessToken(accessTokenKey, accessTokenSecret);
			this.apiVersion = API_VERSION;
			this.server = SERVER;
			this.contentServer = CONTENT_SERVER;
			this.port = PORT;
			this.requestTokenUrl = REQUEST_TOKEN_URL;
			this.accessTokenUrl = ACCESS_TOKEN_URL;
			this.authorizationUrl = AUTHORIZATION_URL;
			this.tokenUrl = TOKEN_URL;
			/**
			 * xperiments UPDATE 
			 */			
			this.accountCreateUrl = ACCOUNT_CREATE_URL;
			
			this.locale = locale;
		}
		
		/**
		 * It's recommended to use this function rather than set key/secret manaually.
		 * It will help you to check whether key/secret are both exists.
		 *  
		 * @param key
		 * @param secret
		 * @throws Error if key is not empty but secret is empty
		 */
		public function setConsumer(key:String, secret:String):void
		{
			if (!isEmpty(key) && isEmpty(secret)) {
				throw new Error('consumer secret is null but key is not null!');
			}
			this.consumerKey = key;
			this.consumerSecret = secret;
		}
		
		/**
		 * It's recommended to use this function rather than set key/secret manaually.
		 * It will help you to check whether key/secret are both exists.
		 *  
		 * @param key
		 * @param secret
		 * @throws Error if key is not empty but secret is empty
		 */
		public function setRequestToken(key:String, secret:String):void
		{
			if (!isEmpty(key) && isEmpty(secret)) {
				throw new Error('request token secret is null but key is not null!');
			}
			this.requestTokenKey = key;
			this.requestTokenSecret = secret;
		}
		
		/**
		 * It's recommended to use this function rather than set key/secret manaually.
		 * It will help you to check whether key/secret are both exists.
		 *  
		 * @param key
		 * @param secret
		 * @throws Error if key is not empty but secret is empty
		 */
		public function setAccessToken(key:String, secret:String):void
		{
			if (!isEmpty(key) && isEmpty(secret)) {
				throw new Error('access token secret is null but key is not null!');
			}
			this.accessTokenKey = key;
			this.accessTokenSecret = secret;
		}
		
		/**
		 * @private
		 * 
		 * Check whether the string is empty.
		 */
		protected static function isEmpty(str:String):Boolean
		{
			return str != null && str.length > 0;
		}
	}
}
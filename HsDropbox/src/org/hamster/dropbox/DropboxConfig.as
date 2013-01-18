package org.hamster.dropbox
{
	/**
	 * Dropbox Client configuration
	 * 
	 * @author yinzeshuo
	 */
	public class DropboxConfig
	{
		public static const API_VERSION:int 		  = 1;
		public static const SERVER:String 			  = 'https://api.dropbox.com';
		public static const CONTENT_SERVER:String 	  = 'https://api-content.dropbox.com';
		public static const PORT:int 				  = 80;
		public static const REQUEST_TOKEN_URL:String  = 'https://api.dropbox.com/1/oauth/request_token';
		public static const ACCESS_TOKEN_URL:String   = 'https://api.dropbox.com/1/oauth/access_token';
		public static const AUTHORIZATION_URL:String  = 'https://www.dropbox.com/1/oauth/authorize';
		public static const TOKEN_URL:String          = 'https://api.dropbox.com/1/token';
		public static const SANDBOX:String            = 'sandbox';
		public static const DROPBOX:String            = 'dropbox';
		public static const ACCOUNT_CREATE_URL:String = 'https://api.dropbox.com/1/account';		
		
		private var _consumerKey:String;
		private var _consumerSecret:String;
		private var _requestTokenKey:String;
		private var _requestTokenSecret:String;
		private var _accessTokenKey:String;
		private var _accessTokenSecret:String;
		
		public function set consumerKey(value:String):void
		{
			this._consumerKey = value;
		}
		
		/**
		 * consumer key of the application
		 */
		public function get consumerKey():String
		{
			return this._consumerKey;
		}
		
		public function set consumerSecret(value:String):void
		{
			this._consumerSecret = value;
		}
		
		/**
		 * consumer secret of the application
		 */
		public function get consumerSecret():String
		{
			return this._consumerSecret;
		}
		
		public function set requestTokenKey(value:String):void
		{
			this._requestTokenKey = value;
		}
		
		/**
		 * request token key
		 */
		public function get requestTokenKey():String
		{
			return this._requestTokenKey;
		}
		
		public function set requestTokenSecret(value:String):void
		{
			this._requestTokenSecret = value;
		}
		
		/**
		 * request token secret
		 */
		public function get requestTokenSecret():String
		{
			return this._requestTokenSecret;
		}
		
		public function set accessTokenKey(value:String):void
		{
			this._accessTokenKey = value;
		}
		
		/**
		 * access token key
		 */
		public function get accessTokenKey():String
		{
			return this._accessTokenKey;
		}
		
		public function set accessTokenSecret(value:String):void
		{
			this._accessTokenSecret = value;
		}
		
		/**
		 * access token secret
		 */
		public function get accessTokenSecret():String
		{
			return this._accessTokenSecret;
		}
		
		private var _apiVersion:int;
		private var _server:String;
		private var _contentServer:String;
		private var _port:int;
		private var _requestTokenUrl:String;
		private var _accessTokenUrl:String;
		private var _authorizationUrl:String;
		private var _tokenUrl:String;
		private var _accountCreateUrl:String;	
		private var _locale:String = "en_US";
		
		public function set apiVersion(value:int):void
		{
			this._apiVersion = value;
		}
		
		/**
		 * api version, default value is API_VERSION. 
		 * generally you don't need to change this value.
		 * 
		 * @see org.hamster.dropbox.DropboxConfig#API_VERSION
		 */
		public function get apiVersion():int
		{
			return this._apiVersion;
		}
		
		public function set server(value:String):void
		{
			this._server = value;
		}
		
		/**
		 * server, default value is SERVER. 
		 * generally you don't need to change this value.
		 * 
		 * @see org.hamster.dropbox.DropboxConfig#API_VERSION
		 */
		public function get server():String
		{
			return this._server;
		}
		
		public function set contentServer(value:String):void
		{
			this._contentServer = value;
		}
		
		/**
		 * content server, default value is CONTENT_SERVER. 
		 * generally you don't need to change this value.
		 * 
		 * @see org.hamster.dropbox.DropboxConfig#CONTENT_SERVER
		 */
		public function get contentServer():String
		{
			return this._contentServer;
		}
		
		public function set port(value:int):void
		{
			this._port = value;
		}
		
		/**
		 * port, default value is PORT. 
		 * generally you don't need to change this value.
		 * 
		 * @see org.hamster.dropbox.DropboxConfig#PORT
		 */
		public function get port():int
		{
			return this._port;
		}
		
		public function set requestTokenUrl(value:String):void
		{
			this._requestTokenUrl = value;
		}
		
		/**
		 * request token url, default value is REQUEST_TOKEN_URL. 
		 * generally you don't need to change this value.
		 * 
		 * @see org.hamster.dropbox.DropboxConfig#REQUEST_TOKEN_URL
		 */
		public function get requestTokenUrl():String
		{
			return this._requestTokenUrl;
		}
		
		public function set accessTokenUrl(value:String):void
		{
			this._accessTokenUrl = value;
		}
		
		/**
		 * access token url, default value is ACCESS_TOKEN_URL. 
		 * generally you don't need to change this value.
		 * 
		 * @see org.hamster.dropbox.DropboxConfig#ACCESS_TOKEN_URL
		 */
		public function get accessTokenUrl():String
		{
			return this._accessTokenUrl;
		}
		
		public function set authorizationUrl(value:String):void
		{
			this._authorizationUrl = value;
		}
		
		/**
		 * authorization url, default value is AUTHORIZATION_URL. 
		 * generally you don't need to change this value.
		 * 
		 * @see org.hamster.dropbox.DropboxConfig#AUTHORIZATION_URL
		 */
		public function get authorizationUrl():String
		{
			return this._authorizationUrl;
		}
		
		public function set tokenUrl(value:String):void
		{
			this._tokenUrl = value;
		}
		
		/**
		 * token url, default value is TOKEN_URL. 
		 * generally you don't need to change this value.
		 * 
		 * @see org.hamster.dropbox.DropboxConfig#TOKEN_URL
		 */
		public function get tokenUrl():String
		{
			return this._tokenUrl;
		}
		public function set accountCreateUrl(value:String):void
		{
			this._accountCreateUrl = value;
		}
		
		/**
		 * account create url, default value is ACCOUNT_CREATE_URL. 
		 * generally you don't need to change this value.
		 * 
		 * @see org.hamster.dropbox.DropboxConfig#ACCOUNT_CREATE_URL
		 */
		public function get accountCreateUrl():String
		{
			return this._accountCreateUrl;
		}
		
		public function set locale(value:String):void
		{
			this._locale = value;
		}
		
		/**
		 * locale of the response, default to be "en_US".
		 */
		public function get locale():String
		{
			return this._locale;
		}
		
		
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
			if ((isEmpty(key) && !isEmpty(secret)) || (!isEmpty(key) && isEmpty(secret))) {
				throw new Error('Consumer key/secret values should be either exists or empty for both.');
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
			if ((isEmpty(key) && !isEmpty(secret)) || (!isEmpty(key) && isEmpty(secret))) {
				throw new Error('Request token key/secret values should be either exists or empty for both.');
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
			if ((isEmpty(key) && !isEmpty(secret)) || (!isEmpty(key) && isEmpty(secret))) {
				throw new Error('Access token key/secret values should be either exists or empty for both.');
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
package org.hamster.dropbox
{

	public class DropboxConfig
	{
		public static const API_VERSION:int = 0;
		public static const SERVER:String = 'api.dropbox.com';
		public static const CONETENT_SERVER:String = 'api-content.dropbox.com';
		public static const PORT:int = 80;
		public static const REQUEST_TOKEN_URL:String = 'http://api.dropbox.com/0/oauth/request_token';
		public static const ACCESS_TOKEN_URL:String = 'http://api.dropbox.com/0/oauth/access_token';
		public static const AUTHORIZATION_URL:String = 'http://api.dropbox.com/0/oauth/authorize';
		public static const SANDBOX:String = 'sandbox';
		public static const DROPBOX:String = 'dropbox';
		
		public var consumerKey:String;
		public var consumerSecret:String;
		public var requestTokenKey:String;
		public var requestTokenSecret:String;
		public var accessTokenKey:String;
		public var accessTokenSecret:String;
		public var apiVersion:int;
		public var server:String;
		public var contentServer:String;
		public var port:int;
		public var requestTokenUrl:String;
		public var accessTokenUrl:String;
		public var authorizationUrl:String;
		public var root:String;
		
		public function DropboxConfig(
			consumerKey:String = "",consumerSecret:String = "",
			requestTokenKey:String = "", requestTokenSecret:String = "",
			accessTokenKey:String = "", accessTokenSecret:String = "",
			apiVersion:int = API_VERSION, server:String = SERVER,
			contentServer:String = CONETENT_SERVER, port:int = PORT,
			requestTokenUrl:String = REQUEST_TOKEN_URL, 
			accessTokenUrl:String = ACCESS_TOKEN_URL,
			authorizationUrl:String = AUTHORIZATION_URL,
			root:String = SANDBOX)
		{
			this.setConsumer(consumerKey, consumerSecret);
			this.setRequestToken(requestTokenKey, requestTokenSecret);
			this.setAccessToken(accessTokenKey, accessTokenSecret);
			this.apiVersion = apiVersion;
			this.server = server;
			this.contentServer = contentServer;
			this.port = port;
			this.requestTokenUrl = requestTokenUrl;
			this.accessTokenUrl = accessTokenUrl;
			this.authorizationUrl = authorizationUrl;
		}
		
		public function setConsumer(key:String, secret:String):void
		{
			if (!isEmpty(key) && isEmpty(secret)) {
				throw new Error('consumer secret is null but key is not null!');
			}
			this.consumerKey = key;
			this.consumerSecret = secret;
		}
		
		public function setRequestToken(key:String, secret:String):void
		{
			if (!isEmpty(key) && isEmpty(secret)) {
				throw new Error('request token secret is null but key is not null!');
			}
			this.requestTokenKey = key;
			this.requestTokenSecret = secret;
		}
		
		public function setAccessToken(key:String, secret:String):void
		{
			if (!isEmpty(key) && isEmpty(secret)) {
				throw new Error('access token secret is null but key is not null!');
			}
			this.accessTokenKey = key;
			this.accessTokenSecret = secret;
		}
		
		public static function isEmpty(str:String):Boolean
		{
			return str != null && str.length > 0;
		}
	}
}
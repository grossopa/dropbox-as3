/**
 * Issue 4: add fail information to DropboxEvent.resultObject;
 */
package org.hamster.dropbox
{
	import com.adobe.serialization.json.JSON;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import mx.utils.URLUtil;
	
	import org.hamster.dropbox.models.AccountInfo;
	import org.hamster.dropbox.models.DropboxFile;
	import org.hamster.dropbox.utils.OAuthHelper;
	
	import ru.inspirit.net.MultipartURLLoader;

	[Event(name="accountCreateResult",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="accountCreateFault",   type="org.hamster.dropbox.DropboxEvent")]
	
	[Event(name="requestTokenResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="requestTokenFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="accessTokenResult",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="accessTokenFault",   type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="tokenResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="tokenFault",  type="org.hamster.dropbox.DropboxEvent")]
	
	[Event(name="accountInfoResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="accountInfoFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="putFileResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="putFileFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="fileCopyResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="fileCopyFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="fileCreateFolderResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="fileCreateFolderFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="fileDeleteResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="fileDeleteFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="fileMoveResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="fileMoveFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="getFileResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="getFileFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="metadataResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="metadataFault",  type="org.hamster.dropbox.DropboxEvent")]
	
	/**
	 * Dropbox client class, in order to use, you should build an instance of
	 * it and put a DropboxConfig instance into it.
	 * 
	 * OAuth workflow:
	 * 1. Ensure that the consumer key/secret pair is set;
	 * 2. Call requestToken() function, register REQUEST_TOKEN_RESULT listener
	 *    and call authorizationUrl() to get the authorization URL;
	 * 3. Let user open the URL and allow application to access;
	 * 4. Call accessToken() function to get access token key/secret pair;
	 * 5. Currently you have 3 key/secret pairs, consumer, requestToken and accessToken,
	 *    store all properties of DropboxConig to somewhere.
	 * 
	 * API access:
	 * 1. Ensure all tokens are set to DropboxConfig;
	 * 2. Register listener before you call any API;
	 * 3. Unregister listener if the listener is no longer necessary.
	 *  
	 * Each API function will return a URLLoader instance which load(urlReqeust:URLRequest)
	 * has been called, you can register other listeners if you want. After the request is
	 * done, the corresponding event will be dispatched from this class.
	 * 
	 * @author yinzeshuo
	 */
	public class DropboxClient extends EventDispatcher
	{
		protected static const REQUEST_TOKEN:String = 'request_token';
		protected static const ACCESS_TOKEN:String = 'access_token';
		protected static const ACCOUNT_INFO:String = 'account_info';
		protected static const DROPBOX_FILE:String = 'dropbox_file';
		
		/**
		 * xperiments UPDATE 
		 */
		protected static const ACCOUNT_CREATE:String = 'account_create';
		
		/**
		 * @private
		 */
		private var _config:DropboxConfig;
		
		/**
		 * @private
		 */
		public function get config():DropboxConfig
		{
			return this._config;
		}
		
		/**
		 * Constructor
		 *  
		 * @param config the consumer key/secret must be set
		 */
		public function DropboxClient(config:DropboxConfig)
		{
			_config = config;
		}
		
		/**
		 * xperiments UPDATE 
		 */
		public function createAccount( email:String, password:String, first_name:String, last_name:String ):URLLoader
		{
			var url:String = config.accountCreateUrl;
			var params:Object = {
				email:email,
				first_name:first_name,
				last_name: last_name,
				password:password 
			}
			var urlReqHeader:URLRequestHeader = OAuthHelper.buildURLRequestHeader(url, params, 
				config.consumerKey, config.consumerSecret, 
				config.requestTokenKey, config.requestTokenSecret, URLRequestMethod.POST);
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.requestHeaders = [urlReqHeader];
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.url = url;
			urlRequest.data = 'email=' + encodeURIComponent(email) + '&password=' + encodeURIComponent(password) + '&first_name=' + encodeURIComponent(first_name) + '&last_name=' + encodeURIComponent(last_name);
			
			var urlLoader:DropboxURLLoader = new DropboxURLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.eventResultType = DropboxEvent.ACCOUNT_CREATE_RESULT;
			urlLoader.eventFaultType = DropboxEvent.ACCOUNT_CREATE_FAULT;
			urlLoader.resultType = ACCOUNT_CREATE;
			
			urlLoader.addEventListener(Event.COMPLETE, createAccountCompleteHandler);
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			urlLoader.load(urlRequest);
			return urlLoader;			
		}	
		/**
		 * xperiments UPDATE 
		 */		
		private function createAccountCompleteHandler(evt:Event):void
		{
			var resultObject:Object ={ status:'ok' };
			this.dispatchDropboxEvent(DropboxEvent.ACCOUNT_CREATE_RESULT, evt, resultObject);
		}
		
		/**
		 * request the request token by consumer key/secret. before you call this API,
		 * you should ensure that you have consumer key/secret pair.
		 *  
		 * @return urlLoader
		 */
		public function requestToken():URLLoader
		{
			var url:String = config.requestTokenUrl;
			var urlRequest:URLRequest = buildURLRequest(url, "", null, URLRequestMethod.POST);
			urlRequest.url = url;
			return this.load(urlRequest, DropboxEvent.REQUEST_TOKEN_RESULT, 
				DropboxEvent.REQUEST_TOKEN_FAULT, REQUEST_TOKEN);
		}
		
		/**
		 * request the access token by consumer key/secret, before you call this API,
		 * you should ensure taht you have consumer key/secret pair and request token key secret pair
		 * and the user has go to dropbox website to allow access of application.
		 *  
		 * @return urlLoader
		 */
		public function accessToken():URLLoader
		{
			var url:String = config.accessTokenUrl;
			var urlReqHeader:URLRequestHeader = OAuthHelper.buildURLRequestHeader(url, null, 
				config.consumerKey, config.consumerSecret, 
				config.requestTokenKey, config.requestTokenSecret, URLRequestMethod.POST);
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.requestHeaders = [urlReqHeader];
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.url = url;
			return this.load(urlRequest, DropboxEvent.ACCESS_TOKEN_RESULT, 
				DropboxEvent.ACCESS_TOKEN_FAULT, ACCESS_TOKEN);
		}
		
		/**
		 * The token call provides a consumer/secret key pair you can use to consistently access the user's account.
		 * This is the preferred method of authentication over storing the username and password. Use the key pair 
		 * as a signature with every subsequent call.
		 * 
		 * <p>The request must be signed using the application's developer and secret key token.
		 * Request or access tokens are necessary. </p>
		 * 
		 * <p>DO NOT STORE THE USER'S PASSWORD!</p>
		 * 
		 * @param email
		 * @param password
		 * @return urlLoader
		 * 
		 */
		public function token(email:String, password:String):URLLoader
		{
			var url:String = config.tokenUrl;
			var params:Object = {
				email : email,
				password : password
			}
			var urlReqHeader:URLRequestHeader = OAuthHelper.buildURLRequestHeader(url, params, 
				config.consumerKey, config.consumerSecret, 
				config.requestTokenKey, config.requestTokenSecret, URLRequestMethod.POST);
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.requestHeaders = [urlReqHeader];
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.url = url;
			urlRequest.data = 'email=' + encodeURIComponent(email) + '&password=' + encodeURIComponent(password);
			
			var urlLoader:DropboxURLLoader = new DropboxURLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.eventResultType = DropboxEvent.TOKEN_RESULT;
			urlLoader.eventFaultType = DropboxEvent.TOKEN_FAULT;
			urlLoader.resultType = ACCESS_TOKEN;
			
			urlLoader.addEventListener(Event.COMPLETE, tokenCompleteHandler);
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			urlLoader.load(urlRequest);
			return urlLoader;
		}
		
		/**
		 * @private 
		 */
		private function tokenCompleteHandler(evt:Event):void
		{
			var urlLoader:DropboxURLLoader = DropboxURLLoader(evt.target);
			var resultObject:*;
			try {
				var accessToken:Object = JSON.decode(urlLoader.data);
				this.config.accessTokenKey = accessToken.token;
				this.config.accessTokenSecret = accessToken.secret;
				resultObject = accessToken;
			} catch (e:Error) {
				this.dispatchDropboxEvent(DropboxEvent.TOKEN_FAULT, evt, e);
				return;
			}
			
			this.dispatchDropboxEvent(DropboxEvent.TOKEN_RESULT, evt, resultObject);
		}
		
		/**
		 * get authorization url address, return empty string if request token key is not ready.
		 *  
		 * @return authorization url address
		 */
		public function get authorizationUrl():String
		{
			if (config.requestTokenKey != null) {
				return this.config.authorizationUrl + '?oauth_token=' + config.requestTokenKey;
			} else {
				return "";
			}
		}
		
		/**
		 * The account/info API call to Dropbox for getting info about an account attached to the access token.
		 * Return status and account information in JSON format.
		 * 
		 * @return urlLoader
		 */
		public function accountInfo():URLLoader
		{
			var urlRequest:URLRequest = buildURLRequest(
				config.server, "/account/info", null);
			return this.load(urlRequest, DropboxEvent.ACCOUNT_INFO_RESULT, 
				DropboxEvent.ACCOUNT_INFO_FAULT, ACCOUNT_INFO);
		}
		
		/**
		 * Copy a file from one path to another, with root being either "sandbox" or "dropbox".
		 * return copied file metadata information in JSON format.
		 * 
		 * @param fromPath
		 * @param toPath
		 * @param root, optional, default is "dropbox" 2011/01/22
		 * @return urlLoader
		 */
		public function fileCopy(fromPath:String, toPath:String, 
								 root:String = DropboxConfig.DROPBOX):URLLoader
		{
			var params:Object = { 
				"root": root, 
				"from_path": fromPath,
				"to_path": toPath
			};
			var urlRequest:URLRequest = buildURLRequest(
				config.server, "/fileops/copy", params, URLRequestMethod.POST);
			return this.load(urlRequest, DropboxEvent.FILE_COPY_RESULT, 
				DropboxEvent.FILE_COPY_FAULT, DROPBOX_FILE);
		}
		
		/**
		 * Create a folder at the given path. Return created folder 
		 * metadata information in JSON format.
		 * 
		 * @param path
		 * @param root, optional, default is "dropbox" 2011/01/22
		 * @return urlLoader
		 */
		public function fileCreateFolder(path:String, 
			root:String = DropboxConfig.DROPBOX):URLLoader
		{
			var params:Object = { 
				"root": root, 
				"path": path
			};
			var urlRequest:URLRequest = buildURLRequest(
				config.server, "/fileops/create_folder", params, URLRequestMethod.POST);
			return this.load(urlRequest, DropboxEvent.FILE_CREATE_FOLDER_RESULT, 
				DropboxEvent.FILE_CREATE_FOLDER_FAULT, DROPBOX_FILE);
		}
		
		/** 
		 * Delete a file.
		 * 
		 * @param path full file path
		 * @param root, optional, default is "dropbox" 2011/01/22
		 * @return urlLoader
		 */
		public function fileDelete(path:String, 
			root:String = DropboxConfig.DROPBOX):URLLoader
		{
			var params:Object = { 
				"root": root, 
				"path": path
			};
			
			var urlRequest:URLRequest = buildURLRequest(
				config.server, "/fileops/delete", params, URLRequestMethod.POST);
			return this.load(urlRequest, DropboxEvent.FILE_DELETE_RESULT, 
				DropboxEvent.FILE_DELETE_FAULT, "");
		}
		
		/** 
		 * Move a file.
		 * 
		 * @param fromPath
		 * @param toPath
		 * @param root, optional, default is "dropbox" 2011/01/22
		 * @return urlLoader
		 */
		public function fileMove(fromPath:String, toPath:String, 
								 root:String = DropboxConfig.DROPBOX):URLLoader
		{
			var params:Object = { 
				"root" : root, 
				"from_path": fromPath,
				"to_path": toPath
			};
			var urlRequest:URLRequest = buildURLRequest(
				config.server, "/fileops/move", params, URLRequestMethod.POST);
			return this.load(urlRequest, DropboxEvent.FILE_MOVE_RESULT, 
				DropboxEvent.FILE_MOVE_FAULT, DROPBOX_FILE);
		}
		
		/**
		 * Get metadata about directories and files, such as file listings and such.
		 * 
		 * @param path
		 * @param fileLimit
		 * @param hash pass a hash value to perform better performance
		 * @param list if query a directory, true to show sub list.
		 * @param root, optional, default is "dropbox" 2011/01/22
		 * @return urlLoader
		 */
		public function metadata(path:String, 
			fileLimit:int, hash:String, list:Boolean,
			root:String = DropboxConfig.DROPBOX):URLLoader
		{
			var params:Object = {
				"file_limit" : fileLimit,
				"hash": hash,
				"list": list
			};
			
			var urlRequest:URLRequest = buildURLRequest(
				config.server, "/metadata/" + root + '/' + buildFilePath(path), params);
			return this.load(urlRequest, DropboxEvent.METADATA_RESULT, 
				DropboxEvent.METADATA_FAULT, DROPBOX_FILE);
		}
		
		/**
		 * Get thumbnails of a photo, dispatch a fault event if no thumbnails available 
		 * or photo doesn't exist.
		 * 
		 * @param pathToPhoto
		 * @param size optional, small|medium|large, medium as default
		 * @param root, optional, default is "dropbox" 2011/01/22
		 * @return urlLoader
		 */
		public function thumbnails(pathToPhoto:String, size:String = "",
								 root:String = DropboxConfig.DROPBOX):URLLoader
		{
			var params:Object = {
				"size" : size
			};
			var urlRequest:URLRequest = buildURLRequest(
				config.contentServer, "/thumbnails/" + root + '/' + buildFilePath(pathToPhoto), params);
			return this.load(urlRequest, DropboxEvent.THUMBNAILS_RESULT, 
				DropboxEvent.THUMBNAILS_FAULT, "", URLLoaderDataFormat.BINARY);
		}
		
		/**
		 * Get a file from the content server, returning the raw Apache HTTP Components response object
		 * so you can stream it or work with it how you need. 
		 * 
		 * @param filePath
		 * @param root, optional, default is "dropbox" 2011/01/22
		 * @return urlLoader
		 */
		public function getFile(filePath:String, 
								root:String=DropboxConfig.DROPBOX):URLLoader
		{
			var urlRequest:URLRequest = buildURLRequest(
				config.contentServer, "/files/" + root + '/' +  buildFilePath(filePath), null);
			return this.load(urlRequest, DropboxEvent.GET_FILE_RESULT, 
				DropboxEvent.GET_FILE_FAULT, "", URLLoaderDataFormat.BINARY);
		}
		 
		/**
		 * Put a file to server.
		 *  
		 * @param filePath
		 * @param fileName
		 * @param data
		 * @param root, optional, default is "dropbox" 2011/01/22
		 * @return multipartURLLoader
		 */
		public function putFile(filePath:String, 
								fileName:String, 
								data:ByteArray, 
								root:String = DropboxConfig.DROPBOX):MultipartURLLoader
		{
			var url:String = this.buildFullURL(config.contentServer, '/files/' + root + '/' + buildFilePath(filePath));
			var params:Object = { 
				"file" : fileName
			};
			var urlReqHeader:URLRequestHeader = OAuthHelper.buildURLRequestHeader(url, params, 
				config.consumerKey, config.consumerSecret, 
				config.accessTokenKey, config.accessTokenSecret, URLRequestMethod.POST);
			var m:MultipartURLLoader = new MultipartURLLoader();
			m.requestHeaders = [urlReqHeader];
			m.addFile(data, fileName, 'file');
			m.addEventListener(Event.COMPLETE, uploadCompleteHandler);
			m.addEventListener(IOErrorEvent.IO_ERROR, uploadIOErrorHandler);
			m.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadSecurityErrorHandler);
			m.load(url);
			return m;
		}
		
		/**
		 * Build a OAuth URL request.
		 *  
		 * @param apiHost
		 * @param target
		 * @param params
		 * @param httpMethod
		 * @param protocol
		 * @return built URL request
		 */
		protected function buildURLRequest(apiHost:String, target:String, params:Object,
									    httpMethod:String = URLRequestMethod.GET,
									    protocol:String = 'http'):URLRequest
		{
			var url:String = this.buildFullURL(apiHost, target, protocol);
			
			var urlReqHeader:URLRequestHeader = OAuthHelper.buildURLRequestHeader(url, params, 
				config.consumerKey, config.consumerSecret, 
				config.accessTokenKey, config.accessTokenSecret, httpMethod);
			
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.requestHeaders = [urlReqHeader];
			urlRequest.method = httpMethod;
			urlRequest.data = URLUtil.objectToString(params, '&');
			urlRequest.url = url;
			return urlRequest;
		}
		
		/**
		 * Load a URL request.
		 * 
		 * @param urlRequest
		 * @param evtResultType
		 * @param evtFaultType
		 * @param resultType
		 * @param dataFormat
		 * @return urlLoader
		 */
		protected function load(urlRequest:URLRequest, 
								evtResultType:String, evtFaultType:String,
								resultType:String = null,
								dataFormat:String = URLLoaderDataFormat.TEXT):URLLoader
		{
			var urlLoader:DropboxURLLoader = new DropboxURLLoader();
			urlLoader.dataFormat = dataFormat;
			urlLoader.eventResultType = evtResultType;
			urlLoader.eventFaultType = evtFaultType;
			urlLoader.resultType = resultType;
			
			urlLoader.addEventListener(Event.COMPLETE, loadCompleteHandler);
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			urlLoader.load(urlRequest);
			return urlLoader;
		}
		
		/**
		 * @private
		 * 
		 * Listener function when urlLoader is load complete.
		 * The result will be formatted to object if the type is set in
		 * DropboxURLLoader.
		 *  
		 * @param evt
		 */
		protected function loadCompleteHandler(evt:Event):void
		{
			var urlLoader:DropboxURLLoader = DropboxURLLoader(evt.target);
			var resultObject:*;
			try {
				if (urlLoader.resultType == REQUEST_TOKEN) {
					var requestToken:Object = OAuthHelper.getTokenFromResponse(urlLoader.data);
					this.config.requestTokenKey = requestToken.key;
					this.config.requestTokenSecret = requestToken.secret;
					resultObject = requestToken;
				} else if (urlLoader.resultType == ACCESS_TOKEN) {
					var accessToken:Object = OAuthHelper.getTokenFromResponse(urlLoader.data);
					this.config.accessTokenKey = accessToken.key;
					this.config.accessTokenSecret = accessToken.secret;
					resultObject = accessToken;
				} else if (urlLoader.resultType == ACCOUNT_INFO) {
					var accountInfo:AccountInfo = new AccountInfo();
					accountInfo.decode(JSON.decode(urlLoader.data));
					resultObject = accountInfo;
				} else if (urlLoader.resultType == DROPBOX_FILE) {
					var dropboxFile:DropboxFile = new DropboxFile();
					dropboxFile.decode(JSON.decode(urlLoader.data));
					resultObject = dropboxFile;
				} else {
					resultObject = urlLoader.data;
				}
			} catch (e:Error) {
				this.dispatchDropboxEvent(urlLoader.eventFaultType, evt, e);
				return;
			}
			
			this.dispatchDropboxEvent(urlLoader.eventResultType, evt, resultObject);
		}
		
		/**
		 * @private
		 * 
		 * Listener for upload request. 
		 *  
		 * @param evt
		 */
		protected function uploadCompleteHandler(evt:Event):void
		{
			var m:MultipartURLLoader = MultipartURLLoader(evt.target);
			this.dispatchDropboxEvent(DropboxEvent.PUT_FILE_RESULT, evt, m.loader.data);
		}
		
		/**
		 * @private
		 * 
		 * Listener for upload request.
		 *  
		 * @param evt
		 * 
		 */
		protected function uploadIOErrorHandler(evt:IOErrorEvent):void
		{
			var m:MultipartURLLoader = MultipartURLLoader(evt.target);
			this.dispatchDropboxEvent(DropboxEvent.PUT_FILE_FAULT, evt, m.loader.data);
		}
		
		/**
		 * @private
		 * 
		 * Listener for upload request.
		 *  
		 * @param evt
		 * 
		 */
		protected function uploadSecurityErrorHandler(evt:SecurityErrorEvent):void
		{
			var m:MultipartURLLoader = MultipartURLLoader(evt.target);
			this.dispatchDropboxEvent(DropboxEvent.PUT_FILE_FAULT, evt, m.loader.data);
		}
		
		/**
		 * @private
		 * 
		 * dispatch a dropbox event.
		 *  
		 * @param evtType
		 * @param relatedEvent
		 * @param resultObject
		 */
		protected function dispatchDropboxEvent(
			evtType:String, relatedEvent:Event, resultObject:Object):void
		{
			var dropboxEvent:DropboxEvent = new DropboxEvent(evtType);
			dropboxEvent.resultObject = resultObject;
			dropboxEvent.relatedEvent = relatedEvent;
			this.dispatchEvent(dropboxEvent);
		}
		
		/**
		 * @private
		 * 
		 * @param evt
		 */
		protected function ioErrorHandler(evt:IOErrorEvent):void
		{
			var urlLoader:DropboxURLLoader = DropboxURLLoader(evt.target);
			this.dispatchDropboxEvent(urlLoader.eventFaultType, evt, urlLoader.data);
		}
		
		/**
		 * @private
		 *  
		 * @param evt
		 */
		protected function securityErrorHandler(evt:SecurityErrorEvent):void
		{
			var urlLoader:DropboxURLLoader = DropboxURLLoader(evt.target);
			this.dispatchDropboxEvent(urlLoader.eventFaultType, evt, urlLoader.data);
		}
			
		/**
		 * build full URL string by given values.
		 *  
		 * @param host
		 * @param target
		 * @param protocol
		 * @return built string
		 */
		protected function buildFullURL(host:String, target:String, protocol:String = 'http'):String
		{
			var portString:String = (_config.port == 80) ? "" : (":" + _config.port);
			if (host.indexOf('http://') == 0 || host.indexOf('https://') == 0) {
				protocol = '';
			} else {
				protocol += "://";
			}
			return protocol + host + portString + '/' + config.apiVersion + target; 
		}
		
		/**
		 * encode file path.
		 *  
		 * @param filePath
		 * @return encoded file path
		 * 
		 */
		private static function buildFilePath(filePath:String):String
		{
			var filePaths:Array = filePath.split('/');
			for (var i:int = 0; i < filePaths.length; i++) {
				filePaths[i] = encodeURIComponent(filePaths[i]);
			}
			return filePaths.join('/');
		}
	}
}


import flash.net.URLLoader;

/**
 * Internal class. Extends flash.net.URLLoader, add 3 properties. 
 * 
 * @author yinzeshuo
 * 
 */
internal class DropboxURLLoader extends URLLoader
{
	/**
	 * define class type of result, can be REQUEST_TOKEN|ACCESS_TOKEN|ACCOUNT_INFO|DROPBOX_FILE.
	 * 
	 * REQUEST_TOKEN & ACCESS_TOKEN : set to DropboxConfig when type is requestToken & accessToken.
	 * ACCOUNT_INFO : return an AccountInfo object
	 * DROPBOX_FILE : return an DropboxFile object
	 * others : return response string.
	 */
	public var resultType:String;
	
	/**
	 * define dispatch event type
	 */
	public var eventResultType:String;
	/**
	 * define dispatch event type
	 */
	public var eventFaultType:String;
}
package org.hamster.dropbox
{
	
	import com.adobe.serialization.json.JSON;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import org.hamster.dropbox.models.AccountInfo;
	import org.hamster.dropbox.models.ChunkedUpload;
	import org.hamster.dropbox.models.CopyRef;
	import org.hamster.dropbox.models.Delta;
	import org.hamster.dropbox.models.DropboxFile;
	import org.hamster.dropbox.models.SharesInfo;
	import org.hamster.dropbox.services.ChunkedUploadSession;
	import org.hamster.dropbox.utils.OAuthHelper;
	import org.hamster.dropbox.utils.URLUtil;
	
	
	[Event(name="DropboxEvent_AccountCreateResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_AccountCreateFault", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_RequestTokenResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_RequestTokenFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_AccessTokenResult",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_AccessTokenFault",   type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_TokenResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_TokenFault",  type="org.hamster.dropbox.DropboxEvent")]
	
	[Event(name="DropboxEvent_AccountInfoResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_AccountInfoFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_PutFileResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_PutFileFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_FileCopyResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_FileCopyFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_FileCreateFolderResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_FileCreateFolderFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_FileDeleteResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_FileDeleteFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_FileMoveResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_FileMoveFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_GetFileResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_GetFileFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_MetadataResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_MetadataResultNotModified", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_MetadataFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_RevisionResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_RevisionFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_RestoreResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_RestoreFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_SearchResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_SearchFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_SharesResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_SharesFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_MediaResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_MediaFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_DeltaResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_DeltaFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_CopyRefResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_CopyRefFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_ChunkedUploadResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_ChunkedUploadFault",  type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_CommitChunkedUploadResult", type="org.hamster.dropbox.DropboxEvent")]
	[Event(name="DropboxEvent_CommitChunkedUploadFault",  type="org.hamster.dropbox.DropboxEvent")]
	
	
	/**
	 * Dropbox client class, in order to use, you should build an instance of
	 * it and put a DropboxConfig instance into it.
	 * 
	 * <p><b>OAuth workflow:</b></p>
	 * <li>1. Ensure that the consumer key/secret pair has been set;</li>
	 * <li>2. Call requestToken() function, register REQUEST_TOKEN_RESULT listener
	 *    and call authorizationUrl() to get the authorization URL;</li>
	 * <li>3. Let user open the URL in browser and then allow application to access;</li>
	 * <li>4. Call accessToken() function to get access token key/secret pair;</li>
	 * <li>5. Currently you have 3 key/secret pairs, consumer, requestToken and accessToken,
	 *    store all properties (or at least consumer and accessToken) 
	 *    of DropboxConig to somewhere.</li>
	 * 
	 * <p><b>API access:</b></p>
	 * <li>1. Ensure all tokens are set to DropboxConfig;</li>
	 * <li>2. Register listener before you call any API;</li>
	 * <li>3. Unregister listener if the listener is no longer necessary.</li>
	 *  
	 * <p>Each API function will return a URLLoader instance which load(urlReqeust:URLRequest)
	 * has been called, you can register other listeners if you want. After the request is
	 * done, the corresponding event will be dispatched from this class.</p>
	 * 
	 * @author yinzeshuo
	 */
	public class DropboxClient extends EventDispatcher
	{
		protected static const REQUEST_TOKEN:String       = 'request_token';
		protected static const ACCESS_TOKEN:String        = 'access_token';
		/**
		 * model type AccountInfo
		 */
		protected static const ACCOUNT_INFO:String        = 'account_info';
		/**
		 * model type DropboxFile
		 */
		protected static const DROPBOX_FILE:String        = 'dropbox_file';
		/**
		 * model type Array Of DropboxFile
		 */
		protected static const DROPBOX_FILE_LIST:String   = 'dropbox_file_list';
		/**
		 * model type SharesInfo
		 */
		protected static const SHARES_INFO:String         = 'shares_info';
		/**
		 * model type DeltaInfo
		 */
		protected static const DELTA_INFO:String          = 'delta_info';
		/**
		 * model type CopyRefInfo
		 */
		protected static const COPY_REF_INFO:String       = 'copy_ref_info';
		
		protected static const ACCOUNT_CREATE:String      = 'account_create';
		
		/**
		 * @private
		 */
		private var _config:DropboxConfig;
		
		/**
		 * @private
		 * 
		 * stores a list of unfinished chunked upload session
		 */
		private var _chunkedUploadSessionList:Array = new Array();
		
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
		 * Create an account. Deprecated because currently this api 
		 * cannot be found from the official api support.
		 * 
		 * @param email
		 * @param password
		 * @param first_name
		 * @param last_name
		 * @return URLLoader
		 */
		[Deprecated]
		public function createAccount( email:String, password:String, first_name:String, last_name:String ):URLLoader
		{
			var url:String = config.accountCreateUrl;
			var params:Object = {
				email:email,
				first_name:first_name,
				last_name: last_name,
				password:password,
				locale: config.locale
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
		 * @private
		 */		
		private function createAccountCompleteHandler(evt:Event):void
		{
			var resultObject:Object ={ status:'ok' };
			this.dispatchDropboxEvent(DropboxEvent.ACCOUNT_CREATE_RESULT, evt, resultObject);
		}
		
		/**
		 * Step 1 of authentication. Obtain an OAuth request token to be used for the rest 
		 * of the authentication process. 
		 * <p>This method corresponds to <a href="http://oauth.net/core/1.0/#auth_step1">Obtaining 
		 * an Unauthorized Request Token</a> in the OAuth Core 1.0 specification.</p>
		 * 
		 * <p><b>Result</b></p>
		 * <p>A request token and the corresponding request token secret, URL-encoded. 
		 * This token/secret pair is meant to be used with /oauth/access_token to complete 
		 * the authentication process and cannot be used for any other API calls.
		 * See <a href="http://oauth.net/core/1.0/#rfc.section.6.1.2">Service Provider Issues an Unauthorized Request Token</a>
		 * in the OAuth Core 1.0 specification for additional discussion of the values returned 
		 * when fetching a request token.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Success Event</td><td>DropboxEvent.REQUEST_TOKEN_RESULT</td></tr>
		 * <tr><td>Failure Event</td><td>DropboxEvent.REQUEST_TOKEN_FAULT</td></tr>
		 * <tr><td>URL Structure</td><td>https://api.dropbox.com/1/oauth/request_token</td></tr>
		 * <tr><td>Version</td><td>0,1</td></tr>
		 * <tr><td>Methods</td><td>POST</td></tr>
		 * </table>
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
		 * Step 3 of authentication. After the /oauth/authorize step is complete, 
		 * the application can call /oauth/access_token to acquire an access token.
		 * 
		 * <p>This method corresponds to <a href="http://oauth.net/core/1.0/#auth_step3">
		 * Obtaining an Access Token in the OAuth Core 1.0 specification</a>.</p>
		 * 
		 * <p><b>Result</b></p>
		 * <p>A request token and the corresponding request token secret, URL-encoded. 
		 * This token/secret pair is meant to be used with /oauth/access_token to complete 
		 * the authentication process and cannot be used for any other API calls.
		 * See <a href="http://oauth.net/core/1.0/#rfc.section.6.1.2">Service Provider Issues an Unauthorized Request Token</a>
		 * in the OAuth Core 1.0 specification for additional discussion of the values returned 
		 * when fetching a request token.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Success Event</td><td>DropboxEvent.ACCESS_TOKEN_RESULT</td></tr>
		 * <tr><td>Failure Event</td><td>DropboxEvent.ACCESS_TOKEN_FAULT</td></tr>
		 * <tr><td>URL Structure</td><td>https://api.dropbox.com/1/oauth/access_token</td></tr>
		 * <tr><td>Version</td><td>0,1</td></tr>
		 * <tr><td>Methods</td><td>POST</td></tr>
		 * </table>
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
		 * <b>Deprecated</b> since we cannot find this api from official dropbox api document.
		 * 
		 * <p>The token call provides a consumer/secret key pair you can use to consistently access the user's account.
		 * This is the preferred method of authentication over storing the username and password. Use the key pair 
		 * as a signature with every subsequent call.</p>
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
		[Deprecated]
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
				var accessToken:Object = com.adobe.serialization.json.JSON.decode(urlLoader.data);
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
		 * Step 2 of authentication. Applications should direct the user to /oauth/authorize. 
		 * This isn't an API call per see, but rather a web endpoint that lets the user sign 
		 * in to Dropbox and choose whether to grant the application the ability to access 
		 * files on their behalf. The page served by /oauth/authorize should be presented 
		 * to the user through their web browser. Without the user's authorization in this step, 
		 * it isn't possible for your application to obtain an access token from /oauth/access_token.
		 * 
		 * <p>This method corresponds to Obtaining User Authorization in the 
		 * <a href="http://oauth.net/core/1.0/#auth_step2">OAuth Core 1.0 specification</a>.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>URL Structure</td><td>https://www.dropbox.com/1/oauth/authorize</td></tr>
		 * <tr><td>Version</td><td>0,1</td></tr>
		 * <tr><td>Methods</td><td>GET</td></tr>
		 * </table>
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
		 * Retrieves information about the user's account.
		 * 
		 * <p><b>Result</b></p>
		 * <p>User account information.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Success Event</td><td>DropboxEvent.ACCOUNT_INFO_RESULT</td></tr>
		 * <tr><td>Failure Event</td><td>DropboxEvent.ACCOUNT_INFO_FAULT</td></tr>
		 * <tr><td>URL Structure</td><td>https://api.dropbox.com/1/account/info</td></tr>
		 * <tr><td>Version</td><td>0,1</td></tr>
		 * <tr><td>Methods</td><td>GET</td></tr>
		 * <tr><td>Result</td><td>AccountInfo</td></tr>
		 * </table>
		 * 
		 * @see org.hamster.dropbox.models.AccountInfo
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
		 * Copies a file or folder to a new location.
		 * 
		 * <p><b>Result</b></p>
		 * <p>Metadata for the copy of the file or folder.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Success Event</td><td>DropboxEvent.FILE_COPY_RESULT</td></tr>
		 * <tr><td>Failure Event</td><td>DropboxEvent.FILE_COPY_FAULT</td></tr>
		 * <tr><td>URL Structure</td><td>https://api.dropbox.com/1/fileops/copy</td></tr>
		 * <tr><td>Version</td><td>0,1</td></tr>
		 * <tr><td>Methods</td><td>POST</td></tr>
		 * <tr><td>Result</td><td>DropboxFile</td></tr>
		 * </table>
		 * 
		 * @param fromPath Specifies the file or folder to be copied from relative to root.
		 * @param toPath Specifies the destination path, including the new name for the file or folder, relative to root.
		 * @param root The root relative to which from_path and to_path are specified. Valid values are sandbox and dropbox.
		 * @param fromCopyRef Specifies a copy_ref generated from a previous /copy_ref call. 
		 *        Must be used instead of the from_path parameter.
		 * @see org.hamster.dropbox.models.DropboxFile
		 * @return urlLoader
		 */
		public function fileCopy(fromPath:String, toPath:String, 
								 root:String = DropboxConfig.DROPBOX,
								 fromCopyRef:String = ""):URLLoader
		{
			var params:Object = { 
				"root": root, 
				"to_path": toPath
			};
			
			if (fromCopyRef != null && fromCopyRef.length > 0) {
				buildOptionalParameters(params, "from_copy_ref", fromCopyRef);
			} else {
				params["from_path"] = fromPath;
			}
			
			var urlRequest:URLRequest = buildURLRequest(
				config.server, "/fileops/copy", params, URLRequestMethod.POST);
			return this.load(urlRequest, DropboxEvent.FILE_COPY_RESULT, 
				DropboxEvent.FILE_COPY_FAULT, DROPBOX_FILE);
		}
		
		/**
		 * Creates a folder.
		 * 
		 * <p><b>Result</b></p>
		 * <p>Metadata for the new folder.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Success Event</td><td>DropboxEvent.FILE_CREATE_FOLDER_RESULT</td></tr>
		 * <tr><td>Failure Event</td><td>DropboxEvent.FILE_CREATE_FOLDER_FAULT</td></tr>
		 * <tr><td>URL Structure</td><td>https://api.dropbox.com/1/fileops/create_folder</td></tr>
		 * <tr><td>Version</td><td>0,1</td></tr>
		 * <tr><td>Methods</td><td>POST</td></tr>
		 * <tr><td>Result</td><td>DropboxFile</td></tr>
		 * </table>
		 * 
		 * @param path The path to the new folder to create relative to root.
		 * @param root The root relative to which path is specified. Valid values are sandbox and dropbox.
		 * @see org.hamster.dropbox.models.DropboxFile
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
		 * Deletes a file or folder.
		 * 
		 * <p><b>Result</b></p>
		 * <p>Metadata for the deleted file or folder.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Success Event</td><td>DropboxEvent.FILE_DELETE_RESULT</td></tr>
		 * <tr><td>Failure Event</td><td>DropboxEvent.FILE_DELETE_FAULT</td></tr>
		 * <tr><td>URL Structure</td><td>https://api.dropbox.com/1/fileops/delete</td></tr>
		 * <tr><td>Version</td><td>0,1</td></tr>
		 * <tr><td>Methods</td><td>POST</td></tr>
		 * <tr><td>Result</td><td>DropboxFile</td></tr>
		 * </table>
		 * 
		 * @param path The path to the file or folder to be deleted.
		 * @param root The root relative to which path is specified. Valid values are sandbox and dropbox.
		 * @see org.hamster.dropbox.models.DropboxFile
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
				DropboxEvent.FILE_DELETE_FAULT, DROPBOX_FILE);
		}
		
		/**
		 * Moves a file or folder to a new location.
		 * 
		 * <p><b>Result</b></p>
		 * <p>Metadata for the moved file or folder.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Success Event</td><td>DropboxEvent.FILE_MOVE_RESULT</td></tr>
		 * <tr><td>Failure Event</td><td>DropboxEvent.FILE_MOVE_FAULT</td></tr>
		 * <tr><td>URL Structure</td><td>https://api.dropbox.com/1/fileops/move</td></tr>
		 * <tr><td>Version</td><td>0,1</td></tr>
		 * <tr><td>Methods</td><td>POST</td></tr>
		 * <tr><td>Result</td><td>DropboxFile</td></tr>
		 * </table>
		 * 
		 * @param fromPath Specifies the file or folder to be moved from relative to root.
		 * @param toPath Specifies the destination path, including the new name for the file or folder, relative to root.
		 * @param root The root relative to which from_path and to_path are specified. Valid values are sandbox and dropbox.
		 * @see org.hamster.dropbox.models.DropboxFile
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
		 * Retrieves file and folder metadata.
		 * 
		 * <p><b>Result</b></p>
		 * <p>The metadata for the file or folder at the given 
		 * &lt;path&gt;. If &lt;path&gt; represents a folder and the list parameter is true, 
		 * the metadata will also include a listing of metadata for the folder's contents.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Success Event</td><td>DropboxEvent.METADATA_RESULT</td></tr>
		 * <tr><td>&#160;</td><td>DropboxEvent.METADATA_RESULT_NOT_MODIFIED</td></tr>
		 * <tr><td>Failure Event</td><td>DropboxEvent.METADATA_FAULT</td></tr>
		 * <tr><td>URL Structure</td><td>https://api.dropbox.com/1/metadata/&lt;root&gt;/&lt;path&gt;</td></tr>
		 * <tr><td>Version</td><td>0,1</td></tr>
		 * <tr><td>Methods</td><td>GET</td></tr>
		 * <tr><td>Result</td><td>DropboxFile or null if 304 not modified by hash.</td></tr>
		 * </table>
		 * 
		 * @param path The path to the file or folder.
		 * @param fileLimit Default is 10,000 (max is 25,000). When listing a folder, 
		 *        the service will not report listings containing more than the specified amount 
		 *        of files and will instead respond with a 406 (Not Acceptable) status response.
		 * @param hash Each call to /metadata on a folder will return a hash field, generated by 
		 *        hashing all of the metadata contained in that response. On later calls to /metadata,
		 *        you should provide that value via this parameter so that if nothing has changed, the 
		 *        response will be a 304 (Not Modified) status code instead of the full, potentially 
		 *        very large, folder listing. This parameter is ignored if the specified path is 
		 *        associated with a file or if list=false. A folder shared between two users will have 
		 *        the same hash for each user.
		 * @param list The strings true and false are valid values. true is the default. 
		 *        If true, the folder's metadata will include a contents field with a list of 
		 *        metadata entries for the contents of the folder. If false,
		 *        the contents field will be omitted.
		 * @param include_deleted Only applicable when list is set. If this parameter is set to true, 
		 *        then contents will include the metadata of deleted children. Note that the target of 
		 *        the metadata call is always returned even when it has been deleted (with is_deleted 
		 *        set to true) regardless of this flag.
		 * @param rev If you include a particular revision number, then only the metadata for 
		 *        that revision will be returned.
		 * @param locale The metadata returned will have its size field translated based on the given locale.
		 * @param root The root relative to which path is specified. Valid values are sandbox and dropbox.
		 * @see org.hamster.dropbox.models.DropboxFile
		 * @return urlLoader
		 */
		public function metadata(path:String, 
								 fileLimit:int, 
								 hash:String, 
								 list:Boolean,
								 include_deleted:Boolean = false,
								 rev:String = "",
								 locale:String = "",
								 root:String = DropboxConfig.DROPBOX):URLLoader
		{
			var params:Object;
			if (hash != null && hash.length > 0) {
				params = {
					"hash": hash,
					"list": true
				};
			} else {
				params = {
					"file_limit" : fileLimit,
					"list": list
				};
			}
			
			
			// added in v1
			if (include_deleted == true)
				buildOptionalParameters(params, 'include_deleted', include_deleted);
			buildOptionalParameters(params, 'rev', rev);
			buildOptionalParameters(params, 'locale', locale);
			
			var urlRequest:URLRequest = buildURLRequest(
				config.server, '/metadata/' + root + buildURLFilePath(path), params);
			var urlLoader:URLLoader = this.load(urlRequest, DropboxEvent.METADATA_RESULT, 
				DropboxEvent.METADATA_FAULT, DROPBOX_FILE);
			// add for hash functions
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, metadataHttpStatusHandler);
			return urlLoader;
		}
		
		/**
		 * @private
		 */
		protected function metadataHttpStatusHandler(event:HTTPStatusEvent):void
		{
			if (event.status == 304) {
				var urlLoader:URLLoader = event.currentTarget as URLLoader;
				
				// clean the events
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				
				// since the complete will still be triggered and it will finally dispatch an empty stream ioErrorEvent, so here
				// to register an empty handler to discard the ioErrorEvent.
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandlerDoNothing);
					
				this.dispatchDropboxEvent(DropboxEvent.METADATA_RESULT_NOT_MODIFIED, event, null);
			}
		}
		
		/**
		 * Gets a thumbnail for an image. Note that this call goes to the api-content server.
		 * 
		 * <p>https://api-content.dropbox.com/1/thumbnails/&lt;root&gt;/&lt;path&gt;</p>
		 * <p>version: 0,1</p>
		 * <p>methods: GET</p>
		 * <p>results: A thumbnail of the specified image's contents.</p>
		 * 
		 * @param pathToPhoto
		 * @param size optional, small|medium|large, medium as default
		 * @param root, optional, default is "dropbox" 2011/01/22
		 * @return urlLoader
		 */
		
		/**
		 * Gets a thumbnail for an image.
		 * 
		 * <p><b>Result</b></p>
		 * <p>A thumbnail of the specified image's contents. The image returned may be larger 
		 * or smaller than the size requested, depending on the size and aspect ratio of 
		 * the original image.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Success Event</td><td>DropboxEvent.THUMBNAILS_RESULT</td></tr>
		 * <tr><td>Failure Event</td><td>DropboxEvent.THUMBNAILS_FAULT</td></tr>
		 * <tr><td>URL Structure</td><td>https://api-content.dropbox.com/1/thumbnails/&lt;root&gt;/&lt;path&gt;</td></tr>
		 * <tr><td>Version</td><td>0,1</td></tr>
		 * <tr><td>Methods</td><td>GET</td></tr>
		 * <tr><td>Result</td><td>ByteArray of the photo</td></tr>
		 * </table>
		 * 
		 * @param pathToPhoto The path to the image file you want to thumbnail.
		 * @param size One of the following values (default: s):
		 *        &#160;&#160;&#160;&#160;&#160;&#160;
		 *        <table><tr><th>value</th><th>dimensions (px)</th></tr>
		 *               <tr><td>x</td><td>32x32</td></tr>
		 *               <tr><td>s</td><td>64x64</td></tr>
		 *               <tr><td>m</td><td>128x128</td></tr>
		 *               <tr><td>l</td><td>640x480</td></tr>
		 *               <tr><td>ml</td><td>1024x768</td></tr></table>
		 * @param root The root relative to which path is specified. Valid values are sandbox and dropbox.
		 * @param format jpeg (default) or png. For images that are photos, 
		 *        jpeg should be preferred, while png is better for screenshots and digital art.
		 * @return urlLoader
		 */
		public function thumbnails(pathToPhoto:String, size:String = "s",
								   root:String = DropboxConfig.DROPBOX,
								   format:String = "jpeg"):URLLoader
		{
			var params:Object = {
				"size" : size,
				"format" : format
			};
			var urlRequest:URLRequest = buildURLRequest(
				config.contentServer, "/thumbnails/" + root + buildURLFilePath(pathToPhoto), params);
			return this.load(urlRequest, DropboxEvent.THUMBNAILS_RESULT, 
				DropboxEvent.THUMBNAILS_FAULT, "", URLLoaderDataFormat.BINARY);
		}
		
		/**
		 * Downloads a file.
		 * 
		 * <p><b>Result</b></p>
		 * <p>The specified file's contents at the requested revision.
		 * The HTTP response contains the content metadata in JSON format 
		 * within an x-dropbox-metadata header.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Success Event</td><td>DropboxEvent.GET_FILE_RESULT</td></tr>
		 * <tr><td>Failure Event</td><td>DropboxEvent.GET_FILE_FAULT</td></tr>
		 * <tr><td>URL Structure</td><td>https://api-content.dropbox.com/1/files/&lt;root&gt;/&lt;path&gt;</td></tr>
		 * <tr><td>Version</td><td>0,1</td></tr>
		 * <tr><td>Methods</td><td>GET</td></tr>
		 * <tr><td>Result</td><td>ByteArray of the file</td></tr>
		 * </table>
		 * 
		 * @param filePath The path to the file you want to retrieve.
		 * @param rev The revision of the file to retrieve. This defaults to the most recent revision.
		 * @param root The root relative to which path is specified. Valid values are sandbox and dropbox.
		 * @return urlLoader
		 */
		public function getFile(filePath:String, rev:String = "",
								root:String=DropboxConfig.DROPBOX):URLLoader
		{
			var params:Object = null;
			if (rev != "" && rev != null) {
				params = {
					rev : rev
				}
			}
			var urlRequest:URLRequest = buildURLRequest(
				config.contentServer, "/files/" + root + buildURLFilePath(filePath), params);
			return this.load(urlRequest, DropboxEvent.GET_FILE_RESULT, 
				DropboxEvent.GET_FILE_FAULT, "", URLLoaderDataFormat.BINARY);
		}
		 
		/**
		 * Uploads a file using PUT semantics.
		 * 
		 * <p><b>Result</b></p>
		 * <p>Metadata for the copy of the file or folder.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Success Event</td><td>DropboxEvent.FILE_PUT_RESULT</td></tr>
		 * <tr><td>Failure Event</td><td>DropboxEvent.FILE_PUT_FAULT</td></tr>
		 * <tr><td>URL Structure</td><td>https://api-content.dropbox.com/1/files_put/&lt;root&gt;/&lt;path&gt;?param=val</td></tr>
		 * <tr><td>Version</td><td>1</td></tr>
		 * <tr><td>Methods</td><td>PUT,POST</td></tr>
		 * <tr><td>Result</td><td>DropboxFile</td></tr>
		 * </table>
		 * 
		 * @param filePath The path to the folder you want to write to. 
		 *        This parameter <b>should</b> point to a folder.
		 * @param fileName the file name you want to upload to.
		 * @param data The file contents to be uploaded. Since the entire PUT 
		 *        body will be treated as the file, any parameters must be passed 
		 *        as part of the request URL. The request URL should be signed just 
		 *        as you would sign any other OAuth request URL.
		 * @param locale The metadata returned on successful upload will have its 
		 *        size field translated based on the given locale.
		 * @param overwrite This value, either true (default) or false, determines 
		 *        what happens when there's already a file at the specified path. 
		 *        If true, the existing file will be overwritten by the new one. 
		 *        If false, the new file will be automatically renamed (for example, 
		 *        test.txt might be automatically renamed to test (1).txt). The new 
		 *        name can be obtained from the returned metadata.
		 * @param parent_rev The revision of the file you're editing. If parent_rev
		 *        matches the latest version of the file on the user's Dropbox, 
		 *        that file will be replaced. Otherwise, the new file will be 
		 *        automatically renamed (for example, test.txt might be automatically 
		 *        renamed to test (conflicted copy).txt). If you specify a revision 
		 *        that doesn't exist, the file will not save (error 400). Get the most 
		 *        recent rev by performing a call to /metadata.
		 * @param root The root relative to which path is specified. Valid values are sandbox and dropbox.
		 * @see org.hamster.dropbox.models.DropboxFile
		 * @return urlLoader
		 */
		public function putFile(filePath:String, 
								fileName:String, 
								data:ByteArray, 
								locale:String = "",
								overwrite:Boolean = true,
								parent_rev:String = "",
								root:String = DropboxConfig.DROPBOX):URLLoader
		{
			var url:String = this.buildFullURL(config.contentServer, 
				OAuthHelper.encodeURL('/files_put/' + root + ((filePath == null || filePath == "") ? "/" : buildURLFilePath(filePath) + '/') + fileName)
				
				, "https");
			var params:Object = { 
			};
			
			//added in version 1
			buildOptionalParameters(params, 'locale', locale);
			params.overwrite = overwrite.toString();
			buildOptionalParameters(params, 'parent_rev', parent_rev);
			
			var urlReqHeader:URLRequestHeader = OAuthHelper.buildURLRequestHeader(url, params, 
				config.consumerKey, config.consumerSecret, 
				config.accessTokenKey, config.accessTokenSecret, URLRequestMethod.POST);
			
			var fileTypeArray:Array = fileName.split('.');
			var fileType:String = "file";
			if (fileTypeArray.length > 1) {
				fileType = fileTypeArray[fileTypeArray.length - 1];
			}
			
			var paramString:String = "";
			var paramList:Array = new Array();
			if (locale != '' && locale != null) {
				paramList.push('locale=' + locale);
			}
			paramList.push('overwrite=' + overwrite);
			if (parent_rev != '' && parent_rev != null) {
				paramList.push('parent_rev=' + parent_rev);
			}
			paramString = paramList.join('&');
			
			var urlRequest:URLRequest = new URLRequest(url + '?' + paramString);
			urlRequest.data = data;
			urlRequest.method = URLRequestMethod.POST;
			var contentTypeHeader:URLRequestHeader = new URLRequestHeader("Content-Type", "application/" + fileType);
			urlRequest.requestHeaders = [urlReqHeader, contentTypeHeader];
			var urlLoader:URLLoader = new URLLoader(urlRequest);
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, uploadCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, uploadIOErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadSecurityErrorHandler);
			urlLoader.load(urlRequest);
			return urlLoader;
		}
		
		/**
		 * Obtains metadata for the previous revisions of a file.
		 * <p>Only revisions up to thirty days old are available (or more if the 
		 * Dropbox user has <a href="https://www.dropbox.com/help/113/en">Pack-Rat</a>). You can use the revision number in conjunction 
		 * with the /restore call to revert the file to its previous state.</p>
		 * <p><b>Result</b></p>
		 * <p>A list of all revisions formatted just like file metadata.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Success Event</td><td>DropboxEvent.REVISION_RESULT</td></tr>
		 * <tr><td>Failure Event</td><td>DropboxEvent.REVISION_FAULT</td></tr>
		 * <tr><td>URL Structure</td><td>https://api.dropbox.com/1/revisions/&lt;root&gt;/&lt;path&gt;</td></tr>
		 * <tr><td>Version</td><td>1</td></tr>
		 * <tr><td>Methods</td><td>GET</td></tr>
		 * <tr><td>Result</td><td>list of DropboxFile</td></tr>
		 * </table>
		 * 
		 * @param filePathWithName
		 * @param root
		 * @param rev_limit Default is 10. Max is 1,000. When listing a file, 
		 *        the service will not report listings containing more than 
		 *        the amount specified and will instead respond with a 406 
		 *        (Not Acceptable) status response.
		 * @param locale locale The metadata returned will have its size field 
		 *        translated based on the given locale. 
		 * @see org.hamster.dropbox.models.DropboxFile
		 * @return urlLoader
		 */
		public function revisions(filePathWithName:String,
								  root:String = DropboxConfig.DROPBOX,
								  rev_limit:int = 10, locale:String = ""):URLLoader
		{
			var params:Object = {
				rev_limit : rev_limit
			};
			buildOptionalParameters(params, 'locale', locale);
			
			
			var urlRequest:URLRequest = buildURLRequest(
				config.server, '/revisions/' + root + buildURLFilePath(filePathWithName), params);
			return this.load(urlRequest, DropboxEvent.REVISION_RESULT, 
				DropboxEvent.REVISION_FAULT, DROPBOX_FILE_LIST, URLLoaderDataFormat.TEXT);
		}
		
		/**
		 * Restores a file path to a previous revision.
		 * <p>Unlike downloading a file at a given revision and 
		 * then re-uploading it, this call is atomic. 
		 * It also saves a bunch of bandwidth.</p>
		 * 
		 * <p><b>Result</b></p>
		 * <p>The metadata of the restored file.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Success Event</td><td>DropboxEvent.RESTORE_RESULT</td></tr>
		 * <tr><td>Failure Event</td><td>DropboxEvent.RESTORE_FAULT</td></tr>
		 * <tr><td>URL Structure</td><td>https://api.dropbox.com/1/restore/&lt;root&gt;/&lt;path&gt;</td></tr>
		 * <tr><td>Version</td><td>1</td></tr>
		 * <tr><td>Methods</td><td>POST</td></tr>
		 * <tr><td>Result</td><td>DropboxFile</td></tr>
		 * </table>
		 * 
		 * @param filePathWithName The revision of the file to restore.
		 * @param rev The revision of the file to restore.
		 * @param locale The metadata returned will have its size field 
		 *        translated based on the given locale. 
		 * @param root The root relative to which path is specified. Valid values 
		 *        are sandbox and dropbox.
		 * @see org.hamster.dropbox.models.DropboxFile
		 * @return urlLoader
		 */
		public function restore(filePathWithName:String,
								rev:String,
								locale:String="",
								root:String = DropboxConfig.DROPBOX):URLLoader
		{
			var params:Object = {
				rev : rev
			};
			
			buildOptionalParameters(params, 'locale', locale);
			
			var urlRequest:URLRequest = buildURLRequest(
				config.server, '/restore/' + root + buildURLFilePath(filePathWithName), params, URLRequestMethod.POST);
			return this.load(urlRequest, DropboxEvent.RESTORE_RESULT, 
				DropboxEvent.RESTORE_FAULT, DROPBOX_FILE, URLLoaderDataFormat.TEXT);			
		}
		
		/**
		 * Returns metadata for all files and folders whose filename 
		 * contains the given search string as a substring.
		 * <p>Searches are limited to the folder path and its sub-folder hierarchy provided in the call.</p>
		 * 
		 * <p><b>Result</b></p>
		 * <p>List of metadata entries for any matching files and folders.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Success Event</td><td>DropboxEvent.SEARCH_RESULT</td></tr>
		 * <tr><td>Failure Event</td><td>DropboxEvent.SEARCH_FAULT</td></tr>
		 * <tr><td>URL Structure</td><td>https://api.dropbox.com/1/search/&lt;root&gt;/&lt;path&gt;</td></tr>
		 * <tr><td>Version</td><td>0,1</td></tr>
		 * <tr><td>Methods</td><td>GET,POST</td></tr>
		 * <tr><td>Result</td><td>List of DropboxFile</td></tr>
		 * </table>
		 * 
		 * @param filePath The path to the folder you want to search from.
		 * @param query The search string. Must be at least three characters long.
		 * @param file_limit The maximum and default value is 1,000. No more than 
		 *        file_limit search results will be returned.
		 * @param include_deleted If this parameter is set to true, then files and 
		 *        folders that have been deleted will also be included in the search.
		 * @param root The metadata returned will have its size field translated 
		 *        based on the given locale. 
		 * @see org.hamster.dropbox.models.DropboxFile
		 * @return urlLoader
		 */
		public function search(filePath:String, 
							   query:String,
							   file_limit:int = 1000,
							   include_deleted:Boolean = false,
							   root:String = DropboxConfig.DROPBOX):URLLoader
		{
			var params:Object = {
				query : query
			};
			
			buildOptionalParameters(params, 'file_limit', file_limit);
			buildOptionalParameters(params, 'include_deleted', include_deleted);
			
			var urlRequest:URLRequest = buildURLRequest(
				config.server, '/search/' + root + buildURLFilePath(filePath), params, URLRequestMethod.POST);
			return this.load(urlRequest, DropboxEvent.SEARCH_RESULT, 
				DropboxEvent.SEARCH_FAULT, DROPBOX_FILE_LIST, URLLoaderDataFormat.TEXT);
		}
		
		/**
		 * Creates and returns a Dropbox link to files or folders users can 
		 * use to view a preview of the file in a web browser.
		 * 
		 * <p><b>Result</b></p>
		 * <p>A Dropbox link to the given path. The link can be used publicly 
		 * and directs to a preview page of the file. For compatibility reasons, 
		 * it returns the link's expiration date in Dropbox's usual date format.
		 *  All links are currently set to expire far enough in the future so that 
		 * expiration is effectively not an issue.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Success Event</td><td>DropboxEvent.SHARES_RESULT</td></tr>
		 * <tr><td>Failure Event</td><td>DropboxEvent.SHARES_FAULT</td></tr>
		 * <tr><td>URL Structure</td><td>https://api.dropbox.com/1/shares/&lt;root&gt;/&lt;path&gt;</td></tr>
		 * <tr><td>Version</td><td>0,1</td></tr>
		 * <tr><td>Methods</td><td>POST</td></tr>
		 * <tr><td>Result</td><td>SharesInfo</td></tr>
		 * </table>
		 * 
		 * @param filePathWithName The path to the file or folder you want to link to.
		 * @param root The root relative to which path is specified. Valid values are sandbox and dropbox.
		 * @param short_url When true (default), the url returned will be shortened using the Dropbox 
		 *        url shortener. If false, the url will link directly to the file's preview page.
		 * @param locale Use to specify language settings for user error messages and other language specific text.
		 * @see org.hamster.dropbox.models.SharesInfo
		 * @return urlLoader
		 */
		public function shares(filePathWithName:String,
							   root:String = DropboxConfig.DROPBOX,
							   short_url:Boolean = true,
							   locale:String = ""):URLLoader
		{
			var params:Object = {
				short_url : short_url
			};
			buildOptionalParameters(params, 'locale', locale);
			var urlRequest:URLRequest = buildURLRequest(
				config.server, '/shares/' + root + buildURLFilePath(filePathWithName), params);
			return this.load(urlRequest, DropboxEvent.SHARES_RESULT, 
				DropboxEvent.SHARES_FAULT, SHARES_INFO, URLLoaderDataFormat.TEXT);
		}
		
		/**
		 * Returns a link directly to a file.
		 * 
		 * <p><b>Result</b></p>
		 * <p>A url that serves the media directly. 
		 * Also returns the link's expiration date in Dropbox's usual date format.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Success Event</td><td>DropboxEvent.MEDIA_RESULT</td></tr>
		 * <tr><td>Failure Event</td><td>DropboxEvent.MEDIA_FAULT</td></tr>
		 * <tr><td>URL Structure</td><td>https://api.dropbox.com/1/media/&lt;root&gt;/&lt;path&gt;</td></tr>
		 * <tr><td>Version</td><td>1</td></tr>
		 * <tr><td>Methods</td><td>POST</td></tr>
		 * <tr><td>Result</td><td>SharesInfo</td></tr>
		 * </table>
		 * 
		 * @param filePathWithName The path to the media file you want a direct link to.
		 * @param locale Use to specify language settings for user error messages and other language specific text.
		 * @param root The root relative to which path is specified. Valid values are sandbox and dropbox.
		 * @see org.hamster.dropbox.models.SharesInfo
		 * @return urlLoader
		 */
		public function media(filePathWithName:String,
							  locale:String = "",
							  root:String = DropboxConfig.DROPBOX):URLLoader
		{
			var params:Object;
			if (locale != null && locale != "") {
				params = new Object();
				buildOptionalParameters(params, 'locale', locale);
			}
			
			var urlRequest:URLRequest = buildURLRequest(
				config.server, '/media/' + root + buildURLFilePath(filePathWithName), params, URLRequestMethod.POST);
			return this.load(urlRequest, DropboxEvent.MEDIA_RESULT, 
				DropboxEvent.MEDIA_FAULT, SHARES_INFO, URLLoaderDataFormat.TEXT);
		}
		
		/**
		 * A way of letting you keep up with changes to files and folders in a user's Dropbox. 
		 * You can periodically call /delta to get a list of "delta entries", 
		 * which are instructions on how to update your local state to match the server's state.
		 * 
		 * <p><b>Result</b></p>
		 * <p>The Delta Object. see the Delta Class for details.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Success Event</td><td>DropboxEvent.DELTA_RESULT</td></tr>
		 * <tr><td>Failure Event</td><td>DropboxEvent.DELTA_FAULT</td></tr>
		 * <tr><td>URL Structure</td><td>https://api.dropbox.com/1/delta</td></tr>
		 * <tr><td>Version</td><td>1</td></tr>
		 * <tr><td>Methods</td><td>POST</td></tr>
		 * <tr><td>Result</td><td>Delta</td></tr>
		 * </table>
		 * 
		 * @param cursor A string that is used to keep track of your current state.
		 *        On the next call pass in this value to return delta entries that 
		 *        have been recorded since the cursor was returned.
		 * @param locale The metadata returned will have its size field translated 
		 *        based on the given locale. 
		 * @see org.hamster.dropbox.models.Delta
		 * @return urlLoader
		 */
		public function delta(cursor:String = null, locale:String = ""):URLLoader
		{
			var params:Object = new Object();
			buildOptionalParameters(params, 'cursor', cursor);
			buildOptionalParameters(params, 'locale', locale);
			
			var urlRequest:URLRequest = buildURLRequest(
				config.server, "/delta", params, URLRequestMethod.POST);
			return this.load(urlRequest, DropboxEvent.DELTA_RESULT, 
				DropboxEvent.DELTA_FAULT, DELTA_INFO);
		}
		
		/**
		 * Creates and returns a copy_ref to a file. This reference string can be used 
		 * to copy that file to another user's Dropbox by passing it in as the 
		 * from_copy_ref parameter on /fileops/copy.
		 * 
		 * <p><b>Result</b></p>
		 * <p>A copy_ref to the specified file. For compatibility reasons, it returns 
		 * the link's expiration date in Dropbox's usual date format. All links are currently 
		 * set to expire far enough in the future so that expiration is effectively not an issue.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Success Event</td><td>DropboxEvent.COPY_REF_RESULT</td></tr>
		 * <tr><td>Failure Event</td><td>DropboxEvent.COPY_REF_FAULT</td></tr>
		 * <tr><td>URL Structure</td><td>https://api.dropbox.com/1/copy_ref/&lt;root&gt;/&lt;path&gt;</td></tr>
		 * <tr><td>Version</td><td>1</td></tr>
		 * <tr><td>Methods</td><td>GET</td></tr>
		 * <tr><td>Result</td><td>CopyRef</td></tr>
		 * </table>
		 * 
		 * @param filePathWithName The path to the file you want a copy_ref to refer to.
		 * @param root The root relative to which path is specified. Valid values are sandbox and dropbox.
		 * @see org.hamster.dropbox.models.CopyRef
		 * @return urlLoader
		 */
		public function copyRef(filePathWithName:String,
								root:String = DropboxConfig.DROPBOX):URLLoader
		{
			var params:Object = new Object();
			
			var urlRequest:URLRequest = buildURLRequest(
				config.server, '/copy_ref/' + root + buildURLFilePath(filePathWithName), null);
			return this.load(urlRequest, DropboxEvent.COPY_REF_RESULT, 
				DropboxEvent.COPY_REF_FAULT, COPY_REF_INFO);
		}
		
		/**
		 * Uploads large files to Dropbox in mulitple chunks. Also has the ability to resume 
		 * if the upload is interrupted. This allows for uploads larger than the /files and 
		 * /files_put maximum of 150 MB.
		 * <p>Typical usage:</p>
		 * <p>Send a PUT request to /chunked_upload with the first chunk of the file without 
		 * setting upload_id, and receive an upload_id in return.</p>
		 * <p>Repeatedly PUT subsequent chunks using the upload_id to identify the upload 
		 * in progress and an offset representing the number of bytes transferred so far.</p>
		 * <p>After each chunk has been uploaded, the server returns a new offset representing 
		 * the total amount transferred.</p>
		 * <p>After the last chunk, POST to /commit_chunked_upload to complete the upload.</p>
		 * <p>Chunks can be any size up to 150 MB. A typical chunk is 4 MB. Using large chunks 
		 * will mean fewer calls to /chunked_upload and faster overall throughput. However, 
		 * whenever a transfer is interrupted, you will have to resume at the beginning of 
		 * the last chunk, so it is often safer to use smaller chunks.</p>
		 * <p>If the offset you submit does not match the expected offset on the server, 
		 * the server will ignore the request and respond with a 400 error that includes 
		 * the current offset. To resume upload, seek to the correct offset (in bytes) 
		 * within the file and then resume uploading from that point.</p>
		 * <p>A chunked upload can take a maximum of 24 hours before expiring.</p>
		 * 
		 * <p><b>How to use:</b></p>
		 * <p>This API will first to call /chunked_upload repeatly to uplaod all
		 * chunked items, then will call /commit_chunked_upload to try to commit 
		 * the chunked upload.  For each /chunked_upload call, the event 
		 * <code>DropboxEvent.CHUNKED_UPLOAD_RESULT</code> or 
		 * <code>DropboxEvent.CHUNKED_UPLOAD_FAULT</code> will be dispatched, the 
		 * relatedObject of the dispatched event is type of ChunkedUpload.  For 
		 * /commit_chunked_upload event, the event
		 * <code>DropboxEvent.COMMIT_CHUNKED_UPLOAD_RESULT</code> or 
		 * <code>DropboxEvent.COMMIT_CHUNKED_UPLOAD_FAULT</code> will be dispatched.</p>
		 * 
		 * <p><b>Result</b></p>
		 * <p>For DropboxEvent.CHUNKED_UPLOAD_RESULT: ChunkUpload</p>
		 * <p>For DropboxEvent.COMMIT_CHUNKED_UPLOAD_RESULT: The metadata for the uploaded file.</p>
		 * 
		 * <table>
		 * <tr><th></th><th>&#160;</th></tr>
		 * <tr><td>Chunk Success Event</td><td>DropboxEvent.CHUNKED_UPLOAD_RESULT</td></tr>
		 * <tr><td>Chunk Failure Event</td><td>DropboxEvent.CHUNKED_UPLOAD_FAULT</td></tr>
		 * <tr><td>Commit Success Event</td><td>DropboxEvent.COMMIT_CHUNKED_UPLOAD_RESULT</td></tr>
		 * <tr><td>Commit Failure Event</td><td>DropboxEvent.COMMIT_CHUNKED_UPLOAD_FAULT</td></tr>
		 * <tr><td>Chunk URL Structure</td><td>https://api-content.dropbox.com/1/chunked_upload?param=val</td></tr>
		 * <tr><td>Commit URL Structure</td><td>https://api-content.dropbox.com/1/commit_chunked_upload/&lt;root&gt;/&lt;path&gt;</td></tr>
		 * <tr><td>Version</td><td>1</td></tr>
		 * <tr><td>Chunk Methods</td><td>PUT</td></tr>
		 * <tr><td>Commit Methods</td><td>POST</td></tr>
		 * <tr><td>Chunk Result</td><td>ChunkedUpload</td></tr>
		 * <tr><td>Commit Result</td><td>DropboxFile</td></tr>
		 * </table>
		 * 
		 * @param filePath The full path to the folder you want to write to. This parameter should point to a folder.
		 * @param fileName The file name you want to point to.
		 * @param data the upload file content
		 * @param retryCount for all chunk upload, times of retrying if failed.
		 * @param chunkedSize size of each time uploaded
		 * @param locale The metadata returned on successful upload will have its 
		 *        size field translated based on the given locale.
		 * @param overwrite This value, either true (default) or false, determines what happens 
		 *        when there's already a file at the specified path. If true, the existing file 
		 *        will be overwritten by the new one. If false, the new file will be automatically 
		 *        renamed (for example, test.txt might be automatically renamed to test (1).txt). 
		 *        The new name can be obtained from the returned metadata.
		 * @param parent_rev  The revision of the file you're editing. If parent_rev matches the 
		 *        latest version of the file on the user's Dropbox, that file will be replaced. 
		 *        Otherwise, the new file will be automatically renamed (for example, test.txt 
		 *        might be automatically renamed to test (conflicted copy).txt). If you specify 
		 *        a revision that doesn't exist, the file will not save (error 400). 
		 *        Get the most recent rev by performing a call to /metadata.
		 * @param root The root relative to which path is specified. Valid values are sandbox and dropbox.
		 * @see org.hamster.dropbox.models.ChunkedUpload
		 * @see org.hamster.dropbox.models.DropboxFile
		 * @return urlLoader
		 */
		public function chunkedUpload(filePath:String,
									  fileName:String,
									  data:ByteArray,
									  retryCount:int = 3,
									  chunkedSize:Number = 4194304,
									  locale:String = "",
									  overwrite:Boolean = true,
									  parent_rev:String = "",
									  root:String = DropboxConfig.DROPBOX):URLLoader
		{
			var url:String = this.buildFullURL(config.contentServer, 
				OAuthHelper.encodeURL('/chunked_upload'));
			
			var session:ChunkedUploadSession = new ChunkedUploadSession(data, chunkedSize);
			_chunkedUploadSessionList.push(session);
			session.url = url;
			session.fileName = fileName;
			session.filePathWithName =  (filePath == null || filePath == "" ? "" : filePath + '/') + fileName;
			session.root = root;
			session.locale = locale;
			session.overwrite = overwrite;
			session.parent_rev = parent_rev;
			session.retryCount = retryCount;
			
			return chunkedUploadNext(session);
		}
		
		/**
		 * @private
		 * 
		 */
		private function commitChunkUpload(session:ChunkedUploadSession):URLLoader
		{
			var params:Object = new Object();
			params = {
				upload_id : session.uploadId
			};
			
			buildOptionalParameters(params, 'locale', session.locale);
			params.overwrite = session.overwrite.toString();
			buildOptionalParameters(params, 'parent_rev', session.parent_rev);
			
			var urlRequest:URLRequest = buildURLRequest(
				config.contentServer, '/commit_chunked_upload/' + session.root +  buildURLFilePath(session.filePathWithName), params, URLRequestMethod.POST);
			return this.load(urlRequest, DropboxEvent.COMMIT_CHUNKED_UPLOAD_RESULT, 
				DropboxEvent.COMMIT_CHUNKED_UPLOAD_FAULT, DROPBOX_FILE);
		}
		
		/**
		 * @private
		 */
		private function chunkedUploadNext(session:ChunkedUploadSession, retry:Boolean = false):URLLoader
		{
			var nextData:ByteArray;
			if (!retry) {
				nextData = session.getNext();
			} else {
				nextData = session.retry();
			}
			if (nextData == null) {
				this._chunkedUploadSessionList.splice(_chunkedUploadSessionList.indexOf(session), 1);
				this.commitChunkUpload(session);
				return null;
			}
			
			var targetURL:String = session.url;
			var params:Object = new Object();
			if (session.uploadId != null && session.uploadId.length > 0) {
				targetURL += "?upload_id=" + session.uploadId;
				targetURL += "&offset=" + session.currentOffset;
				params.upload_id = session.uploadId;
				params.offset = session.currentOffset;
			}
			
			
			var urlReqHeader:URLRequestHeader = OAuthHelper.buildURLRequestHeader(session.url, params, 
				config.consumerKey, config.consumerSecret, 
				config.accessTokenKey, config.accessTokenSecret, URLRequestMethod.PUT);
			
			var fileTypeArray:Array = session.fileName.split('.');
			var fileType:String = "file";
			if (fileTypeArray.length > 1) {
				fileType = fileTypeArray[fileTypeArray.length - 1];
			}
			
			var urlRequest:URLRequest = new URLRequest(targetURL);
			urlRequest.data = nextData;
			urlRequest.method = URLRequestMethod.PUT;
			var contentTypeHeader:URLRequestHeader = new URLRequestHeader("Content-Type", "application/" + fileType);
			urlRequest.requestHeaders = [urlReqHeader, contentTypeHeader];
			var urlLoader:URLLoader = new URLLoader(urlRequest);
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, chunkedUploadCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, chunkedUploadIOErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, chunkedUploadSecurityErrorHandler);
			urlLoader.load(urlRequest);
			session.relatedLoader = urlLoader;
			return urlLoader;
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
			target  = OAuthHelper.encodeURL(target);
			//target  = encodeURI(target);
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
			urlLoader.dataFormat 		= dataFormat;
			urlLoader.eventResultType 	= evtResultType;
			urlLoader.eventFaultType 	= evtFaultType;
			urlLoader.resultType 		= resultType;
			
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
					accountInfo.decode(com.adobe.serialization.json.JSON.decode(urlLoader.data));
					resultObject = accountInfo;
				} else if (urlLoader.resultType == DROPBOX_FILE) {
					var dropboxFile:DropboxFile = new DropboxFile();
					dropboxFile.decode(com.adobe.serialization.json.JSON.decode(urlLoader.data));
					resultObject = dropboxFile;
				} else if (urlLoader.resultType == DROPBOX_FILE_LIST) {
					var array:Array = new Array();
					var resultArray:* = com.adobe.serialization.json.JSON.decode(urlLoader.data);
					for each (var ro:Object in resultArray) {
						var df:DropboxFile = new DropboxFile();
						df.decode(ro);
						array.push(df);
					}
					resultObject = array;
				} else if (urlLoader.resultType == SHARES_INFO) {
					var sharesInfo:SharesInfo = new SharesInfo();
					sharesInfo.decode(com.adobe.serialization.json.JSON.decode(urlLoader.data));
					resultObject = sharesInfo;
				} else if (urlLoader.resultType == DELTA_INFO) {
					var delta:Delta = new Delta();
					delta.decode(com.adobe.serialization.json.JSON.decode(urlLoader.data));
					resultObject = delta;
				} else if (urlLoader.resultType == COPY_REF_INFO) {
					var copyRef:CopyRef = new CopyRef();
					copyRef.decode(com.adobe.serialization.json.JSON.decode(urlLoader.data));
					resultObject = copyRef;
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
		protected function chunkedUploadCompleteHandler(evt:Event):void
		{
			var m:URLLoader = URLLoader(evt.target);
			var theSession:ChunkedUploadSession;
			for each (var session:ChunkedUploadSession in this._chunkedUploadSessionList) {
				if (session.relatedLoader == m) {
					theSession = session;
					break;
				}
			}
			
			var chunkedUpload:ChunkedUpload = new ChunkedUpload();
			chunkedUpload.decode(com.adobe.serialization.json.JSON.decode(m.data));
			
			if (session.uploadId == null || session.uploadId == "") {
				session.uploadId = chunkedUpload.uploadId;
			}
			
			this.dispatchDropboxEvent(DropboxEvent.CHUNKED_UPLOAD_RESULT, evt, chunkedUpload);
			
			this.chunkedUploadNext(session);
		}
		
		/**
		 * @private
		 * 
		 * Listener for upload request.
		 *  
		 * @param evt
		 * 
		 */
		protected function chunkedUploadIOErrorHandler(evt:IOErrorEvent):void
		{
			var urlLoader:URLLoader = URLLoader(evt.target);
			var theSession:ChunkedUploadSession;
			for each (var session:ChunkedUploadSession in this._chunkedUploadSessionList) {
				if (session.relatedLoader == urlLoader) {
					theSession = session;
				}
			}
			if (theSession.retryCount > 0) {
				theSession.retryCount--;
				this.chunkedUploadNext(theSession, true);
			} else {
				this._chunkedUploadSessionList.splice(_chunkedUploadSessionList.indexOf(session), 1);
				this.dispatchDropboxEvent(DropboxEvent.CHUNKED_UPLOAD_FAULT, evt, urlLoader.data);
			}
		}
		
		/**
		 * @private
		 * 
		 * Listener for upload request.
		 *  
		 * @param evt
		 * 
		 */
		protected function chunkedUploadSecurityErrorHandler(evt:SecurityErrorEvent):void
		{
			var urlLoader:URLLoader = URLLoader(evt.target);
			var theSession:ChunkedUploadSession;
			for each (var session:ChunkedUploadSession in this._chunkedUploadSessionList) {
				if (session.relatedLoader == urlLoader) {
					theSession = session;
				}
			}
			this._chunkedUploadSessionList.splice(_chunkedUploadSessionList.indexOf(session), 1);
			this.dispatchDropboxEvent(DropboxEvent.CHUNKED_UPLOAD_FAULT, evt, urlLoader.data);
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
			var m:URLLoader = URLLoader(evt.target);
			var dropboxFile:DropboxFile = new DropboxFile();
			dropboxFile.decode(com.adobe.serialization.json.JSON.decode(m.data));
			this.dispatchDropboxEvent(DropboxEvent.PUT_FILE_RESULT, evt, dropboxFile);
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
			var m:URLLoader = URLLoader(evt.target);
			this.dispatchDropboxEvent(DropboxEvent.PUT_FILE_FAULT, evt, m.data);
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
			var m:URLLoader = URLLoader(evt.target);
			this.dispatchDropboxEvent(DropboxEvent.PUT_FILE_FAULT, evt, m.data);
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
		 */
		protected function ioErrorHandlerDoNothing(event:IOErrorEvent):void
		{
			// for 304 response, do nothing
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
			return protocol + host + portString + (target == "" ? "" : '/' + config.apiVersion + target); 
		}
		
		/**
		 * @private
		 */
		protected function buildURLFilePath(filePath:String):String
		{
			if (filePath == null || filePath == "") {
				filePath = "";
			} else if (filePath.substr(0, 1) != '/') {
				filePath = '/' + filePath;
			}
			return filePath;
		}
		
		private static function buildOptionalParameters(paramTarget:Object, paramName:String, paramValue:*):void
		{
			if (paramName != null && paramName != "" && paramValue != null && paramValue != "") {
				paramTarget[paramName] = paramValue.toString();
			}
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
	 * define class type of result.
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
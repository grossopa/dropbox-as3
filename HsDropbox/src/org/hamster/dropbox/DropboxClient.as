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
	import org.hamster.dropbox.models.ChunkedUpload;
	import org.hamster.dropbox.models.CopyRef;
	import org.hamster.dropbox.models.Delta;
	import org.hamster.dropbox.models.DropboxFile;
	import org.hamster.dropbox.models.SharesInfo;
	import org.hamster.dropbox.services.ChunkedUploadSession;
	import org.hamster.dropbox.utils.OAuthHelper;
	
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
		 * create an account.
		 * 
		 * @param email
		 * @param password
		 * @param first_name
		 * @param last_name
		 * @return URLLoader
		 */
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
		 * Retrieves information about the user's account.
		 * 
		 * <p>https://api.dropbox.com/1/account/info</p>
		 * <p>version: 0,1</p>
		 * <p>methods: GET</p>
		 * <p>results: User account information.</p>
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
		 * Copies a file or folder to a new location.
		 * 
		 * <p>https://api.dropbox.com/1/fileops/copy</p>
		 * <p>version: 0,1</p>
		 * <p>methods: POST</p>
		 * <p>results: Metadata for the copy of the file or folder.</p>
		 * 
		 * @param fromPath
		 * @param toPath
		 * @param fromCopyRef optional, if it's not empty, then ignore fromPath parameter
		 * @param root, optional, default is "dropbox" 2011/01/22
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
		 * <p>https://api.dropbox.com/1/fileops/create_folder</p>
		 * <p>version: 0,1</p>
		 * <p>methods: POST</p>
		 * <p>results: Metadata for the new folder.</p>
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
		 * Deletes a file or folder.
		 * 
		 * <p>https://api.dropbox.com/1/fileops/delete</p>
		 * <p>version: 0,1</p>
		 * <p>methods: POST</p>
		 * <p>results: Metadata for the deleted file or folder.</p>
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
				DropboxEvent.FILE_DELETE_FAULT, DROPBOX_FILE);
		}
		
		/** 
		 * Moves a file or folder to a new location.
		 * 
		 * <p>https://api.dropbox.com/1/fileops/move</p>
		 * <p>version: 0,1</p>
		 * <p>methods: POST</p>
		 * <p>results: Metadata for the moved file or folder.</p>
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
		 * Retrieves file and folder metadata.
		 * 
		 * <p>https://api.dropbox.com/1/metadata/&lt;root&gt;/&lt;path&gt;</p>
		 * <p>version: 0,1</p>
		 * <p>methods: GET</p>
		 * <p>results: The metadata for the file or folder at the given &lt;path&gt;. 
		 * If &lt;path&gt; represents a folder and the list parameter is true, 
		 * the metadata will also include a listing of metadata for the folder's contents.</p>
		 * 
		 * @param path
		 * @param fileLimit
		 * @param hash pass a hash value to perform better performance
		 * @param list if query a directory, true to show sub list.
		 * @param root, optional, default is "dropbox" 2011/01/22
		 * @param include_deleted optional, added in v1
		 * @param rev optional, added in v1
		 * @param locale optional, added in v1
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
			var params:Object = {
				"file_limit" : fileLimit,
				"hash": hash,
				"list": list
			};
			
			// added in v1
			if (include_deleted == true)
				buildOptionalParameters(params, 'include_deleted', include_deleted);
			buildOptionalParameters(params, 'rev', rev);
			buildOptionalParameters(params, 'locale', locale);
			
			var urlRequest:URLRequest = buildURLRequest(
				config.server, '/metadata/' + root + '/' + path, params);
			return this.load(urlRequest, DropboxEvent.METADATA_RESULT, 
				DropboxEvent.METADATA_FAULT, DROPBOX_FILE);
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
		public function thumbnails(pathToPhoto:String, size:String = "",
								 root:String = DropboxConfig.DROPBOX):URLLoader
		{
			var params:Object = {
				"size" : size
			};
			var urlRequest:URLRequest = buildURLRequest(
				config.contentServer, "/thumbnails/" + root + '/' + pathToPhoto, params);
			return this.load(urlRequest, DropboxEvent.THUMBNAILS_RESULT, 
				DropboxEvent.THUMBNAILS_FAULT, "", URLLoaderDataFormat.BINARY);
		}
		
		/**
		 * Downloads a file. Note that this call goes to the api-content server.
		 * 
		 * <p>https://api-content.dropbox.com/1/files/&lt;root&gt;/&lt;path&gt;</p>
		 * <p>version: 0,1</p>
		 * <p>methods: GET</p>
		 * <p>results: The specified file's contents at the requested revision.</p>
		 * 
		 * @param filePath
		 * @param rev
		 * @param root, optional, default is "dropbox" 2011/01/22
		 * @rev file revision added in v1
		 * @return urlLoader
		 */
		public function getFile(filePath:String, rev:String = "",
								root:String=DropboxConfig.DROPBOX):URLLoader
		{
			var params:Object = null;
			if (rev != "") {
				params = {
					rev : rev
				}
			}
			var urlRequest:URLRequest = buildURLRequest(
				config.contentServer, "/files/" + root + '/' + filePath, params);
			return this.load(urlRequest, DropboxEvent.GET_FILE_RESULT, 
				DropboxEvent.GET_FILE_FAULT, "", URLLoaderDataFormat.BINARY);
		}
		 
		/**
		 * Uploads a file. Note that this call goes to the api-content server.
		 * 
		 * <p>https://api-content.dropbox.com/1/files/&lt;root&gt;/&lt;path&gt;</p>
		 * <p>version: 0,1</p>
		 * <p>methods: POST</p>
		 * <p>results: The metadata for the uploaded file.</p>
		 *  
		 * @param filePath
		 * @param fileName
		 * @param data
		 * @param root, optional, default is "dropbox" 2011/01/22
		 * @param locale optional added in v1
		 * @param overwrite optional added in v1
		 * @param parent_rev optional added in v1
		 * @return multipartURLLoader
		 */
		public function putFile(filePath:String, 
								fileName:String, 
								data:ByteArray, 
								locale:String = "",
								overwrite:Boolean = true,
								parent_rev:String = "",
								root:String = DropboxConfig.DROPBOX):URLLoader
		{
			var url:String = this.buildFullURL(config.contentServer, OAuthHelper.encodeURL('/files_put/' + root + '/' + filePath + '/' + fileName), "https");
			var params:Object = { 
			};
			
			//added in version 1
			buildOptionalParameters(params, 'locale', locale);
			params.overwrite = overwrite.toString();
			buildOptionalParameters(params, 'parent_rev', parent_rev);
			
			var urlReqHeader:URLRequestHeader = OAuthHelper.buildURLRequestHeader(url, new Object(), 
				config.consumerKey, config.consumerSecret, 
				config.accessTokenKey, config.accessTokenSecret, URLRequestMethod.POST);
			
			var fileTypeArray:Array = fileName.split('.');
			var fileType:String = "file";
			if (fileTypeArray.length > 1) {
				fileType = fileTypeArray[fileTypeArray.length - 1];
			}
			var urlRequest:URLRequest = new URLRequest(url);
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
		 * 
		 * <p>https://api.dropbox.com/1/revisions/&lt;root&gt;/&lt;path&gt;</p>
		 * <p>version: 0,1</p>
		 * <p>methods: GET</p>
		 * <p>results: A list of all revisions formatted just like file metadata.</p>
		 * 
		 * @param filePathWithName
		 * @param root optional, default is dropbox.  
		 * @return urlLoader
		 */
		public function revisions(filePathWithName:String,
								  root:String = DropboxConfig.DROPBOX):URLLoader
		{
			var urlRequest:URLRequest = buildURLRequest(
				config.server, '/revisions/' + root + '/' +  filePathWithName, null);
			return this.load(urlRequest, DropboxEvent.REVISION_RESULT, 
				DropboxEvent.REVISION_FAULT, DROPBOX_FILE_LIST, URLLoaderDataFormat.TEXT);
		}
		
		/**
		 * Restores a file path to a previous revision. 
		 * Unlike downloading a file at a given revision and 
		 * then re-uploading it, this call is atomic. 
		 * It also saves a bunch of bandwidth.
		 * 
		 * <p>https://api.dropbox.com/1/restore/&lt;root&gt;/&lt;path&gt;</p>
		 * <p>version: 1</p>
		 * <p>methods: POST</p>
		 * <p>results: A list of all revisions formatted just like file metadata.</p>
		 * 
		 * @param filePathWithName
		 * @param rev revision to restore
		 * @param locale optional
		 * @param root optional, default is dropbox.
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
				config.server, '/restore/' + root + '/' +  filePathWithName, params, URLRequestMethod.POST);
			return this.load(urlRequest, DropboxEvent.RESTORE_RESULT, 
				DropboxEvent.RESTORE_FAULT, DROPBOX_FILE, URLLoaderDataFormat.TEXT);			
		}
		
		/**
		 * Returns metadata for all files and folders that match the 
		 * search query. Searches are limited to the folder path and 
		 * its sub-folder hierarchy provided in the call.
		 * 
		 * <p>https://api.dropbox.com/1/search/&lt;root&gt;/&lt;path&gt;</p>
		 * <p>version: 1</p>
		 * <p>methods: GET, POST</p>
		 * <p>results: List of metadata entries for any matching files and folders.</p>
		 * 
		 * @param filePathWithName
		 * @param rev revision to restore
		 * @param locale optional
		 * @param root optional, default is dropbox.
		 * @return urlLoader
		 * 
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
				config.server, '/search/' + root + '/' +  filePath, params, URLRequestMethod.POST);
			return this.load(urlRequest, DropboxEvent.SEARCH_RESULT, 
				DropboxEvent.SEARCH_FAULT, DROPBOX_FILE_LIST, URLLoaderDataFormat.TEXT);
		}
		
		/**
		 * Creates and returns a shareable link to files or folders. 
		 * Note: Links created by the /shares API call expire after thirty days.
		 * 
		 * <p>https://api.dropbox.com/1/shares/&lt;root&gt;/&lt;path&gt;</p>
		 * <p>version: 0,1</p>
		 * <p>methods: POST</p>
		 * <p>results: A shareable link to the file or folder. 
		 * The link can be used publicly and directs to a preview page 
		 * of the file. Also returns the link's expiration date 
		 * in Dropbox's usual date format.</p>
		 * 
		 * @param filePathWithName
		 * @param root optional, default is dropbox.
		 * @return urlLoader
		 */
		public function shares(filePathWithName:String,
							   root:String = DropboxConfig.DROPBOX):URLLoader
		{
			var urlRequest:URLRequest = buildURLRequest(
				config.server, '/shares/' + root + '/' +  filePathWithName, null);
			return this.load(urlRequest, DropboxEvent.SHARES_RESULT, 
				DropboxEvent.SHARES_FAULT, SHARES_INFO, URLLoaderDataFormat.TEXT);
		}
		
		/**
		 * Returns a link directly to a file. Similar to /shares. 
		 * The difference is that this bypasses the Dropbox webserver,
		 * used to provide a preview of the file, so that you can 
		 * effectively stream the contents of your media.
		 * 
		 * <p>https://api.dropbox.com/1/media/&lt;root&gt;/&lt;path&gt;</p>
		 * <p>version: 1</p>
		 * <p>methods: POST</p>
		 * <p>results: A url that serves the media directly. Also returns 
		 * the link's expiration date in Dropbox's usual date format.</p>
		 * 
		 * @param filePathWithName
		 * @param root optional, default is dropbox.
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
				config.server, '/media/' + root + '/' + filePathWithName, params, URLRequestMethod.POST);
			return this.load(urlRequest, DropboxEvent.MEDIA_RESULT, 
				DropboxEvent.MEDIA_FAULT, SHARES_INFO, URLLoaderDataFormat.TEXT);
		}
		
		/**
		 * A way of letting you keep up with changes to files and folders in a user's Dropbox. 
		 * You can periodically call /delta to get a list of "delta entries", 
		 * which are instructions on how to update your local state to match the server's state.
		 * 
		 * <p>https://api.dropbox.com/1/delta</p>
		 * <p>version: 1</p>
		 * <p>methods: POST</p>
		 * <p>results: Delta information.</p>
		 * 
		 * @param cursor
		 * @param locale
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
		 * Creates and returns a copy_ref to a file. 
		 * This reference string can be used to copy that file to another 
		 * user's Dropbox by passing it in as the from_copy_ref parameter 
		 * on /fileops/copy.
		 * 
		 * <p>https://api.dropbox.com/1/copy_ref/<root>/<path></p>
		 * <p>version: 1</p>
		 * <p>methods: GET</p>
		 * <p>results: CopyRef information.</p>
		 * 
		 * @param filePathWithName
		 * @return urlLoader
		 */
		public function copyRef(filePathWithName:String,
								root:String = DropboxConfig.DROPBOX):URLLoader
		{
			var params:Object = new Object();
			
			var urlRequest:URLRequest = buildURLRequest(
				config.server, '/copy_ref/' + root + '/' + filePathWithName, null);
			return this.load(urlRequest, DropboxEvent.COPY_REF_RESULT, 
				DropboxEvent.COPY_REF_FAULT, COPY_REF_INFO);
		}
		
		/**
		 * Uploads large files to Dropbox in mulitple chunks. 
		 * Also has the ability to resume if the upload is interrupted. 
		 * This allows for uploads larger than the /files 
		 * and /files_put maximum of 150 MB.
		 * 
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
		 * 
		 * <p>https://api-content.dropbox.com/1/chunked_upload?param=val</p>
		 * <p>https://api-content.dropbox.com/1/commit_chunked_upload/<root>/<path></p>
		 * <p>version: 1</p>
		 * <p>methods: PUT</p>
		 * <p>results: ChunkedUpload for each /chunked_upload call 
		 * and DropboxFile for /commit_chunked_upload call.</p>
		 * 
		 * @param filePath
		 * @param fileName
		 * @param data
		 * @param retryCount
		 * @param chunkedSize
		 * @param locale
		 * @param overwrite
		 * @param parent_rev
		 * @param root
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
			session.filePathWithName =  filePath + '/' + fileName;
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
				config.contentServer, '/commit_chunked_upload/' + session.root + '/' + session.filePathWithName, params, URLRequestMethod.POST);
			return this.load(urlRequest, DropboxEvent.COMMIT_CHUNKED_UPLOAD_RESULT, 
				DropboxEvent.COMMIT_CHUNKED_UPLOAD_FAULT, DROPBOX_FILE);
		}
		
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
			if (session.uploadId != null && session.uploadId.length > 0) {
				targetURL += "?upload_id=" + session.uploadId;
				targetURL += "&offset=" + session.currentOffset;
			}
			
			var urlReqHeader:URLRequestHeader = OAuthHelper.buildURLRequestHeader(targetURL, new Object(), 
				config.consumerKey, config.consumerSecret, 
				config.accessTokenKey, config.accessTokenSecret, URLRequestMethod.POST);
			
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
	 * define class type of result, can be REQUEST_TOKEN|ACCESS_TOKEN|ACCOUNT_INFO|DROPBOX_FILE.
	 * 
	 * REQUEST_TOKEN & ACCESS_TOKEN : set to DropboxConfig when type is requestToken & accessToken.
	 * ACCOUNT_INFO : return an AccountInfo object
	 * DROPBOX_FILE : return an DropboxFile object
	 * DROPBOX_FILE_LIST : return an array of DropboxFile object
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
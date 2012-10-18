package org.hamster.dropbox
{
	import flash.events.Event;
	
	/**
	 * Dropbox Event.
	 *  
	 * @author yinzeshuo
	 * 
	 */
	public class DropboxEvent extends Event
	{
		public static const REQUEST_TOKEN_RESULT:String = 'DropboxEvent_RequestTokenResult';
		public static const REQUEST_TOKEN_FAULT:String = 'DropboxEvent_RequestTokenFault';
		public static const ACCESS_TOKEN_RESULT:String = 'DropboxEvent_AccessTokenResult';
		public static const ACCESS_TOKEN_FAULT:String = 'DropboxEvent_AccessTokenFault';
		public static const ACCOUNT_INFO_RESULT:String = 'DropboxEvent_AccountInfoResult';
		public static const ACCOUNT_INFO_FAULT:String = 'DropboxEvent_AccountInfoFault';
		public static const PUT_FILE_RESULT:String = 'DropboxEvent_PutFileResult';
		public static const PUT_FILE_FAULT:String = 'DropboxEvent_PutFileFault';
		public static const FILE_COPY_RESULT:String = 'DropboxEvent_FileCopyResult';
		public static const FILE_COPY_FAULT:String = 'DropboxEvent_FileCopyFault';
		public static const FILE_CREATE_FOLDER_RESULT:String = 'DropboxEvent_FileCreateFolderResult';
		public static const FILE_CREATE_FOLDER_FAULT:String = 'DropboxEvent_FileCreateFolderFault';
		public static const FILE_DELETE_RESULT:String = 'DropboxEvent_FileDeleteResult';
		public static const FILE_DELETE_FAULT:String = 'DropboxEvent_FileDeleteFault';
		public static const FILE_MOVE_RESULT:String = 'DropboxEvent_FileMoveResult';
		public static const FILE_MOVE_FAULT:String = 'DropboxEvent_FileMoveFault';
		public static const GET_FILE_RESULT:String = 'DropboxEvent_GetFileResult';
		public static const GET_FILE_FAULT:String = 'DropboxEvent_GetFileFault';
		public static const METADATA_RESULT:String = 'DropboxEvent_MetadataResult';
		public static const METADATA_FAULT:String = 'DropboxEvent_MetadataFault';
		public static const THUMBNAILS_RESULT:String = 'DropboxEvent_ThumbnailsResult';
		public static const THUMBNAILS_FAULT:String = 'DropboxEvent_ThumbnailsFault';
		public static const TOKEN_RESULT:String = 'DropboxEvent_TokenResult';
		public static const TOKEN_FAULT:String = 'DropboxEvent_TokenFault';
		/**
		 * xperiments UPDATE 
		 */		
		public static const ACCOUNT_CREATE_RESULT:String = 'DropboxEvent_AccountCreateResult';
		public static const ACCOUNT_CREATE_FAULT:String = 'DropboxEvent_AccountCreateFault';
		/**
		 * added in v1
		 */
		public static const REVISION_RESULT:String 	= "DropboxEvent_RevisionResult";
		public static const REVISION_FAULT:String 	= "DropboxEvent_RevisionFault";
		public static const RESTORE_RESULT:String 	= "DropboxEvent_RestoreResult";
		public static const RESTORE_FAULT:String 	= "DropboxEvent_RestoreFault";
		public static const SEARCH_RESULT:String	= 'DropboxEvent_SearchResult';
		public static const SEARCH_FAULT:String		= 'DropboxEvent_SearchFault';
		public static const SHARES_RESULT:String	= 'DropboxEvent_SharesResult';
		public static const SHARES_FAULT:String		= 'DropboxEvent_SharesFault';
		public static const MEDIA_RESULT:String		= 'DropboxEvent_MediaResult';
		public static const MEDIA_FAULT:String		= 'DropboxEvent_MediaFault';
		public static const DELTA_RESULT:String		= 'DropboxEvent_DeltaResult';
		public static const DELTA_FAULT:String		= 'DropboxEvent_DeltaFault';
		public static const COPY_REF_RESULT:String	= 'DropboxEvent_CopyRefResult';
		public static const COPY_REF_FAULT:String	= 'DropboxEvent_CopyRefFault';
		
		public static const CHUNKED_UPLOAD_RESULT:String = 'DropboxEvent_ChunkedUploadResult';
		public static const CHUNKED_UPLOAD_FAULT:String  = 'DropboxEvent_ChunkedUploadFault';
		public static const COMMIT_CHUNKED_UPLOAD_RESULT:String = 'DropboxEvent_CommitChunkedUploadResult';
		public static const COMMIT_CHUNKED_UPLOAD_FAULT:String = 'DropboxEvent_CommitChunkedUploadFault';
		
		/**
		 * related URLLoader Event. 
		 */
		public var relatedEvent:Event;
		/**
		 * result Object
		 * 1. object{key:'', secret:''} when you called DropboxClient.requestToken() or DropboxClient.accessToken()
		 * 2. AccountInfo when you called accountInfo()
		 * 3. DropboxFile when you called files API
		 * 4. ByteArray when you called getFile()
		 * 5. response string.
		 */
		public var resultObject:Object;
		
		/**
		 * Constructor
		 *  
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */
		public function DropboxEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * clone function.
		 *  
		 * @return a cloned instance of DropboxEvent
		 */
		override public function clone():Event
		{
			var result:DropboxEvent = new DropboxEvent(type, bubbles, cancelable);
			result.relatedEvent = this.relatedEvent;
			result.resultObject = this.resultObject;
			return result;
		}
	}
}
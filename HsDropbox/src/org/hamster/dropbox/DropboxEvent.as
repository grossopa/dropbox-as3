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
		/**
		 * Result event of requestToken method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#requestToken() 
		 */
		public static const REQUEST_TOKEN_RESULT:String = 'DropboxEvent_RequestTokenResult';
		/**
		 * Fault event of requestToken method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#requestToken() 
		 */
		public static const REQUEST_TOKEN_FAULT:String = 'DropboxEvent_RequestTokenFault';
		
		/**
		 * Result event of accessToken method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#accessToken() 
		 */
		public static const ACCESS_TOKEN_RESULT:String = 'DropboxEvent_AccessTokenResult';
		/**
		 * Fault event of accessToken method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#accessToken() 
		 */
		public static const ACCESS_TOKEN_FAULT:String = 'DropboxEvent_AccessTokenFault';
		/**
		 * Result event of accountInfo method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#accountInfo() 
		 */
		public static const ACCOUNT_INFO_RESULT:String = 'DropboxEvent_AccountInfoResult';
		/**
		 * Fault event of accessToken method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#accessToken() 
		 */
		public static const ACCOUNT_INFO_FAULT:String = 'DropboxEvent_AccountInfoFault';
		/**
		 * Result event of putFile method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#putFile() 
		 */
		public static const PUT_FILE_RESULT:String = 'DropboxEvent_PutFileResult';
		/**
		 * Fault event of putFile method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#putFile() 
		 */
		public static const PUT_FILE_FAULT:String = 'DropboxEvent_PutFileFault';
		/**
		 * Result event of fileCopy method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#fileCopy() 
		 */
		public static const FILE_COPY_RESULT:String = 'DropboxEvent_FileCopyResult';
		/**
		 * Fault event of fileCopy method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#fileCopy() 
		 */
		public static const FILE_COPY_FAULT:String = 'DropboxEvent_FileCopyFault';
		/**
		 * Result event of fileCreateFolder method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#fileCreateFolder() 
		 */
		public static const FILE_CREATE_FOLDER_RESULT:String = 'DropboxEvent_FileCreateFolderResult';
		/**
		 * Fault event of fileCreateFolder method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#fileCreateFolder() 
		 */
		public static const FILE_CREATE_FOLDER_FAULT:String = 'DropboxEvent_FileCreateFolderFault';
		/**
		 * Result event of fileDelete method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#fileDelete() 
		 */
		public static const FILE_DELETE_RESULT:String = 'DropboxEvent_FileDeleteResult';
		/**
		 * Fault event of fileDelete method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#fileDelete() 
		 */
		public static const FILE_DELETE_FAULT:String = 'DropboxEvent_FileDeleteFault';
		/**
		 * Result event of fileMove method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#fileMove() 
		 */
		public static const FILE_MOVE_RESULT:String = 'DropboxEvent_FileMoveResult';
		/**
		 * Fault event of fileMove method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#fileMove() 
		 */
		public static const FILE_MOVE_FAULT:String = 'DropboxEvent_FileMoveFault';
		/**
		 * Result event of getFile method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#getFile() 
		 */
		public static const GET_FILE_RESULT:String = 'DropboxEvent_GetFileResult';
		/**
		 * Fault event of getFile method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#getFile() 
		 */
		public static const GET_FILE_FAULT:String = 'DropboxEvent_GetFileFault';
		/**
		 * Result event of metadata method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#metadata() 
		 */
		public static const METADATA_RESULT:String = 'DropboxEvent_MetadataResult';
		/**
		 * Result event of metadata method. When hash is not modified.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#metadata() 
		 */
		public static const METADATA_RESULT_NOT_MODIFIED:String = 'DropboxEvent_MetadataResultNotModified';
		/**
		 * Fault event of metadata method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#metadata() 
		 */
		public static const METADATA_FAULT:String = 'DropboxEvent_MetadataFault';
		/**
		 * Result event of thumbnails method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#thumbnails() 
		 */
		public static const THUMBNAILS_RESULT:String = 'DropboxEvent_ThumbnailsResult';
		/**
		 * Fault event of thumbnails method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#thumbnails() 
		 */
		public static const THUMBNAILS_FAULT:String = 'DropboxEvent_ThumbnailsFault';
		/**
		 * Result event of token method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#token() 
		 */
		public static const TOKEN_RESULT:String = 'DropboxEvent_TokenResult';
		/**
		 * Fault event of token method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#token() 
		 */
		public static const TOKEN_FAULT:String = 'DropboxEvent_TokenFault';
		/**
		 * Result event of accountCreate method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#accountCreate() 
		 */
		public static const ACCOUNT_CREATE_RESULT:String = 'DropboxEvent_AccountCreateResult';
		/**
		 * Fault event of accountCreate method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#accountCreate() 
		 */
		public static const ACCOUNT_CREATE_FAULT:String = 'DropboxEvent_AccountCreateFault';
		/**
		 * Result event of revision method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#revision() 
		 */
		public static const REVISION_RESULT:String 	= "DropboxEvent_RevisionResult";
		/**
		 * Fault event of revision method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#revision() 
		 */
		public static const REVISION_FAULT:String 	= "DropboxEvent_RevisionFault";
		/**
		 * Result event of restore method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#restore() 
		 */
		public static const RESTORE_RESULT:String 	= "DropboxEvent_RestoreResult";
		/**
		 * Fault event of restore method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#restore() 
		 */
		public static const RESTORE_FAULT:String 	= "DropboxEvent_RestoreFault";
		/**
		 * Result event of search method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#search() 
		 */
		public static const SEARCH_RESULT:String	= 'DropboxEvent_SearchResult';
		/**
		 * Fault event of search method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#search() 
		 */
		public static const SEARCH_FAULT:String		= 'DropboxEvent_SearchFault';
		/**
		 * Result event of shares method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#shares() 
		 */
		public static const SHARES_RESULT:String	= 'DropboxEvent_SharesResult';
		/**
		 * Fault event of shares method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#shares() 
		 */
		public static const SHARES_FAULT:String		= 'DropboxEvent_SharesFault';
		/**
		 * Result event of media method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#media() 
		 */
		public static const MEDIA_RESULT:String		= 'DropboxEvent_MediaResult';
		/**
		 * Fault event of media method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#media() 
		 */
		public static const MEDIA_FAULT:String		= 'DropboxEvent_MediaFault';
		/**
		 * Result event of delta method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#delta() 
		 */
		public static const DELTA_RESULT:String		= 'DropboxEvent_DeltaResult';
		/**
		 * Fault event of delta method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#delta() 
		 */
		public static const DELTA_FAULT:String		= 'DropboxEvent_DeltaFault';
		/**
		 * Result event of copyRef method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#copyRef() 
		 */
		public static const COPY_REF_RESULT:String	= 'DropboxEvent_CopyRefResult';
		/**
		 * Fault event of copyRef method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#copyRef() 
		 */
		public static const COPY_REF_FAULT:String	= 'DropboxEvent_CopyRefFault';
		/**
		 * Result event of chunkedUpload method. Dispatched when each chunks uploading has been done.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#chunkedUpload() 
		 */
		public static const CHUNKED_UPLOAD_RESULT:String = 'DropboxEvent_ChunkedUploadResult';
		/**
		 * Fault event of chunkedUpload method. Dispatched when chunk failed and also the retry count
		 * has returned to 0.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#chunkedUpload() 
		 */
		public static const CHUNKED_UPLOAD_FAULT:String  = 'DropboxEvent_ChunkedUploadFault';
		/**
		 * Result event of commitChunkedUpload method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#chunkedUpload() 
		 */
		public static const COMMIT_CHUNKED_UPLOAD_RESULT:String = 'DropboxEvent_CommitChunkedUploadResult';
		/**
		 * Fault event of commitChunkedUpload method.
		 * 
		 * @see org.hamster.dropbox.DropboxClient#chunkedUpload() 
		 */
		public static const COMMIT_CHUNKED_UPLOAD_FAULT:String = 'DropboxEvent_CommitChunkedUploadFault';
		
		/**
		 * related URLLoader Event.
		 */
		public var relatedEvent:Event;
		
		/**
		 * result Object.
		 * 
		 * <table><tr><th>Event name</th><th>Object Type</th></tr>
		 *        <tr><td>REQUEST_TOKEN_RESULT</td><td>Request token object with property "key" and "secret".</td></tr>
		 *        <tr><td>ACCESS_TOKEN_RESULT</td><td>Access token object with property "key" and "secret".</td></tr>
		 *        <tr><td>ACCOUNT_INFO_RESULT</td><td>AccountInfo</td></tr>
		 *        <tr><td>FILE_COPY_RESULT</td><td>DropboxFile</td></tr>
		 *        <tr><td>FILE_CREATE_FOLDER_RESULT</td><td>DropboxFile</td></tr>
		 *        <tr><td>FILE_DELETE_RESULT</td><td>DropboxFile</td></tr>
		 *        <tr><td>FILE_MOVE_RESULT</td><td>DropboxFile</td></tr>
		 *        <tr><td>METADATA_RESULT</td><td>DropboxFile</td></tr>
		 *        <tr><td>METADATA_RESULT_NOT_MODIFIED</td><td>null</td></tr>
		 *        <tr><td>THUMBNAILS_RESULT</td><td>ByteArray</td></tr>
		 *        <tr><td>GET_FILE_RESULT</td><td>ByteArray</td></tr>
		 *        <tr><td>PUT_FILE_RESULT</td><td>DropboxFile</td></tr>
		 *        <tr><td>REVISIONS_RESULT</td><td>Array contains DropboxFile list</td></tr>
		 *        <tr><td>RESTORE_RESULT</td><td>DropboxFile</td></tr>
		 *        <tr><td>SEARCH_RESULT</td><td>Array contains DropboxFile list</td></tr>
		 *        <tr><td>SHARES_RESULT</td><td>SharesInfo</td></tr>
		 *        <tr><td>MEDIA_RESULT</td><td>SharesInfo</td></tr>
		 *        <tr><td>DELTA_RESULT</td><td>Delta</td></tr>
		 *        <tr><td>COPY_REF_RESULT</td><td>CopyRef</td></tr>
		 *        <tr><td>CHUNKED_UPLOAD_RESULT</td><td>ChunkedUpload</td></tr>
		 *        <tr><td>COMMIT_CHUNKED_UPLOAD_RESULT</td><td>DropboxFile</td></tr>
		 * </table>
		 */
		public var resultObject:*;
		
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
		 * @return
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
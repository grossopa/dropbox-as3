package org.hamster.dropbox
{
	import flash.events.Event;
	
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
		
		public var relatedEvent:Event;
		public var resultObject:Object;
		
		public function DropboxEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var result:DropboxEvent = new DropboxEvent(type, bubbles, cancelable);
			result.relatedEvent = this.relatedEvent;
			result.resultObject = this.resultObject;
			return result;
		}
	}
}
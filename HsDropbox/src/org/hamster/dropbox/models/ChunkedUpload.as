package org.hamster.dropbox.models
{
	/**
	 * Chunked upload object, usually you don't need to access this object,
	 * the client itself will manage all the chunked upload sessions.
	 * 
	 * @author yinzeshuo
	 */
	public class ChunkedUpload extends DropboxModelSupport
	{
		private var _uploadId:String;
		private var _offset:Number = 0;
		private var _expires:Date;
		
		public function set uploadId(value:String):void
		{
			this._uploadId = value;
		}
		
		/**
		 * The unique ID of the in-progress upload on the server. 
		 * If left blank, the server will create a new upload session.
		 */
		public function get uploadId():String
		{
			return this._uploadId;
		}
		
		public function set offset(value:Number):void
		{
			this._offset = value;
		}
		
		/**
		 * The byte offset of this chunk, relative to the beginning of the full file. 
		 * The server will verify that this matches the offset it expects. 
		 * If it does not, the server will return an error with the expected offset.
		 */
		public function get offset():Number
		{
			return this._offset;
		}
		
		public function set expires(value:Date):void
		{
			this._expires = value;
		}
		
		/**
		 * The chunked session exipred date
		 */
		public function get expires():Date
		{
			return this._expires;
		}
		
		override public function decode(result:Object):void
		{
			super.decode(result);
			
			this.uploadId = result['upload_id'];
			this.offset   = result['offset'];
			this.expires  = new Date(result['expires']);
		}
		
		override public function toString():String 
		{
			return "ChunkedUpload [upload_id=" + uploadId 
				+ ", offset=" + offset
				+ ", expires=" + expires
				+ "]";
		}
	}
}
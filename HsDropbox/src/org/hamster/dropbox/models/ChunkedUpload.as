package org.hamster.dropbox.models
{
	public class ChunkedUpload extends DropboxModelSupport
	{
		public var uploadId:String;
		public var offset:Number = 0;
		public var expires:String;
		
		override public function decode(result:Object):void
		{
			super.decode(result);
			
			this.uploadId = result['upload_id'];
			this.offset   = result['offset'];
			this.expires  = result['expires'];
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
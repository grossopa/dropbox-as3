package org.hamster.dropbox.services
{
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	
	import mx.core.ByteArrayAsset;
	
	import org.hamster.dropbox.models.ChunkedUpload;
	
	import ru.inspirit.net.MultipartURLLoader;

	public class ChunkedUploadSession extends EventDispatcher
	{
		private const chunkedUpload:ChunkedUpload = new ChunkedUpload();
		private var _data:ByteArray;
		private var _chunkedSize:Number;
		public var relatedLoader:URLLoader;
		public var url:String;
		public var fileName:String;
		public var filePathWithName:String;
		public var root:String;
		public var locale:String;
		public var overwrite:Boolean;
		public var parent_rev:String;
		public var retryCount:int;
		
		public function set uploadId(value:String):void
		{
			if (chunkedUpload.uploadId == null || chunkedUpload.uploadId == "") {
				chunkedUpload.uploadId = value;
			} else {
				throw new Error("uploadId has been set, you cannot modify it!");
			}
		}
		
		public function get uploadId():String
		{
			return chunkedUpload.uploadId;
		}
		
		public function get nextOffset():Number
		{
			return chunkedUpload.offset;
		}
		
		public function get currentOffset():Number
		{
			return nextOffset - chunkedSize;
		}
		
		public function get chunkedSize():Number
		{
			return _chunkedSize;
		}
		
		public function get expires():String
		{
			return chunkedUpload.expires;
		}
		
		public function ChunkedUploadSession(data:ByteArray, chunkedSize:Number)
		{
			this._chunkedSize = chunkedSize;
			this._data     = data;
			this._data.position = 0;
		}
		
		public function getNext():ByteArray
		{
			var result:ByteArray = new ByteArray();
			_data.position = chunkedUpload.offset;
			if (_data.bytesAvailable <= 0) {
				return null;
			}
			_data.readBytes(result, 0, 
				Math.min(_data.bytesAvailable, chunkedSize));
			chunkedUpload.offset += chunkedSize;
			return result;
		}
		
		public function retry():ByteArray
		{
			chunkedUpload.offset -= chunkedSize;
			return getNext();
		}
	}
}
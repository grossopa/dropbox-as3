package org.hamster.dropbox.models
{
	import com.adobe.utils.ArrayUtil;
	import com.hurlant.util.ArrayUtil;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ArrayUtil;
	import mx.utils.ObjectUtil;

// {"thumb_exists": false,
//	"bytes": 736, 
//	"modified": "Wed, 12 May 2010 07:28:39 +0000", 
//	"path": "/id_dsa1273649318857", 
//	"is_dir": false, 
//	"icon": "page_white", 
//	"root": "sandbox", 
//	"mime_type": "application/octet-stream",
//	"size": "736 bytes"}
	public class DropboxFile extends DropboxModelSupport
	{
		public var thumbExists:Boolean;
		public var bytes:Number;
		public var modified:Date;
		public var isDir:Boolean;
		public var icon:String;
		public var root:String;
		public var mimeType:String;
		public var size:String;
		
		public var hash:String;
		public var contents:Array;
		
		public function DropboxFile()
		{
		}
		
		override public function decode(result:Object):void
		{
			super.decode(result);
			
			this.thumbExists = String(result['thumb_exists']) == 'true';
			this.bytes = result['bytes'];
			this.modified = new Date(result['modified']);
			this.isDir = String(result['is_dir']) == 'true';
			this.icon = result['icon'];
			this.root = result['root'];
			this.mimeType = result['mime_type'];
			this.size = result['size'];
			
			this.hash = result['hash'];
			
			this.contents = new Array();
			for each (var content:Object in result['contents']) {
				var subFile:DropboxFile = new DropboxFile();
				subFile.decode(content);
				this.contents.push(subFile);
			}
		}
		
		override public function toString():String 
		{
			var s:String = "DropboxFile [bytes=" + bytes
			s	+=  ", hash=" + (hash == null ? "null" : hash) 
			s	+=  ", icon=" + (icon == null ? "null" : icon)
			s	+=  ", isDir=" + isDir == null
			s	+=  ", mimeType=" + (mimeType == null ? "null" : mimeType)
			s	+=  ", modified=" + (modified == null ? "null" : modified.toString())
			s	+=  ", root=" + (root == null ? "null" : root)
			s	+=  ", size=" + (size == null ? "null" : size)
			s	+=  ", thumbExists=" + thumbExists
			s	+=  ", contents=" + (contents == null || contents.length == 0 ? "null" : contents.join()) + "]";
			return s;
		}
	}
}
package org.hamster.dropbox.models
{
	/**
	 * either a dropbox file or a dropbox folder.
	 * 
	 * @author yinzeshuo
	 */
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
		public var path:String;
		// added in version 1
		public var rev:String;
		public var revision:String;
		public var isDeleted:Boolean;
		
		public var hash:String;
		public var contents:Array;
		
		public function DropboxFile()
		{
		}
		
		/**
		 * decode a object
		 *  
		 * @param result
		 */
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
			this.path = result['path'];
			this.rev = result['rev'];
			this.revision = result['revision'];
			this.isDeleted = result['is_deleted'];
			
			this.hash = result['hash'];
			
			this.contents = new Array();
			for each (var content:Object in result['contents']) {
				var subFile:DropboxFile = new DropboxFile();
				subFile.decode(content);
				this.contents.push(subFile);
			}
		}
		
		/**
		 * {
		 * "revision": 62966514, 
		 * "rev": "3c0caf20034507a", 
		 * "thumb_exists": true, 
		 * "bytes": 97725, 
		 * "modified": "Thu, 18 Oct 2012 08:03:08 +0000", 
		 * "client_mtime": "Thu, 18 Oct 2012 08:03:08 +0000", 
		 * "path": "/test folder/test ~`!@#$%^&()_-=+{}[];',.123\u4e2d\u6587/test ~`!@#$%^&()_-=+{}[];',.123\u4e2d\u65873.jpg", 
		 * "is_dir": false, 
		 * "icon": "page_white_picture", 
		 * "root": "dropbox", 
		 * "mime_type": "image/jpeg", 
		 * "size": "95.4 KB"}
		 */
		override public function toString():String 
		{
			var s:String = "DropboxFile [bytes=" + bytes
			s	+=  ", hash=" + (hash == null ? "null" : hash) 
			s	+=  ", rev=" + (rev == null ? "null" : rev) 
			s	+=  ", revision=" + (revision == null ? "null" : revision) 
			s	+=  ", isDeleted=" + isDeleted
			s	+=  ", icon=" + (icon == null ? "null" : icon)
			s	+=  ", isDir=" + isDir == null
			s	+=  ", mimeType=" + (mimeType == null ? "null" : mimeType)
			s	+=  ", modified=" + (modified == null ? "null" : modified.toString())
			s	+=  ", root=" + (root == null ? "null" : root)
			s	+=  ", path=" + (path == null ? "null" : path)
			s	+=  ", size=" + (size == null ? "null" : size)
			s	+=  ", thumbExists=" + thumbExists
			s	+=  ", contents=" + (contents == null || contents.length == 0 ? "null" : contents.join()) + "]";
			return s;
		}
	}
}
package org.hamster.dropbox.models
{
	/**
	 * either a dropbox file or a dropbox folder.
	 * 
	 * @author yinzeshuo
	 */
	public class DropboxFile extends DropboxModelSupport
	{
		private var _thumbExists:Boolean;
		private var _bytes:Number;
		private var _modified:Date;
		private var _clientMTime:Date;
		private var _isDir:Boolean;
		private var _icon:String;
		private var _root:String;
		private var _mimeType:String;
		private var _size:String;
		private var _path:String;
		private var _rev:String;
		private var _revision:String;
		private var _isDeleted:Boolean;
		private var _hash:String;
		private var _contents:Array;
		
		
		public function set thumbExists(value:Boolean):void
		{
			this._thumbExists = value;
		}
		
		/**
		 * True if the file is an image can be converted to a thumbnail via the /thumbnails call.
		 */
		public function get thumbExists():Boolean
		{
			return this._thumbExists;
		}
		
		public function set bytes(value:Number):void
		{
			this._bytes = value;
		}
		
		/**
		 * The file size in bytes.
		 */
		public function get bytes():Number
		{
			return this._bytes;
		}
		
		public function set modified(value:Date):void
		{
			this._modified = value;
		}
		
		/**
		 * The last time the file was modified on Dropbox, 
		 * in the standard date format (not included for the root folder).
		 */
		public function get modified():Date
		{
			return this._modified;
		}
		
		public function set clientMTime(value:Date):void
		{
			this._clientMTime = value;
		}
		
		/**
		 * For files, this is the modification time set by the desktop client 
		 * when the file was added to Dropbox, in the standard date format. 
		 * Since this time is not verified (the Dropbox server stores whatever 
		 * the desktop client sends up), this should only be used for display 
		 * purposes (such as sorting) and not, for example, to determine if
		 * a file has changed or not.
		 */
		public function get clientMTime():Date
		{
			return this._clientMTime;
		}
		
		public function set isDir(value:Boolean):void
		{
			this._isDir = value;
		}
		
		/**
		 * Whether the given entry is a folder or not.
		 */
		public function get isDir():Boolean
		{
			return this._isDir;
		}
		
		public function set icon(value:String):void
		{
			this._icon = value;
		}
		
		/**
		 * The name of the icon used to illustrate the file type in Dropbox's 
		 * <a href="https://www.dropbox.com/static/images/dropbox-api-icons.zip">icon library</a>.
		 */
		public function get icon():String
		{
			return this._icon;
		}
		
		public function set root(value:String):void
		{
			this._root = value;
		}
		
		/**
		 * The root or top-level folder depending on your 
		 * <a href="https://www.dropbox.com/developers/start/core">access level</a>. 
		 * All paths returned are relative to this root level. 
		 * Permitted values are either dropbox or app_folder.
		 */
		public function get root():String
		{
			return this._root;
		}
		
		public function set mimeType(value:String):void
		{
			this._mimeType = value;
		}
		
		/**
		 * the file mine type.
		 */
		public function get mimeType():String
		{
			return this._mimeType;
		}
		
		public function set size(value:String):void
		{
			this._size = value;
		}
		
		/**
		 * A human-readable description of the file size (translated by locale).
		 */
		public function get size():String
		{
			return this._size;
		}
		
		public function set path(value:String):void
		{
			this._path = value;
		}
		
		/**
		 * Returns the canonical path to the file or directory.
		 */
		public function get path():String
		{
			return this._path;
		}
		
		public function set rev(value:String):void
		{
			this._rev = value;
		}
		
		/**
		 * A unique identifier for the current revision of a file. 
		 * This field is the same rev as elsewhere in the API and can be 
		 * used to detect changes and avoid conflicts.
		 */
		public function get rev():String
		{
			return this._rev;
		}
		
		public function set revision(value:String):void
		{
			this._revision = value;
		}
		
		/**
		 * A deprecated field that semi-uniquely identifies a file. Use rev instead.
		 */
		public function get revision():String
		{
			return this._revision;
		}
		
		public function set isDeleted(value:Boolean):void
		{
			this._isDeleted = value;
		}
		
		/**
		 * Whether the given entry is deleted (only included if deleted files are being returned).
		 */
		public function get isDeleted():Boolean
		{
			return this._isDeleted;
		}
		
		public function set hash(value:String):void
		{
			this._hash = value;
		}
		
		/**
		 * A folder's hash is useful for indicating changes to the folder's 
		 * contents in later calls to /metadata. 
		 * This is roughly the folder equivalent to a file's rev.
		 */
		public function get hash():String
		{
			return this._hash;
		}
		
		
		public function set contents(value:Array):void
		{
			this._contents = value;
		}
		
		/**
		 * folder only, a list of metadata entries for the contents of the folder.
		 */
		public function get contents():Array
		{
			return this._contents;
		}
		
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
			this.clientMTime = result['client_mtime'] == null ? null : new Date(result['client_mtime']);
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
		
		override public function toString():String 
		{
			var s:String = "DropboxFile [bytes=" + bytes
			s	+=  ", hash=" + (hash == null ? "null" : hash) 
			s	+=  ", rev=" + (rev == null ? "null" : rev) 
			s	+=  ", revision=" + (revision == null ? "null" : revision) 
			s	+=  ", isDeleted=" + isDeleted
			s	+=  ", icon=" + (icon == null ? "null" : icon)
			s	+=  ", isDir=" + isDir
			s	+=  ", mimeType=" + (mimeType == null ? "null" : mimeType)
			s	+=  ", modified=" + (modified == null ? "null" : modified.toString())
			s	+=  ", modified=" + (clientMTime == null ? "null" : clientMTime.toString())
			s	+=  ", root=" + (root == null ? "null" : root)
			s	+=  ", path=" + (path == null ? "null" : path)
			s	+=  ", size=" + (size == null ? "null" : size)
			s	+=  ", thumbExists=" + thumbExists
			s	+=  ", contents=" + (contents == null || contents.length == 0 ? "null" : contents.join()) + "]";
			return s;
		}
	}
}
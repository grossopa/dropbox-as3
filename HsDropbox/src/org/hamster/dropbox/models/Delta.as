package org.hamster.dropbox.models
{
	/**
	 * Delta
	 *  
	 * @author yinzeshuo
	 * 
	 */
	public class Delta extends DropboxModelSupport
	{
		private var _entries:Array;
		private var _reset:Boolean;
		private var _cursor:String;
		private var _has_more:Boolean;
		
		public function set entries(value:Array):void
		{
			this._entries = value;
		}
		
		/**
		 * Each delta entry is a 2-item list of one of the following forms:
		 * <li>
		 * [&lt;path&gt;, &lt;metadata&gt;] - Indicates that there is a file/folder at the given path. 
		 * You should add the entry to your local path. The metadata value is the same as what would 
		 * be returned by the /metadata call, except folder metadata doesn't have hash or contents fields. 
		 * To correctly process delta entries:<br />
		 * &#160;&#160;If the new entry includes parent folders that don't yet exist in your local state, 
		 * create those parent folders in your local state.<br />
		 * &#160;&#160;If the new entry is a file, replace whatever your local state has at path with 
		 * the new entry.<br />
		 * &#160;&#160;If the new entry is a folder, check what your local state has at &lt;path&gt;. 
		 * If it's a file, replace it with the new entry. If it's a folder, 
		 * apply the new &lt;metadata&gt; to the folder, but do not modify the folder's children.<br />
		 * </li>
		 * <li>[&lt;path&gt;, null] - Indicates that there is no file/folder at the given path.
		 * To update your local state to match, anything at path and all its children 
		 * should be deleted. Deleting a folder in your Dropbox will sometimes send down 
		 * a single deleted entry for that folder, and sometimes separate entries for 
		 * the folder and all child paths. 
		 * If your local state doesn't have anything at path, ignore this entry.
		 * </li>
		 * <p>Note: Dropbox treats file names in a case-insensitive but case-preserving way. 
		 * To facilitate this, the &lt;path&gt; values above are lower-cased versions of 
		 * the actual path. The &lt;metadata&gt; value has the original case-preserved path.</p>
		 */
		public function get entries():Array
		{
			return this._entries;
		}
		
		public function set reset(value:Boolean):void
		{
			this._reset = value;
		}
		
		/**
		 * If true, clear your local state before processing the delta entries. 
		 * reset is always true on the initial call to /delta (i.e. when no cursor is passed in).
		 * Otherwise, it is true in rare situations, such as after server or account maintenance,
		 * or if a user deletes their app folder.
		 */
		public function get reset():Boolean
		{
			return this._reset;
		}
		
		public function set cursor(value:String):void
		{
			this._cursor = value;
		}
		
		/**
		 * A string that encodes the latest information that has been returned. 
		 * On the next call to /delta, pass in this value.
		 */
		public function get cursor():String
		{
			return this._cursor;
		}
		
		public function set has_more(value:Boolean):void
		{
			this._has_more = value;
		}
		
		/**
		 * If true, then there are more entries available; 
		 * you can call /delta again immediately to retrieve those entries. 
		 * If 'false', then wait for at least five minutes (preferably longer) before checking again.
		 */
		public function get has_more():Boolean
		{
			return this._has_more;
		}
		
		
		public function Delta()
		{
			super();
		}
		
		override public function decode(result:Object):void
		{
			super.decode(result);
			
			this.entries = new Array();
			
			var e:Array = result['entries'],
				n:int = e.length, i:int = 0, f:DropboxFile;
			for (i; i < n; i++) {
				f = new DropboxFile();
				if (e[i][1] != null) {
					f.decode(e[i][1]);
				} else {
					f.path = e[i][0];
					f.isDeleted = true;
				}
				entries.push(f);
			}
			
			this.reset = result['reset'];
			this.cursor = result['cursor'];
			this.has_more = result['has_more'];
		}
		
		override public function toString():String 
		{
			return "Delta [entries=" + entries 
				+ ", reset=" + reset
				+ ", cursor=" + cursor
				+ ", has_more=" + has_more
				+ "]";
		}
		
	}
}
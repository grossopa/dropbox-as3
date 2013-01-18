package org.hamster.dropbox.models
{
	/**
	 * CopyRef
	 *  
	 * @author yinzeshuo
	 */
	public class CopyRef extends DropboxModelSupport
	{
		private var _copy_ref:String;
		private var _expires:Date;
		
		public function set copy_ref(value:String):void
		{
			this._copy_ref = value;
		}
		
		/**
		 * The copy_ref to the specified file. 
		 */
		public function get copy_ref():String
		{
			return this._copy_ref;
		}
		
		public function set expires(value:Date):void
		{
			this._expires = value;
		}
		
		/**
		 * Expired date of the copy_ref.
		 */
		public function get expires():Date
		{
			return this._expires;
		}
		
		
		public function CopyRef()
		{
			super();
		}
		
		override public function decode(result:Object):void
		{
			super.decode(result);
			
			this.copy_ref = result['copy_ref'];
			this.expires = new Date(result['expires']);
		}
		
		override public function toString():String 
		{
			return "Delta [copy_ref=" + copy_ref 
				+ ", expires=" + expires
				+ "]";
		}
		
	}
}
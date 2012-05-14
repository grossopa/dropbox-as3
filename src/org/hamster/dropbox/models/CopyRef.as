package org.hamster.dropbox.models
{
	/**
	 * CopyRef
	 *  
	 * @author yinzeshuo
	 * 
	 */
	public class CopyRef extends DropboxModelSupport
	{
		public var copy_ref:String;
		public var expires:String;
		
		
		public function CopyRef()
		{
			super();
		}
		
		override public function decode(result:Object):void
		{
			super.decode(result);
			
			this.copy_ref = result['copy_ref'];
			this.expires = result['expires'];
		}
		
		override public function toString():String 
		{
			return "Delta [copy_ref=" + copy_ref 
				+ ", expires=" + expires
				+ "]";
		}
		
	}
}
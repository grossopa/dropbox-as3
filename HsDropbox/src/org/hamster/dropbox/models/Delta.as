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
		public var entries:Array;
		public var reset:Boolean;
		public var cursor:String;
		public var has_more:Boolean;
		
		
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
			for(i;i<n;i++){
				f = new DropboxFile();
				f.decode( e[i][1] );
				entries.push( f );
			}
			//for(i;i<n;i++)
			//	entries.push( DropboxFile.get( e[i][1] ) );
			
			this.reset = result['reset']=="true";
			this.cursor = result['cursor'];
			this.has_more = result['has_more']=="true";
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
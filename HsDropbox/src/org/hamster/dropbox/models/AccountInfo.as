package org.hamster.dropbox.models
{
	import mx.utils.ObjectUtil;

	public class AccountInfo extends DropboxModelSupport
	{
		[Bindable] public var uid:int;
		[Bindable] public var country:String;
		[Bindable] public var displayName:String;
		[Bindable] public var quotaInfo_shared:Number;
		[Bindable] public var quotaInfo_quota:Number;
		[Bindable] public var quotaInfo_normal:Number;
		
		public function AccountInfo()
		{
			super();
		}
		
		override public function decode(result:Object):void
		{
			super.decode(result);
			
			this.uid = result['uid'];
			this.country = result['country'];
			this.displayName = result['display_name'];
			var quotaInfo:Object = result['quota_info'];
			this.quotaInfo_normal = quotaInfo['normal'];
			this.quotaInfo_quota = quotaInfo['quota'];
			this.quotaInfo_shared = quotaInfo['shared'];
		}
		
		override public function toString():String 
		{
			return "AccountInfo [country=" + country + ", displayName="
				+ displayName + ", quotaInfo_normal=" + quotaInfo_normal
				+ ", quotaInfo_quota=" + quotaInfo_quota
				+ ", quotaInfo_shared=" + quotaInfo_shared + ", uid=" + uid
				+ "]";
		}
		
	}
}
package org.hamster.dropbox.models
{
	/**
	 * Account information of a user.
	 *  
	 * @author yinzeshuo
	 * 
	 */
	public class AccountInfo extends DropboxModelSupport
	{
		public var uid:int;
		public var country:String;
		public var displayName:String;
		public var quotaInfo_shared:Number;
		public var quotaInfo_quota:Number;
		public var quotaInfo_normal:Number;
		
		// added in version 1
		public var referral_link:String;
		public var email:String;
		
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
			this.referral_link = result['referral_link'];
			this.email = result['email'];
		}
		
		override public function toString():String 
		{
			return "AccountInfo [referral_link=" + referral_link 
				+ ", email=" + email
				+ ", country=" + country
				+ ", displayName=" + displayName 
				+ ", quotaInfo_normal=" + quotaInfo_normal
				+ ", quotaInfo_quota=" + quotaInfo_quota
				+ ", quotaInfo_shared=" + quotaInfo_shared + ", uid=" + uid
				+ "]";
		}
		
	}
}
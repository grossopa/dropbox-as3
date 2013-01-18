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
		private var _uid:int;
		private var _country:String;
		private var _displayName:String;
		private var _quotaInfo_shared:Number;
		private var _quotaInfo_quota:Number;
		private var _quotaInfo_normal:Number;
		private var _referral_link:String;
		private var _email:String;
		
		public function set uid(value:int):void
		{
			this._uid = value;
		}
		
		/**
		 * The user's unique Dropbox ID.
		 */
		public function get uid():int
		{
			return this._uid;
		}
		
		public function set country(value:String):void
		{
			this._country = value;
		}
		
		/**
		 * The user's two-letter country code, if available.
		 */
		public function get country():String
		{
			return this._country;
		}
		
		public function set displayName(value:String):void
		{
			this._displayName = value;
		}
		
		/**
		 * The user's display name.
		 */
		public function get displayName():String
		{
			return this._displayName;
		}
		
		public function set quotaInfo_shared(value:Number):void
		{
			this._quotaInfo_shared = value;
		}
		
		/**
		 * The user's used quota in shared folders (bytes).
		 */
		public function get quotaInfo_shared():Number
		{
			return this._quotaInfo_shared;
		}
		
		public function set quotaInfo_quota(value:Number):void
		{
			this._quotaInfo_quota = value;
		}
		
		/**
		 * The user's total quota allocation (bytes).
		 */
		public function get quotaInfo_quota():Number
		{
			return this._quotaInfo_quota;
		}
		
		public function set quotaInfo_normal(value:Number):void
		{
			this._quotaInfo_normal = value;
		}
		
		/**
		 * The user's used quota outside of shared folders (bytes).
		 */
		public function get quotaInfo_normal():Number
		{
			return this._quotaInfo_normal;
		}
		
		public function set referral_link(value:String):void
		{
			this._referral_link = value;
		}
		
		/**
		 * The user's referral link.
		 */
		public function get referral_link():String
		{
			return this._referral_link;
		}
		
		public function set email(value:String):void
		{
			this._email = value;
		}
		
		/**
		 * The user's email.
		 */
		public function get email():String
		{
			return this._email;
		}
		
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
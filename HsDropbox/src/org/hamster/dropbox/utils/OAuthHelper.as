package org.hamster.dropbox.utils
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.hash.HMAC;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import mx.utils.ObjectUtil;
	import mx.utils.UIDUtil;

	public class OAuthHelper
	{
		public function OAuthHelper()
		{
		}
		
		public static function buildURLRequestHeader(url:String, 
													 params:Object, 
													 consumerKey:String,
													 consumerSecret:String,
													 tokenKey:String = null,
													 tokenSecret:String = null,
													 httpMethod:String = URLRequestMethod.GET,
													 headerRealm:String = "",
													 signMethod:String = "HMAC-SHA1"):URLRequestHeader
		{
			var builtParams:Object = buildParams(url, params, 
				consumerKey, consumerSecret, tokenKey, tokenSecret, httpMethod, signMethod);
			var data:String = "";
			
			data += "OAuth "
			if (headerRealm != null && headerRealm.length > 0) {
				data += "realm=\"" + headerRealm + "\"";
			}
			
			var firstTime:Boolean = false;
			for (var param:Object in builtParams) {
				// if this is an oauth param, include it
				if (param.toString().indexOf("oauth") == 0) {
					if (firstTime == false) {
						firstTime = true;
					} else {
						data += ",";
					}
					var paramValue:String = encodeURIComponent(builtParams[param]);
					if (paramValue == null) {
						paramValue = "";
					}
					data += param + "=\"" + paramValue + "\"";
				}
			}
			
			return new URLRequestHeader("Authorization", data);
		}
		
		/**
		 * a refactor function from org.iotashan.oauth.OAuthRequest
		 *  
		 * @param url
		 * @param params
		 * @return 
		 * 
		 */
		public static function buildParams(url:String, 
										   params:Object, 
										   consumerKey:String,
										   consumerSecret:String,
										   tokenKey:String = null,
										   tokenSecret:String = null,
										   httpMethod:String = URLRequestMethod.GET,
										   signMethod:String = "HMAC-SHA1"):Object
		{
			var result:Object = ObjectUtil.copy(params);
			
			if (result == null) {
				result = new Object();
			}
			
			var curDate:Date = new Date();
			var uuid:String = UIDUtil.getUID(curDate);
			
			// first, let's add the oauth required params
			result["oauth_nonce"] = uuid;
			result["oauth_timestamp"] = String(curDate.time).substring(0, 10);
			result["oauth_consumer_key"] = consumerKey;
			result["oauth_signature_method"] = signMethod;
			
			// if there already is a token, add that too
			if (tokenKey) {
				result["oauth_token"] = tokenKey;
			}
			
			// generate the signature
			var signature:String = "";
			if (signMethod == "HMAC-SHA1") {
				signature = sign_HMAC_SHA1(url, result, consumerSecret, tokenSecret, httpMethod);
			} else if (signMethod == "PLAINTEXT") {
				signature = sign_PLAINTEXT(url, result, consumerSecret, tokenSecret, httpMethod);
			} else {
				throw new Error('sign method ' + signMethod + ' is not supported.');
			}
			result["oauth_signature"] = signature;
			
			return result;
		}
		
		public static function sign_HMAC_SHA1(url:String, 
											  params:Object, 
											  consumerSecret:String,
											  tokenSecret:String = "",
											  httpMethod:String = URLRequestMethod.GET):String
		{
			// get signable string
			var toBeSigned:String = getSignableString(url, params, httpMethod);
			
			// get the secrets to encrypt with
			var sSec:String = encodeURIComponent(consumerSecret) + "&"
			if (tokenSecret != null && tokenSecret.length > 0) {
				sSec += encodeURIComponent(tokenSecret);
			}
			// hash them
			var hmac:HMAC = Crypto.getHMAC("sha1");
			var key:ByteArray = Hex.toArray(Hex.fromString(sSec));
			var message:ByteArray = Hex.toArray(Hex.fromString(toBeSigned));
			var result:ByteArray = hmac.compute(key,message);
			var ret:String = Base64.encodeByteArray(result);
			
			return ret;
		}
		
		public static function sign_PLAINTEXT(url:String, 
											  params:Object, 
											  consumerSecret:String,
											  tokenSecret:String = "",
											  httpMethod:String = URLRequestMethod.GET):String
		{
			// get signable string
			var toBeSigned:String = getSignableString(url, params, httpMethod);
			var sSec:String = consumerSecret + "&";
			if (tokenSecret) {
				sSec += tokenSecret;
			}
			return sSec;
		}
		
		public static function getSignableString(url:String, 
			params:Object, httpMethod:String):String
		{
			var ret:String = encodeURIComponent(httpMethod.toUpperCase());
			ret += "&";
			ret += encodeURIComponent(url);
			ret += "&";
			
			var aParams:Array = new Array();
			// loop over params, find the ones we need
			for (var param:String in params) {
				if (param != "oauth_signature") {
					aParams.push(param + "=" + encodeURIComponent(params[param].toString()));
				}
			}
			// put them in the right order
			aParams.sort();
			
			// return them like a querystring
			ret += encodeURIComponent(aParams.join("&"));
			return ret;
		}
		
		/**
		 *
		 * @param tokenResponse Result from a getRequest/AccessToken call.
		 * @return OAuthToken containing key/secret of the token request response.
		 *
		 * Inspired by http://github.com/sekimura/as3-misc/blob/master/twitter-oauth/test2.mxml
		 *
		 */
		public static function getTokenFromResponse(tokenResponse:String):Object {
			var result:Object = new Object();
			var params:Array = tokenResponse.split("&");
			for each (var param:String in params ) {
				var paramNameValue:Array = param.split("=");
				if ( paramNameValue.length == 2 ) {
					if ( paramNameValue[0] == "oauth_token" ) {
						result.key = paramNameValue[1];
					} else if ( paramNameValue[0] == "oauth_token_secret" ) {
						result.secret = paramNameValue[1];
					}
				}
			}
			
			// check if key and secret are set otherwise return null
			if ( result.key != null && result.secret != null ) {
				return result;
			}
			return null;
		}
	}
}
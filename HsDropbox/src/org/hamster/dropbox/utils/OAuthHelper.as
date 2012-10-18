package org.hamster.dropbox.utils
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.hash.HMAC;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import org.hamster.dropbox.DropboxClient;
	
	/**
	 * a refactor util class from org.iotashan.oauth.OAuthRequest
	 * 
	 * @author yinzeshuo
	 * 
	 */
	public class OAuthHelper
	{
		public static const CHARACTER_ENCODING_MAPPING:Array = [
			{charFrom : '#', charTo : '%23'},
			{charFrom : '$', charTo : '%24'},
			{charFrom : '(', charTo : '%28'},
			{charFrom : ')', charTo : '%29'},
			{charFrom : "'", charTo : '%27'},
			{charFrom : "@", charTo : '%40'},
			{charFrom : "+", charTo : '%2B'},
			{charFrom : "!", charTo : '%21'},
			{charFrom : "`", charTo : '%60'},
			{charFrom : "^", charTo : '%5E'},
			{charFrom : "&", charTo : '%26'},
			{charFrom : "=", charTo : '%3D'},
			{charFrom : "+", charTo : '%2B'},
			{charFrom : "{", charTo : '%7B'},
			{charFrom : "}", charTo : '%7D'},
			{charFrom : "[", charTo : '%5B'},
			{charFrom : "]", charTo : '%5D'},
			{charFrom : ";", charTo : '%3B'},
			{charFrom : ",", charTo : '%2C'},
		];
		
		
		public function OAuthHelper()
		{
		}
		
		/**
		 * Build a OAuth Request header.
		 *  
		 * @param url the target URL, should not contain parameters like ?a=b&c=d
		 * @param params parameters used in GET or POST methods.
		 * @param consumerKey consumer key provided by Web Service.
		 * @param consumerSecret consumer secret of consumer key
		 * @param tokenKey can be either access token key or request token key
		 * @param tokenSecret can be either access token secret or request token secret
		 * @param httpMethod
		 * @param headerRealm
		 * @param signMethod can be either PLAINTEXT or HMAC-SHA1
		 * @return 
		 * 
		 */
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
			// build parameters object first
			var builtParams:Object = buildParams(url, params, 
				consumerKey, consumerSecret, tokenKey, tokenSecret, httpMethod, signMethod);
			
			// format to string
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
			// return URLRequestHeader
			return new URLRequestHeader("Authorization", data);
		}
		
		/**
		 * build parameter object
		 * 
		 * @param url
		 * @param params
		 * @param consumerKey
		 * @param consumerSecret
		 * @param tokenKey
		 * @param tokenSecret
		 * @param httpMethod
		 * @param signMethod
		 * @return parameters object
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
			var result:Object = objectUtilCopy(params);
			
			if (result == null) {
				result = new Object();
			}
			
			var curDate:Date = new Date();
			var uuid:String = uidUtilCreateUID();
			
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
		
		/**
		 * sign request by HMAC-SHA1
		 *  
		 * @param url
		 * @param params
		 * @param consumerSecret
		 * @param tokenSecret
		 * @param httpMethod
		 * @return signed string
		 */
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
		
		/**
		 * sign request by PLAINTEXT
		 * 
		 * @param url
		 * @param params
		 * @param consumerSecret
		 * @param tokenSecret
		 * @param httpMethod
		 * @return signed string
		 * 
		 */
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
					aParams.push(param + "=" + encodeURICharacter(params[param].toString()).split('/').join('%2F'));
				}
			}
			// put them in the right order
			aParams.sort();
			
			// return them like a querystring
			ret += encodeURIComponent(aParams.join("&"));
			return ret;
		}
		
		public static function encodeURL(url:String):String
		{
			return encodeURICharacter(url).split('~').join('%7E');
		}
		
		
		public static function encodeURICharacter(url:String):String
		{
			var paths:Array = url.split('/');
			for (var i:int = 0; i < paths.length; i++) {
				var str:String = encodeURI(paths[i]);
				for each (var charObj:Object in CHARACTER_ENCODING_MAPPING) {
					str = str.split(charObj.charFrom).join(charObj.charTo);
				}
				paths[i] = str;
			}
			return paths.join('/');
		}
		
		public static function getProtocol(url:String):String
		{
			var slash:int = url.indexOf("/");
			var indx:int = url.indexOf(":/");
			if (indx > -1 && indx < slash)
			{
				return url.substring(0, indx);
			}
			else
			{
				indx = url.indexOf("::");
				if (indx > -1 && indx < slash)
					return url.substring(0, indx);
			}
			
			return "";
		}
		
		public static function objectUtilCopy(value:Object):Object
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeObject(value);
			buffer.position = 0;
			var result:Object = buffer.readObject();
			return result;
		}
		
		private static const ALPHA_CHAR_CODES:Array = [48, 49, 50, 51, 52, 53, 54, 
			55, 56, 57, 65, 66, 67, 68, 69, 70];
		private static function uidUtilCreateUID():String
		{
			var uid:Array = new Array(36);
			var index:int = 0;
			
			var i:int;
			var j:int;
			
			for (i = 0; i < 8; i++)
			{
				uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() *  16)];
			}
			
			for (i = 0; i < 3; i++)
			{
				uid[index++] = 45; // charCode for "-"
				
				for (j = 0; j < 4; j++)
				{
					uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() *  16)];
				}
			}
			
			uid[index++] = 45; // charCode for "-"
			
			var time:Number = new Date().time;
			// Note: time is the number of milliseconds since 1970,
			// which is currently more than one trillion.
			// We use the low 8 hex digits of this number in the UID.
			// Just in case the system clock has been reset to
			// Jan 1-4, 1970 (in which case this number could have only
			// 1-7 hex digits), we pad on the left with 7 zeros
			// before taking the low digits.
			var timeString:String = ("0000000" + time.toString(16).toUpperCase()).substr(-8);
			
			for (i = 0; i < 8; i++)
			{
				uid[index++] = timeString.charCodeAt(i);
			}
			
			for (i = 0; i < 4; i++)
			{
				uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() *  16)];
			}
			
			return String.fromCharCode.apply(null, uid);
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
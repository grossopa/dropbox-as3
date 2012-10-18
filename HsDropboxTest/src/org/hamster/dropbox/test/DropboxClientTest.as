package org.hamster.dropbox.test
{
	import com.adobe.images.JPGEncoder;
	
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.async.Async;
	import org.fluint.sequence.SequenceCaller;
	import org.fluint.sequence.SequenceRunner;
	import org.fluint.sequence.SequenceSetter;
	import org.fluint.sequence.SequenceWaiter;
	import org.hamster.dropbox.DropboxClient;
	import org.hamster.dropbox.DropboxConfig;
	import org.hamster.dropbox.DropboxEvent;
	import org.hamster.dropbox.models.AccountInfo;
	import org.hamster.dropbox.models.CopyRef;
	import org.hamster.dropbox.models.Delta;
	import org.hamster.dropbox.models.DropboxFile;
	import org.hamster.dropbox.models.SharesInfo;
	
	public class DropboxClientTest
	{
		private var consumerKey:String         = "xs1b9kygh7gz96v";
		private var consumerSecret:String      = "fsg0iv0hqyh02yd";
		private var requestTokenKey:String     = "8ntx6hhyuxg9cfv";
		private var requestTokenSecret:String  = "sc5ic82mhjncv7u";
		private var accessTokenKey:String      = "m11tpfwi1d87q6d";
		private var accessTokenSecret:String   = "niewgnxsvgdof8e";
		
		protected var dropboxConfig:DropboxConfig;
		protected var dropboxClient:DropboxClient;
		
		[Embed(source='test.jpg')]
		public static var TEST_IMAGE:Class;
		
		public static const DEFAULT_TIMEOUT:Number = 30000;
		/**
		 * < (less than)
		 * > (greater than)
		 * : (colon)
		 * " (double quote)
		 * / (forward slash)
		 * \ (backslash)
		 * | (vertical bar or pipe)
		 * ? (question mark)
		 * * (asterisk)  `!@#$%^&()_-=+{}[];',.
		 */
		public static const ROOT_FOLDER:String = "test folder";
		public static const FOLDER:String   = ROOT_FOLDER + "/test ~`!@#$%^&()_-=+{}[];',.123中文";
		public static const FILE:String     = "test ~`!@#$%^&()_-=+{}[];',.123中文.txt";
		public static const FILE_2:String   = "test ~`!@#$%^&()_-=+{}[];',.123中文2.txt";
		public static const FILE_3:String   = "test ~`!@#$%^&()_-=+{}[];',.123中文3.txt";
		public static const FILE_IMAGE:String   = "test ~`!@#$%^&()_-=+{}[];',.123中文3.jpg";
		public static const FOLDER_FILE:String = FOLDER + "/" + FILE;
		public static const FOLDER_FILE_2:String = FOLDER + "/" + FILE_2;
		public static const FOLDER_FILE_3:String = FOLDER + "/" + FILE_3;
		public static const FOLDER_IMAGE:String = FOLDER + "/" + FILE_IMAGE;
		public static const uploadContent:ByteArray = new ByteArray();
		public static var uploadContentImage:ByteArray = new ByteArray();
		public static var lastDropboxFile:DropboxFile;
		
		[Before]
		public function setUp():void
		{
			uploadContent.writeUTF("Abcdefghijklmnopqrstuvwxyz!@#$%^&*()_+1234567890-=");
			var quality:int = 100;
			var jpg:JPGEncoder = new JPGEncoder(quality);
			var bitmap:Bitmap = new TEST_IMAGE();
			uploadContentImage = jpg.encode(bitmap.bitmapData);
			
			dropboxConfig = new DropboxConfig(
				consumerKey,     consumerSecret, 
				requestTokenKey, requestTokenSecret, 
				accessTokenKey,  accessTokenSecret);
			dropboxClient = new DropboxClient(dropboxConfig);
			
			dropboxClient.addEventListener(DropboxEvent.ACCESS_TOKEN_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.ACCOUNT_CREATE_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.ACCOUNT_INFO_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.COPY_REF_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.DELTA_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.FILE_COPY_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.FILE_CREATE_FOLDER_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.FILE_DELETE_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.FILE_MOVE_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.GET_FILE_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.MEDIA_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.METADATA_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.PUT_FILE_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.REQUEST_TOKEN_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.REVISION_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.RESTORE_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.SEARCH_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.SHARES_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.THUMBNAILS_FAULT, faultHandler);
			dropboxClient.addEventListener(DropboxEvent.TOKEN_FAULT, faultHandler);
			
			Assert.assertNotNull(dropboxClient.config.consumerKey, dropboxClient.config.consumerSecret);
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		/************************************************
		 ** Following is the authentication test cases **
		 ************************************************/
		[Test(async, order=1)]
		public function testRequestToken():void
		{
			if (requestTokenKey == null || requestTokenSecret == null) {
				dropboxClient.addEventListener(DropboxEvent.REQUEST_TOKEN_RESULT, 
					Async.asyncHandler(this, 
						function (event:DropboxEvent, passThroughData:Object):void
						{
							Assert.assertNotNull(dropboxConfig.requestTokenKey, dropboxConfig.requestTokenSecret);
							resultHandler(event, null);
						}
						, DEFAULT_TIMEOUT));
				dropboxClient.requestToken();
			} else {
				trace ("Skipping testRequestToken because requestToken has already been set");
			}
		}
		
		[Test(async, order=2)]
		public function testAccessToken():void
		{
			if (accessTokenKey == null || accessTokenSecret == null) {
				dropboxClient.addEventListener(DropboxEvent.ACCESS_TOKEN_RESULT, 
					Async.asyncHandler(this, 
						function (event:DropboxEvent, passThroughData:Object):void
						{
							Assert.assertNotNull(dropboxConfig.accessTokenKey, dropboxConfig.accessTokenSecret);
							resultHandler(event, null);
						}
						, DEFAULT_TIMEOUT));
				dropboxClient.accessToken();
			} else {
				trace ("Skipping testAccessToken because accessToken has already been set");
			}
		}
		
		[Test(async, order=3)]
		public function testAccountInfo():void
		{
			dropboxClient.addEventListener(DropboxEvent.ACCOUNT_INFO_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT, {clazz: AccountInfo}));
			dropboxClient.accountInfo();
		}
		
		/************************************************
		 ** Following is the api test cases            **
		 ************************************************/
		[Test(async, order=10)]
		public function testFileCreateFolder():void
		{
			dropboxClient.addEventListener(DropboxEvent.FILE_CREATE_FOLDER_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT, {clazz: DropboxFile}));
			dropboxClient.fileCreateFolder(FOLDER);
		}
		
		[Test(async, order=11)]
		public function testMetadata_getFolder():void
		{
			dropboxClient.addEventListener(DropboxEvent.METADATA_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT, {clazz: DropboxFile}));
			dropboxClient.metadata(FOLDER, 10,"", true);
		}
		
		[Test(async, order=12)]
		public function testPutFile():void
		{
			dropboxClient.addEventListener(DropboxEvent.PUT_FILE_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT, null));
			dropboxClient.putFile(FOLDER, FILE, uploadContent);
		}
		
			
		[Test(async, order=13)]
		public function testGetFile_getFile():void
		{
			dropboxClient.addEventListener(DropboxEvent.METADATA_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT, {clazz: DropboxFile}));
			dropboxClient.metadata(FOLDER_FILE, 0, "", false);
		}
		
		[Test(async, order=14)]
		public function testFileCopy():void
		{
			dropboxClient.addEventListener(DropboxEvent.FILE_COPY_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT, {clazz: DropboxFile}));
			dropboxClient.fileCopy(FOLDER_FILE, FOLDER_FILE_2);
		}
		
		[Test(async, order=15)]
		public function testFileMove():void
		{
			dropboxClient.addEventListener(DropboxEvent.FILE_MOVE_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT, {clazz: DropboxFile}));
			dropboxClient.fileMove(FOLDER_FILE_2, FOLDER_FILE_3);
		}
		
		[Test(async, order=16)]
		public function testDeleteFile():void
		{
			dropboxClient.addEventListener(DropboxEvent.FILE_DELETE_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT, {clazz: DropboxFile}));
			dropboxClient.fileDelete(FOLDER_FILE_3);
		}
		
		[Test(async, order=17)]
		public function testMetadata_deletedFile():void
		{
			dropboxClient.addEventListener(DropboxEvent.METADATA_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT, {clazz: DropboxFile}));
			dropboxClient.metadata(FOLDER_FILE_3, 0, "", false, true);
		}
		
		[Test(async, order=18)]
		public function testRestore():void
		{
			dropboxClient.addEventListener(DropboxEvent.RESTORE_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT, {clazz: DropboxFile}));
			dropboxClient.restore(FOLDER_FILE_3, lastDropboxFile.rev);
		}
		
		[Test(async, order=20)]
		public function testSearch():void
		{
			dropboxClient.addEventListener(DropboxEvent.SEARCH_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT, {clazz: Array}));
			dropboxClient.search(FOLDER, "1");
		}
		
		[Test(async, order=21)]
		public function testRevisions():void
		{
			dropboxClient.addEventListener(DropboxEvent.REVISION_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT, {clazz: Array}));
			dropboxClient.revisions(FOLDER_FILE);
		}
		
		[Test(async, order=22)]
		public function testPutFile_putImage():void
		{
			dropboxClient.addEventListener(DropboxEvent.PUT_FILE_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT));
			dropboxClient.putFile(FOLDER, FILE_IMAGE, uploadContentImage);
		}
		
		[Test(async, order=23)]
		public function testThumbnails():void
		{
			dropboxClient.addEventListener(DropboxEvent.THUMBNAILS_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT, {clazz: Array}));
			dropboxClient.thumbnails(FOLDER_IMAGE, "medium");
		}
		
		[Test(async, order=24)]
		public function testShares():void
		{
			dropboxClient.addEventListener(DropboxEvent.SHARES_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT, {clazz: SharesInfo}));
			dropboxClient.shares(FOLDER_IMAGE);
		}

		
		[Test(async, order=25)]
		public function testCopyRef():void
		{
			dropboxClient.addEventListener(DropboxEvent.COPY_REF_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT, {clazz: CopyRef}));
			dropboxClient.copyRef(FOLDER_FILE);
		}
		[Test(async, order=26)]
		public function testDelta():void
		{
			dropboxClient.addEventListener(DropboxEvent.DELTA_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT, {clazz: Delta}));
			dropboxClient.delta();
		}
		
		[Test(async, order=27)]
		public function testMedia():void
		{
			dropboxClient.addEventListener(DropboxEvent.MEDIA_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT, {clazz: SharesInfo}));
			dropboxClient.media(FOLDER_IMAGE);
		}
		
		[Test(async, order=99)]
		public function testDeleteFile_clean():void
		{
			dropboxClient.addEventListener(DropboxEvent.FILE_DELETE_RESULT, 
				Async.asyncHandler(this, resultHandler, DEFAULT_TIMEOUT, {clazz: DropboxFile}));
			dropboxClient.fileDelete(ROOT_FOLDER);
		}


//		
//		[Test]
//		public function testCreateAccount():void
//		{
//			Assert.fail("Test method Not yet implemented");
//		}
//		
//		
//		
//		
//		
//		
//		

//		
//		
//		
//		
		public function resultHandler(event:DropboxEvent, passThroughData:Object):void
		{
			if (passThroughData) {
				var targetClass:Class = passThroughData.clazz;
				if (targetClass) {
					Assert.assertTrue(event.resultObject is targetClass);
				}
			}
			trace ("Success : " + event.type + " " + event.resultObject);
			if (event.resultObject is DropboxFile) {
				lastDropboxFile = event.resultObject as DropboxFile;
			}
		}
		
		public function faultHandler(event:DropboxEvent):void
		{
			trace ("Error   : " + event.type + " " + event.resultObject);
		}
	}
}
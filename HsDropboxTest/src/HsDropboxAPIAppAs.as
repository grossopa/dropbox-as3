import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.FileReference;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.ByteArray;

import mx.controls.Alert;

import org.hamster.dropbox.DropboxClient;
import org.hamster.dropbox.DropboxConfig;
import org.hamster.dropbox.DropboxEvent;
import org.hamster.dropbox.models.AccountInfo;
import org.hamster.dropbox.models.CopyRef;
import org.hamster.dropbox.models.Delta;
import org.hamster.dropbox.models.DropboxFile;

[Bindable] public var dropAPI:DropboxClient;
public static const FOLDER:String = "test test/bb#$()+%\'\'asdf";
public static const FILE_NAME:String = "aa#$()+%\'\'asdf.txt";
//public static const FOLDER:String = "test test/bb";
//public static const FILE_NAME:String = "#asdf.txt";
public static const FILE_NAME_WITH_PATH:String = FOLDER + '/' + FILE_NAME;

public function appCompleteHandler():void
{
	var config:DropboxConfig = new DropboxConfig('', '');
	//config.setConsumer();
//	config.setRequestToken('', '');
	config.setAccessToken('', '');
	dropAPI = new DropboxClient(config);
	
	if (config.accessTokenKey && config.accessTokenSecret) {
		loginedAPIContainer.enabled = true;
	}
}

public function createAccount():void
{
	dropAPI.createAccount('yourtestemailhere@gmail.com', '123abc', 'a', 'b');
	var handler:Function = function (evt:DropboxEvent):void
	{
		dropAPI.removeEventListener(DropboxEvent.ACCOUNT_CREATE_RESULT, handler);
	}
	dropAPI.addEventListener(DropboxEvent.ACCOUNT_CREATE_RESULT, handler);
	if (!dropAPI.hasEventListener(DropboxEvent.ACCOUNT_CREATE_FAULT)) {
		dropAPI.addEventListener(DropboxEvent.ACCOUNT_CREATE_FAULT, faultHandler);
	}
}

public function getRequestToken():void
{
	dropAPI.requestToken();
	var handler:Function = function (evt:DropboxEvent):void
	{
		dropAPI.removeEventListener(DropboxEvent.REQUEST_TOKEN_RESULT, handler);
		var obj:Object = evt.resultObject;
		reqTokenKeyLabel.text = obj.key;
		reqTokenSecretLabel.text = obj.secret;
		// goto authorization web page to authorize, after that, call get access token 
		if (oauthRadioBtn.selected) {
			Alert.show(dropAPI.authorizationUrl);
		}
	};
	dropAPI.addEventListener(DropboxEvent.REQUEST_TOKEN_RESULT, handler);
	if (!dropAPI.hasEventListener(DropboxEvent.REQUEST_TOKEN_FAULT)) {
		dropAPI.addEventListener(DropboxEvent.REQUEST_TOKEN_FAULT, faultHandler);
	}
}

public function emailLogin():void
{ 
	dropAPI.token(eMailLabel.text, passwordLabel.text);
	var handler:Function = function (evt:DropboxEvent):void
	{
		dropAPI.removeEventListener(DropboxEvent.TOKEN_RESULT, handler);
		var obj:Object = evt.resultObject;
		accTokenKeyLabel.text = obj.token;
		accTokenSecretLabel.text = obj.secret;
		loginedAPIContainer.enabled = true;
	};
	dropAPI.addEventListener(DropboxEvent.TOKEN_RESULT, handler);
	if (!dropAPI.hasEventListener(DropboxEvent.TOKEN_FAULT)) {
		dropAPI.addEventListener(DropboxEvent.TOKEN_FAULT, faultHandler);
	}
}

public function getAccessToken():void
{
	dropAPI.accessToken();
	var handler:Function = function (evt:DropboxEvent):void
	{
		dropAPI.removeEventListener(DropboxEvent.ACCESS_TOKEN_RESULT, handler);
		var obj:Object = evt.resultObject;
		accTokenKeyLabel.text = obj.key;
		accTokenSecretLabel.text = obj.secret;
		loginedAPIContainer.enabled = true;
	};
	dropAPI.addEventListener(DropboxEvent.ACCESS_TOKEN_RESULT, handler);
	if (!dropAPI.hasEventListener(DropboxEvent.ACCESS_TOKEN_FAULT)) {
		dropAPI.addEventListener(DropboxEvent.ACCESS_TOKEN_FAULT, faultHandler);
	}
}

public function accountInfo():void
{
	dropAPI.accountInfo();
	var handler:Function = function (evt:DropboxEvent):void
	{
		dropAPI.removeEventListener(DropboxEvent.ACCESS_TOKEN_RESULT, handler);
		var accountInfo:AccountInfo = AccountInfo(evt.resultObject);
		accountInfoLabel.text = accountInfo.toString();
	};
	dropAPI.addEventListener(DropboxEvent.ACCOUNT_INFO_RESULT, handler);
	if (!dropAPI.hasEventListener(DropboxEvent.ACCOUNT_INFO_FAULT)) {
		dropAPI.addEventListener(DropboxEvent.ACCOUNT_INFO_FAULT, faultHandler);
	}
}

//private var testFolder1:String = new Date().time.toString() + "  111/222 444";
//private var testFile:String;

public function uploadFile():void
{
	var fr:FileReference = new FileReference();
	var loadCompHandler:Function = function (evt:Event):void
	{
		fr.removeEventListener(Event.COMPLETE, loadCompHandler);
		//testFile = fr.name;
		dropAPI.putFile(FOLDER, fr.name, fr.data);
		var handler:Function = function (evt:DropboxEvent):void
		{
			dropAPI.removeEventListener(DropboxEvent.PUT_FILE_RESULT, handler);
			uploadFileLabel.text = evt.resultObject.toString();
		};
		dropAPI.addEventListener(DropboxEvent.PUT_FILE_RESULT, handler);
		if (!dropAPI.hasEventListener(DropboxEvent.PUT_FILE_FAULT)) {
			dropAPI.addEventListener(DropboxEvent.PUT_FILE_FAULT, faultHandler);
		}
	};
	var selectHandler:Function = function (evt:Event):void
	{
		fr.removeEventListener(Event.SELECT, selectHandler);
		fr.addEventListener(Event.COMPLETE, loadCompHandler);
		fr.load();
	};
	fr.addEventListener(Event.SELECT, selectHandler);
	fr.browse();
}

public function copyFile():void
{
	dropAPI.fileCopy(FILE_NAME_WITH_PATH, FILE_NAME_WITH_PATH + "." + testFolder);
	var handler:Function = function (evt:DropboxEvent):void
	{
		dropAPI.removeEventListener(DropboxEvent.FILE_COPY_RESULT, handler);
		var dropboxFile:DropboxFile = DropboxFile(evt.resultObject);
		copyFileLabel.text = dropboxFile.toString();
	};
	dropAPI.addEventListener(DropboxEvent.FILE_COPY_RESULT, handler);
	if (!dropAPI.hasEventListener(DropboxEvent.FILE_COPY_FAULT)) {
		dropAPI.addEventListener(DropboxEvent.FILE_COPY_FAULT, faultHandler);
	}		
}

private var testFolder:String = new Date().time.toString();

public function createFolder():void
{
	dropAPI.fileCreateFolder(FOLDER + '.' + testFolder, 'dropbox');
	var handler:Function = function (evt:DropboxEvent):void
	{
		dropAPI.removeEventListener(DropboxEvent.FILE_CREATE_FOLDER_RESULT, handler);
		var dropboxFile:DropboxFile = DropboxFile(evt.resultObject);
		createFolderLabel.text = dropboxFile.toString();
	};
	dropAPI.addEventListener(DropboxEvent.FILE_CREATE_FOLDER_RESULT, handler);
	if (!dropAPI.hasEventListener(DropboxEvent.FILE_CREATE_FOLDER_FAULT)) {
		dropAPI.addEventListener(DropboxEvent.FILE_CREATE_FOLDER_FAULT, faultHandler);
	}	
}

public function moveFile():void
{
	dropAPI.fileMove(FILE_NAME_WITH_PATH, FILE_NAME_WITH_PATH + testFolder);
	var handler:Function = function (evt:DropboxEvent):void
	{
		dropAPI.removeEventListener(DropboxEvent.FILE_MOVE_RESULT, handler);
		var dropboxFile:DropboxFile = DropboxFile(evt.resultObject);
		moveFileLabel.text = dropboxFile.toString();
	};
	dropAPI.addEventListener(DropboxEvent.FILE_MOVE_RESULT, handler);
	if (!dropAPI.hasEventListener(DropboxEvent.FILE_MOVE_FAULT)) {
		dropAPI.addEventListener(DropboxEvent.FILE_MOVE_FAULT, faultHandler);
	}		
}

public function deleteFile():void
{
	dropAPI.fileDelete(FILE_NAME_WITH_PATH + '.' + testFolder);
	var handler:Function = function (evt:DropboxEvent):void
	{
		dropAPI.removeEventListener(DropboxEvent.FILE_DELETE_RESULT, handler);
		deleteFileLabel.text = evt.resultObject.toString();
	};
	dropAPI.addEventListener(DropboxEvent.FILE_DELETE_RESULT, handler);
	if (!dropAPI.hasEventListener(DropboxEvent.FILE_DELETE_RESULT)) {
		dropAPI.addEventListener(DropboxEvent.FILE_DELETE_FAULT, faultHandler);
	}
}

public function getFile():void
{
	dropAPI.getFile(FILE_NAME_WITH_PATH, "0");
	var handler:Function = function (evt:DropboxEvent):void
	{
		dropAPI.removeEventListener(DropboxEvent.GET_FILE_RESULT, handler);
		getFileLabel.text = ByteArray(evt.resultObject).length.toString();
	};
	dropAPI.addEventListener(DropboxEvent.GET_FILE_RESULT, handler);
	if (!dropAPI.hasEventListener(DropboxEvent.GET_FILE_FAULT)) {
		dropAPI.addEventListener(DropboxEvent.GET_FILE_FAULT, faultHandler);
	}	
}

public function metadata():void
{
	dropAPI.metadata(FILE_NAME_WITH_PATH, 1000, "", true);
	var handler:Function = function (evt:DropboxEvent):void
	{
		dropAPI.removeEventListener(DropboxEvent.METADATA_RESULT, handler);
		metadataLabel.text = DropboxFile(evt.resultObject).toString();
	};
	dropAPI.addEventListener(DropboxEvent.METADATA_RESULT, handler);
	if (!dropAPI.hasEventListener(DropboxEvent.METADATA_FAULT)) {
		dropAPI.addEventListener(DropboxEvent.METADATA_FAULT, faultHandler);
	}	
}

public function thumbnails():void
{
	dropAPI.thumbnails(FILE_NAME_WITH_PATH, "");
	var handler:Function = function (evt:DropboxEvent):void
	{
		dropAPI.removeEventListener(DropboxEvent.THUMBNAILS_RESULT, handler);
		thumbnailsLabel.text = ByteArray(evt.resultObject).length.toString();
	};
	dropAPI.addEventListener(DropboxEvent.THUMBNAILS_RESULT, handler);
	if (!dropAPI.hasEventListener(DropboxEvent.THUMBNAILS_FAULT)) {
		dropAPI.addEventListener(DropboxEvent.THUMBNAILS_FAULT, faultHandler);
	}	
}

private var revisionDetails:Array;

public function revisions():void
{
	dropAPI.revisions(FILE_NAME_WITH_PATH);
	var handler:Function = function (evt:DropboxEvent):void
	{
		dropAPI.removeEventListener(DropboxEvent.REVISION_RESULT, handler);
		revisionsLabel.text = evt.resultObject.toString();
		revisionDetails = evt.resultObject as Array;
	};
	dropAPI.addEventListener(DropboxEvent.REVISION_RESULT, handler);
	if (!dropAPI.hasEventListener(DropboxEvent.REVISION_FAULT)) {
		dropAPI.addEventListener(DropboxEvent.REVISION_FAULT, faultHandler);
	}	
}

public function restore_f():void
{
	if (revisionDetails.length > 1) {
		dropAPI.restore(FILE_NAME_WITH_PATH + "." + testFolder, DropboxFile(revisionDetails[0]).rev);
		var handler:Function = function (evt:DropboxEvent):void
		{
			dropAPI.removeEventListener(DropboxEvent.RESTORE_RESULT, handler);
			restoreLabel.text = evt.resultObject.toString();
		};
		dropAPI.addEventListener(DropboxEvent.RESTORE_RESULT, handler);
		if (!dropAPI.hasEventListener(DropboxEvent.RESTORE_FAULT)) {
			dropAPI.addEventListener(DropboxEvent.RESTORE_FAULT, faultHandler);
		}
	}
}

public function search():void
{
	dropAPI.search('Books', 'pdf');
	var handler:Function = function (evt:DropboxEvent):void
	{
		dropAPI.removeEventListener(DropboxEvent.SEARCH_RESULT, handler);
		searchLabel.text = evt.resultObject.toString();
	};
	dropAPI.addEventListener(DropboxEvent.SEARCH_RESULT, handler);
	if (!dropAPI.hasEventListener(DropboxEvent.SEARCH_FAULT)) {
		dropAPI.addEventListener(DropboxEvent.SEARCH_FAULT, faultHandler);
	}	
}

public function shares():void
{
	dropAPI.shares(FILE_NAME_WITH_PATH);
	var handler:Function = function (evt:DropboxEvent):void
	{
		dropAPI.removeEventListener(DropboxEvent.SHARES_RESULT, handler);
		sharesLabel.text = evt.resultObject.toString();
	};
	dropAPI.addEventListener(DropboxEvent.SHARES_RESULT, handler);
	if (!dropAPI.hasEventListener(DropboxEvent.SHARES_FAULT)) {
		dropAPI.addEventListener(DropboxEvent.SHARES_FAULT, faultHandler);
	}		
}

public function media():void
{
	dropAPI.media(FILE_NAME_WITH_PATH);
	var handler:Function = function (evt:DropboxEvent):void
	{
		dropAPI.removeEventListener(DropboxEvent.MEDIA_RESULT, handler);
		mediaLabel.text = evt.resultObject.toString();
	};
	dropAPI.addEventListener(DropboxEvent.MEDIA_RESULT, handler);
	if (!dropAPI.hasEventListener(DropboxEvent.MEDIA_FAULT)) {
		dropAPI.addEventListener(DropboxEvent.MEDIA_FAULT, faultHandler);
	}	
}

private var cursor:String = "";
public function delta():void
{
	dropAPI.delta(cursor);
	var handler:Function = function (evt:DropboxEvent):void
	{
		dropAPI.removeEventListener(DropboxEvent.DELTA_RESULT, handler);
		var delta:Delta = evt.resultObject as Delta;
		deltaLabel.text = delta.toString();
		cursor = delta.cursor;
	};
	dropAPI.addEventListener(DropboxEvent.DELTA_RESULT, handler);
	if (!dropAPI.hasEventListener(DropboxEvent.DELTA_FAULT)) {
		dropAPI.addEventListener(DropboxEvent.DELTA_FAULT, faultHandler);
	}	
}

public function copyRef():void
{
	dropAPI.copyRef(FILE_NAME_WITH_PATH);
	var handler:Function = function (evt:DropboxEvent):void
	{
		dropAPI.removeEventListener(DropboxEvent.COPY_REF_RESULT, handler);
		var copyRef:CopyRef = evt.resultObject as CopyRef;
		copyRefLabel.text = copyRef.toString();
	};
	dropAPI.addEventListener(DropboxEvent.COPY_REF_RESULT, handler);
	if (!dropAPI.hasEventListener(DropboxEvent.COPY_REF_FAULT)) {
		dropAPI.addEventListener(DropboxEvent.COPY_REF_FAULT, faultHandler);
	}	
}

private function faultHandler(evt:Event):void
{
	trace ((evt as Object).resultObject.toString());
	Alert.show((evt as Object).resultObject.toString());
}
# Introduction #
ActionScript 3 Dropbox API, currently only support AIR platform because the crossdomain issue will happen in web flash.

Dropbox API use OAuth to authorize and JSON as result.  So another two libraries is necessary: Crypto.swc and as3corelib.swc.  Both two files can be found either in source code or google code projects.

**For examples, please check the HsDropboxTest project**

# Authorization API Implementation #

1. OAuth:
|requestToken()| get request token key/secret from Dropbox server|
|:-------------|:------------------------------------------------|
|authorizationUrl()| get a string of authorization URL and ask user to go and authorize|
|accessToken()| get access token key/secret from Dropbox server after user has authorized your application|

2. email/ Password:
|requestToken()| get request token key/secret from Dropbox server|
|:-------------|:------------------------------------------------|
|token()| get access token key/secret from Dropbox Server by email / password|

# Dropbox API Implementation #

|accountInfo()| get user's account information|
|:------------|:------------------------------|
|fileCopy()| copy a file|
|fileCreateFolder()| create a folder|
|fileDelete()| delete a file|
|fileMove()| move a file|
|metadata()| get the metadata of a file or folder|
|delta()| A way of letting you keep up with changes to files and folders in a user's Dropbox.|
|revisions()| Obtains metadata for the previous revisions of a file.|
|restore()| Restores a file path to a previous revision.|
|search()| Returns metadata for all files and folders whose filename contains the given search string as a substring.|
|shares()| Creates and returns a Dropbox link to files or folders users can use to view a preview of the file in a web browser.|
|media()| Returns a link directly to a file.|
|copy\_ref()| reates and returns a copy\_ref to a file. This reference string can be used to copy that file to another user's Dropbox by passing it in as the from\_copy\_ref parameter on /fileops/copy.|
|thumbnails()| Gets a thumbnail for an image. Note that this call goes to api-content.dropbox.com instead of api.dropbox.com.|
|chunked\_upload()| Uploads large files to Dropbox in mulitple chunks. Also has the ability to resume if the upload is interrupted. This allows for uploads larger than the /files and /files\_put maximum of 150 MB. |
|commit\_chunked\_upload()(private)| Completes an upload initiated by the /chunked\_upload method. Saves a file uploaded via /chunked\_upload to a user's Dropbox.|

asdoc: http://dropbox-as3.googlecode.com/svn/docs/dropbox-doc/index.html
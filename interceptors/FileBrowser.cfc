/**
********************************************************************************
Copyright 2013 Photo Gallery by Seth Engen and Computer Know How, LLC
www.sethengen.com | www.compknowhow.com
********************************************************************************

Author:  Seth Engen
Description:  Photo gallery interceptor
*/

component extends="coldbox.system.Interceptor" {

	// DI
	property name="cbSettingService" inject="id:settingService@cb";
	property name="settingService" inject="settingService@cb";
	property name="controller" inject="coldbox";

	//after a file is uploaded resize and crop into the _photogallery folders
	void function fb_postFileUpload(event,struct interceptData) {
		//if it is a photo gallery and a file we can handle process the file
		if ( isPhotoGallery( interceptData.results.serverDirectory ) and ( isFileAllowed( interceptData.results.serverFileExt ) ) ) {
			//create the thumbnail and photo files
			processPhoto( interceptData.results.serverDirectory, interceptData.results.serverFile );
		}
	}

	//after a filename modification replicate the name change in the _photogallery folders
	void function fb_postFileRename(event,struct interceptData) {
		//if it is a photo gallery
		//TODO: we should be checking if it is a photo before we rename it
		if ( isPhotoGallery( getDirectoryFromPath( interceptData.original ) ) ) {
			//rename the photos
			renamePhotos( getDirectoryFromPath( interceptData.original ), getFileFromPath( interceptData.original ), interceptData.newName );
		}
	}

	//after a folder is removed remove the files from the _photogallery folders
	void function fb_postFileRemoval(event,struct interceptData) {
		//if it is a photo gallery
		//TODO: we should be checking if it is a photo before we delete it
		if ( isPhotoGallery( getDirectoryFromPath( interceptData.path ) ) ) {
			//delete the photos
			deletePhotos( getDirectoryFromPath( interceptData.path ), getFileFromPath( interceptData.path ) );
		}
	}

	//add a message box that tells them that this folder is a photo gallery folder
	void function fb_preFileListing(event, struct interceptData) {
		var prc = controller.getRequestService().getContext().getCollection(private=true);

		if( isPhotoGallery( prc.fbCurrentRoot ) ) {
			appendToBuffer('<div class="alert alert-danger"><strong>This folder is setup as a photo gallery.</strong>  Any photos that are added to this folder will be processed by the "Photo Gallery" module.  Uploads may appear to stop at 100% while the photos are resized and cropped (especially with larger file sizes).  Please be patient while we process the files!</div>');
		}
	}

	//remove the "_photogallery" folder from view (make it hidden)
	void function fb_postDirectoryRead(event,struct interceptData) {
		if( isPhotoGallery( interceptData.directory ) ) {
			//filter out our "_photogallery" folder from the original directory listing
			var query = new Query();
			query.setAttributes(directoryListing = interceptData.listing);
			var filteredDirectory = query.execute(sql="select * from directoryListing where name <> '_photogallery'", dbtype="query");

			var prc = controller.getRequestService().getContext().getCollection(private=true);
			prc.fbqListing = filteredDirectory.getResult();
		}
	}

	//PRIVATE FUNCTIONS
	private struct function getGallerySettings() {
		return deserializeJSON(settingService.getSetting( "photo_gallery" ));
	}

	private string function getGalleryTempFolderPath( folder ) {
		return arguments.folder & "/" & getGallerySettings().galleryTempFolderName;
	}

	private string function getGallerySmallFolderPath( folder ) {
		return getGalleryTempFolderPath( folder ) & "/" & getGallerySettings().gallerySmallFolderName;
	}

	private string function getGalleryNormalFolderPath( folder ) {
		return getGalleryTempFolderPath( folder ) & "/" & getGallerySettings().galleryNormalFolderName;
	}

	private string function getGalleryOriginalFolderPath( folder ) {
		return getGalleryTempFolderPath( folder ) & "/" & getGallerySettings().galleryOriginalFolderName;
	}

	private string function getMediaRoot( folder ) {
		return replace(lcase(expandPath(cbSettingService.getSetting('cb_media_directoryRoot'))),"\","/","all");
	}

	private array function getRegisteredGalleries() {
		var registeredGalleries = [];

		var galleryFolders = listToArray(getGallerySettings().galleryFolders);

		//setup conventions based gallery folder if it isn't blank
		if( len(getGallerySettings().conventionGalleryPath) ) {
			conventionGalleryPath = getMediaRoot() & "/" & getGallerySettings().conventionGalleryPath;
			arrayAppend(registeredGalleries, conventionGalleryPath);
		}

		//register our manually created galleries
		for(var galleryFolder in galleryFolders) {
			galleryPath = getMediaRoot() & "/" & galleryFolder;
			arrayAppend(registeredGalleries, galleryPath);
		}

		return registeredGalleries;
	}

	//TODO: only checking extension...should check MIME type too
	private boolean function isFileAllowed( extension ) {
		//check to see if this extension is in our list of allowed
		var allowedPhotoExtensions = getGallerySettings().allowedPhotoExtensions;
			// ^((?!\.).)*$|.+\.(jpg|jpeg|bmp|gif|png)/? *
		return listFindNoCase(allowedPhotoExtensions, arguments.extension);
	}

	private void function setupGallery( folder ) {
		//create the temp root folder
		if ( !directoryExists( getGalleryTempFolderPath( arguments.folder ) ) ) {
			directoryCreate( getGalleryTempFolderPath( arguments.folder ) );
		}

		//create the small photo folder inside our temp root
		if ( !directoryExists( getGallerySmallFolderPath( arguments.folder ) ) ) {
			directoryCreate( getGallerySmallFolderPath( arguments.folder ) );
		}

		//create the normal photo folder inside our temp root
		if ( !directoryExists( getGalleryNormalFolderPath( arguments.folder ) ) ) {
			directoryCreate( getGalleryNormalFolderPath( arguments.folder ) );
		}

		//if chosen, create the original photo folder inside our temp root
		if ( getGallerySettings().moveOriginals ) {
			if ( !directoryExists( getGalleryOriginalFolderPath( arguments.folder ) ) ) {
				directoryCreate( getGalleryOriginalFolderPath( arguments.folder ) );
			}
		}
	}

	private boolean function isPhotoGallery( folder ) {
		//check up the folder and traverse up the tree to see if any are photo galleries
		var found = false;

		//convert all '\' to '/'
		var folderToCheck = replace(arguments.folder,"\","/","all");

		//get the registered photo galleries
		var registeredGalleries = getRegisteredGalleries();

		while ( !found AND folderToCheck NEQ getMediaRoot() AND len(folderToCheck) GT len(getMediaRoot()) ) {
			if ( arrayFindNoCase( registeredGalleries, folderToCheck ) ) { found = true; }
			//traverse up the folder tree
			folderToCheck = GetDirectoryFromPath( folderToCheck ).replaceFirst( "[\\\/]{1}$", "" );
		}

		return found;
	}

	private void function processPhoto( folder, filename ) {
		//be sure the gallery is setup
		setupGallery( arguments.folder );

		//get our image size settings
		var imageSize = getGallerySettings().imageSize;

		//put together the full file path for the photo we are processing
		var sourceFilePath = arguments.folder & "/" & arguments.filename;

		//read in the image (not sure why I have to read this twice??)
		var imgToProcess1 = imageRead( sourceFilePath );
		var imgToProcess2 = imageRead( sourceFilePath );

		//resize and crop
		var smallImage = resizeCropPhoto(imgToProcess1, imageSize.small.resizeWidth, imageSize.small.resizeHeight, imageSize.small.cropWidth, imageSize.small.cropHeight );
		var normalImage = resizeCropPhoto(imgToProcess2, imageSize.normal.resizeWidth, imageSize.normal.resizeHeight, imageSize.normal.cropWidth, imageSize.normal.cropHeight );

		//write the image to our _photogallery folder
		imageWrite( smallImage, getGallerySmallFolderPath( arguments.folder ) & "/" & arguments.filename, true );
		imageWrite( normalImage, getGalleryNormalFolderPath( arguments.folder ) & "/" & arguments.filename, true );

		//move the original to a temp originals folder and replace it with the resized normal photo (speeds up media manager considerably (when in grid listing) depending on sizes)
		if ( getGallerySettings().moveOriginals ) {
			fileMove( sourceFilePath, getGalleryOriginalFolderPath( arguments.folder) );
			imageWrite( normalImage, arguments.folder & "/" & arguments.filename, true );
		}
	}

	function resizeCropPhoto( img, resizeHeight, resizeWidth, cropWidth, cropHeight ) {
		var resized = false;

		//portrait or square
		if( (arguments.img.height GT arguments.img.width) OR (arguments.img.height EQ arguments.img.width) ) {
			//resize if it is needed
			if( arguments.img.height GT arguments.resizeHeight) {
				imageResize( arguments.img, arguments.resizeHeight, '' );
				resized = true;

				//should we crop
				if( arguments.cropWidth OR arguments.cropHeight ) {
					var distanceFromX = arguments.img.Height / 2 - (arguments.resizeHeight / 2);
					imageCrop(arguments.img, 0, distanceFromX, arguments.cropWidth, arguments.cropHeight);
				}
			}

		//landscape
		} else if( arguments.img.width GT arguments.img.height ) {
			//resize if it is needed
			if( arguments.img.width GT arguments.resizeWidth ) {
				imageResize( arguments.img, '', arguments.resizeWidth );
				resized = true;

				//should we crop
				if( arguments.cropWidth OR arguments.cropHeight ) {
					var distanceFromY = arguments.img.Width / 2 - (arguments.resizeWidth / 2);
					imageCrop( arguments.img, distanceFromY,0, arguments.cropWidth, arguments.cropHeight);
				}
			}
		}

		return arguments.img;
	}

	private void function renamePhotos( folder, oldFilename, newFilename ) {
		//build our small and normal paths (source and destination)
		var smallFileSource = getGallerySmallFolderPath( arguments.folder ) & "/" & arguments.oldFilename;
		var smallFileDestination = getGallerySmallFolderPath( arguments.folder ) & "/" & arguments.newFilename;

		var normalFileSource = getGalleryNormalFolderPath( arguments.folder ) & "/" & arguments.oldFilename;
		var normalFileDestination = getGalleryNormalFolderPath( arguments.folder ) & "/" & arguments.newFilename;

		fileMove( smallFileSource, smallFileDestination );
		fileMove( normalFileSource, normalFileDestination );

		//do the rename on the originals folder if move originals is enabled
		if ( getGallerySettings().moveOriginals ) {
			var originalFileSource = getGalleryOriginalFolderPath( arguments.folder ) & "/" & arguments.oldFilename;
			var originalFileDestination = getGalleryOriginalFolderPath( arguments.folder ) & "/" & arguments.newFilename;
			fileMove( originalFileSource, originalFileDestination );
		}
	}

	private void function deletePhotos( folder, filename ) {
		//build our small and normal paths
		var smallFilePath = getGallerySmallFolderPath( arguments.folder ) & "/" & arguments.filename;
		var normalFilePath = getGalleryNormalFolderPath( arguments.folder ) & "/" & arguments.filename;

		fileDelete( smallFilePath );
		fileDelete( normalFilePath );

		//do the delete on the originals folder if move originals is enabled
		if ( getGallerySettings().moveOriginals ) {
			var originalFilePath = getGalleryOriginalFolderPath( arguments.folder ) & "/" & arguments.filename;
			fileDelete( originalFilePath );
		}
	}

	private boolean function isFile( path ) {
		var fileInfo = getFileInfo( arguments.path );

		return fileInfo.type EQ "file";
	}

}
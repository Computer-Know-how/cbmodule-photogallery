/**
* I handle the gallery events
*/
component extends="base" {

	property name="settingService" 	inject="settingService@contentbox";
	property name="cb" 				inject="cbHelper@contentbox";

	function index(event,rc,prc){
		var cbSettings = event.getValue(name="cbSettings",private=true);
		var oSetting = settingService.findWhere( { name="photo_gallery" } );
		var settings = deserializeJSON(oSetting.getValue());

		// Get the paths
		prc.mediaRoot = expandPath(cbSettings.cb_media_directoryRoot & "\");
		prc.galleryFolders = settings.galleryFolders;
		prc.conventionGalleryPath = settings.conventionGalleryPath;

		// Get the directory listing of our media root
		var mediaRootDirectories = directoryList(prc.mediaRoot,true,"query","*","Directory ASC");

		// Setup a new query to filter the media root results
		var query = new Query();
		query.setAttributes(directoryListing = mediaRootDirectories);
		var qryFilteredFolderList = query.execute(sql="select directory + '\' + name as path from directoryListing where type = 'Dir' and directory NOT LIKE '%_photogallery' and name <> '_photogallery'", dbtype="query");
		prc.contentFolders = qryFilteredFolderList.getResult();

		event.setView(view="gallery/index",module="PhotoGallery");
	}

	function saveGalleries(event,rc,prc){
		param name="rc.galleryFolders" default="";

		var oSetting = settingService.findWhere( { name="photo_gallery" } );

		incomingSetting = serializeJSON(
			{"galleryFolders" = rc.galleryFolders}
		);

		var newSetting = deserializeJSON(incomingSetting);
		var existingSettings = deserializeJSON(oSetting.getValue());

		// Append the new settings sent in to the existing settings (overwrite)
		structAppend(existingSettings,newSetting);

		oSetting.setValue( serializeJSON(existingSettings) );
		settingService.save( oSetting );

		// Flush the settings cache so our new settings are reflected
		settingService.flushSettingsCache();

		getInstance("messageBox@cbMessageBox").info("Gallery Folders Saved & Updated!");
		cb.setNextModuleEvent("PhotoGallery","gallery.index");
	}

}
component extends="base" {

	// DI
	property name="settingService" 	inject="settingService@cb";
	property name="cb" 				inject="cbHelper@cb";

	function index(event,rc,prc){
		prc.settings = deserializeJSON(settingService.getSetting( "photo_gallery" ));

		event.setView("settings/index");
	}

	function saveSettings(event,rc,prc){
		var incomingSettings = "";
		var newSettings = {};

		var oSetting = settingService.findWhere( { name="photo_gallery" } );

		// Get settings from user input
		if(structKeyExists(rc,"imageSizeSmallResizeWidth")) {
			incomingSettings = serializeJSON(
				{
					"imageSize" = {
						"small" = {
							"resizeWidth" = rc.imageSizeSmallResizeWidth,
							"resizeHeight" = rc.imageSizeSmallResizeHeight,
							"cropWidth" = rc.imageSizeSmallCropWidth,
							"cropHeight" = rc.imageSizeSmallCropHeight
						},
						"normal" = {
							"resizeWidth" = rc.imageSizeNormalResizeWidth,
							"resizeHeight" = rc.imageSizeNormalResizeHeight,
							"cropWidth" = rc.imageSizeNormalCropWidth,
							"cropHeight" = rc.imageSizeNormalCropHeight
						}
					}
				}
			);
			newSettings = deserializeJSON(incomingSettings);
		}

		if(structKeyExists(rc,"galleryTempFolderName")) {
			incomingSettings = serializeJSON(
				{
					"galleryTempFolderName" = rc.galleryTempFolderName,
					"gallerySmallFolderName" = rc.gallerySmallFolderName,
					"galleryNormalFolderName" = rc.galleryNormalFolderName,
					"moveOriginals" = rc.moveOriginals,
					"galleryOriginalFolderName" = rc.galleryOriginalFolderName,
					"conventionGalleryPath" = rc.conventionGalleryPath
				}
			);
			newSettings = deserializeJSON(incomingSettings);
		}

		if(structKeyExists(rc,"allowedPhotoExtensions")) {
			incomingSettings = serializeJSON(
				{
					"allowedPhotoExtensions" = rc.allowedPhotoExtensions
				}
			);
			newSettings = deserializeJSON(incomingSettings);
		}

		if(structKeyExists(rc,"maxPhotosPerPage")) {
			incomingSettings = serializeJSON(
				{
					"maxPhotosPerPage" = rc.maxPhotosPerPage
				}
			);
			newSettings = deserializeJSON(incomingSettings);
		}

		var existingSettings = deserializeJSON(oSetting.getValue());

		// Append the new settings sent in to the existing settings (overwrite)
		structAppend(existingSettings,newSettings);

		oSetting.setValue( serializeJSON(existingSettings) );
		settingService.save( oSetting );

		// Flush the settings cache so our new settings are reflected
		settingService.flushSettingsCache();

		getPlugin("MessageBox").info("Settings Saved & Updated!");
		cb.setNextModuleEvent("PhotoGallery","settings.index");
	}

}
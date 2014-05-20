/**
* A module that will generate photo galleries for your ContentBox website,
* used in combination with the PhotoGallery widget.
*/
component {

	// Module Properties
	this.title 				= "PhotoGallery";
	this.author 			= "Computer Know How, LLC";
	this.webURL 			= "http://www.compknowhow.com";
	this.description 		= "A photo gallery for your ContentBox website";
	this.version			= "1.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "PhotoGallery";

	function configure(){

		// module settings - stored in modules.name.settings
		settings = {
			galleryFolders = "",
			allowedPhotoExtensions = "jpg,jpeg,bmp,gif,png",
			galleryTempFolderName = "_photogallery",
			gallerySmallFolderName = "small",
			galleryNormalFolderName = "normal",
			moveOriginals = true,
			galleryOriginalFolderName = "original",
			conventionGalleryPath = "_photogalleries",
			imageSize = {
				small = {
					resizeWidth = 150,
					resizeHeight = 150,
					cropWidth = 150,
					cropHeight = 150
				},
				normal = {
					resizeWidth = 600,
					resizeHeight = 600,
					cropWidth = 0,
					cropHeight = 0
				}
			},
			maxPhotosPerPage = 8
		};

		// SES Routes
		routes = [
			{pattern="/", handler="gallery",action="index"},
			// Convention Route
			{pattern="/:handler/:action?"}
		];

		// Interceptors
		interceptors = [
			{ class="#moduleMapping#.interceptors.FileBrowser", properties={ entryPoint="cbadmin" }, name="FileBrowser@PhotoGallery" }
		];

	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// ContentBox loading
		if( structKeyExists( controller.getSetting("modules"), "contentbox" ) ){
			var menuService = controller.getWireBox().getInstance("AdminMenuService@cb");

			// Add the 'Photo Gallery' contribution to the module menu
			menuService.addSubMenu(topMenu=menuService.MODULES,name="PhotoGallery",label="Photo Gallery",href="#menuService.buildModuleLink('PhotoGallery','gallery.index')#");
		}
	}

	/**
	* Fired when the module is activated
	*/
	function onActivate(){
		var settingService = controller.getWireBox().getInstance("SettingService@cb");

		// Store default settings
		var findArgs = {name="photo_gallery"};
		var setting = settingService.findWhere(criteria=findArgs);
		if( isNull(setting) ){
			var args = {name="photo_gallery", value=serializeJSON( settings )};
			var photoGallerySettings = settingService.new(properties=args);
			settingService.save( photoGallerySettings );
		}

		// Flush the settings cache so our new settings are reflected
		settingService.flushSettingsCache();
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		// ContentBox unloading
		if( structKeyExists( controller.getSetting("modules"), "contentbox" ) ){
			var menuService = controller.getWireBox().getInstance("AdminMenuService@cb");

			// Remove the 'Photo Gallery' contribution from the module menu
			menuService.removeSubMenu(topMenu=menuService.MODULES,name="PhotoGallery");
		}
	}

	/**
	* Fired when the module is deactivated by ContentBox Only
	*/
	function onDeactivate(){
		var settingService = controller.getWireBox().getInstance("SettingService@cb");

		var args = {name="photo_gallery"};
		var setting = settingService.findWhere(criteria=args);
		if( !isNull(setting) ){
			settingService.delete( setting );
		}

		// Flush the settings cache so our new settings are reflected
		settingService.flushSettingsCache();
	}

}
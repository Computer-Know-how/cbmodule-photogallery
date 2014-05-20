/**
* base handler for the photo gallery
*/
component{

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);

		// Get module root
		prc.moduleRoot = getModuleSettings( "PhotoGallery" ).mapping;

		// Exit points
		prc.xehGalleries = "gallery.index";
		prc.xehGalleriesSave = "gallery.saveGalleries";
		prc.xehSettings = "settings.index";
		prc.xehSettingsSave = "settings.saveSettings";

		// Activate the module tab and 'Photo Gallery' menu contribution
		prc.tabModules = true;
		prc.tabModules_PhotoGallery = true;
	}

}
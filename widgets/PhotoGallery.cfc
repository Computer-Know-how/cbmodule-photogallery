/**
* A widget that renders a gallery of the photos in a folder.
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	property name="settingService" 	inject="settingService@cb";

	PhotoGallery function init(controller){
		// super init
		super.init(controller);

		// Widget Properties
		setName("PhotoGallery");
		setVersion("1.1");
		setDescription("A widget that renders a gallery of the photos in a folder.");
		setForgeBoxSlug("cbwidget-photogallery");
		setAuthor("Computer Know How, LLC");
		setAuthorURL("http://www.compknowhow.com");
		setIcon( "image" );
		setCategory( "Utilities" );
		return this;
	}

	/**
	* Renders a photo gallery
	* @folder.hint The folder (relative to the ContentBox content root) from which to list the gallery of photos
	* @filter.hint A file extension filter to apply (*.jpg)
	* @sort.hint The sort field (Name, Size, DateLastModified)
	* @order.hint The sort order of the photos (ASC/DESC)
	* @class.hint Class(es) to apply to the gallery
	*/
	any function renderIt(string folder,string filter="*",string sort="Name",string order="ASC",string class=""){
		var event = getRequestContext();
		rc = event.getCollection();

		param name="rc.startRow" default=1;

		var relativePath = "";
		var cbSettings = event.getValue(name="cbSettings",private=true);
		var sortOrder = arguments.sort & " " & arguments.order;
		var mediaRoot = expandPath(cbSettings.cb_media_directoryRoot);
		var mediaPath = "modules" & cbSettings.cb_media_directoryRoot & "/" & arguments.folder;
		var mediaPathExpanded = expandPath(mediaPath);
		var galleryPath = event.buildLink("__media/#arguments.folder#/_photogallery");

		if(!len(arguments.folder)){
			return "Please specify a folder";
		}

		if(!directoryExists(mediaPathExpanded)){
			return "The folder specified does not exist";
		}

		//security check - can't be higher then the media root
		if(!findNoCase(mediaRoot, mediaPathExpanded)){
			return "This widget is restricted to the ContentBox media root.  All photo galleries must be contained within that directory.";
		}

		var gallery = directoryList(mediaPathExpanded,false,"query",arguments.filter,sortOrder);

		var query = new Query();
		query.setAttributes(directoryListing = gallery);

		var qryGalleryFolders = query.execute(sql="select * from directoryListing where type = 'Dir' and name <> '_photogallery'", dbtype="query");
		var qryGalleryPhotos = query.execute(sql="select * from directoryListing where type = 'File'", dbtype="query");

		var galleryFolders = qryGalleryFolders.getResult();
		var galleryPhotos = qryGalleryPhotos.getResult();

		// generate photo gallery
		saveContent variable="rString"{
			writeOutput('
				<style>
					.cb-photogallery-tiles {
						overflow: hidden;
					}

					.cb-photogallery-tile {
						float: left;
						border-radius: 3px;
						-webkit-box-shadow: 0 0 7px rgba(0, 0, 0, 0.5);
						-moz-box-shadow: 0 0 7px rgba(0, 0, 0, 0.5);
						box-shadow: 0 0 7px rgba(0, 0, 0, 0.5);
						position: relative;
						width: 150px;
						margin: 0 20px 20px 0;
						background-color: ##fff;
					}

					.cb-photogallery-tile img {
						display: block;
						overflow: hidden;
						position: relative;
						width: 150px;
						border-radius: 3px;
					}

					.widget-preview-content .cb-photogallery-tile,
					.widget-preview-content a.cb-photogallery-nextlink,
					.widget-preview-content a.cb-photogallery-prevlink {
						pointer-events: none;
						cursor: not-allowed;
					}

					.cb-photogallery-pageinfo:before {
						content: "(";
					}

					.cb-photogallery-pageinfo:after {
						content: ")";
					}

					a.cb-photogallery-prevlink:before {
						content: "\2190 \020";
					}

					a.cb-photogallery-nextlink:after {
						content: "\020 \2192";
					}

					span.cb-photogallery-prevlink,
					span.cb-photogallery-nextlink {
						cursor: not-allowed;
					}
				</style>
			');

			writeOutput('<div class="cb-photogallery"><div class="cb-photogallery-tiles">');

			var settings = deserializeJSON(settingService.getSetting( "photo_gallery" ));

			var maxRows = settings.maxPhotosPerPage;
			var startRow = rc.startRow;

			for (var x=startRow; (x lte startRow + maxRows - 1) and (x lte galleryPhotos.recordcount); x++) {
				writeOutput('
					<div class="cb-photogallery-tile">
						<a href="#galleryPath#/normal/#galleryPhotos.name[x]#" title="#galleryPhotos.name[x]#" class="cb-photogallery-link">
							<img src="#galleryPath#/small/#galleryPhotos.name[x]#" title="#galleryPhotos.name[x]#" alt="#galleryPhotos.name[x]#" class="cb-photogallery-image" rel="group">
						</a>
					</div>
				');
			}

			writeOutput('</div>');

			var totalPages = ceiling(galleryPhotos.recordCount / maxRows);
			var thisPage = ceiling(startRow / maxRows);

			if (totalPages gt 1) {
				var previousPageStart = startRow - maxRows;
				if ( previousPageStart gte 1 ) {
					var previousPageLink = "<a href='" & #cgi.path_info# & "?startRow=" & previousPageStart & "' class='cb-photogallery-prevlink'>previous</a>";
				} else {
					var previousPageLink = "<span class='cb-photogallery-prevlink'>previous</span>";
				}
				var nextPageStart = startRow + maxRows;
				if ( nextPageStart lt galleryPhotos.recordcount ) {
					var nextPageLink = "<a href='" & #cgi.path_info# & "?startRow=" & nextPageStart & "' class='cb-photogallery-nextlink'>next</a>";
				} else {
					var nextPageLink = "<span class='cb-photogallery-nextlink'>next</span>";
				}

				writeOutput('
					<div class="cb-photogallery-paging">
						#previousPageLink# | #nextPageLink#
						<span class="cb-photogallery-pageinfo">#thisPage# of #totalPages#</span>
					</div>
				');
			}

			writeOutput('</div>');

		}

		return rString;
	}

}
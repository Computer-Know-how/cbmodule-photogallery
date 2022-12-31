<cfoutput>
	#renderView( "viewlets/assets" )#
	<!--============================Main Column============================-->
	<div class="row">
		<div class="col-md-12">
			<h1 class="h1">
				<i class="fa fa-gears"></i> Settings
			</h1>
		</div>
	</div>
	<div class="row">
		<div class="col-md-9">
			<div class="panel panel-default">
				<div class="panel-body">
					#getInstance("MessageBox@cbmessagebox").renderit()#

					<div class="tabbable tabs-left">
						<ul class="nav nav-tabs">
							<li class="active"><a href="##images" data-toggle="tab"><i class="fa fa-image"></i> Images</a></li>

							<li><a href="##folders" data-toggle="tab"><i class="fa fa-folder-open"></i> Folders</a></li>

							<li><a href="##security" data-toggle="tab"><i class="fa fa-lock"></i> Security</a></li>

							<li><a href="##paging" data-toggle="tab"><i class="fa fa-file-image"></i> Paging & Layout</a></li>
						</ul>

						<div class="tab-content">
							<!--- Settings: Images --->
							<div class="tab-pane active" id="images">
								#html.startForm(action="#cb.buildModuleLink('PhotoGallery',prc.xehSettingsSave)#",name="settingsForm")#
								#html.startFieldset(legend="<i class='icon-picture icon-large'></i> Images (Small)")#

								<div class="alert alert-info clearfix">
									<i class="fa fa-info-circle fa-lg fa-2x pull-left"></i>
									Changing image sizes will not resize gallery images already processed.  Settings will take effect for all images going forward.
								</div>

								<div class="form-group">
									#html.textField(name="imageSizeSmallResizeWidth", label="Resize Width:", value="#prc.settings.imageSize.small.resizeWidth#", class="form-control", help="This is some help text!")#
								</div>

								<div class="form-group">
									#html.textField(name="imageSizeSmallResizeHeight", label="Resize Height:", value="#prc.settings.imageSize.small.resizeHeight#", class="form-control")#
								</div>

								<div class="form-group">
									#html.textField(name="imageSizeSmallCropWidth", label="Crop Width:", value="#prc.settings.imageSize.small.cropWidth#", class="form-control")#
								</div>

								<div class="form-group">
									#html.textField(name="imageSizeSmallCropHeight", label="Crop Height:", value="#prc.settings.imageSize.small.cropHeight#", class="form-control")#
								</div>

								#html.endFieldSet()#

								#html.startFieldset(legend="<i class='icon-picture icon-large'></i> Images (Normal)")#

								<div class="alert alert-info clearfix">
									<i class="fa fa-info-circle fa-lg fa-2x pull-left"></i>
									Changing image sizes will not resize gallery images already processed.  Settings will take effect for all images going forward.
								</div>

								<div class="form-group">
									#html.textField(name="imageSizeNormalResizeWidth", label="Resize Width:", value="#prc.settings.imageSize.normal.resizeWidth#", class="form-control")#
								</div>

								<div class="form-group">
									#html.textField(name="imageSizeNormalResizeHeight", label="Resize Height:", value="#prc.settings.imageSize.normal.resizeHeight#", class="form-control")#
								</div>

								<div class="form-group">
									#html.textField(name="imageSizeNormalCropWidth", label="Crop Width:", value="#prc.settings.imageSize.normal.cropWidth#", class="form-control")#
								</div>

								<div class="form-group">
									#html.textField(name="imageSizeNormalCropHeight", label="Crop Height:", value="#prc.settings.imageSize.normal.cropHeight#", class="form-control")#
								</div>

								#html.endFieldSet()#

								<!--- Button Bar --->
								<div class="form-actions">
									#html.submitButton(value="Save Settings", class="btn btn-danger")#
								</div>

								#html.endForm()#
							</div>

							<!--- Settings: Folders --->
							<div class="tab-pane" id="folders">
								#html.startForm(action="#cb.buildModuleLink('PhotoGallery',prc.xehSettingsSave)#",name="settingsForm")#
								#html.startFieldset(legend="<i class='icon-folder-open icon-large'></i> Folders")#

								<div class="form-group">
									#html.textField(name="galleryTempFolderName", label="Temp Folder Name:", value="#prc.settings.galleryTempFolderName#", class="form-control")#
								</div>

								<div class="form-group">
									#html.textField(name="gallerySmallFolderName", label="Small Folder Name:", value="#prc.settings.gallerySmallFolderName#", class="form-control")#
								</div>

								<div class="form-group">
									#html.textField(name="galleryNormalFolderName", label="Normal Folder Name:", value="#prc.settings.galleryNormalFolderName#", class="form-control")#
								</div>

								<!--- Move Originals --->
								<div class="form-group">
									#html.label(class="control-label",field="moveOriginals",content="Move Originals:")#

									<div class="controls">
										<small>Images uploaded in their original sizes can be optionally stored in the photo gallery temp folder.  This is typically done to speed up galleries with large number of images.  The original images in the root folder are replaced with resized versions.</small><br/>
										#html.radioButton(name="moveOriginals",checked=prc.settings.moveOriginals,value=true)# Yes
										#html.radioButton(name="moveOriginals",checked=not prc.settings.moveOriginals,value=false)# No
									</div>
								</div>

								<div class="form-group">
									#html.textField(name="galleryOriginalFolderName", label="Original Folder Name:", value="#prc.settings.galleryOriginalFolderName#", class="form-control")#
								</div>

								<div class="form-group">
									#html.textField(name="conventionGalleryPath", label="Convention Gallery Path:", value="#prc.settings.conventionGalleryPath#", class="form-control")#
								</div>

								#html.endFieldSet()#

								<!--- Button Bar --->
								<div class="form-actions">
									#html.submitButton(value="Save Settings", class="btn btn-danger")#
								</div>

								#html.endForm()#
							</div>

							<!--- Settings: Security --->
							<div class="tab-pane" id="security">
								#html.startForm(action="#cb.buildModuleLink('PhotoGallery',prc.xehSettingsSave)#",name="settingsForm")#
								#html.startFieldset(legend="<i class='icon-lock icon-large'></i> Security")#

								<div class="form-group">
									#html.textField(name="allowedPhotoExtensions", label="Allowed Photo Extensions:", value="#prc.settings.allowedPhotoExtensions#", class="form-control")#
								</div>

								#html.endFieldSet()#

								<!--- Button Bar --->
								<div class="form-actions">
									#html.submitButton(value="Save Settings", class="btn btn-danger")#
								</div>

								#html.endForm()#
							</div>

							<!--- Settings: Paging --->
							<div class="tab-pane" id="paging">
								#html.startForm(action="#cb.buildModuleLink('PhotoGallery',prc.xehSettingsSave)#",name="settingsForm")#
								#html.startFieldset(legend="<i class='icon-sort-by-attributes icon-large'></i> Paging")#

								<div class="form-group">
									#html.textField(name="maxPhotosPerPage", label="Max Photos Per Page:", value="#prc.settings.maxPhotosPerPage#", class="form-control")#
								</div>
								
								<div class="form-group">
									#html.textField(name="maxPhotosPerRow", label="Max Photos Per Row:", value="#prc.settings.maxPhotosPerRow ?: 0#", class="form-control")#
								</div>

								#html.endFieldSet()#

								<!--- Button Bar --->
								<div class="form-actions">
									#html.submitButton(value="Save Settings", class="btn btn-danger")#
								</div>

								#html.endForm()#
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<!--============================ Sidebar ============================-->
		<div class="col-md-3">
			<cfinclude template="../sidebar/actions.cfm" >
			<cfinclude template="../sidebar/help.cfm" >
			<cfinclude template="../sidebar/about.cfm" >
		</div>
	</div>
</cfoutput>
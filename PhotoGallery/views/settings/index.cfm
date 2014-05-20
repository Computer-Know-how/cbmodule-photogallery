<cfoutput>
#renderView( "viewlets/assets" )#
<!--============================Main Column============================-->
<div class="row-fluid">
	<div class="span9" id="main-content">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-magic"></i> Settings
			</div>
			<!--- Body --->
			<div class="body" id="mainBody">
				#getPlugin("MessageBox").renderit()#
				<div class="tabbable tabs-left">
					<ul class="nav nav-tabs">
						<li class="active"><a href="##images" data-toggle="tab"><i class="icon-picture"></i> Images</a></li>

						<li><a href="##folders" data-toggle="tab"><i class="icon-folder-open"></i> Folders</a></li>

						<li><a href="##security" data-toggle="tab"><i class="icon-lock"></i> Security</a></li>

						<li><a href="##paging" data-toggle="tab"><i class="icon-sort-by-attributes"></i> Paging</a></li>
					</ul>

					<div class="tab-content">
						<!--- Settings: Images --->
						<div class="tab-pane active" id="images">
							#html.startForm(action="#cb.buildModuleLink('PhotoGallery',prc.xehSettingsSave)#",name="settingsForm")#
								#html.startFieldset(legend="<i class='icon-picture icon-large'></i> Images (Small)")#

									<div class="alert alert-info clearfix">
										<i class="icon-info-sign icon-large"></i>
										Changing image sizes will not resize gallery images already processed.  Settings will take effect for all images going forward.
									</div>

									#html.textField(name="imageSizeSmallResizeWidth", label="Resize Width:", value="#prc.settings.imageSize.small.resizeWidth#", class="textfield width98", help="This is some help text!")#

									#html.textField(name="imageSizeSmallResizeHeight", label="Resize Height:", value="#prc.settings.imageSize.small.resizeHeight#", class="textfield width98")#

									#html.textField(name="imageSizeSmallCropWidth", label="Crop Width:", value="#prc.settings.imageSize.small.cropWidth#", class="textfield width98")#

									#html.textField(name="imageSizeSmallCropHeight", label="Crop Height:", value="#prc.settings.imageSize.small.cropHeight#", class="textfield width98")#

								#html.endFieldSet()#

								#html.startFieldset(legend="<i class='icon-picture icon-large'></i> Images (Normal)")#

									<div class="alert alert-info clearfix">
										<i class="icon-info-sign icon-large"></i>
										Changing image sizes will not resize gallery images already processed.  Settings will take effect for all images going forward.
									</div>

									#html.textField(name="imageSizeNormalResizeWidth", label="Resize Width:", value="#prc.settings.imageSize.normal.resizeWidth#", class="textfield width98")#

									#html.textField(name="imageSizeNormalResizeHeight", label="Resize Height:", value="#prc.settings.imageSize.normal.resizeHeight#", class="textfield width98")#

									#html.textField(name="imageSizeNormalCropWidth", label="Crop Width:", value="#prc.settings.imageSize.normal.cropWidth#", class="textfield width98")#

									#html.textField(name="imageSizeNormalCropHeight", label="Crop Height:", value="#prc.settings.imageSize.normal.cropHeight#", class="textfield width98")#

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

									#html.textField(name="galleryTempFolderName", label="Temp Folder Name:", value="#prc.settings.galleryTempFolderName#", class="textfield width98")#

									#html.textField(name="gallerySmallFolderName", label="Small Folder Name:", value="#prc.settings.gallerySmallFolderName#", class="textfield width98")#

									#html.textField(name="galleryNormalFolderName", label="Normal Folder Name:", value="#prc.settings.galleryNormalFolderName#", class="textfield width98")#

									<!--- Move Originals --->
									<div class="control-group">
										#html.label(class="control-label",field="moveOriginals",content="Move Originals:")#
										<div class="controls">
											<small>Images uploaded in their original sizes can be optionally stored in the photo gallery temp folder.  This is typically done to speed up galleries with large number of images.  The original images in the root folder are replaced with resized versions.</small><br/>
												#html.radioButton(name="moveOriginals",checked=prc.settings.moveOriginals,value=true)# Yes
												#html.radioButton(name="moveOriginals",checked=not prc.settings.moveOriginals,value=false)# No
										</div>
									</div>

									#html.textField(name="galleryOriginalFolderName", label="Original Folder Name:", value="#prc.settings.galleryOriginalFolderName#", class="textfield width98")#

									#html.textField(name="conventionGalleryPath", label="Convention Gallery Path:", value="#prc.settings.conventionGalleryPath#", class="textfield width98")#

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

									#html.textField(name="allowedPhotoExtensions", label="Allowed Photo Extensions:", value="#prc.settings.allowedPhotoExtensions#", class="textfield width98")#

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

									#html.textField(name="maxPhotosPerPage", label="Max Photos Per Page:", value="#prc.settings.maxPhotosPerPage#", class="textfield width98")#

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
	<div class="span3" id="main-sidebar">
		<cfinclude template="../sidebar/actions.cfm" >
		<cfinclude template="../sidebar/help.cfm" >
		<cfinclude template="../sidebar/about.cfm" >
	</div>
</div>
</cfoutput>
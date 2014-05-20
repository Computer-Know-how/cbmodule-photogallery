<cfoutput>
#renderView( "viewlets/assets" )#
<!--============================Main Column============================-->
<div class="row-fluid">
	<div class="span9" id="main-content">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-list-alt icon-large"></i>
				Photo Gallery
			</div>
			<!--- Body --->
			<div class="body">

				<!--- MessageBox --->
				#getPlugin("MessageBox").renderit()#
				#html.startForm(action="#cb.buildModuleLink('PhotoGallery',prc.xehGalleriesSave)#",name="settingsForm")#
					#html.startFieldset(legend="<i class='icon-camera icon-large'></i> Galleries")#

						<cfif prc.contentFolders.recordCount GT 0>
							<ul class="galleryFolderTree">
							<cfloop query="prc.contentFolders">
								<li>
									<cfset folder = replace(lcase(ReplaceNoCase(Path, prc.mediaRoot, "")),"\","/","all")>

									<cfif folder contains prc.conventionGalleryPath>
										<input type="checkbox" name="galleryFolders" value="#folder#" checked disabled> <strong>#folder#**</strong>
									<cfelse>
										<cfif listFindNoCase(prc.galleryFolders, folder)>
											<input type="checkbox" name="galleryFolders" value="#folder#" checked> #folder#
										<cfelse>
											<input type="checkbox" name="galleryFolders" value="#folder#"> #folder#
										</cfif>
									</cfif>
								</li>
							</cfloop>
							</ul>

							<div class="alert alert-info clearfix">
								<i class="icon-info-sign icon-large"></i>
								<i>**Photo Gallery by conventions folder setting</i>
							</div>
						<cfelse>
							<div class="alert alert-error clearfix">
								<i class="icon-warning-sign icon-large"></i>
								<i>Sorry, no folders to list.  Add folders to your "Media Manager" and then select those folders as galleries here.</i>
							</div>
						</cfif>

					#html.endFieldSet()#

					<cfif prc.contentFolders.recordCount GT 0>
						<!--- Button Bar --->
						<div class="form-actions">
							#html.submitButton(value="Save Galleries", class="btn btn-danger")#
						</div>
					</cfif>

				#html.endForm()#

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
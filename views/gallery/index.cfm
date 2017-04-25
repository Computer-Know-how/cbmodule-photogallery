<cfoutput>
	#renderView( "viewlets/assets" )#
	<!--============================Main Column============================-->
	<div class="row">
		<div class="col-md-12">
			<h1 class="h1">
				<i class="fa fa-list"></i> Photo Gallery
			</h1>
		</div>
	</div>
	<div class="row">
		<div class="col-md-9">
			<div class="panel panel-default">
				<div class="panel-body">
					#getInstance("MessageBox@cbmessagebox").renderit()#

					#html.startForm(action="#cb.buildModuleLink('PhotoGallery',prc.xehGalleriesSave)#",name="settingsForm")#
					#html.startFieldset(legend="<i class='fa fa-camera'></i> Galleries")#

					<cfif prc.contentFolders.recordCount GT 0>
						<ul class="galleryFolderTree" style="padding: 0">
							<cfloop query="prc.contentFolders">
								<li>
									<cfset folder = replace(lcase(ReplaceNoCase(replace(Path,"\","/","all"), prc.mediaRoot, "")),"\","/","all")>

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

						<i>**Photo Gallery by conventions folder setting</i>
					<cfelse>
						<div class="alert alert-warning">
							<i class="fa fa-warning"></i>
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
		<div class="col-md-3">
			<cfinclude template="../sidebar/actions.cfm" >
			<cfinclude template="../sidebar/help.cfm" >
			<cfinclude template="../sidebar/about.cfm" >
		</div>
	</div>
</cfoutput>
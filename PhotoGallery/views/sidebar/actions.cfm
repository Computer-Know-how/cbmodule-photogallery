<cfoutput>
<!--- Info Box --->
<div class="small_box">
	<div class="header">
		<i class="icon-cogs"></i> Actions
	</div>
	<div class="body">
		<!--- Galleries --->
		<button class="btn btn-danger" onclick="return to('#cb.buildModuleLink('PhotoGallery',prc.xehGalleries)#')">Galleries</button>
		<button class="btn" onclick="return to('#cb.buildModuleLink('PhotoGallery',prc.xehSettings)#')">Settings</button>
	</div>
</div>
</cfoutput>
<cfif IsDefined("url.id") AND url.id NEQ "">
	<cfif DirectoryExists("#expandpath('.')#\docs\status\#url.id#") IS FALSE>
		<cfdirectory action="CREATE" directory="#expandpath('.')#\docs\status\#url.id#">
		FOLDER CREATO
	<cfelse>
		FOLDER ESISTENTE	 
	</cfif>
</cfif>

<cfparam name="url.folder" default="knobs">
<cfdirectory name="myicons" action="list" directory="#expandpath('..')#\include\css\icons\#url.folder#">
<cfoutput query="myicons">
	<div style="float:left"><img src="../include/css/icons/#url.folder#/#name#" onclick="doAssegnaIcona('#url.folder#/#name#')"></div>
</cfoutput>
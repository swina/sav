<cfparam name="url.folder" default="">
<cfdirectory name="icons" action="list" directory="#expandpath('.')#\include\\css\icons\#url.folder#">
<cfoutput query="icons">
	<cfif type EQ "file">
		<img src="include/css/icons/#url.folder#/#name#">#name#<br>
	<cfelse>
		<a href="?folder=#name#">#name#</a><br>
		
	</cfif>
</cfoutput>
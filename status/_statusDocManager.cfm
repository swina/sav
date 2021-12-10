<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
<cfparam name="url.folder" default="">
<cfif IsDefined("url.delete")>
	<cfif url.delete NEQ "">
		<cfif FileExists("d:\hosting\sav\docs\status\#url.folder#\#url.delete#")>
			<cffile action="delete" file="d:\hosting\sav\docs\status\#url.folder#\#url.delete#">
		</cfif>
	</cfif>
</cfif>
<cfif url.folder NEQ "">
<body style="overflow:auto">
<table width="100%" cellpadding="2" cellspacing="0" style="overflow:auto">
	<cfdirectory name="qryDocs" action="list" directory="d:\hosting\sav\docs\status\#url.folder#" sort="datelastmodified DESC">
	<cfif qryDocs.recordcount GT 0>
	<cfoutput query="qryDocs">
		<tr>
			<td><a href="http://vm4.indual.it/sav/docs/status/#url.folder#\#name#" target="_blank">#name#</a><br></td>
			<td>#Dateformat(datelastmodified,"dd.mm.yyyy")#</td>
			<td>
			<a href="http://vm4.indual.it/sav/docs/status/#url.folder#\#name#" target="_blank"><img src="../include/css/icons/knobs/action_paste.gif" border="0" alt="Apri" title="Apri"></a>
			</td>
			<td><a href="?delete=#name#&folder=#url.folder#"><img src="../include/css/icons/page_cross.gif" align="absmiddle" title="Cancella documento" style="cursor:pointer"></a></td>
		</tr>
	</cfoutput>
	<cfelse>
		<tr>
			<td align="center">
			<br><br>
			
			<h3>Nessun documento per il cliente selezionato</h3>
			</td>
		</tr>
	</cfif>
</table>
</body>	
</cfif>
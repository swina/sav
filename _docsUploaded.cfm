<!--- <cfinvoke component="crmdemo.docs.docs" method="getFiles" returnvariable="rsFiles">
	<cfinvokeargument name="dir" value="#expandpath('.')#\docs\download">
</cfinvoke>

<cfset docs = false>
<cfset checkDate = DateFormat(now(),"YYYYMMDD")>
<div id="docs" style="display:none;background:#cbe2fe;padding:4px"><strong>Documenti recenti</strong></div>
<table width="100%">
<cfoutput query="rsFiles">
	<cfif dateLastModified GT dateAdd("d",-2,now())>
		<script>
			document.getElementById("docs").style.display = "";
		</script>
		<cfset docs = true>
		<tr>
			<td>#ListGetAt(directory,ListLen(directory,"\"),"\")#</td>
			<td>
			<a href="docs/download/#ListGetAt(directory,ListLen(directory,"\"),"\")#/#name#" target="_blank">#name#</a>
			</td>
			<td>#DateFormat(dateLastModified,"dd.mm.yyyy")#</td>
		</tr>	
	</cfif>
</cfoutput>
</table>
<cfif docs><br>
<br>
</cfif> --->
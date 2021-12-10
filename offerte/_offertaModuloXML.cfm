<cfparam name="url.uuid" default="BD1D3C0E-5056-8B39-7D7A42F96EBAF1E7">
<cfinvoke component="offerte" method="getModulo" returnvariable="qryModulo">
	<cfinvokeargument name="modulo_uuid" value="#url.uuid#">
</cfinvoke>
<cfscript>
	function stripHTML(str) {
		return REReplaceNoCase(str,"<[^>]*>","","ALL");
	}
</cfscript>
<!--- Send the headers --->
<cfheader name="Content-type" value="text/xml">
<cfheader name="Pragma" value="public">
<cfheader name="Cache-control" value="private">
<cfheader name="Expires" value="-1">
<cfsetting enablecfoutputonly="no"><?xml version="1.0" encoding="ISO-8859-1"?>
<rows>
	<cfoutput query="qryModulo">
	<cfset myValore = ListGetAt(valori,currentrow,"|")>
	<cfset myValore = stripHTML(myValore)>
	<cfset myValore = HTMLEditFormat(myValore)>
	<row>
		<cell>#ac_label#</cell>
		<cell style="font-weight:bold"><cfif myValore NEQ "null">#myValore#</cfif></cell>
	</row>
	</cfoutput>
</rows>

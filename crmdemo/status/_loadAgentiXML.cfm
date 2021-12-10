<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfparam name="url.cliente" default="">
<cfquery name="rsAll" datasource="#application.dsn#">
Select 
id_persona,
ac_cognome AS agente
From
tbl_persone
WHERE id_gruppo = 3
ORDER BY  ac_cognome
</cfquery>
<cfset listaColumn = "id_persona,agente">
<cfset ColumnNames = ListToArray(listaColumn)>


<!--- <cfset ColumnNames = ListToArray(rsAll.ColumnList)> --->
<!--- Send the headers --->
<cfheader name="Content-type" value="text/xml">
<cfheader name="Pragma" value="public">
<cfheader name="Cache-control" value="private">
<cfheader name="Expires" value="-1">
<cfsetting enablecfoutputonly="no"><?xml version="1.0" encoding="ISO-8859-1"?>
<rows>
	<cfoutput query="rsAll">
	<row id="#id_persona#">
		<cfloop from="1" to="#ArrayLen(ColumnNames)#" index="index">
		<cfset column = LCase(ColumnNames[index])>
		<cfset value = UCASE(rsAll[column][rsAll.CurrentRow])>
			<cell><![CDATA[#value#]]></cell>
		</cfloop>
	</row>
    </cfoutput>
</rows>
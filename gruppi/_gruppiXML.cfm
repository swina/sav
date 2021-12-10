<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="no">
<!--- Query the database and get all the records --->
<cfset listaColumn = "id_gruppo,id_gruppo_padre,ac_gruppo,int_livello">
<cfinvoke component="gruppi" method="getGruppi" returnvariable="rsAll"></cfinvoke>
<!--- <cfinvoke component="gruppi" method="buildTreeXML" returnvariable="myXML">
	<cfinvokeargument name="data" value="#rsAll#">
	<cfinvokeargument name="cols" value="#listaColumn#">
	<cfinvokeargument name="root" value="Amministratori">
</cfinvoke> --->
<cfset listaColumn = "ac_gruppo">
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
	<row id="#id_gruppo#">
		<userdata name="id_gruppo">#id_gruppo#</userdata>
		<userdata name="id_gruppo_padre">#id_gruppo_padre#</userdata>
		<userdata name="ac_gruppo">#UCASE(ac_gruppo)#</userdata>
		<userdata name="int_livello">#int_livello#</userdata>
		<cfloop from="1" to="#ArrayLen(ColumnNames)#" index="index">
		<cfset column = LCase(ColumnNames[index])>
		<cfset value = UCASE(rsAll[column][rsAll.CurrentRow])>
			<cell style="cursor:pointer"><![CDATA[#value#]]></cell>
		</cfloop>
	</row>
    </cfoutput>
</rows>
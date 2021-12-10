<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfinvoke component="setup" method="getQualificaClienti" returnvariable="rsAll"></cfinvoke>
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
		<userdata name="ac_gruppo">#ac_gruppo#</userdata>
		<userdata name="ac_colore">#ac_colore#</userdata>
		<cfloop from="1" to="#ArrayLen(ColumnNames)#" index="index">
			<cfset column = LCase(ColumnNames[index])>
			<cfset value = UCASE(rsAll[column][rsAll.CurrentRow])>
			<cell style="cursor:pointer"><![CDATA[#value#]]></cell>
		</cfloop>
<!--- 		<cell style="padding:2px;background:###ac_colore#"></cell> --->
		<cell style="cursor:pointer;"><cfif ac_icona EQ "">../include/css/icons/knobs/Knob_ Green.png<cfelse>../include/css/icons/#ac_icona#^Assegna Icona^</cfif></cell>
	</row>
    </cfoutput>
	<row id="0">
		<userdata name="id_gruppo">0</userdata>
		<cell title="Doppio click su questa riga per inserire una nuova qualifica" style="cursor:help"></cell>
		<cell>../include/css/icons/empty.png</cell>
	</row>
</rows>
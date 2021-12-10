<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfinvoke component="setup" method="getProcessi" returnvariable="rsAll"></cfinvoke>
<cfset listaColumn = "ac_processo,ac_sigla,int_prealert,int_postalert">
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
	<row id="#id_processo#">
		<userdata name="id_processo">#id_processo#</userdata>
		<userdata name="int_tipo">#int_tipo#</userdata>
		<userdata name="int_ordine">#int_ordine#</userdata>
		<userdata name="ac_processo">#UCASE(ac_processo)#</userdata>
		<userdata name="ac_sigla">#UCASE(ac_sigla)#</userdata>
		<userdata name="ac_colore">#ac_colore#</userdata>
		<userdata name="int_timer_limit">#int_timer_limit#</userdata>
		<userdata name="int_prealert">#int_prealert#</userdata>
		<userdata name="int_prealert_event">#int_prealert_event#</userdata>
		<userdata name="int_postalert">#int_postalert#</userdata>
		<userdata name="int_postalert_event">#int_postalert_event#</userdata>
		<userdata name="int_status">#int_status#</userdata>
		<userdata name="int_gerarchia">#int_gerarchia#</userdata>	
		<userdata name="ac_permissions">#ac_permissions#</userdata>	
		<cfloop from="1" to="#ArrayLen(ColumnNames)#" index="index">
			<cfset column = LCase(ColumnNames[index])>
			<cfset value = UCASE(rsAll[column][rsAll.CurrentRow])>
			<cell style="cursor:pointer"><![CDATA[#value#]]></cell>
		</cfloop>
		<cell>#bl_alert_admin#</cell>
		<cell>#bl_alert_assegnato#</cell>
		<cell><cfif bl_assegnazione NEQ 0>../include/css/icons/business-contact.png^Il processo prevede l'assegnazione ad un altro utente<cfelse>../include/css/icons/empty.png</cfif></cell>
	</row>
    </cfoutput>
</rows>
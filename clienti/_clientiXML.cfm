<script>
startPage();
</script>
<!--- <cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfinvoke component="clienti" method="getClientiAdvanced" returnvariable="rsCount">
	<cfinvokeargument name="page" value="0">
	<cfinvokeargument name="pagesize" value="27">
	<cfinvokeargument name="searchString" value="">
	<cfinvokeargument name="id_agente" value="-1">
	<cfinvokeargument name="id_qualifica" value="">
	<cfinvokeargument name="ac_pv" value="">
	<cfinvokeargument name="scopo" value=1>
</cfinvoke>
<!--- Query the database and get all the records --->
<cfinvoke component="clienti" method="getClientiAdvanced" returnvariable="rsAll">
	<cfinvokeargument name="page" value="0">
	<cfinvokeargument name="pagesize" value="27">
	<cfinvokeargument name="searchString" value="">
	<cfinvokeargument name="id_agente" value="-1">
	<cfinvokeargument name="id_qualifica" value="">
	<cfinvokeargument name="ac_pv" value="">
	<cfinvokeargument name="scopo" value=0>
</cfinvoke>
<cfset listaColumn = "ac_azienda,ac_cognome,ac_nome,ac_indirizzo,ac_citta,ac_pv">
<cfset ColumnNames = ListToArray(listaColumn)>
<!--- <cfset ColumnNames = ListToArray(rsAll.ColumnList)> --->
<!--- Send the headers --->
<cfheader name="Content-type" value="text/xml">
<cfheader name="Pragma" value="public">
<cfheader name="Cache-control" value="private">
<cfheader name="Expires" value="-1">
<cfsetting enablecfoutputonly="no"><?xml version="1.0" encoding="ISO-8859-1"?>
<rows>
	<userdata name="pagine"><cfoutput>#rsCount#</cfoutput></userdata>
	<cfoutput query="rsAll">
	<row id="#id_cliente#">
		<userdata name="id_cliente">#id_cliente#</userdata>
		<userdata name="id_agente">#id_agente#</userdata>
		<userdata name="ac_azienda">#UCASE(ac_azienda)#</userdata>
		<userdata name="ac_cognome">#UCASE(replace(ac_cognome,"&","e","ALL"))#</userdata>
		<userdata name="ac_nome">#UCASE(ac_nome)#</userdata>
		<userdata name="ac_indirizzo">#UCASE(ac_indirizzo)#</userdata>
		<userdata name="ac_citta">#UCASE(ac_citta)#</userdata>
		<userdata name="ac_pv">#UCASE(ac_pv)#</userdata>
		<userdata name="ac_cap">#UCASE(ac_cap)#</userdata>
		<userdata name="ac_telefono">#ac_telefono#</userdata>
		<userdata name="ac_cellulare">#ac_cellulare#</userdata>
		<userdata name="ac_email">#ac_email#</userdata>
		<cfloop from="1" to="#ArrayLen(ColumnNames)#" index="index">
		<cfset column = LCase(ColumnNames[index])>
		<cfset value = UCASE(rsAll[column][rsAll.CurrentRow])>
			<cell title="#UCASE(ac_indirizzo)# - #UCASE(ac_citta)# [#ac_telefono# - #ac_cellulare#]" style="cursor:pointer"><![CDATA[#replace(value,"''","'","ALL")#]]></cell>
		</cfloop>
			<cell style="cursor:pointer;"><cfif id_agente EQ 0>../include/css/icons/flag.png^Assegna Commerciale^javascript:doAssignSales()<cfelse>../include/css/icons/check.png^ASSEGNATO</cfif></cell>
			<cell style="cursor:pointer;"><cfif ac_icona NEQ "">../include/css/icons/#ac_icona#^#qualifica#</cfif></cell>
	</row>
    </cfoutput>
</rows> --->
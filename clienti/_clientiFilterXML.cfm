<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfparam name="url.search" default="">
<cfparam name="url.id_agente" default="-1">
<cfparam name="url.id_gruppo" default="1">
<cfparam name="url.pv" default="null">
<cfparam name="url.bl_attivo" default="1">
<cfparam name="url.startpage" default="0">
<cfparam name="url.pagesize" default="27">
<cfparam name="url.import" default="1">
<cfparam name="url.id_agente_assegnato" default="">
<cfparam name="url.dFrom" default="">
<cfparam name="url.dTo" default="">
<cfparam name="url.fornitore" default="lgi">

<!--- Query the database and get all the records --->
<cfinvoke component="clienti" method="getClientiAdvanced" returnvariable="numOfRecords">
	<cfinvokeargument name="page" value="#url.startpage#">
	<cfinvokeargument name="pagesize" value="#url.pagesize#">
	<cfinvokeargument name="searchString" value="#url.search#">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="id_qualifica" value="#url.id_gruppo#">
	<cfinvokeargument name="ac_pv" value="#url.pv#">
	<cfinvokeargument name="bl_attivo" value="#url.import#">
	<cfinvokeargument name="id_agente_assegnato" value="#url.id_agente_assegnato#">
	<cfinvokeargument name="dFrom" value="#url.dFrom#">
	<cfinvokeargument name="dTo" value="#url.dTo#">
	<cfinvokeargument name="fornitore" value="#url.fornitore#">
	<cfinvokeargument name="fornitore_search" value="#url.fornitore_search#">
	<cfinvokeargument name="scopo" value=1>
</cfinvoke>
<cfinvoke component="clienti" method="getClientiAdvanced" returnvariable="rsAll">
	<cfinvokeargument name="page" value="#url.startpage#">
	<cfinvokeargument name="pagesize" value="#url.pagesize#">
	<cfinvokeargument name="searchString" value="#url.search#">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="id_qualifica" value="#url.id_gruppo#">
	<cfinvokeargument name="ac_pv" value="#url.pv#">
	<cfinvokeargument name="bl_attivo" value="#url.import#">
	<cfinvokeargument name="id_agente_assegnato" value="#url.id_agente_assegnato#">
	<cfinvokeargument name="dFrom" value="#url.dFrom#">
	<cfinvokeargument name="dTo" value="#url.dTo#">
	<cfinvokeargument name="fornitore" value="#url.fornitore#">
	<cfinvokeargument name="fornitore_search" value="#url.fornitore_search#">
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
	<cfif rsAll.recordcount GT 0>
	<userdata name="pagine"><cfoutput>#numOfRecords#</cfoutput></userdata>
	<cfoutput query="rsAll">
	<row id="#id_cliente#">
		<userdata name="id_cliente">#id_cliente#</userdata>
		<userdata name="id_agente">#id_agente#</userdata>
		<userdata name="ac_azienda"><![CDATA[#UCASE(ac_azienda)#]]></userdata>
		<userdata name="ac_cognome"><![CDATA[#UCASE(ac_cognome)#]]></userdata>
		<userdata name="ac_nome"><![CDATA[#UCASE(ac_nome)#]]></userdata>
		<userdata name="ac_indirizzo"><![CDATA[#UCASE(ac_indirizzo)#]]></userdata>
		<userdata name="ac_citta"><![CDATA[#UCASE(ac_citta)#]]></userdata>
		<userdata name="ac_pv"><![CDATA[#UCASE(ac_pv)#]]></userdata>
		<userdata name="ac_cap"><cfif ac_cap NEQ "">#UCASE(ac_cap)#</cfif></userdata>
		<userdata name="ac_telefono"><![CDATA[#ac_telefono#]]></userdata>
		<userdata name="ac_cellulare"><![CDATA[#ac_cellulare#]]></userdata>
		<userdata name="ac_email"><![CDATA[#ac_email#]]></userdata>
		<userdata name="ac_segnalatore"><![CDATA[#ac_segnalatore#]]></userdata>
<!--- 		<cell><cfif dt_data_registrazione NEQ "">#DateFormat(dt_data_registrazione,"dd.mm.yyyy")#</cfif></cell> --->
		<cell title="" style="cursor:pointer"><cfif ac_azienda NEQ ""><![CDATA[#UCASE(ac_azienda)#]]><cfelse><![CDATA[#UCASE(ac_cognome)# #UCASE(ac_nome)#]]></cfif></cell>
		<cell title="" style="cursor:pointer"><![CDATA[#UCASE(ac_indirizzo)#]]></cell>
		<cell title="" style="cursor:pointer"><![CDATA[#UCASE(ac_citta)#]]></cell>
		<cell title="" style="cursor:pointer"><![CDATA[#UCASE(ac_pv)#]]></cell>
<!--- 		<cfloop from="1" to="#ArrayLen(ColumnNames)#" index="index">
		<cfset column = LCase(ColumnNames[index])>
		<cfset value = UCASE(rsAll[column][rsAll.CurrentRow])>
			<cell title="#UCASE(ac_indirizzo)# - #UCASE(ac_citta)# [#ac_telefono# - #ac_cellulare#]" style="cursor:pointer"><![CDATA[#value#]]></cell>
		</cfloop> --->
			<cell style="cursor:pointer;"><cfif id_agente EQ 0>../include/css/icons/flag.png^Assegna Commerciale<cfelse>../include/css/icons/check.png^ASSEGNATO</cfif></cell>
			<cell style="cursor:pointer;"><cfif ac_icona NEQ "">../include/css/icons/#ac_icona#^#qualifica#</cfif></cell>
			<cell><![CDATA[#UCASE(agente)#]]></cell>
			<cell><cfif dt_data_registrazione NEQ ""><![CDATA[#DateFormat(dt_data_registrazione,"dd.mm.yyyy")#]]></cfif></cell>
			<cell style="cursor:pointer"><![CDATA[#UCASE(ac_segnalatore)#]]></cell>
	</row>
    </cfoutput>
	<cfelse>
		<userdata name="pagine">0</userdata>
		<row id="0">
			<cell></cell>
			<cell></cell>
			<cell></cell>
			<cell></cell>
			<cell>../include/css/icons/empty.png</cell>
			<cell></cell>
			<cell></cell>
			<cell></cell>
			<cell></cell>
		</row>
	</cfif>
	
</rows>
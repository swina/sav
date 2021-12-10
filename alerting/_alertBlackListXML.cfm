<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfparam name="url.dateFrom" default="#DateFormat(DateAdd('d',-30,now()),'dd/mm/yyyy')#">
<cfparam name="url.dateTo" default="#DateFormat(now(),'dd/mm/yyyy')#">
<cfparam name="url.id_gruppo_agenti" default="">
<cfparam name="url.id_agente" default="">
<cfparam name="url.id_processo" default="">

<cfinvoke component="alert" method="blackList" returnvariable="rsAll">
	<cfinvokeargument name="dateFrom" value="#dateFrom#">
	<cfinvokeargument name="dateTo" value="#dateTo#">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
	<cfinvokeargument name="id_processo" value="#url.id_processo#">
</cfinvoke>
<cfinvoke component="alert" method="tutors" returnvariable="rsTutors"></cfinvoke>
<cfset listaTutorsID = ValueList(rsTutors.id_persona)>
<cfset listaTutors = ValueList(rsTutors.ac_cognome)>

<cfset dt_riferimento = CreateDate(ListGetAt(dateTo,3,"/"),ListGetAt(dateTo,2,"/"),ListGetAt(dateTo,1,"/"))>
<!--- Send the headers --->
<cfheader name="Content-type" value="text/xml">
<cfheader name="Pragma" value="public">
<cfheader name="Cache-control" value="private">
<cfheader name="Expires" value="-1">
<cfsetting enablecfoutputonly="no"><?xml version="1.0" encoding="ISO-8859-1"?>
<rows>
	<cfoutput query="rsAll" group="int_ordine">
	<row style="background:###ac_colore#" id="#ac_processo#">
		<userdata name="id_status">#id_status#</userdata>
		<userdata name="ac_modulo_uuid">#ac_modulo_uuid#</userdata>
		<cell style="font-weight:bold;background:###ac_colore#">#ac_processo#</cell>
		<cell></cell>
		<cell></cell>
		<cell></cell>
		<cell></cell>
		<cell></cell>
		<cell>../include/css/icons/empty.png</cell>
		<cell></cell>
		
	</row>
	<cfoutput group="data_status">
	<row>
		<userdata name="id_status">#id_status#</userdata>
		<userdata name="ac_modulo_uuid">#ac_modulo_uuid#</userdata>
		<cell></cell>
		<cell style="font-weight:bold;<cfif dt_status LT DateAdd('d',-3,dt_riferimento)>color:red</cfif>">#data_status# </cell>
		<cell></cell>
		<cell></cell>
		<cell></cell>
		<cell></cell>
		<cell>../include/css/icons/empty.png</cell>
		<cell></cell>
	</row>	
	<cfoutput>
	<cfset assegnato_a = "non assegnato">
	<row>
		<userdata name="ac_modulo_uuid">#ac_modulo_uuid#</userdata>
		<userdata name="id_status">#id_status#</userdata>
		<cell></cell>
		<cell></cell>
		<cell>#ora_status#</cell>
		<cell>#UCASE(agente)#</cell>
		<cell>#UCASE(ac_cognome)# #UCASE(ac_nome)#</cell>
		<cell>#gruppo#</cell>
	</row>	
	</cfoutput>
	</cfoutput>
    </cfoutput>
</rows>
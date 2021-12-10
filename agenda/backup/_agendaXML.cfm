<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfparam name="url.id_agente" default="">
<cfparam name="url.id_gruppo_agenti" default="">
<cfparam name="url.soloagente" default=0>

<cfinvoke component="agenda" method="events" returnvariable="rsAll">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
	<cfinvokeargument name="soloagente" value="#url.soloagente#">
</cfinvoke>
<cfset listaColumn = "ac_processo,dt_status,ac_cognome,ac_nome">
<cfset ColumnNames = ListToArray(listaColumn)>
<!--- <cfset ColumnNames = ListToArray(rsAll.ColumnList)> --->
<!--- Send the headers --->
<cfheader name="Content-type" value="text/xml">
<cfheader name="Pragma" value="public">
<cfheader name="Cache-control" value="private">
<cfheader name="Expires" value="-1">
<cfsetting enablecfoutputonly="no"><?xml version="1.0" encoding="ISO-8859-1"?>
<data>
	<cfoutput query="rsAll">
	<cfset endDate = DateAdd("H",1,dt_status)>
	<userdata name="id_cliente">#id_cliente#</userdata>
	<event id="#id_status#">
		<start_date>#DateFormat(dt_status,"mm-dd-yyyy")# #TimeFormat(dt_status,"HH:MM")#</start_date>
		<end_date>#DateFormat(endDate,"mm-dd-yyyy")# #TimeFormat(endDate,"HH:MM")#</end_date>
		<text>#ac_sigla# - #UCASE(ac_cognome)# #UCASE(ac_nome)# <cfif session.livello LT 3 OR url.soloagente EQ 0>[#UCASE(agente)#]</cfif></text>
		<details><![CDATA[#UCASE(ac_indirizzo)# #UCASE(ac_citta)#]]></details>
	</event>
	</cfoutput>
</data>

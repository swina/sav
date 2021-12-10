<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfparam name="url.dateFrom" default="#DateFormat(DateAdd('d',-7,now()),'dd/mm/yyyy')#">
<cfparam name="url.dateTo" default="#DateFormat(DateAdd('d',7,now()),'dd/mm/yyyy')#">
<cfparam name="url.metodo" default="processiInCorso">
<cfparam name="url.id_gruppo_agenti" default="">
<cfparam name="url.id_agente" default="">
<cfparam name="url.start_processo" default="">
<cfparam name="url.end_processo" default="">

<!--- Query the database and get all the records --->
<cfinvoke component="analisi" method="#url.metodo#" returnvariable="rsAll">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
	<cfinvokeargument name="start_processo" value="#url.start_processo#">
	<cfinvokeargument name="end_processo" value="#url.end_processo#">
</cfinvoke>
<cfinvoke component="analisi" method="calcola_giorni" returnvariable="ngiorni">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
</cfinvoke>
<cfset listaColumn = "ac_processo,nrprocessi,agenti">
<cfset ColumnNames = ListToArray(listaColumn)>
<!--- Send the headers --->
<cfheader name="Content-type" value="text/xml">
<cfheader name="Pragma" value="public">
<cfheader name="Cache-control" value="private">
<cfheader name="Expires" value="-1">
<cfsetting enablecfoutputonly="no"><?xml version="1.0" encoding="ISO-8859-1"?>
<rows>
	<cfoutput query="rsAll">
	<row id="#ac_processo#">
		<cell>#ac_processo#</cell>
		<cell>#nrprocessi#</cell>
		<cell>#ngiorni#</cell>
		<cell title="indice operativo">#NumberFormat(nrprocessi/agenti,"999.99")#</cell>
		<cell title="media giornaliera">#NumberFormat(nrprocessi/ngiorni,"999.99")#</cell>
	</row>
    </cfoutput>
</rows>
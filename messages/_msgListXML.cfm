<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfparam name="url.dateFrom" default="#DateFormat(DateAdd('d',-30,now()),'dd/mm/yyyy')#">
<cfparam name="url.dateTo" default="#DateFormat(now(),'dd/mm/yyyy')#">
<cfparam name="url.id_gruppo_agenti" default="">
<cfparam name="url.id_agente" default="">
<cfparam name="url.id_processo" default="">
<cfparam name="url.tutti" default="true">

<cfif url.id_gruppo_agenti EQ 0>
	<cfset url.id_gruppo_agenti = "">
</cfif>
<cfif url.id_agente EQ 0>
	<cfset url.id_agente = "">
</cfif>

<cfinvoke component="msg" method="getMsg" returnvariable="rsAll">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
	<cfinvokeargument name="tutti" value="#url.tutti#">
</cfinvoke>
<!--- <cfinvoke component="alert" method="tutors" returnvariable="rsTutors"></cfinvoke> --->
<!--- <cfset listaTutorsID = ValueList(rsTutors.id_persona)>
<cfset listaTutors = ValueList(rsTutors.ac_cognome)>

<cfset dt_riferimento = CreateDate(ListGetAt(dateTo,3,"/"),ListGetAt(dateTo,2,"/"),ListGetAt(dateTo,1,"/"))> --->
<!--- Send the headers --->
<cfheader name="Content-type" value="text/xml">
<cfheader name="Pragma" value="public">
<cfheader name="Cache-control" value="private">
<cfheader name="Expires" value="-1">
<cfsetting enablecfoutputonly="no"><?xml version="1.0" encoding="ISO-8859-1"?>
<rows>
	<cfoutput query="rsAll">
	<row id="#id_message#">
		<userdata name="id_message">#id_message#</userdata>
		<userdata name="msgDate">#DateFormat(dt_message,'dd.mm.yyyy')# #DateFormat(dt_message,"HH:MM")#</userdata>
		<userdata name="msgTo"><cfif id_to NEQ -1><cfif ac_gruppo EQ "">#ac_cognome#<cfelse>#ac_gruppo#</cfif><cfelse>Tutti</cfif></userdata>
		<userdata name="msgSubject">#ac_subject#</userdata>
		<userdata name="msgText">#ac_message#</userdata>
		<cell>#DateFormat(dt_message,'dd.mm.yyyy')#</cell>
		<cell>#DateFormat(dt_message,"HH:MM")#</cell>
		<cell><cfif id_to NEQ -1><cfif ac_gruppo EQ "">#ac_cognome#<cfelse>#ac_gruppo#</cfif><cfelse>Tutti</cfif></cell>
		<cell>#ac_subject#</cell>
		<cell>#ac_message#</cell>
	</row>
    </cfoutput>
</rows>
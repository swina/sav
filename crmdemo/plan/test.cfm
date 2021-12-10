<cfparam name="url.dateFrom" default="#DateFormat(now(),'dd/mm/yyyy')#">
<cfparam name="url.dateTo" default="#DateFormat(DateAdd('d',7,now()),'dd/mm/yyyy')#">
<cfparam name="url.id_gruppo_agenti" default="5">
<cfparam name="url.id_agente" default="">
<cfparam name="url.id_processo" default="">
<cfsetting showdebugoutput="yes">
<cfinvoke component="plan" method="plan" returnvariable="rsAll">
	<cfinvokeargument name="dateFrom" value="#dateFrom#">
	<cfinvokeargument name="dateTo" value="#dateTo#">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
	<cfinvokeargument name="id_processo" value="#url.id_processo#">
</cfinvoke>
<cfoutput query="rsAll">
#id_status#<br>
</cfoutput>
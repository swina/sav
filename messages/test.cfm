<!--- <cfparam name="url.dateFrom" default="#DateFormat(DateAdd('d',-30,now()),'dd/mm/yyyy')#">
<cfparam name="url.dateTo" default="#DateFormat(now(),'dd/mm/yyyy')#">
<cfparam name="url.id_gruppo_agenti" default="">
<cfparam name="url.id_agente" default="">
<cfparam name="url.id_processo" default="">
<cfsetting showdebugoutput="yes">
<cfinvoke component="alert" method="blackListMail" returnvariable="rsAll">
	<cfinvokeargument name="dateFrom" value="#dateFrom#">
	<cfinvokeargument name="dateTo" value="#dateTo#">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
	<cfinvokeargument name="id_processo" value="#url.id_processo#">
</cfinvoke>
<style>
TD, .testo { font-family:Verdana,Arial,Helvetica ; font-size:12px ; padding:3px; }
</style>
<cfoutput query="rsAll" group="mailto">
<div class="testo">
A: <strong>#mailto#</strong><br>
Da : <strong>elena.galeotti@savenergy.it</strong><br>

Gentile Utente,
a tutt'oggi risultano ancora aperte nello status alcune azioni che richiedono un'aggiornamento come da seguente lista :<br>
	<table width="500">
		<tr>
			<td><strong>Cliente</strong></td>
			<td><strong>Azione</strong></td>
			<td><strong>Scaduto</strong></td>
		</tr>
	<cfoutput group="id_processo">
		
	<cfoutput>
	<tr>
		<td class="testo">#UCASE(ac_azienda)#</td>
		<td class="testo" style="background:###ac_colore#">#ac_processo#</td>
		<td class="testo">#data_status#</td>
	</tr>
	</cfoutput>
	</cfoutput>
	</table>
	<br>
	Direzione Commerciale<br>
	SAVEnergy
</div>	
	
<hr>	
</cfoutput> --->

<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="yes">
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
<cfdump var="#rsAll#">
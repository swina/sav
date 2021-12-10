<!--- <cfparam name="url.dateFrom" default="#DateFormat(DateAdd('d',-30,now()),'dd/mm/yyyy')#">
<cfparam name="url.dateTo" default="#DateFormat(now(),'dd/mm/yyyy')#">
<cfparam name="url.id_gruppo_agenti" default="">
<cfparam name="url.id_agente" default="265">
<cfparam name="url.id_processo" default="">
<cfinvoke component="alerting.alert" method="blackList" returnvariable="rsAllAlerting">
	<cfinvokeargument name="dateFrom" value="#dateFrom#">
	<cfinvokeargument name="dateTo" value="#dateTo#">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
	<cfinvokeargument name="id_processo" value="#url.id_processo#">
</cfinvoke>
<cfdump var="#rsAllAlerting#"> --->
<cfsetting showdebugoutput="yes">
<!--- <cfquery name="allCustomers" datasource="#application.dsn#">
SELECT id_cliente FROM tbl_clienti_work WHERE bl_cancellato = 0 AND bl_attivo = 1 AND id_cliente > 27700 GROUP BY id_cliente ORDER BY id_cliente LIMIT 0 , 300
</cfquery>
<cfoutput query="allCustomers">
#id_cliente#
	<cfquery name="isStatus" datasource="#application.dsn#">
	SELECT id_cliente FROM tbl_status WHERE id_cliente = #id_cliente#
	</cfquery>
	<cfif isStatus.recordcount EQ 0>
	<cfquery name="update" datasource="#application.dsn#">
	UPDATE tbl_clienti_work SET bl_cancellato = 1 WHERE id_cliente = #id_cliente#
	</cfquery>
	NOT FOUND !!!</cfif> 
	<br>
</cfoutput> --->
<cfquery name="delete" datasource="#application.dsn#">
DELETE FROM tbl_clienti_work WHERE bl_cancellato = 1
</cfquery>
<!--- <cfif rsAllAlerting.recordcount GT 0>
	<cfset session.noOfferte = true>
</cfif> --->
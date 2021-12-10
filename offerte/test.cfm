<cfparam name="url.dateFrom" default="#DateFormat(DateAdd('d',-60,now()),'dd/mm/yyyy')#">
<cfparam name="url.dateTo" default="#DateFormat(DateAdd('d',7,now()),'dd/mm/yyyy')#">
<cfparam name="url.cliente" default="">
<cfparam name="url.id_gruppo_agenti" default="">
<cfparam name="url.id_agente" default="">
<cfparam name="url.id_processo" default="">
<cfparam name="url.id_persona" default="">
<cfparam name="url.noOfferte" default=true>
<cfsetting showdebugoutput="yes">
<cfinvoke component="offerte" method="plan" returnvariable="rsAll">
	<cfinvokeargument name="dateFrom" value="#dateFrom#">
	<cfinvokeargument name="dateTo" value="#dateTo#">
	<cfinvokeargument name="ac_cliente" value="#url.cliente#">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
	<cfinvokeargument name="id_processo" value="#url.id_processo#">
	<cfinvokeargument name="id_persona" value="#url.id_persona#">
	<cfinvokeargument name="noOfferte" value="#url.noOfferte#">
</cfinvoke>
<cfoutput query="rsAll">
#id_status# #id_processo# #ac_processo# #ac_cognome#<br>
</cfoutput>
<!---  ---> 
<!--- <cfparam name="url.dateFrom" default="#DateFormat(DateAdd('d',-60,now()),'dd/mm/yyyy')#">
<cfparam name="url.dateTo" default="#DateFormat(DateAdd('d',7,now()),'dd/mm/yyyy')#">
<cfparam name="url.cliente" default="">
<cfparam name="url.id_gruppo_agenti" default="">
<cfparam name="url.id_agente" default="">
<cfparam name="url.id_processo" default="">
<cfparam name="url.id_persona" default="">
<cfparam name="url.noOfferte" default=true>
<cfsetting showdebugoutput="yes">
<cfinvoke component="offerte" method="plan" returnvariable="rsAll">
	<cfinvokeargument name="dateFrom" value="#dateFrom#">
	<cfinvokeargument name="dateTo" value="#dateTo#">
	<cfinvokeargument name="ac_cliente" value="#url.cliente#">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
	<cfinvokeargument name="id_processo" value="#url.id_processo#">
	<cfinvokeargument name="id_persona" value="#url.id_persona#">
	<cfinvokeargument name="noOfferte" value="#url.noOfferte#">
</cfinvoke>
<cfoutput query="rsAll" group="id_cliente">
	
	#bl_evasa# > #id_processo# > #data_status# #agente# <strong>#ac_cognome#</strong> #assegnato#<br>
	
	
</cfoutput>
 ---> 
 <!---
 <cfquery name="getPresentazioni" datasource="#application.dsn#">
SELECT tbl_status.id_Processo , tbl_status.id_cliente , tbl_status.dt_status, tbl_status.id_status , tbl_status.bl_evasa , tbl_clienti.ac_cognome 
FROM tbl_status 
INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
WHERE (tbl_status.id_processo = 9 OR tbl_status.id_processo = 6) AND tbl_status.dt_status > #DateAdd("d",-30,now())# 
ORDER BY tbl_status.id_cliente, dt_status ASC
</cfquery>

<cfoutput query="getPresentazioni" group="id_cliente">
	#ac_cognome# #id_cliente# <br>
	<ul>
	<cfset lastProc = 0>
	<cfset lastEvasa = -1>
	<cfoutput>
		<cfset lastProc = id_processo>
		<cfif id_processo EQ 6>
			<cfset lastEvasa = bl_evasa>
			<cfset statusUpdate = id_status>
		</cfif>
		[<strong>#id_status#</strong>] > [#id_processo#] [#dt_status#] [#bl_evasa#] (#lastEvasa#)<br>
	</cfoutput>
	<cfif lastProc EQ 9 AND lastEvasa NEQ -1 AND lastEvasa EQ 0>
		<!--- <cfquery name="updateStatus" datasource="#application.dsn#">
		UPDATE tbl_status SET bl_evasa = 1 WHERE id_status = #statusUpdate#
		</cfquery> --->
		[AGGIORNARE <strong>#statusUpdate#</strong>]<br>
	<cfelse>
		<br>
			
	</cfif>
	
	</ul>
	<hr>

<!--- 	<cfquery name="getRichieste" datasource="#application.dsn#">
		SELECT id_status , dt_status FROM tbl_status WHERE id_cliente = #id_cliente# AND id_processo = 6
	</cfquery> --->
	<!--- <cfset data_nuova = CreateDateTime(year(dt_status),month(dt_status),day(dt_status),hour(dt_status),minute(dt_status),0)>
	<cfquery name="updateRichiesta" datasource="#application.dsn#">
		UPDATE tbl_status SET dt_next_status = #data_nuova# WHERE id_cliente = #id_cliente# AND id_processo = 6
	</cfquery> --->
	<!--- [#getRichieste.dt_status# -> #getRichieste.id_status#]<br> --->
	
<!--- 	<cfquery name="updateOfferte" datasource="#application.dsn#">
	UPDATE tbl_status SET bl_evasa = 1 WHERE id_cliente = #id_cliente# AND id_processo = 6
	</cfquery> --->
</cfoutput> --->

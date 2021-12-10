<cfsetting showdebugoutput="yes">
<cfsetting enablecfoutputonly="no">
<cfparam name="from" default="#CreateDate(year(now()),month(now())-3,day(now()))#">
<cfparam name="to" default="#CreateDate(year(now()),month(now()),day(now()))#">
<cfif IsDefined("url.dateFrom") AND url.dateFrom NEQ "">
	<cfset from = CreateDate(ListGetAt(url.dateFrom,3,"/"),ListGetAt(url.dateFrom,2,"/"),ListGetAt(url.dateFrom,1,"/"))>
	<cfset to = CreateDate(ListGetAt(url.dateTo,3,"/"),ListGetAt(url.dateTo,2,"/"),ListGetAt(url.dateTo,1,"/"))>
</cfif>
<cfquery name="getContratti" datasource="#application.dsn#">
SELECT * FROM (SELECT
			tbl_processi.ac_processo,
			tbl_persone.ac_cognome,
			tbl_persone.ac_nome,
			tbl_clienti.ac_azienda,
			tbl_status.*
			FROM tbl_status
			Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
			Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona)
AS Verifica			
WHERE 
	(dt_status >= #from# AND dt_status <= #to#)
	AND
	id_processo = 7

</cfquery>


<style>
TD { border-bottom:1px solid #eaeaea}
</style>
<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
<!---  ---> 
<body style="overflow:auto">
<div align="center">
<cfset ncount = 0>
<cfset naltri = 0>
<cfset perc = 0>
<cfset perc2 = 0>
<cfset ids = 0>
<cfoutput query="getContratti">
	
	<cfquery name="getProcessi" datasource="#application.dsn#">
	SELECT * FROM tbl_status WHERE
		id_processo = 8
		AND 
		id_cliente = #id_cliente#
	</cfquery>
	<cfif getProcessi.recordcount EQ 0>
	<!--- #id_cliente#<br> --->
	<cfquery name="getStatus" datasource="#application.dsn#">
	SELECT 
	tbl_processi.ac_processo,	
	tbl_status.*,
	tbl_clienti.ac_azienda,
	tbl_clienti.ac_segnalatore,
	tbl_persone.ac_cognome
	FROM tbl_status
	INNER JOIN tbl_processi ON tbl_status.id_processo = tbl_processi.id_processo 
	INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
	INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
	 WHERE tbl_status.id_cliente = #id_cliente#
	</cfquery>
		<cfloop query="getStatus">
			<cfif id_processo EQ 7 AND ids NEQ id_status>
				<cfset ncount = ncount + 1>
			</cfif>
			<cfset ids = id_status>
		</cfloop>
	<!--- <cfdump var="#getStatus#"> --->
	<cfelse>
		<cfset naltri = naltri + 1>
	<!---<cfdump var="#getProcessi#"> --->
	</cfif>
	
	
</cfoutput>
<cfif ncount GT 0>
	<cfset perc = (ncount /getContratti.recordcount)*100>
</cfif>
<cfif naltri GT 0>
<cfset perc2 = (naltri/getContratti.recordcount)*100>
</cfif>

<table width="100%" cellspacing="0" cellpadding="2" style="border:1px solid #eaeaea">
	<tr>
		<td colspan="8">
		<strong>ANALISI 1° APPUNTAMENTO - CONTRATTO </strong> Periodo : <cfoutput><strong>#url.dateFrom# - #url.DateTo#</strong>
		<!--- &nbsp;&nbsp;&nbsp;<img src="../include/css/icons/files/xls.png" onclick="createExcel('#url.startprocesso#','#url.dateFrom#','#url.dateTo#')" style="cursor:pointer" title="Crea Excel"> ---></cfoutput>
		</td>
	</tr>
	<tr bgcolor="#eaeaea">
		<td>1° APPUNTAMENTO - CONTRATTO</td>
		<td></td>
		<td>+APPUNTAMENTI - CONTRATTO</td>
		<td></td>
		<td></td>
	</tr>
	<cfoutput>
	<tr>
		<td>#ncount# </td>
		<td><img src="../include/css/dot-trasp.png" width="#int(perc)#" height="10" align="absmiddle" style="background:green;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-int(perc)#" height="10" align="absmiddle" style="background:white;border:1px solid black"> (#decimalFormat(perc)#)</td>
		<td>#naltri# </td>
		<td><img src="../include/css/dot-trasp.png" width="#int(perc2)#" height="10" align="absmiddle" style="background:green;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-int(perc2)#" height="10" align="absmiddle" style="background:white;border:1px solid black"></td>
		<td><a href="_1app-contratto_dettaglio.cfm?dateFrom=#url.dateFrom#&dateTo=#url.dateTo#" target="detailFrame"><input type="button" class="btn" value="Dettaglio"></a></td>
	</tr>
	</cfoutput>
</table>
</div>
</body>

<cfsetting showdebugoutput="yes">
<cfsetting enablecfoutputonly="no">
<cfparam name="from" default="#CreateDate(year(now()),month(now())-3,day(now()))#">
<cfparam name="to" default="#CreateDate(year(now()),month(now()),day(now()))#">
<cfparam name="id_gruppo" default="">
<cfparam name="id_agente" default="">

<script>
function createExcelThis(params){
	document.getElementById("excel_detail").src = "_1app-contratto_dettaglio_XLS.cfm?"+ params;
}
</script>

<cfif IsDefined("url.dateFrom") AND url.dateFrom NEQ "">
	<cfset from = CreateDate(ListGetAt(url.dateFrom,3,"/"),ListGetAt(url.dateFrom,2,"/"),ListGetAt(url.dateFrom,1,"/"))>
	<cfset to = CreateDate(ListGetAt(url.dateTo,3,"/"),ListGetAt(url.dateTo,2,"/"),ListGetAt(url.dateTo,1,"/"))>
</cfif>

<cfif url.id_gruppo_agenti NEQ "">
	<cfset id_gruppo = url.id_gruppo_agenti>
</cfif>

<cfif url.id_agente NEQ "">
	<cfset id_agente = url.id_agente>
</cfif>

<cfquery name="getContratti" datasource="#application.dsn#">
SELECT * FROM (SELECT
			tbl_processi.ac_processo,
			tbl_persone.ac_cognome,
			tbl_persone.ac_nome,
			tbl_persone.id_gruppo,
			tbl_clienti.ac_azienda,
			tbl_clienti.id_agente,
			tbl_status.*,
			tbl_gruppi.ac_gruppo
			FROM tbl_status
			Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
			Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
			ORDER BY tbl_persone.id_gruppo, ac_cognome
			)
AS Verifica			
WHERE 
	(dt_status >= #from# AND dt_status <= #to#)
	AND
	id_processo = 7
	<cfif id_gruppo NEQ "">
		AND
		id_gruppo = #id_gruppo#
	</cfif>
	<cfif id_agente NEQ "">
		AND
		id_agente = #id_agente#
	</cfif>
</cfquery>
<style>
TD { border-bottom:1px solid #eaeaea}
</style>
<script language="JavaScript" type="text/javascript">
function viewDetail(obj){
	document.getElementById(obj).style.display = "";
}
</script>
<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
<cfset ncount = 0>
<cfset naltri = 0>
<cfset myHTML = "">
<cfset idp = 0>
<cfset idc = 0>
<cfset ids = 0>
<cfset perc = 0>
<cfset perc2 = 0>
<cfset nSAV = 0>
<cfset nEXTRA = 0>
<cfset nSAVAgente = 0>
<cfset nExtraAgente = 0>
<cfset nGiorniTotali = 0>
<cfset nMediaGiorni = 0>
<cfset totali = 0>
<cfset thisAgente = 0>
<cfset totale_agente = 0>
<cfset totale_giorni_agente = 0>
<cfset myData = "">
<cfset myHTML = "<tr bgcolor='##eaeaea'><td></td><td><strong>GRUPPO</strong></td><td><strong>AGENTE</strong></td><td><strong>CLIENTE</strong></td><td><strong>CONTATTO</strong></td><td><strong>DATA</strong></td><td><strong>GG.</strong></td></tr>">
<body style="overflow:auto">
<cfif getContratti.recordcount GT 0>
<cfoutput query="getContratti">
	<cfquery name="getProcessi" datasource="#application.dsn#">
	SELECT tbl_status.id_cliente
	 FROM tbl_status WHERE
		id_processo = 2
		AND 
		id_cliente = #id_cliente#
	</cfquery>
	

	<cfif getProcessi.recordcount GT 0>

	<!--- #id_cliente#<br> --->
	<cfquery name="getStatus" datasource="#application.dsn#">
	SELECT 
	tbl_processi.ac_processo,	
	tbl_status.*,
	tbl_clienti.ac_azienda,
	tbl_clienti.ac_segnalatore,
	tbl_persone.ac_cognome,
	tbl_gruppi.ac_gruppo
	FROM tbl_status
	INNER JOIN tbl_processi ON tbl_status.id_processo = tbl_processi.id_processo 
	INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
	INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
	INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
	WHERE tbl_status.id_cliente = #id_cliente#
	AND
	(dt_status >= #from# AND dt_status <= #to#)
	GROUP BY id_cliente,id_status
	ORDER BY id_processo
	</cfquery>
	<cfif thisAgente NEQ id_agente>
		<cfif thisAgente NEQ 0>
			<cfif totale_giorni_agente EQ 0>
				<cfset totale_giorni_agente = 1>
			</cfif>
			<cfif totale_agente EQ 0>
				<cfset totale_agente = 1>
			</cfif>
			<cfset myHTML = "#myHTML#<tr><td></td><td colspan='3'></td><td><strong>#Int(nSAVAgente)#  <span style='color:red'>(#Int(nExtraAgente)#)</span></strong></td><td>&nbsp;</td><td  x:num='#DecimalFormat(totale_giorni_agente/totale_agente)#'><strong>#DecimalFormat(totale_giorni_agente/totale_agente)#</strong>&nbsp;</td></tr>">
		</cfif>
		<cfset totale_agente = 0>
		<cfset totale_giorni_agente = 0>
		<cfset nSAVAgente = 0>
		<cfset nExtraAgente = 0>
	</cfif>
	
	<cfloop query="getStatus">
		<cfif getStatus.id_processo EQ 2>
			<cfset myData = getStatus.dt_status>
		</cfif>
		<cfif getStatus.id_processo EQ 7>
			<cfif idc NEQ getStatus.id_cliente>
				<cfif ids NEQ id_status>
				<cfset ncount = ncount + 1>
				<cfif ac_segnalatore EQ "LGI" OR ac_segnalatore EQ "COLLEAD" OR ac_segnalatore EQ "OPTIMAMENTE">
					<cfset contatto = "<span style='color:red'>#UCASE(ac_Segnalatore)#</span>">
					<cfset nExtra = nExtra + 1>
					<cfset nExtraAgente = nExtraAgente + 1>
				<cfelse>
					<cfset nSAV = nSAV + 1>
					<cfset nSAVAgente = nSAVAgente + 1>
					<cfset contatto = UCASE(ac_segnalatore)>
					<cfif contatto EQ "NULL" OR contatto EQ "">
						<cfset contatto = "SAVEnergy">
					<cfelse>
						<cfset contatto = UCASE(ac_segnalatore)>	
					</cfif>
				</cfif>
				<cfif myData NEQ "">
					<cfset nGiorni = Abs(DateDiff("d",myData,getContratti.dt_status))>
					<cfif nGiorni EQ 0>
						<cfset nGiorni = 7>
					</cfif>
				<cfelse>
					<cfset nGiorni = 7>	
				</cfif>
				<cfset nGiorniTotali = nGiorniTotali + nGiorni>
				<cfset totale_agente = totale_agente + 1>
				<cfset totale_giorni_agente = totale_giorni_agente + nGiorni>
				<cfset totali = totali + 1>
				<cfset myHTML = "#myHTML#<tr><td>#Int(totale_agente)#</td><td>#ac_gruppo#</td><td>#ucase(ac_cognome)#</td> <td>#ucase(ac_azienda)#</td><td>#contatto#</td><td>#dateFormat(dt_status,'dd mm yyyy')#</td><td>#Int(nGiorni)#</td></tr>">
				</cfif>	
			</cfif>
			<cfset idp = id_processo>
			<cfset ids = id_status>
			<cfset idc = getStatus.id_cliente>	
		</cfif>
	
	</cfloop> 
	<!--- <cfset myHTML = "#myHTML#<tr><td colspan='8'>Totale agente: #totale_agente#&nbsp;&nbsp;Media Giorni = </td></tr>"> --->
	<!--- <cfdump var="#getStatus#"> --->
	<cfelse>
		<cfset naltri = naltri + 1>
	<!---<cfdump var="#getProcessi#"> --->
	</cfif>
	<cfset thisAgente = id_agente>
	
</cfoutput>
<cfif totali GT 0>
	<cfset myHTML = "#myHTML#<tr><td></td><td colspan='3'></td><td><strong>#Int(nSAVAgente)#  <span style='color:red'>(#Int(nExtraAgente)#)</span></strong></td><td>&nbsp;</td><td x:num='#DecimalFormat(totale_giorni_agente/totale_agente)#'> <strong>#DecimalFormat(totale_giorni_agente/totale_agente)#</strong>&nbsp;</td></tr>">
	
	<!--- <cfset totaliClienti = ncount + naltri> --->
	<cfset nMediaGiorni = nGiorniTotali / totali>
	<cfif ncount GT 0>
		<cfset perc = (ncount /(ncount+naltri))*100>
		<cfset nSAVPerc = (nSAV/ncount)*100>
		<cfset nExtraPerc = (nExtra/ncount)*100>
	</cfif>
	<cfif naltri GT 0>
		<cfset perc2 = (naltri/(ncount+naltri))*100>
	</cfif>


<table width="99%" cellspacing="0" cellpadding="2" style="border:1px solid #eaeaea;margin:4px">
	<tr>
		<td colspan="8" class="winblue">
		<strong>ANALISI 1° CONTATTO TELEFONICO - CONTRATTO </strong> Periodo : <cfoutput><strong>#url.dateFrom# - #url.DateTo#</strong>
		<input type="button" class="btn" value="Excel" onclick="createExcelThis('from=#url.dateFrom#&to=#url.dateTo#&mode=1tele')"></cfoutput>
		</td>
	</tr>
	<tr bgcolor="#eaeaea">
		<td>1° CONTATTO TELEFONICO - CONTRATTO</td>
		<td></td>
		<td>CONTRATTO senza 1° CONTATTO TELEFONICO</td>
		<td></td>
		<td>Clienti SAV/Fornitori</td>
		<td></td>
	</tr>
	<cfoutput>
	<tr>
		<td>#ncount# </td>
		<td><img src="../include/css/dot-trasp.png" width="#int(perc)#" height="10" align="absmiddle" style="background:green;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-int(perc)#" height="10" align="absmiddle" style="background:white;border:1px solid black"> (#decimalFormat(perc)#)</td>
		<td>#naltri# </td>
		<td><img src="../include/css/dot-trasp.png" width="#int(perc2)#" height="10" align="absmiddle" style="background:red;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-int(perc2)#" height="10" align="absmiddle" style="background:white;border:1px solid black"> (#decimalFormat(perc2)#)</td>
		<td>
		<img src="../include/css/dot-trasp.png" width="#nSAVPerc#" height="10" style="background:##99ccff"><img src="../include/css/dot-trasp.png" width="#nExtraPerc#" height="10" style="background:navy"> #nSAV#/#nExtra# (#DecimalFormat(nSAVPerc)#% - #DecimalFOrmat(nExtraPerc)#%)
		</td>

		<td><!--- <a href="javascript:viewDetail('myDetail')"><input type="button" class="btn" value="Dettaglio"></a> ---></td>
	</tr>
	<tr>
		<td colspan="8">
		Totale analizzati : #totali#   Media Giorni : #DecimalFormat(nMediaGiorni)#
		</td>
	</tr>
	</cfoutput>
</table>
<cfoutput>
<table width="99%" id="myDetail" cellpadding="3" cellspacing="0" style="display:;margin:4px">
	<!--- <tr bgcolor="##eaeaea">
		<td><strong>Nr.</strong></td>
		<td><strong>Gruppo</strong></td>
		<td><strong>Agente</strong></td>
		<td><strong>Cliente</strong></td>
		<td><strong>Contatto</strong></td>
		<td><strong>Data</strong></td>
		<td><strong>GG.</strong></td>
	</tr> --->
#myHTML#
</table>
</cfoutput>
<cfset myHTML = "<tr><td colspan='7'><strong>Totali analizzati: #totali# &nbsp;&nbsp;&nbsp; Media Giorni: #DecimalFormat(nMediaGiorni)#&nbsp;</strong></td></tr>#myHTML#">
<cfset session.Excel = myHTML>
<iframe id="excel_detail" name="excel_detail" style="display:none"></iframe>
<cfelse>
<br>
<br>
<br>

	<div align="center"><strong>NON CI SONO DATI PER IL PERIODO SELEZIONATO</strong></div>
</cfif>

<cfelse>
<br>
<br>
<br>

	<div align="center"><strong>NON CI SONO DATI PER IL PERIODO SELEZIONATO</strong></div>
</cfif>
</body>
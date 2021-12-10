<cfsetting showdebugoutput="yes">
<cfsetting enablecfoutputonly="no">
<cfparam name="from" default="#CreateDate(2011,1,1)#">
<cfparam name="to" default="#CreateDate(year(now()),month(now()),day(now()))#">
<cfparam name="id_gruppo" default="">
<cfparam name="id_agente" default="">

<script>
function createExcelThis(params){
	document.getElementById("excel_detail").src = "_1app-contratto_dettaglio_XLS.cfm?mode=1app&"+ params;
}
</script>

<cfif IsDefined("url.dateFrom") AND url.dateFrom NEQ "">
	<cfset from = CreateDate(ListGetAt(url.dateFrom,3,"/"),ListGetAt(url.dateFrom,2,"/"),ListGetAt(url.dateFrom,1,"/"))>
	<cfset to = CreateDate(ListGetAt(url.dateTo,3,"/"),ListGetAt(url.dateTo,2,"/"),ListGetAt(url.dateTo,1,"/"))>
<cfelse>	
	<cfset url.dateFrom = DateFormat(from,"dd.mm.yyyy")>
	<cfset url.dateTo = DateFormat(to,"dd.mm.yyyy")>
</cfif>

<cfif IsDefined("url.id_gruppo_agenti") AND url.id_gruppo_agenti NEQ "">
	<cfset id_gruppo = url.id_gruppo_agenti>
</cfif>

<cfif IsDefined("url.id_agente") AND url.id_agente NEQ "">
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
			tbl_clienti.ac_segnalatore,
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
<cfset myHTML = "<tr bgcolor='##eaeaea'><td></td><td><strong>GRUPPO</strong></td><td><strong>AGENTE</strong></td><td><strong>CLIENTE</strong></td><td><strong>CONTATTO PROPRIO/SEDE</strong></td><td><strong>1° APPUNT.</strong></td><td><strong>APPUNT. SUCC. (ultimo)</strong></td><td><strong>DATA CONTRATTO</strong></td><td><strong>nr GG.</strong></td></tr>">

<body style="overflow:auto">
<cfset ncount = 0>


<cfset noStat = true>
<cfif getContratti.recordcount GT 0>
<cfoutput query="getContratti">
	<cfquery name="getProcessi" datasource="#application.dsn#">
	SELECT tbl_status.id_cliente,tbl_status.dt_status
	 FROM tbl_status WHERE
		id_processo = 8
		AND 
		id_cliente = #id_cliente#
		GROUP BY id_cliente
		ORDER BY dt_status DESC
	</cfquery>
	<cfif getProcessi.recordcount GT 0>
 		<cfquery name="get1App" datasource="#application.dsn#">
			SELECT tbl_status.*
			 FROM tbl_status WHERE
			id_processo = 3
			AND 
			id_cliente = #id_cliente#
			GROUP BY id_cliente
		</cfquery>
		
		<cfif get1App.recordcount GT 0>
			<cfset noStat = FALSE>
			<cfset totale_agente = 0>
			<cfset totale_giorni_agente = 0>
			<cfset nSAVAgente = 0>
			<cfset nExtraAgente = 0>

			<cfset myData1 = get1App.dt_status>
			<cfset ncount = ncount +1>
			<cfloop query="get1App">
				<cfif getContratti.ac_segnalatore EQ "LGI" OR getContratti.ac_segnalatore EQ "COLLEAD" OR getContratti.ac_segnalatore EQ "OPTIMAMENTE">
					<cfset contatto = "<span style='color:red'>#UCASE(getContratti.ac_Segnalatore)#</span>">
					<cfset nExtra = nExtra + 1>
					<cfset nExtraAgente = nExtraAgente + 1>
				<cfelse>
					<cfset nSAV = nSAV + 1>
					<cfset nSAVAgente = nSAVAgente + 1>
					<cfset contatto = UCASE(getContratti.ac_segnalatore)>
					<cfif contatto EQ "NULL" OR contatto EQ "">
						<cfset contatto = "SAVEnergy">
					<cfelse>
						<cfset contatto = UCASE(getContratti.ac_segnalatore)>	
					</cfif>
				</cfif>
				
				<cfset myData2 = getProcessi.dt_status>
				<cfset nGiorni = Abs(DateDiff("d",myData2,myData1))>
				<cfset nGiorniTotali = nGiorniTotali + nGiorni>
				<cfset totale_agente = totale_agente + 1>
				<cfset totale_giorni_agente = totale_giorni_agente + nGiorni>
				<cfset totali = totali + 1>
				<cfset myHTML = "#myHTML#<tr><td>#Int(ncount)#</td><td>#getContratti.ac_gruppo#</td><td>#ucase(getContratti.ac_cognome)#</td> <td>#ucase(getContratti.ac_azienda)#</td><td>#contatto#</td><td>#DateFormat(myData1,'dd mm yyyy')#</td><td>#DateFormat(myData2,'dd mm yyyy')#</td><td>#dateFormat(getContratti.dt_status,'dd mm yyyy')#</td><td>#Int(nGiorni)#</td></tr>">
				<cfset myHTML = "#myHTML#<tr><td></td><td colspan='3'></td><td><strong>#Int(nSAVAgente)#  <span style='color:red'>(#Int(nExtraAgente)#)</span></strong></td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td  x:num='#DecimalFormat(totale_giorni_agente/totale_agente)#'><strong>#DecimalFormat(totale_giorni_agente/totale_agente)#</strong>&nbsp;</td></tr>">
<!--- 			#ncount# - (#getContratti.ac_gruppo#) #getContratti.ac_cognome# - #getContratti.ac_azienda# #dateFormat(getContratti.dt_status,"dd.mm.yyyy")# > #get1App.id_status# #get1App.id_cliente# > 1 APP #DateFormat(get1App.dt_status,"dd.mm.yyyy")# - ALTRO APPUNT. #dateFormat(getProcessi.dt_status,"dd.mm.yyyy")# (#getContratti.ac_segnalatore#)<br> --->
			
			</cfloop>
			
		</cfif>
	<!--- 
	<cfdump var="#getProcessi#"> --->
	</cfif>
</cfoutput>
</cfif>


<cfif ncount GT 0>
<cfset myHTML = "#myHTML#<tr bgcolor='silver'><td></td><td colspan='3'></td><td><strong>#Int(nSAV)#  <span style='color:red'>(#Int(nExtra)#)</span></strong></td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td x:num='#DecimalFormat(nGiorniTotali/ncount)#'> <strong>#DecimalFormat(nGiorniTotali/nCount)#</strong>&nbsp;</td></tr>">
<!--- <cfset totaliClienti = ncount + naltri> --->
<cfset nMediaGiorni = nGiorniTotali / totali>
<cfif ncount GT 0>
	<cfset naltri = getContratti.recordcount - ncount>
	<cfset perc = (ncount /(ncount+naltri))*100>
	<cfset nSAVPerc = (nSAV/ncount)*100>
	<cfset nExtraPerc = (nExtra/ncount)*100>
	
</cfif>
<cfif naltri GT 0>
	<cfset perc2 = (naltri/(ncount+naltri))*100>
</cfif>
<table width="100%" cellspacing="0" cellpadding="2" style="border:1px solid #eaeaea">
	<tr>
		<td colspan="8" class="winblue">
		<strong>ANALISI APPUNTAMENTI - CONTRATTO </strong> Periodo : <cfoutput><strong>#url.dateFrom# - #url.DateTo#</strong>
		<!--- &nbsp;&nbsp;&nbsp;<img src="../include/css/icons/files/xls.png" onclick="createExcel('#url.startprocesso#','#url.dateFrom#','#url.dateTo#')" style="cursor:pointer" title="Crea Excel"> ---><input type="button" class="btn" value="Excel" onclick="createExcelThis('from=#url.dateFrom#&to=#url.dateTo#')"></cfoutput>
		</td>
	</tr>
	<cfif noStat IS FALSE>
	<tr bgcolor="#eaeaea">
		<td>+ APPUNTAMENTI - CONTRATTO</td>
		<td></td>
		<td>1° APPUNTAMENTO - CONTRATTO</td>
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
	<tr>
		<td colspan="8">
		<table width="100%" cellspacing="0" cellpadding="2" style="border:1px solid ##eaeaea">
		#myHTML#	
		</table>
		</td>
	</tr>
	</cfoutput>
	</cfif>
</table>
	<cfset session.Excel = myHTML>
	<iframe id="excel_detail" name="excel_detail" style="display:none"></iframe>

<cfelse>
<br>
<br>
<br>

	<div align="center"><strong>NON CI SONO DATI PER IL PERIODO SELEZIONATO</strong></div>
</cfif>


<!--- <link rel='stylesheet' type='text/css' href='../include/css/style.css'>
<script src="../include/js/functions.js"></script>
<style>
TD { font-size:12px ; border-bottom:1px solid #eaeaea}
</style>
<script>
function hide ( idg ){
	hideObj("gruppo_" + idg);
}
</script>
<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="yes">
<cfinvoke component="statistiche" method="dettaglioProcessi" returnvariable="rsDetail">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="start_processo" value="#url.id_processo#">
</cfinvoke>
<cfset totale = 0>
<cfset totale_perc = 0>
<table width="100%" cellspacing="0" cellpadding="4" style="border:1px solid black">
	<tr bgcolor="<cfoutput>###rsDetail.ac_colore#</cfoutput>">
		<td colspan="5">
		<strong><cfoutput>#rsDetail.ac_processo#</cfoutput></strong>
		</td>
	</tr>
	<tr bgcolor="#eaeaea">
		<td></td>
		<td><strong>Gruppo</strong></td>
		<td><strong>Totale</strong></td>
		<td align="center"><strong>%</strong></td>
		<td></td>
	</tr>
<cfoutput query="rsDetail">
	<cfset perc_processi = DecimalFormat((nrprocessi/tp)*100)>
	<cfset totale_perc = totale_perc + ((nrprocessi/tp)*100)>
	<tr id="gruppo_#id_gruppo#" style="display:">
		<td><img src="../include/css/dot-trasp.png" style="background:red;cursor:pointer" alt="Escludi" title="Escludi" width="8" height="4" onclick="hide(#id_gruppo#)"></td>
		<td>#ac_gruppo#</td>
		<td>#nrprocessi#</td>
		<td>#perc_processi#</td>
		<td><img src="../include/css/dot-trasp.png" width="#perc_processi#" height="10" style="background:green;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-perc_processi#" height="10" style="background:white;border:1px solid black"></td>
	</tr>
<cfset totale = totale + nrprocessi>
</cfoutput>
	<cfoutput>
	<tr bgcolor="##eaeaea">
		<td></td>
		<td>Totale processi analizzati</td>
		<td><strong>#totale#</strong></td>
		<td><strong>#round(totale_perc)#</strong></td>
		<td></td>
	</tr>
	</cfoutput>
</table> --->
<!--- <cfdump var="#rsDetail#"> --->
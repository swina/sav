<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
<style>
TD { border-bottom:1px solid #eaeaea}
</style>
<cfsetting showdebugoutput="yes">
<cfsetting enablecfoutputonly="no">
<cfparam name="from" default="#CreateDate(2011,1,1)#">
<cfparam name="to" default="#CreateDate(year(now()),month(now()),day(now()))#">

<cfparam name="id_gruppo" default="">
<cfparam name="id_agente" default="">

<script>
function createExcelThis(params){
	document.getElementById("excel_detail").src = "_appuntamenti_XLS.cfm?mode=apps&"+ params;
}
</script>

<cfif IsDefined("url.dateFrom") AND url.dateFrom NEQ "">
	<cfset from = CreateDate(ListGetAt(url.dateFrom,3,"/"),ListGetAt(url.dateFrom,2,"/"),ListGetAt(url.dateFrom,1,"/"))>
	<cfset to = CreateDate(ListGetAt(url.dateTo,3,"/"),ListGetAt(url.dateTo,2,"/"),ListGetAt(url.dateTo,1,"/"))>
	<cfset from2 = CreateDate(ListGetAt(url.dateFrom2,3,"/"),ListGetAt(url.dateFrom2,2,"/"),ListGetAt(url.dateFrom2,1,"/"))>
	<cfset to2 = CreateDate(ListGetAt(url.dateTo2,3,"/"),ListGetAt(url.dateTo2,2,"/"),ListGetAt(url.dateTo2,1,"/"))>
<cfelse>	
	<cfset url.dateFrom = DateFormat(from,"dd.mm.yyyy")>
	<cfset url.dateTo = DateFormat(to,"dd.mm.yyyy")>
	<cfset url.dateFrom2 = DateFormat(from,"dd.mm.yyyy")>
	<cfset url.dateTo2 = DateFormat(to,"dd.mm.yyyy")>
</cfif>

<cfif IsDefined("url.id_gruppo_agenti") AND url.id_gruppo_agenti NEQ "">
	<cfset id_gruppo = url.id_gruppo_agenti>
</cfif>

<cfif IsDefined("url.id_agente") AND url.id_agente NEQ "">
	<cfset id_agente = url.id_agente>
	<cfif ListLen(id_agente) GT 1>
		<cfset id_agente = Left(id_agente,Len(id_agente)-1)>
	</cfif>	
	<cfif right(id_agente,1) EQ ",">
		<cfset id_agente = Left(id_agente,Len(id_agente)-1)>
	</cfif>
	<cfif left(id_agente,1) EQ ",">
		<cfset id_agente = Right(id_agente,len(id_agente)-1)>
	</cfif>
</cfif>
<body style="overflow:auto">

<cfif IsDefined("url.periodo2") AND url.periodo2 EQ "true">
	<cfset thisHTML = "">
	<cfloop index="i" from="1" to="2">
		<cfif i EQ 2>
			<cfset from = from2>
			<cfset to = to2>
		</cfif>


			
<cfquery name="conta1appuntamento" datasource="#application.dsn#">
SELECT tbl_status.id_processo,
tbl_clienti.id_agente,
tbl_clienti.ac_segnalatore,
tbl_persone.ac_cognome,
tbl_persone.ac_nome
FROM tbl_status 
INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
WHERE
( tbl_status.id_processo = 3)
AND
(dt_status >= #from# AND dt_status <= #to#)
<cfif id_agente NEQ "">
	<cfif ListLen(id_agente) GT 1>
		
		AND tbl_persone.id_persona IN ( #id_agente# )
	<cfelse>
		AND tbl_persone.id_persona = #id_agente#		
	</cfif>
</cfif>
<!--- GROUP BY tbl_clienti.id_agente --->
ORDER BY tbl_persone.ac_cognome ASC 
</cfquery>



<cfquery name="appuntamenti" datasource="#application.dsn#">
SELECT COUNT(tbl_status.id_processo) AS nr ,
tbl_clienti.id_agente,
tbl_persone.ac_cognome,
tbl_persone.ac_nome
FROM tbl_status 
INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
WHERE
( tbl_status.id_processo = 4 OR tbl_status.id_processo = 8)
AND
(dt_status >= #from# AND dt_status <= #to#)
<cfif id_agente NEQ "">
	<cfif ListLen(id_agente) GT 1>
		
		AND tbl_persone.id_persona IN ( #id_agente# )
	<cfelse>
		AND tbl_persone.id_persona = #id_agente#		
	</cfif>
</cfif>
GROUP BY tbl_clienti.id_agente
ORDER BY tbl_persone.ac_cognome ASC
</cfquery>
<cfset listAgenti = ValueList(appuntamenti.id_agente)>
<cfset listConta = ValueList(appuntamenti.nr)>
<!--- <cfset appuntamento1 = conta1appuntamento.nr>
<cfset altriappuntamenti = appuntamenti.nr>
<cfset totale_appuntamenti = appuntamento1 + altriappuntamenti> --->

<table width="50%" cellspacing="0" cellpadding="2" style="border:1px solid #eaeaea">
	<tr>
		<td colspan="8" class="winblue">
		<cfset thisHTML = "#thisHTML#<tr><td colspan='6'><strong>APPUNTAMENTI </strong>Periodo : <cfoutput><strong>#DateFormat(from,'dd/mm/yyyy')# - #DateFormat(to,'dd/mm/yyyy')#</strong></td></tr>">
		<strong>APPUNTAMENTI </strong> Periodo : <cfoutput><strong>#DateFormat(from,"dd/mm/yyyy")# - #DateFormat(to,"dd/mm/yyyy")#</strong>
		<input type="button" class="btn" value="Excel" onclick="createExcelThis('from=#url.dateFrom#&to=#url.dateTo#&from2=#url.dateFrom2#&to2=#url.dateTo2#')"></cfoutput>
		</td>
		<cfset thisHTML = "#thisHTML#<tr><td><strong>AGENTE</strong></td><td><strong>APPUNTAM.</strong></td><td><strong>1° APPUNT.</strong></td><td><strong>FORNITORI</strong></td><td><strong>CLIENTE SAV</strong></td><td><strong>TOTALE</strong></td></tr>">

	</tr>
	<tr>
		<td align="center"><strong>AGENTE</strong></td>
		<td align="center"><strong>APPUNTAM.</strong></td>
		<td align="center"><strong>1° APPUNT.</strong></td>
		
		<td align="center"><strong>FORNITORI</strong></td>
		<td align="center"><strong>CLIENTE SAV</strong></td>
		<td align="center"><strong>TOTALE</strong></td>
	</tr>
	<cfset nr = 0>
	<cfset totale_altri = 0>
	<cfset totale_1 = 0>
	<cfoutput query="conta1appuntamento" group="ac_cognome">
	<tr>
		<td>#UCASE(ac_cognome)# #UCASE(ac_nome)#</td>
		<td align="center">
		<cfif ListFind(listAgenti,id_agente)>
			<cfset altri_appuntamenti =ListGetAt(listConta,ListFind(listAgenti,id_agente))>
		<cfelse>
			<cfset altri_appuntamenti = 0>
		</cfif>
		<cfset totale_altri = totale_altri + altri_appuntamenti>
		#altri_appuntamenti#
		</td>
		<cfset cliente_sav = 0>
		<cfset cliente_agente = 0>
		<cfoutput>
			<cfset nr = nr + 1>
			<cfif ac_segnalatore EQ "COLLEAD" OR ac_segnalatore EQ "LGI" OR ac_segnalatore EQ "BETHEBOSS" OR ac_segnalatore EQ "DIGITOUCH" OR ac_segnalatore EQ "SITO" OR ac_segnalatore EQ "">
				<cfset cliente_sav = cliente_sav + 1>
			<cfelse>
				<cfset cliente_agente = cliente_agente + 1>
			</cfif>	
		</cfoutput>
		<cfset totale_1 = totale_1 + nr>
		<td align="center">#nr#</td>
		
		<td align="center">#cliente_sav#</td>
		<td align="center">#nr-cliente_sav#</td>
		<td align="center">
			#nr+altri_appuntamenti#
		</td>
		
		<cfset thisHTML = "#thisHTML#<tr><td>#UCASE(ac_cognome)# #UCASE(ac_nome)#</td><td align='right'>#altri_appuntamenti#</td><td align='right'>#nr#</td><td align='right'>#cliente_sav#</td><td align='right'>#nr-cliente_sav#</td><td align='right'>#nr+altri_appuntamenti#</td></tr>">
	</tr>
	<cfset nr = 0>
</cfoutput>
	<tr>
		<cfoutput>
		<td align="right">Totale</td>
		<td align="right"><strong>#totale_altri#</strong></td>
		<td align="right"><strong>#totale_1#</strong></td>
		
		<td></td>
		<td></td>
		<td align="right"><strong>#totale_altri+totale_1#</strong></td>
		</cfoutput>
	</tr>
	<cfoutput>
	<cfset thisHTML = "#thisHTML#<tr><td align='right'>Totale</td><td align='right'><strong>#totale_altri#</strong></td><td align='right'>#totale_1#</td><td></td><td></td><td align='right'><strong>#totale_altri+totale_1#</strong></td></tr>">
	</cfoutput>
</table>

</cfloop>

<cfelse>

<cfquery name="conta1appuntamento" datasource="#application.dsn#">
SELECT tbl_status.id_processo,
tbl_clienti.id_agente,
tbl_clienti.ac_segnalatore,
tbl_persone.ac_cognome,
tbl_persone.ac_nome
FROM tbl_status 
INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
WHERE
( tbl_status.id_processo = 3)
AND
(dt_status >= #from# AND dt_status <= #to#)
<cfif id_agente NEQ "">
	<cfif ListLen(id_agente) GT 1>
		
		AND tbl_persone.id_persona IN ( #id_agente# )
	<cfelse>
		AND tbl_persone.id_persona = #id_agente#		
	</cfif>
</cfif>
<!--- GROUP BY tbl_clienti.id_agente --->
ORDER BY tbl_persone.ac_cognome ASC 
</cfquery>



<cfquery name="appuntamenti" datasource="#application.dsn#">
SELECT COUNT(tbl_status.id_processo) AS nr ,
tbl_clienti.id_agente,
tbl_persone.ac_cognome,
tbl_persone.ac_nome
FROM tbl_status 
INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
WHERE
( tbl_status.id_processo = 4 OR tbl_status.id_processo = 8)
AND
(dt_status >= #from# AND dt_status <= #to#)
<cfif id_agente NEQ "">
	<cfif ListLen(id_agente) GT 1>
		
		AND tbl_persone.id_persona IN ( #id_agente# )
	<cfelse>
		AND tbl_persone.id_persona = #id_agente#		
	</cfif>
</cfif>
GROUP BY tbl_clienti.id_agente
ORDER BY tbl_persone.ac_cognome ASC
</cfquery>

<cfset listAgenti = ValueList(appuntamenti.id_agente)>
<cfset listConta = ValueList(appuntamenti.nr)>
<cfset thisHTML = "">
<!--- <cfset appuntamento1 = conta1appuntamento.nr>
<cfset altriappuntamenti = appuntamenti.nr>
<cfset totale_appuntamenti = appuntamento1 + altriappuntamenti> --->

<table width="50%" cellspacing="0" cellpadding="2" style="border:1px solid #eaeaea">
	<tr>
		<td colspan="8" class="winblue">
		<cfset thisHTML = "#thisHTML#<tr><td colspan='6'><strong>APPUNTAMENTI </strong>Periodo : <cfoutput><strong>#DateFormat(from,'dd/mm/yyyy')# - #DateFormat(to,'dd/mm/yyyy')#</strong></td></tr>">	
		<strong>APPUNTAMENTI </strong> Periodo : <cfoutput><strong><strong>#DateFormat(from,"dd/mm/yyyy")# - #DateFormat(to,"dd/mm/yyyy")#</strong>
		<!--- &nbsp;&nbsp;&nbsp;<img src="../include/css/icons/files/xls.png" onclick="createExcel('#url.startprocesso#','#url.dateFrom#','#url.dateTo#')" style="cursor:pointer" title="Crea Excel"> ---><input type="button" class="btn" value="Excel" onclick="createExcelThis('from=#url.dateFrom#&to=#url.dateTo#')"></cfoutput>
		<cfset thisHTML = "#thisHTML#<tr><td><strong>AGENTE</strong></td><td><strong>APPUNTAM.</strong></td><td><strong>1° APPUNT.</strong></td><td><strong>FORNITORI</strong></td><td><strong>CLIENTE SAV</strong></td><td><strong>TOTALE</strong></td></tr>">
		</td>
	</tr>
	<tr>
		<td align="center"><strong>AGENTE</strong></td>
		<td align="center"><strong>APPUNTAM.</strong></td>
		<td align="center"><strong>1° APPUNT.</strong></td>
		
		<td align="center"><strong>FORNITORI</strong></td>
		<td align="center"><strong>CLIENTE SAV</strong></td>
		<td align="center"><strong>TOTALE</strong></td>
	</tr>
	<cfset nr = 0>
	<cfset totale_altri = 0>
	<cfset totale_1 = 0>
	<cfoutput query="conta1appuntamento" group="ac_cognome">
	<tr>
		<td>#UCASE(ac_cognome)# #UCASE(ac_nome)#</td>
		<td align="center">
		<cfif ListFind(listAgenti,id_agente)>
			<cfset altri_appuntamenti =ListGetAt(listConta,ListFind(listAgenti,id_agente))>
		<cfelse>
			<cfset altri_appuntamenti = 0>
		</cfif>
		<cfset totale_altri = totale_altri + altri_appuntamenti>
		#altri_appuntamenti#
		</td>
		<cfset cliente_sav = 0>
		<cfset cliente_agente = 0>
		<cfoutput>
			<cfset nr = nr + 1>
			<cfif ac_segnalatore EQ "COLLEAD" OR ac_segnalatore EQ "LGI" OR ac_segnalatore EQ "BETHEBOSS" OR ac_segnalatore EQ "DIGITOUCH" OR ac_segnalatore EQ "SITO" OR ac_segnalatore EQ "">
				<cfset cliente_sav = cliente_sav + 1>
			<cfelse>
				<cfset cliente_agente = cliente_agente + 1>
			</cfif>	
		</cfoutput>
		<cfset totale_1 = totale_1 + nr>
		<td align="center">#nr#</td>
		
		<td align="center">#cliente_sav#</td>
		<td align="center">#nr-cliente_sav#</td>
		<td align="center">
			#nr+altri_appuntamenti#
		</td>
		
		<cfset thisHTML = "#thisHTML#<tr><td>#UCASE(ac_cognome)# #UCASE(ac_nome)#</td><td align='right'>#altri_appuntamenti#</td><td align='right'>#nr#</td><td align='right'>#cliente_sav#</td><td align='right'>#nr-cliente_sav#</td><td align='right'>#nr+altri_appuntamenti#</td></tr>">
	</tr>
	<cfset nr = 0>
</cfoutput>
	<tr>
		<cfoutput>
		<td align="right">Totale</td>
		<td align="right"><strong>#totale_altri#</strong></td>
		<td align="right"><strong>#totale_1#</strong></td>
		
		<td></td>
		<td></td>
		<td align="right"><strong>#totale_altri+totale_1#</strong></td>
		</cfoutput>
	</tr>
	<cfoutput>
	<cfset thisHTML = "#thisHTML#<tr><td align='right'>Totale</td><td align='right'><strong>#totale_altri#</strong></td><td align='right'>#totale_1#</td><td></td><td></td><td align='right'><strong>#totale_altri+totale_1#</strong></td></tr>">
	</cfoutput>
</table>
</cfif>

<br><br>
<br>
<cfset session.Excel = thisHTML>
<iframe id="excel_detail" name="excel_detail" style="display:none"></iframe>
<cfif remote_addr EQ "89.118.53.254">
<cfdump var="#thisHTML#">
<cfdump var="#conta1appuntamento#">
<cfdump var="#appuntamenti#">
</cfif>
</body>
<!--- 
<strong>Totale appuntamenti</strong>
<cfoutput>#totale_appuntamenti# (1° appuntamento = #appuntamento1#    appuntamenti=#altriappuntamenti#)</cfoutput> --->

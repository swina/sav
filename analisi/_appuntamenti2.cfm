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
<cfparam name="thisHTML" default="">
<cfparam name="cliente_sav" default=0>
<cfparam name="cliente_agente" default=0>
<cfparam name="totale_sav" default=0>
<cfparam name="totale_agente" default=0>
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
	<cfset to = DateAdd("d",1,to)>
	<cfset to2 = DateAdd("d",1,to2)>
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
<cfset HTML_periodo_1 = "">
<cfset HTML_periodo_2 = "">
<cfif IsDefined("url.periodo2") AND url.periodo2 EQ "true">
	<cfset thisHTML = "">
	
	
	<!--------------------------  due periodi ----------------------------------------------------->
	<cfloop index="i" from="1" to="2">
		<cfif i EQ 2>
			<cfset from = from2>
			<cfset to = to2>
		</cfif>


			
<cfquery name="contaappuntamenti" datasource="#application.dsn#">
SELECT tbl_status.id_processo ,
tbl_status.dt_status,
tbl_clienti.id_agente,
tbL_clienti.ac_segnalatore,
tbl_persone.ac_cognome,
tbl_persone.ac_nome
FROM tbl_status 
INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
WHERE
( tbl_status.id_processo = 3 OR tbl_status.id_processo = 4 OR tbl_status.id_processo = 8)
AND
(dt_status >= #from# AND dt_status <= #to#)
<cfif id_agente NEQ "">
	<cfif ListLen(id_agente) GT 1>
		
		AND tbl_persone.id_persona IN ( #id_agente# )
	<cfelse>
		AND tbl_persone.id_persona = #id_agente#		
	</cfif>
</cfif>

ORDER BY tbl_persone.ac_cognome ASC 
</cfquery>


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
	<cfset totale_appuntamenti = 0>
	
	<cfoutput query="contaappuntamenti" group="id_agente">
		<cfset appuntamenti = 0>
		<cfset altri_appuntamenti = 0>
		<cfset cliente_sav = 0>
		<cfset cliente_agente = 0>
		<cfoutput>
			<cfif id_processo EQ 3>
				<cfset appuntamenti = appuntamenti + 1>
				<!--- <cfset totale_appuntamenti = totale_appuntamenti + 1> --->
			</cfif>
			<cfif id_processo EQ 4 OR id_processo EQ 8>
				<cfset altri_appuntamenti = altri_appuntamenti + 1>
				<!--- <cfset totale_altri = totale_altri + altri_appuntamenti> --->
			</cfif> 
			<cfset nr = nr + 1>
			<cfif ac_segnalatore EQ "COLLEAD" OR ac_segnalatore EQ "LGI" OR ac_segnalatore EQ "BETHEBOSS" OR ac_segnalatore EQ "DIGITOUCH" OR ac_segnalatore EQ "SITO" OR ac_segnalatore EQ "">
				<cfset cliente_sav = cliente_sav + 1>
			<cfelse>
				<cfset cliente_agente = cliente_agente + 1>
			</cfif>
		</cfoutput>
		<tr>
		<td>#UCASE(ac_cognome)# #UCASE(ac_nome)#</td>
		<td align="center">
		#altri_appuntamenti#
		</td>
		<td align="center">
		#appuntamenti#
		</td>
		<td align="center">#cliente_sav#</td>
		<td align="center">#nr-cliente_sav#</td>
		<td align="center">
			#appuntamenti+altri_appuntamenti#
		</td>
		<cfset totale_altri = totale_altri + altri_appuntamenti>
		<cfset totale_appuntamenti = totale_appuntamenti + appuntamenti>
		<cfif i EQ 1>
			<cfset HTML_PERIODO_1 = "#HTML_PERIODO_1##UCASE(ac_cognome)# #UCASE(ac_nome)#|#altri_appuntamenti#|#appuntamenti#|#cliente_sav#|#nr-cliente_sav#|#appuntamenti+altri_appuntamenti#§">
		<cfelse>
			<cfset HTML_PERIODO_2 = "#HTML_PERIODO_2#NULL|#altri_appuntamenti#|#nr#|#cliente_sav#|#nr-cliente_sav#|#appuntamenti+altri_appuntamenti#§">
		</cfif>	
		<cfset thisHTML = "#thisHTML#<tr><td>#UCASE(ac_cognome)# #UCASE(ac_nome)#</td><td align='right'>#altri_appuntamenti#</td><td align='right'>#nr#</td><td align='right'>#cliente_sav#</td><td align='right'>#nr-cliente_sav#</td><td align='right'>#appuntamenti+altri_appuntamenti#</td></tr>">
	</tr>
	<cfset nr = 0>
</cfoutput>
	<tr>
		<cfoutput>
		<td align="center">Totale</td>
		<td align="center"><strong>#totale_altri#</strong></td>
		<td align="center"><strong>#totale_appuntamenti#</strong></td>
		
		<td></td>
		<td></td>
		<td align="center"><strong>#totale_altri+totale_appuntamenti#</strong></td>
		</cfoutput>
	</tr>
	<cfoutput>
	<cfset thisHTML = "#thisHTML#<tr><td align='right'>Totale</td><td align='right'><strong>#totale_altri#</strong></td><td align='right'>#totale_appuntamenti#</td><td></td><td></td><td align='right'><strong>#totale_altri+totale_appuntamenti#</strong></td></tr>">
	</cfoutput>
</table>

</cfloop>

<cfelse>

<!----- UN PERIODO SOLO --->
<cfquery name="contaappuntamenti" datasource="#application.dsn#">
SELECT tbl_status.id_processo ,
tbl_status.dt_status,
tbl_clienti.id_agente,
tbL_clienti.ac_segnalatore,

tbl_persone.ac_cognome,
tbl_persone.ac_nome
FROM tbl_status 
INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
WHERE
( tbl_status.id_processo = 3 OR tbl_status.id_processo = 4 OR tbl_status.id_processo = 8)
AND
(dt_status >= #from# AND dt_status <= #to#)
<cfif id_agente NEQ "">
	<cfif ListLen(id_agente) GT 1>
		
		AND tbl_persone.id_persona IN ( #id_agente# )
	<cfelse>
		AND tbl_persone.id_persona = #id_agente#		
	</cfif>
</cfif>
<!--- GROUP BY tbl_clienti.id_agente, tbl_status.id_processo --->
ORDER BY tbl_persone.ac_cognome ASC 
</cfquery>
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
	<cfset totale_appuntamenti = 0>
	<cfoutput query="contaappuntamenti" group="id_agente">
		<cfset appuntamenti = 0>
		<cfset altri_appuntamenti = 0>
		<cfset cliente_sav = 0>
		<cfset cliente_agente = 0>
		<cfoutput>
			<cfif id_processo EQ 3>
				<cfset appuntamenti = appuntamenti + 1>
				<cfset totale_appuntamenti = totale_appuntamenti + 1>
			</cfif>
			<cfif id_processo EQ 4 OR id_processo EQ 8>
				<cfset altri_appuntamenti = altri_appuntamenti + 1>
				<cfset totale_altri = totale_altri + 1>
			</cfif> 
			<cfset nr = nr + 1>
			<cfif ac_segnalatore EQ "COLLEAD" OR ac_segnalatore EQ "LGI" OR ac_segnalatore EQ "BETHEBOSS" OR ac_segnalatore EQ "DIGITOUCH" OR ac_segnalatore EQ "SITO" OR ac_segnalatore EQ "PANN.FOTO">
				<cfset cliente_sav = cliente_sav + 1>
			<cfelse>
				<cfset cliente_agente = cliente_agente + 1>
			</cfif>
		</cfoutput>
		<tr>
		<td>#UCASE(ac_cognome)# #UCASE(ac_nome)#</td>
		<td align="center">
		#altri_appuntamenti#
		</td>
		<td align="center">
		#appuntamenti#
		</td>
		<td align="center">#cliente_sav#</td>
		<td align="center">#nr-cliente_sav#</td>
		<td align="center">
			#appuntamenti+altri_appuntamenti#
		</td>
		
		<cfset thisHTML = "#thisHTML#<tr><td>#UCASE(ac_cognome)# #UCASE(ac_nome)#</td><td align='right'>#altri_appuntamenti#</td><td align='right'>#appuntamenti#</td><td align='right'>#cliente_sav#</td><td align='right'>#nr-cliente_sav#</td><td align='right'>#appuntamenti+altri_appuntamenti#</td></tr>">
	</tr>
	<cfset nr = 0>
</cfoutput>
	<tr>
		<cfoutput>
		<td align="center">Totale</td>
		<td align="center"><strong>#totale_altri#</strong></td>
		<td align="center"><strong>#totale_appuntamenti#</strong></td>
		
		<td></td>
		<td></td>
		<td align="center"><strong>#totale_altri+totale_appuntamenti#</strong></td>
		</cfoutput>
	</tr>
	<cfoutput>
	<cfset thisHTML = "#thisHTML#<tr><td align='right'>Totale</td><td align='right'><strong>#totale_altri#</strong></td><td align='right'>#totale_appuntamenti#</td><td></td><td></td><td align='right'><strong>#totale_altri+totale_appuntamenti#</strong></td></tr>">
	</cfoutput>
</table>
</cfif>

<br><br>
<br>
<cfset session.Excel = thisHTML>



<iframe id="excel_detail" name="excel_detail" style="display:none"></iframe>
<cfif remote_addr EQ "89.118.53.254">

<cfif HTML_PERIODO_1 NEQ "">
	<cfoutput>
	<cfset riga = 1>
	<cfloop index="i" list="#HTML_PERIODO_1#" delimiters="§">
		<cfset c2 = ListGetAt(HTML_PERIODO_2,riga,"§")>
		<cfset colonna = 1>
		<cfloop index="n" list="#i#" delimiters="|">
			<div style="width:100px;float:left">#n# <cfif colonna GT 1>#ListGetAt(c2,colonna,"|")#</cfif></div>
			<cfset colonna = colonna + 1>
		</cfloop>
		<div style="clear:both"></div>
		<cfset riga = riga + 1>
	</cfloop>
	</cfoutput>
</cfif>

<cfdump var="#thisHTML#">
<!--- <cfdump var="#appuntamenti#"> --->
</cfif>
</body>
<!--- 
<strong>Totale appuntamenti</strong>
<cfoutput>#totale_appuntamenti# (1° appuntamento = #appuntamento1#    appuntamenti=#altriappuntamenti#)</cfoutput> --->

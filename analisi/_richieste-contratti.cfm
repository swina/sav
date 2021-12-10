<!--- <cfsetting showdebugoutput="yes">
<cfquery name="getRichieste" datasource="#application.dsn#">
SELECT
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
		WHERE 
	(dt_status >= {ts '2011-11-01 00:00:00'} AND dt_status <= {ts '2011-12-05 00:00:00'})
	AND
	tbl_status.id_processo = 6

			ORDER BY tbl_persone.ac_cognome
</cfquery>

<cfoutput query="getRichieste" group="ac_cognome">
	<cfset nr = 0>
	<cfset lista_clienti = "">
	#ac_cognome# #ac_nome#
	<cfoutput>
		<cfset nr = nr + 1>
		<cfset lista_clienti = "#lista_clienti##id_cliente#,">
	</cfoutput>
	<cfif right(lista_clienti,1) EQ ",">
		<cfset lista_clienti = Left(lista_clienti,Len(lista_clienti)-1)>
	</cfif>
	<cfinvoke component="statistiche" method="findStatus" returnvariable="contratti">
		<cfinvokeargument name="id_cliente" value="0">
		<cfinvokeargument name="lista_clienti" value="#lista_clienti#">
		<cfinvokeargument name="id_processo" value="7">
	</cfinvoke> 
	richieste = #nr#  contratti = #contratti#<br>
	
</cfoutput> --->

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
	document.getElementById("excel_detail").src = "_assegnazioniXLS.cfm?file=richieste-contratti&mode=apps&"+ params;
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


			
<cfquery name="assegnazioni" datasource="#application.dsn#">
SELECT tbl_status.id_processo,
tbl_clienti.id_cliente,
tbl_clienti.id_agente,
tbl_clienti.ac_segnalatore,
tbl_persone.ac_cognome,
tbl_persone.ac_nome
FROM tbl_status 
INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
WHERE
( tbl_status.id_processo = 6)
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



<!--- <cfset appuntamento1 = conta1appuntamento.nr>
<cfset altriappuntamenti = appuntamenti.nr>
<cfset totale_appuntamenti = appuntamento1 + altriappuntamenti> --->
<cfif assegnazioni.recordcount GT 0>
<table width="50%" cellspacing="0" cellpadding="2" style="border:1px solid #eaeaea">
	<tr>
		<td colspan="8" class="winblue">
		<cfset thisHTML = "#thisHTML#<tr><td colspan='6'><strong>RICHIESTE OFFERTA-CONTRATTI </strong>Periodo : <cfoutput><strong>#DateFormat(from,'dd/mm/yyyy')# - #DateFormat(to,'dd/mm/yyyy')#</strong></td></tr>">
		<strong>RICHIESTE OFFERTA-CONTRATTI </strong> Periodo : <cfoutput><strong>#DateFormat(from,"dd/mm/yyyy")# - #DateFormat(to,"dd/mm/yyyy")#</strong>
		<input type="button" class="btn" value="Excel" onclick="createExcelThis('from=#url.dateFrom#&to=#url.dateTo#&from2=#url.dateFrom2#&to2=#url.dateTo2#')"></cfoutput>
		</td>
		<cfset thisHTML = "#thisHTML#<tr><td><strong>AGENTE</strong></td><td><strong>RICHIESTE OFFERTA</strong></td><td><strong>CONTRATTI</strong></td><td><strong>FORNTIORI</strong></td><td><strong>CLIENTI SAV</strong></td><strong></strong><td><strong>TOTALE</strong></td></tr>">

	</tr>
	<tr>
		<td><strong>AGENTE</strong></td>
		<td><strong>RICHIESTE OFF.</strong></td>
		<td><strong>CONTRATTI</strong></td>
		<td><strong>%</strong></td>
		<td><strong>DIFF</strong></td>
		<td><strong>FORNITORI</strong></td>
		<td><strong>CLIENTE SAV</strong></td>
		<td><strong>TOTALE</strong></td>
	</tr>
	<cfset nr = 0>
	<cfset totale_altri = 0>
	<cfset totale_1 = 0>
	<cfset totale_sav = 0>
	<cfset totale_agente = 0>
	<cfset totale_contestati = 0>
	
	<cfoutput query="assegnazioni" group="ac_cognome">
	<tr>
		<td>#UCASE(ac_cognome)# #UCASE(ac_nome)#</td>
		
		<cfset cliente_sav = 0>
		<cfset cliente_agente = 0>
		<cfset contestati = 0>
		<cfset lista_clienti = "">
		<cfoutput>
			<cfset nr = nr + 1>
			<cfif ac_segnalatore EQ "COLLEAD" OR ac_segnalatore EQ "LGI" OR ac_segnalatore EQ "BETHEBOSS" OR ac_segnalatore EQ "DIGITOUCH" OR ac_segnalatore EQ "SITO">
				<cfset cliente_sav = cliente_sav + 1>
			<cfelse>
				<cfset cliente_agente = cliente_agente + 1>
			</cfif>	
			<cfset lista_clienti = "#lista_clienti##id_cliente#,">
			
		</cfoutput>
		<cfif Right(lista_clienti,1) EQ ",">
			<cfset lista_clienti = left(lista_clienti,len(lista_clienti)-1)>
		</cfif>
		<cfif Left(lista_clienti,1) EQ ",">
			<cfset lista_clienti = Right(lista_clienti,len(lista_clienti)-1)>
		</cfif>
		<cfinvoke component="statistiche" method="findStatus" returnvariable="contestato">
			<cfinvokeargument name="id_cliente" value="0">
			<cfinvokeargument name="lista_clienti" value="#lista_clienti#">
			<cfinvokeargument name="id_processo" value="7">
		</cfinvoke>
		<cfset contestati = contestati + contestato>
		<cfset totale_contestati = totale_contestati + contestato>
		<cfset totale_1 = totale_1 + nr>
		<cfset totale_sav = totale_sav + cliente_sav>
		<cfset totale_agente = totale_agente + ( nr - cliente_sav)>
		<td align="center">#nr#</td>
		<td align="center" style="color:red">#contestati#</td> 
		<td align="left">#decimalformat((contestati)/nr)*100#%</td>
		<td align="left"><strong>#nr-contestati#</strong> </td>
		<td align="center">#cliente_sav#</td>
		<td align="center">#nr-cliente_sav#</td>
		<td align="center">#nr#</td>
		
		<cfset thisHTML = "#thisHTML#<tr><td>#UCASE(ac_cognome)# #UCASE(ac_nome)#</td><td align='right'>#nr#</td><td align='right'>#contestati#</td><td align='right'>#cliente_sav#</td><td align='right'>#nr-cliente_sav#</td><td align='right'>#nr#</td></tr>">
	</tr>
	<cfset nr = 0>
</cfoutput>
	<tr>
		<cfoutput>
		<td align="center">Totale</td>
		<td align="center"><strong>#totale_1#</strong></td>
		<td align="center" style="color:red"><strong>#totale_contestati#</strong></td>
		<td align="left"><strong>#DecimalFormat((totale_contestati/totale_1)*100)#</strong></td>
		<td align="left"><strong>#totale_1-totale_contestati#</strong></td>
		
		<td align="center"><strong>#totale_sav#</strong></td>
		<td align="center"><strong>#totale_agente#</strong></td>
		<td align="center"><strong>#totale_1#</strong></td>
		</cfoutput>
	</tr>
	<cfoutput>
	<cfset thisHTML = "#thisHTML#<tr><td align='right'>Totale</td><td align='right'><strong>#totale_1#</strong></td><td align='right'><strong>#totale_contestati#</strong></td><td align='right'><strong>#totale_sav#</strong></td><td align='right'><strong>#totale_agente#</strong></td><td align='right'><strong>#totale_1#</strong></td></tr>">
	</cfoutput>
</table>
<cfelse>
	<div align="center"><strong>NON CI SONO RECORD CHE SODDISFANO LA RICERCA</strong></div>
</cfif>
</cfloop>

<cfelse>

<cfquery name="assegnazioni" datasource="#application.dsn#">
SELECT tbl_status.id_processo,
tbl_clienti.id_cliente,
tbl_clienti.id_agente,
tbl_clienti.ac_segnalatore,
tbl_persone.ac_cognome,
tbl_persone.ac_nome
FROM tbl_status 
INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
WHERE
( tbl_status.id_processo = 6)
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



<cfset thisHTML = "">
<cfif assegnazioni.recordcount GT 0>
<!--- <cfset appuntamento1 = conta1appuntamento.nr>
<cfset altriappuntamenti = appuntamenti.nr>
<cfset totale_appuntamenti = appuntamento1 + altriappuntamenti> --->

<table width="50%" cellspacing="0" cellpadding="2" style="border:1px solid #eaeaea">
	<tr>
		<td colspan="8" class="winblue">
		<cfset thisHTML = "#thisHTML#<tr><td colspan='6'><strong>RICHIESTE OFFERTA-CONTRATTI </strong>Periodo : <cfoutput><strong>#DateFormat(from,'dd/mm/yyyy')# - #DateFormat(to,'dd/mm/yyyy')#</strong></td></tr>">	
		<strong>RICHIESTE OFFERTA-CONTRATTI </strong> Periodo : <cfoutput><strong><strong>#DateFormat(from,"dd/mm/yyyy")# - #DateFormat(to,"dd/mm/yyyy")#</strong>
		<!--- &nbsp;&nbsp;&nbsp;<img src="../include/css/icons/files/xls.png" onclick="createExcel('#url.startprocesso#','#url.dateFrom#','#url.dateTo#')" style="cursor:pointer" title="Crea Excel"> ---><input type="button" class="btn" value="Excel" onclick="createExcelThis('from=#url.dateFrom#&to=#url.dateTo#')"></cfoutput>
		<cfset thisHTML = "#thisHTML#<tr><td><strong>AGENTE</strong></td><td><strong>RICHESTE OFF.</strong></td><td><strong>CONTRATTI</strong></td><td><strong>FORNITORI</strong></td><td><strong>CLIENTI SAV</strong></td><td><strong>TOTALE</strong></td></tr>">
		</td>
	</tr>
	<tr>
		<td><strong>AGENTE</strong></td>
		<td><strong>RICHIESTE OFF.</strong></td>
		<td><strong>CONTRATTI</strong></td>
		<td><strong>%</strong></td>
		<td><strong>DIFF</strong></td>
		<td><strong>FORNITORI</strong></td>
		<td><strong>CLIENTE SAV</strong></td>
		<td><strong>TOTALE</strong></td>
		
	</tr>
	<cfset nr = 0>
	<cfset totale_altri = 0>
	<cfset totale_1 = 0>
	<cfset totale_sav = 0>
	<cfset totale_agente = 0>
	<cfset totale_contestati = 0>
	<cfset lista_clienti = 0>
	<cfoutput query="assegnazioni" group="ac_cognome">
	<tr>
		<td>#UCASE(ac_cognome)# #UCASE(ac_nome)#</td>
		
		<cfset cliente_sav = 0>
		<cfset cliente_agente = 0>
		<cfset contestati = 0>
		<cfset lista_clienti = "">
		<cfoutput>
			<cfset nr = nr + 1>
			<cfif ac_segnalatore EQ "COLLEAD" OR ac_segnalatore EQ "LGI" OR ac_segnalatore EQ "BETHEBOSS" OR ac_segnalatore EQ "DIGITOUCH" OR ac_segnalatore EQ "SITO">
				<cfset cliente_sav = cliente_sav + 1>
			<cfelse>
				<cfset cliente_agente = cliente_agente + 1>
			</cfif>	
			<cfif id_cliente NEQ "">
			<cfset lista_clienti = "#lista_clienti##id_cliente#,">
			</cfif>
		<!--- 	<cfinvoke component="statistiche" method="findStatus" returnvariable="contestato">
				<cfinvokeargument name="id_cliente" value="#id_cliente#">
				<cfinvokeargument name="id_processo" value="11">
			</cfinvoke>
			<cfset contestati = contestati + contestato>
			<cfset totale_contestati = totale_contestati + contestato> --->
		</cfoutput>
		<cfif Right(lista_clienti,1) EQ ",">
			<cfset lista_clienti = left(lista_clienti,len(lista_clienti)-1)>
		</cfif>
		<cfif Left(lista_clienti,1) EQ ",">
			<cfset lista_clienti = Right(lista_clienti,len(lista_clienti)-1)>
		</cfif>
		<cfinvoke component="statistiche" method="findStatus" returnvariable="contestato">
			<cfinvokeargument name="id_cliente" value="0">
			<cfinvokeargument name="lista_clienti" value="#lista_clienti#">
			<cfinvokeargument name="id_processo" value="7">
		</cfinvoke>
		<cfset contestati = contestati + contestato>
		<cfset totale_contestati = totale_contestati + contestato>
		
		<cfset totale_1 = totale_1 + nr>
		<cfset totale_sav = totale_sav + cliente_sav>
		<cfset totale_agente = totale_agente + ( nr - cliente_sav)>
		<td align="center">#nr#</td>
		<td align="center" style="color:red">#contestati#</td> 
		<td align="left">#decimalformat((contestati)/nr)*100#%</td>
		<td align="left"><strong>#nr-contestati#</strong> </td>
		<td align="center">#cliente_sav#</td>
		<td align="center">#nr-cliente_sav#</td>
		<td align="center">
			#nr#
		</td>
		

		<cfset thisHTML = "#thisHTML#<tr><td>#UCASE(ac_cognome)# #UCASE(ac_nome)#</td><td align='right'>#nr#</td><td align='right'>#contestati#</td><td align='right'>#cliente_sav#</td><td align='right'>#nr-cliente_sav#</td><td align='right'>#nr#</td></tr>">
	</tr>
	<cfset nr = 0>
</cfoutput>
	<tr>
		<cfoutput>
		<td align="center">Totale</td>
		<td align="center"><strong>#totale_1#</strong></td>
		<td align="center" style="color:red"><strong>#totale_contestati#</strong></td>
		<td align="left"><strong>#DecimalFormat((totale_contestati/totale_1)*100)#</strong></td>
		<td align="left"><strong>#totale_1-totale_contestati#</strong></td>
		
		<td align="center"><strong>#totale_sav#</strong></td>
		<td align="center"><strong>#totale_agente#</strong></td>
		<td align="center"><strong>#totale_1#</strong></td>
		</cfoutput>
	</tr>
	<cfoutput>
	<cfset thisHTML = "#thisHTML#<tr><td align='right'>Totale</td><td align='right'><strong>#totale_1#</strong></td><td align='right'><strong>#totale_contestati#</strong></td><td align='right'><strong>#totale_sav#</strong></td><td align='right'><strong>#totale_agente#</strong></td><td align='right'><strong>#totale_1#</strong></td></tr>">
	</cfoutput>
</table>
<cfelse>
	<div align="center"><strong>NON CI SONO RECORD CHE SODDISFANO LA RICERCA</strong></div>
</cfif>
</cfif>

<br><br>
<br>
<cfset session.Excel = thisHTML>
<iframe id="excel_detail" name="excel_detail" style="display:none"></iframe>
<cfif remote_addr EQ "89.118.53.254">
<cfdump var="#thisHTML#">
<!--- <cfdump var="#conta1appuntamento#">
<cfdump var="#appuntamenti#"> --->
</cfif>

</body>
<!--- 
<strong>Totale appuntamenti</strong>
<cfoutput>#totale_appuntamenti# (1° appuntamento = #appuntamento1#    appuntamenti=#altriappuntamenti#)</cfoutput> --->

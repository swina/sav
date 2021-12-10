<cfheader name="Pragma" value="">
<cfheader name="Cache-control" value="">
<cfheader name="Content-disposition" value="attachment; filename=stat_processo_dettaglio.xls">
<cfcontent type="application/vnd.ms-excel">
<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="no">
<cfparam name="id_gruppo_agenti" default="">
<cfparam name="id_agente" default="">
<cfif url.id_gruppo_agenti NEQ "null">
	<cfset id_gruppo_agenti = url.id_gruppo_agenti>
<cfelse>
	<cfset id_gruppo_agenti = "">	
</cfif>
<cfif url.id_agente NEQ "null">
	<cfset id_agente = url.id_agente>
<cfelse>
	<cfset id_agente = "">	
</cfif>
<cfset a = SetLocale("Italian (Standard)")>
<!--- <cfinvoke component="statistiche" method="dettaglioProcessi" returnvariable="rsDetail">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="start_processo" value="#url.id_processo#">
	<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo_agenti#">
	<cfinvokeargument name="id_agente" value="#id_agente#">
</cfinvoke> --->
<cfinvoke component="statistiche" method="dettaglioProcessiAgenti" returnvariable="rsDetail">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="start_processo" value="#url.id_processo#">
	<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo_agenti#">
	<cfinvokeargument name="id_agente" value="#id_agente#">
</cfinvoke>
<cfset totale = 0>
<cfset totale_perc = 0>
<cfset nrprocessi = 0>
<cfset totale_clienti_sav = 0>
<cfset totale_clienti_extra = 0>
<body style="overflow:auto">
<table width="100%" cellspacing="0" cellpadding="2" border="1">
	<cfoutput>
	<tr>
		<td colspan="6">
		<strong style="font-size:14px">SAVEnergy</strong><br>
		
		<strong>ANALISI #rsDetail.ac_processo#</strong><br>
		Periodo dal #LSDateFormat(url.dateFrom,"dd mmm yyyy")# al #LSDateFormat(url.dateTo,"dd mmm yyyy")#
		</td>
	</tr>
	</cfoutput>
	<tr>
		<td bgcolor="silver"><strong>Gruppo</strong></td>
		<td bgcolor="silver"><strong>Agente</strong></td>
		<td bgcolor="silver"><strong>Totale</strong></td>
		<td bgcolor="silver" align="center"><strong>%</strong></td>
		
		<td bgcolor="silver"><strong>Clienti SAV</strong></td>
		<td bgcolor="silver"><strong>Clienti FORNITORI</strong></td>
		
	</tr>
<cfoutput query="rsDetail" group="ac_gruppo">
	
	<!--- <cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiExtra">
		<cfinvokeargument name="id_processo" value="#id_processo#">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo_agenti#">
		<cfinvokeargument name="id_agente" value="#id_agente#">
	</cfinvoke>
	<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiSAV">
		<cfinvokeargument name="id_processo" value="#id_processo#">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo_agenti#">
		<cfinvokeargument name="id_agente" value="#id_agente#">
		<cfinvokeargument name="tipo_clienti" value="1">
	</cfinvoke> --->
	
	<cfset nconta = 0>
	<cfset nrprocessi = 0>
	<cfoutput group="id_persona">
	
	<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiExtra">
		<cfinvokeargument name="id_processo" value="#id_processo#">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
		<cfinvokeargument name="id_agente" value="#id_persona#">
	</cfinvoke>
	<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiSAV">
		<cfinvokeargument name="id_processo" value="#id_processo#">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
		<cfinvokeargument name="id_agente" value="#id_persona#">
		<cfinvokeargument name="tipo_clienti" value="1">
	</cfinvoke>
		<cfoutput>
			<cfset nconta = nconta + 1>
			<cfset nrprocessi = nrprocessi + 1>
		</cfoutput>
		
	</cfoutput>
	<cfset perc_processi = DecimalFormat((nrprocessi/tp)*100)>
	<cfset totale_perc = totale_perc + ((nrprocessi/tp)*100)>
	
	<tr bgcolor="WhiteSmoke">
		<td colspan="2">
		<strong>#ac_gruppo#</strong></td>
		<td align="right"><strong>#nrprocessi#</strong></td>
		<td align="right"><strong>#perc_processi#</strong></td>
		
		<cfset perc_clienti_sav = DecimalFormat((nrClientiSav/(nrClientiSav+nrClientiExtra))*100)>
		
		<td><!--- #nrClientiSAV# (#perc_clienti_sav#%) ---></td>
		<td><!--- #nrClientiExtra# (#DecimalFormat(100-perc_clienti_sav)#)% ---></td>
		
	</tr>
	<cfoutput group="id_persona">
	<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiExtra">
		<cfinvokeargument name="id_processo" value="#id_processo#">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
		<cfinvokeargument name="id_agente" value="#id_persona#">
	</cfinvoke>
	<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiSAV">
		<cfinvokeargument name="id_processo" value="#id_processo#">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
		<cfinvokeargument name="id_agente" value="#id_persona#">
		<cfinvokeargument name="tipo_clienti" value="1">
	</cfinvoke>
	<cfset nagente = 0>
	<cfoutput>
		<cfset nagente = nagente + 1>
		<!--- <tr>
		<td colspan="10">#id_persona# #ac_cognome#</td>
		</tr> --->
	</cfoutput>
	<cfset npercagente = DecimalFormat((nagente/nrprocessi)*100)>
	
	<tr>
		<td></td>
		<td>#ac_cognome# #ac_nome#</td>
		<td>#nagente#</td>
		<td align="right">#npercagente#</td>
		<cfset tot_clienti = nrClientiSAV + nrClientiExtra>
		<cfset perc_sav = DecimalFormat((nrClientiSAV/tot_clienti)*100)>
		<cfset totale_clienti_sav = totale_clienti_sav + nrClientiSAV>
		<cfset totale_clienti_extra = totale_clienti_extra + nrClientiExtra>
		<td>#nrClientiSAV# (#perc_sav#%)</td>
		<td>#nrClientiExtra# (#DecimalFormat(100-perc_sav)#%)</td>
		
	</tr>
	</cfoutput>
<cfset totale = totale + nrprocessi>
</cfoutput>
	<cfoutput>
	<cfset perc_totale = DecimalFormat((totale_clienti_sav/(totale_clienti_sav+totale_clienti_extra))*100)>
	<tr>
		<td bgcolor="silver"></td>
		<td bgcolor="silver"><strong>Totale processi analizzati</strong></td>
		<td bgcolor="silver"><strong>#totale#</strong></td>
		<td bgcolor="silver"><strong>#round(totale_perc)#</strong></td>
		<td bgcolor="silver" align="right"><strong>#totale_clienti_sav# (#perc_totale#%)</strong></td>
		<td bgcolor="silver" align="right"><strong>#totale_clienti_extra# (#DecimalFormat(100-perc_totale)#%)</strong></td>
	</tr>
	</cfoutput>
</table>

<!--- <cfdump var="#rsDetail#"> --->
<!--- <cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="no">
<cfheader name="Pragma" value="">
<cfheader name="Cache-control" value="">
<cfheader name="Content-disposition" value="attachment; filename=stat_processo_dettaglio.xls">
<cfcontent type="application/vnd.ms-excel">

<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="yes">
<cfinvoke component="statistiche" method="dettaglioProcessi" returnvariable="rsDetail">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="start_processo" value="#url.id_processo#">
</cfinvoke>
<cfset totale = 0>
<cfset totale_perc = 0>
<cfset tp = url.tp>
<body style="overflow:auto">
<table cellspacing="0" cellpadding="2" border="1">
	<tr>
		<td colspan="8"  bgcolor="<cfoutput>###rsDetail.ac_colore#</cfoutput>">
		ANALISI PROCESSO <strong><cfoutput>#rsDetail.ac_processo# dal #url.dateFrom# al #url.dateTo#</cfoutput></strong>
		</td>
	</tr>
	<tr bgcolor="#eaeaea">
		<td width="60"><input type="button" class="btn" value="Confronta" onclick="confronta()"></td>
		<td><strong>Gruppo</strong></td>
		<td><strong>Totale</strong></td>
		<td align="center"><strong>%</strong></td>
		<td colspan="2"><strong>Clienti SAV</strong></td>
		<td colspan="2"><strong>Clienti FORNITORI</strong></td>
	</tr>
<cfoutput query="rsDetail">
	<cfset perc_processi = DecimalFormat((nrprocessi/tp)*100)>
	<cfset totale_perc = totale_perc + ((nrprocessi/tp)*100)>
	<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiExtra">
		<cfinvokeargument name="id_processo" value="#id_processo#">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
	</cfinvoke>
	<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiSAV">
		<cfinvokeargument name="id_processo" value="#id_processo#">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
		<cfinvokeargument name="tipo_clienti" value="1">
	</cfinvoke>
	<tr id="gruppo_#id_gruppo#" style="display:;">
		<td width="60">
		</td>
		<td>#ac_gruppo#</td>
		<td>#nrprocessi#</td>
		<td>#perc_processi#</td>
		<cfset perc_clienti_sav = DecimalFormat((nrClientiSav/(nrClientiSav+nrClientiExtra))*100)>
		<td>#nrClientiSAV#</td>
		<td>#perc_clienti_sav#%</td>
		<td>
		#nrClientiExtra#
		</td>
		<td>#DecimalFormat(100-perc_clienti_sav)#%</td>
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
		<td></td>
		<td></td>
		<td></td>
		
	</tr>
	</cfoutput>
</table> --->

<!--- <cfdump var="#rsDetail#"> --->
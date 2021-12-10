<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="no">
<cfheader name="Pragma" value="">
<cfheader name="Cache-control" value="">
<cfheader name="Content-disposition" value="attachment; filename=stat_processi.xls">
<cfcontent type="application/vnd.ms-excel">

<cfparam name="url.dateFrom" default="#DateFormat(DateAdd('d',-7,now()),'dd/mm/yyyy')#">
<cfparam name="url.dateTo" default="#DateFormat(DateAdd('d',7,now()),'dd/mm/yyyy')#">
<cfparam name="url.metodo" default="processiInCorsoDetail">
<cfparam name="url.id_gruppo_agenti" default="">
<cfparam name="url.id_agente" default="">
<cfparam name="url.startprocesso" default="">
<cfparam name="url.endprocesso" default="">
<cfparam name="gruppo" default="GRUPPO: Tutti">
<cfparam name="agente" default="AGENTE: Tutti">

<!--- Query the database and get all the records --->
<cfinvoke component="statistiche" method="contaProcessi" returnvariable="rsAll">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
	<cfinvokeargument name="start_processo" value="">
	<cfinvokeargument name="end_processo" value="">
</cfinvoke>
<cfinvoke component="analisi" method="calcola_giorni" returnvariable="ngiorni">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
</cfinvoke>


	<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiExtraTotali">
		<cfinvokeargument name="id_processo" value="">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
		<cfinvokeargument name="id_agente" value="#url.id_agente#">
	</cfinvoke>

	
<cfif url.id_gruppo_agenti NEQ "">
	<cfquery name="getGruppo" datasource="#application.dsn#">
	SELECT ac_gruppo FROM tbl_gruppi WHERE id_gruppo = #url.id_gruppo_agenti#
	</cfquery>
	<cfoutput>
		<cfset gruppo = "GRUPPO: #getGruppo.ac_gruppo#">
	</cfoutput>
<cfelse>
	<cfif url.id_agente NEQ "">
		<cfoutput>
			<cfset agente = "AGENTE: #rsAll.ac_cognome#">
		</cfoutput>
	</cfif>
</cfif>	
	
<cfset totale_generale = 0>
<cfloop query="rsAll">
	<cfset totale_generale = totale_generale + rsAll.nrprocessi>
</cfloop>
<cfset perc_totale = 0>
<cfset SAV = 0>
<cfset EXTRA = 0>
<table cellspacing="0" cellpadding="2" border="1">
	<tr>
		<td colspan="9">
		<h2>SAVEnergy</h2>
		<strong>ANALISI PROCESSI</strong> Periodo : <cfoutput><strong>#url.dateFrom# - #url.DateTo# &nbsp; #gruppo# - #agente#</strong></cfoutput>
		</td>
	</tr>
	<tr bgcolor="#eaeaea">
		<td width="50">
		<strong><input type="button" class="btn" value="Confronta" onclick="confronta()"></strong>
		</td>
		<td>
		<strong>PROCESSO</strong>
		</td>
		<td>
		<strong>TOTALE</strong>
		</td>
		<td align="center">
		<strong>%</strong>
		</td>
		<td colspan="2">
		<strong>CLIENTI SAV</strong>
		</td>
		<td colspan="2">
		<strong>CLIENTI FORNITORI</strong>
		</td>
		<td>
		<strong>TOTALE CLIENTI</strong>
		</td>
	</tr>	
<cfoutput query="rsAll" group="id_processo">
<cfset totale = 0>
<cfset clienti_sav = 0>
<cfset numero_sav = 0>
<cfset clienti_extra = 0>
<cfset numero_extra = 0>
<cfset perc = 0>


<cfoutput>
	<cfset totale = totale + nrprocessi>
	<cfif ac_segnalatore NEQ "LGI" AND ac_segnalatore NEQ "Collead">
		<cfset clienti_sav = clienti_sav + nrprocessi>
		<cfset numero_sav = numero_sav + nrprocessi>
	<cfelse>
		<cfset clienti_extra = clienti_extra + nrprocessi>
		<cfset numero_extra = numero_extra + nrprocessi>
	</cfif>
</cfoutput>
	<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiExtra">
		<cfinvokeargument name="id_processo" value="#id_processo#">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
		<cfinvokeargument name="id_agente" value="#url.id_agente#">
	</cfinvoke>
	<tr>
		<td width="50">
		</td>
		<td>
		#ac_processo#</a>
		</td>
		<td align="right">
		<strong>#totale#</strong>
		</td>
		<td align="right">
		<cfset perc_totale = perc_totale + ((totale/totale_generale)*100)>
		<cfset perc = (totale/totale_generale)*100>
		#DecimalFormat(perc)# 
		</td>
		
		<td align="right">
		<cfset clienti_sav = totale-nrClientiExtra>
		<cfset perc_clienti_sav = DecimalFormat((clienti_sav/totale)*100)>
		<cfset SAV = SAV + clienti_sav>
		#clienti_sav# 
		</td>
		<td align="right">
		#perc_clienti_sav#%</td>
		<td align="right">
		<cfset perc_clienti_extra = DecimalFormat((nrClientiExtra/totale)*100)>
		<cfset EXTRA = EXTRA + nrClientiExtra>
		#nrClientiExtra# 
		</td>
		<td align)"right">
		#perc_clienti_extra#%
		</td>
		<td align="right">
		#totale# 
		</td>
	</tr>

</cfoutput>
	<cfoutput>
	<tr>
		<cfset perc_SAV = DecimalFormat(SAV/(SAV+EXTRA)*100)>
		<td colspan="2"><strong>Totale processi analizzati:</strong> </td>
		<td><strong>#totale_generale#</strong></td>
		<td align="right"><strong>#DecimalFormat(perc_totale)# %</strong></td>
		<td><strong>#SAV#</strong></td>
		<td><strong>#perc_SAV#&nbsp;</strong></td>
		<td><strong>#EXTRA#</strong></td>
		<td><strong>#DecimalFormat(100-perc_SAV)#&nbsp;</strong></td>
		<td><strong>#SAV+EXTRA#</strong></td>
	</tr>
	</cfoutput>
	
</table>

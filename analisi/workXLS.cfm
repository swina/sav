<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="yes">
<cfheader name="Pragma" value="">
<cfheader name="Cache-control" value="">
<cfheader name="Content-disposition" value="attachment; filename=Confronto Processi.xls">
<cfcontent type="application/vnd.ms-excel">
<cfparam name="url.id_processo" default="3,7">
<cfparam name="url.dateFrom" default="#DateFormat(DateAdd('d',-15,now()),'dd/mm/yyyy')#">
<cfparam name="url.dateTo" default="#DateFormat(DateAdd('d',-1,now()),'dd/mm/yyyy')#">
<cfparam name="url.gruppi" default="">
<cfinvoke component="statistiche" method="confrontaProcessiDetail" returnvariable="rsDetail">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="start_processo" value="#url.id_processo#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.gruppi#">
	<cfinvokeargument name="scope" value="XLS">
</cfinvoke>

<cfinvoke component="statistiche" method="getNomeProcessi" returnvariable="listProcessi">
	<cfinvokeargument name="id_processo" value="#url.id_processo#">
</cfinvoke>
<cfset totale = 0>
<cfset totale_perc = 0>
<table width="100%" cellspacing="0" cellpadding="2" border="1">
	<tr bgcolor="#fff">
		<td colspan="11">
		<h2><strong>SAVEnergy</strong></h2>
		</td>
	</tr>
	<tr bgcolor="#fff">
		<td colspan="11">
		<h4><strong>Confronto &raquo; <cfloop index="i" list="#listProcessi#"><cfoutput>[#i#] </cfoutput></cfloop> Periodo: <cfoutput>#url.dateFrom# - #url.dateTo#</cfoutput></strong></h4>
		</td>
	</tr>
	<tr bgcolor="silver">
		<td><strong>Gruppo</strong></td>
		<td><strong>Agente</strong></td>
		<cfloop index="processo" list="#listProcessi#">
			<cfoutput>
			<td><strong>#processo#</strong></td>
			<td><strong>%</strong></td>
			</cfoutput>
		</cfloop>
		<td><strong>Clienti SAV</strong></td>
		<td><strong>Clienti FORNITORI</strong></td>
		<td><strong>% su Clienti</strong></td>
	</tr>
	
<cfset thisGruppo = "">
<cfset listaTotali = "">
<cfset totale_generale = ArrayNew(1)>
<cfset SAV = 0>
<cfset EXTRA = 0>

<cfloop index="i" from="1" to="#ListLen(url.id_processo)#">
	<cfset totale_generale[i] = 0>
	<cfset valori[i] = 0>
	<cfset valori_gruppo[i] = 0>
	<cfinvoke component="statistiche" method="contaProcessiGruppo" returnvariable="totale_processo">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="start_processo" value="#ListGetAt(url.id_processo,i)#">
	</cfinvoke>
	<cfset totali[i] = totale_processo>
</cfloop>

<cfoutput query="rsDetail" group="ac_gruppo">
	<tr bgcolor="silver">
		<td colspan="11"><strong>#ac_gruppo#</strong></td>
	</tr>
	<cfloop index="i" from="1" to="#ListLen(url.id_processo)#">
		<cfset valori_gruppo[i] = 0>
	</cfloop>
	<cfset totale_SAV = 0>
	<cfset totale_EXTRA = 0>
	<cfset totale_clienti_SAV = 0>
	<cfset totale_clienti_EXTRA = 0>	
	<cfset n = 1>
		<cfoutput group="ac_cognome">
			<cfloop index="i" from="1" to="#ListLen(url.id_processo)#">
				<cfset valori[i] = 0>
			</cfloop>
			
			<cfset totale_clienti_SAV = 0>
	<cfset totale_clienti_EXTRA = 0>	
		<tr>
			<td></td>
			<td>#UCASE(ac_cognome)#</td>
			<cfset x = 1>
			<cfoutput group="id_processo">
			
				<cfinvoke component="statistiche" method="contaProcessiGruppo" returnvariable="totale_processo_gruppo">
					<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
					<cfinvokeargument name="dateTo" value="#url.dateTo#">
					<cfinvokeargument name="start_processo" value="#id_processo#">
					<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
				</cfinvoke>
			
				<cfset totale_processo_agente = 0>
				<cfoutput>
					<cfif ac_segnalatore NEQ "LGI" AND ac_segnalatore NEQ "COLLEAD">
						<cfset totale_clienti_SAV = totale_clienti_SAV + 1>
					<cfelse>
						<cfset totale_clienti_EXTRA = totale_clienti_EXTRA +1>	
					</cfif>
					<cfset totale_processo_agente = totale_processo_agente + 1>
				</cfoutput>
				<cfset aPos = ListFind(url.id_processo,id_processo)>
				<cfset valori[aPos] = "#totale_processo_agente#">
				<cfset valori_gruppo[aPos] = "#totale_processo_gruppo#">
			</cfoutput> 
			<cfset totale_SAV = totale_SAV + totale_clienti_SAV>
			<cfset totale_EXTRA = totale_EXTRA + totale_clienti_EXTRA>
			<cfloop index="col" from="1" to="#ListLen(url.id_processo)#">
				<cfif valori[col] NEQ 0>
					<cfset perc_agente = DecimalFormat((valori[col]/(totali[col])*100))>
				<cfelse>
					<cfset perc_agente = 0>	
				</cfif>
				<td>#valori[col]#</td>
				<td>#perc_agente#%&nbsp;</td>
				<cfset totale_generale[col]= totale_generale[col] + valori[col]>
			</cfloop>
			<cfset perc_clienti_agente = DecimalFormat((totale_clienti_SAV/(totale_clienti_SAV+totale_clienti_EXTRA))*100)>
			<td>
			#totale_clienti_SAV# 
			</td>
			<td>
			#totale_clienti_EXTRA#
			</td>
			<td>
			#round(perc_clienti_agente)#% - #round(DecimalFormat(100-perc_clienti_agente))#%&nbsp;
			</td>
		</tr>
		<cfset n = n + 1>
		</cfoutput>
		<cfset perc_clienti_gruppo = DecimalFormat((totale_SAV/(totale_SAV+totale_EXTRA))*100)>
		<tr>
			<td colspan="2"><strong>TOTALE GRUPPO</strong></td>
			<cfloop index="col" from="1" to="#ListLen(url.id_processo)#">
				<cfif valori_gruppo[col] NEQ 0>
					<cfset perc_gruppo = DecimalFormat((valori_gruppo[col]/totali[col])*100)>
				<cfelse>
					<cfset perc_gruppo = 0>	
				</cfif>
				<td><strong>#valori_gruppo[col]#</strong></td>
				<td><strong>#perc_gruppo#%&nbsp;</strong></td>
			</cfloop>
			<td><strong>#totale_SAV#</strong></td>
			<td><strong>#totale_EXTRA#</strong></td>
			<td><strong>#perc_clienti_gruppo#% - #DecimalFormat(100-perc_clienti_gruppo)#%</strong></td>
		</tr>
		<cfset SAV = SAV + totale_SAV>
		<cfset EXTRA = EXTRA + totale_EXTRA>
</cfoutput>
<cfoutput>
<tr bgcolor="silver">
		<td colspan="2"><strong>TOTALE</strong></td>
		<cfloop index="i" from="1" to="#ListLen(url.id_processo)#">
		<cfif totale_generale[i] GT 0>
			<cfset perc_totale = DecimalFormat((totale_generale[i]/totali[i])*100)>
		<cfelse>
			<cfset perc_totale = 0>	
		</cfif>
			
		<td><strong>#totale_generale[i]#</strong></td>
		<td><strong>#perc_totale#%&nbsp;</strong></td>
		</cfloop>
		<td><strong>#SAV#</strong></td>
		<td><strong>#EXTRA#</strong></td>
		<td>
		<cfset perc_totale = DecimalFormat((SAV/(SAV+EXTRA))*100)>
		<strong>#perc_totale#% - #DecimalFormat(100-perc_totale)#%</strong>
		</td>
</tr>
</cfoutput>
</table>
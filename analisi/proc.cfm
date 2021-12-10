<cfparam name="url.id_processo" default="3,7">
<cfparam name="url.dateFrom" default="1/4/2011">
<cfparam name="url.dateTo" default="11/05/2011">
<cfparam name="url.tp" default="2,33">
<cfinvoke component="statistiche" method="confrontaProcessi" returnvariable="rsDetail">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="start_processo" value="#url.id_processo#">
</cfinvoke>

<cfinvoke component="statistiche" method="getNomeProcessi" returnvariable="listProcessi">
	<cfinvokeargument name="id_processo" value="#url.id_processo#">
</cfinvoke>
<cfset totale = 0>
<cfset totale_perc = 0>
<cfset totale_a = 0>
<cfset totale_b = 0>
<cfset totale_sav = 0>
<cfset totale_extra = 0>
<cfset totale_clienti = 0>
<cfset thisGruppo = 0>
<table border="1">
<cfset x = 0>
<cfset a = 1>
<cfset b = 0>
	<tr>
		<td>GRUPPO</td>
	<cfloop index="proc" list="#listProcessi#">
		<cfoutput>
		<td>#proc#</td>
		</cfoutput>
	</cfloop>
		<td align="left"><strong>% sul totale periodo</strong></td>
		<td colspan="2"><strong>Clienti SAV</strong></td>
		<td colspan="2"><strong>Clienti FORNITORI</strong></td>
	<cfset testata = false>
<cfoutput query="rsDetail">
	<cfif thisGruppo NEQ id_gruppo>
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
		
		<cfset totale_sav = totale_sav + nrClientiSav>
		<cfset totale_extra = totale_extra + nrClientiExtra>
		<cfset totale_clienti = totale_clienti + totale_sav + totale_extra>
		<cfset url.cs = nrClientiSav>
		<cfset url.ce = nrClientiExtra>
		<cfset perc_processi = DecimalFormat((nrprocessi/tp)*100)>
		<cfset totale_perc = totale_perc + ((nrprocessi/tp)*100)>
		<cfset perc_clienti_sav = DecimalFormat((nrClientiSav/(nrClientiSav+nrClientiExtra))*100)>
		
		<cfif x EQ 2>
		
			<td>
			#DecimalFormat((b/a)*100)#%
			</td>
			
					
		<td width="40">#nrClientiSAV#</td>
		<td>#perc_clienti_sav#%</td>
		<td width="40">#nrClientiExtra#</td>
		<td>#DecimalFormat(100-perc_clienti_sav)#%</td>

			
		<cfelse>
			<cfif testata IS false>
				<cfset testata = true>
			<cfelse>
				<td>
				0
				</td>
				<td>0</td>
				<td width="40">#nrClientiSAV#</td>
		<td>#perc_clienti_sav#%</td>
		<td width="40">#nrClientiExtra#</td>
		<td>#DecimalFormat(100-perc_clienti_sav)#%</td>
				
			</cfif>
		</cfif>
		<cfset x = 0>
	</tr>
		<tr>
			<td>#ac_gruppo#</td>
			<td>#nrprocessi#</td>
			<cfset a = nrprocessi>
			<cfset totale_a = totale_a + nrprocessi>
		<cfset x = x + 1>
	<cfelse>
	<td>#nrprocessi#</td> 
		<cfset b = nrprocessi>
		<cfset totale_b = totale_b + nrprocessi>
	<cfset x = x + 1>
	</cfif>
	<cfset thisGruppo = id_gruppo>
</cfoutput>
	<cfif x EQ 2>
	<td>
		<cfoutput>#DecimalFormat((b/a)*100)#%
		
		<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiExtra">
			<cfinvokeargument name="id_processo" value="#id_processo#">
			<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
			<cfinvokeargument name="dateTo" value="#url.dateTo#">
			<cfinvokeargument name="id_gruppo_agenti" value="#thisGruppo#">
		</cfinvoke>
		<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiSAV">
			<cfinvokeargument name="id_processo" value="#id_processo#">
			<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
			<cfinvokeargument name="dateTo" value="#url.dateTo#">
			<cfinvokeargument name="id_gruppo_agenti" value="#thisGruppo#">
			<cfinvokeargument name="tipo_clienti" value="1">
		</cfinvoke>
		<cfset url.cs = nrClientiSav>
		<cfset url.ce = nrClientiExtra>
		<cfset perc_processi = DecimalFormat((b/tp)*100)>
		<cfset totale_perc = totale_perc + ((b/tp)*100)>
		<cfset perc_clienti_sav = DecimalFormat((nrClientiSav/(nrClientiSav+nrClientiExtra))*100)>
		
		<td width="40">#nrClientiSAV#</td>
		<td>#perc_clienti_sav#%</td>
		<td width="40">#nrClientiExtra#</td>
		<td>#DecimalFormat(100-perc_clienti_sav)#%</td></cfoutput>
	</td>
	</cfif>
	</tr>
	<tr>
		<cfoutput>
		<td></td>
		<td>#totale_a#</td>
		<td>#totale_b#</td>
		<td>#DecimalFormat((totale_b/totale_a)*100)#%</td>
		<td width="40">#totale_sav#</td>
		<td>#DecimalFormat((totale_sav/totale_clienti)*100)#%</td>
		<td width="40">#totale_extra#</td>
		<td>#DecimalFormat((totale_extra/totale_clienti)*100)#%</td>
		</cfoutput>
	</tr>
	<tr>
		<td colspan="4"></td>
		<td colspan="4" align="center"><cfoutput>Totale Clienti : #totale_clienti#</cfoutput></td>
	</tr>
</table>
<cfdump var="#rsDetail#">
<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="no">
<cfheader name="Pragma" value="">
<cfheader name="Cache-control" value="">
<cfheader name="Content-disposition" value="attachment; filename=assegnazioni.xls">
<cfcontent type="application/vnd.ms-excel">
<cfparam name="url.dateFrom" default="#DateFormat(DateAdd('d',-7,now()),'dd/mm/yyyy')#">
<cfparam name="url.dateTo" default="#DateFormat(DateAdd('d',7,now()),'dd/mm/yyyy')#">
<cfparam name="url.id_gruppo_agenti" default="">
<cfparam name="url.id_agente" default="">

<cfinvoke component="statistiche" method="assegnazioniClienti" returnvariable="rsDetail">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="mode" value="normal">
</cfinvoke>
<cfinvoke component="statistiche" method="assegnazioniClienti" returnvariable="rsCount">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="mode" value="count">
</cfinvoke>


<cfset tc = rsCount.totale_clienti>
<cfset totale_perc = 0>
<cfset tc_sav = 0>
<cfset tc_extra = 0>
<body style="overflow:auto">
<table width="99%" cellspacing="0" cellpadding="2" border="1">
	<tr>
		<td colspan="8" class="winblue">
		<h2>SAVEnergy</h2>
		<strong>ASSEGNAZIONI CLIENTI</strong> Periodo <strong><cfoutput>dal #url.dateFrom# al #url.dateTo#</cfoutput></strong>
		</td>
	</tr>
	<tr bgcolor="silver">
		<td width="60"></td>
		<td><strong>Gruppo</strong></td>
		<td><strong>Totale</strong></td>
		<td align="center"><strong>%</strong></td>
		<td><strong>Clienti PROPRI</strong></td>
		<td><strong>%</strong></td>
		<td><strong>Clienti SEDE</strong></td>
		<td><strong>%</strong></td>
	</tr>

<cfoutput query="rsDetail">
	<cfset perc_clienti = DecimalFormat((nrclienti/tc)*100)>
	<cfset totale_perc = totale_perc + ((nrclienti/tc)*100)>
	<cfset nrClientiSav = 1>
	<cfset nrClientiExtra = 1>
	<cfset perc_clienti_sav = 100>
	<cfset perc_clienti_extra = 100>
	<cfinvoke component="statistiche" method="contaClientiAssegnati" returnvariable="nrClientiExtra">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
		<cfinvokeargument name="mode" value="extra">
	</cfinvoke>
	<cfinvoke component="statistiche" method="contaClientiAssegnati" returnvariable="nrClientiSAV">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
		<cfinvokeargument name="mode" value="normal">
	</cfinvoke>
	<tr id="gruppo_#id_gruppo#" style="display:;">
		<td width="60">
		<td>#ac_gruppo#</td>
		<td>#nrclienti#</td>
		<td>#perc_clienti#&nbsp;</td>
		
		<cfif nrClientiSav NEQ "">
			<cfif nrClientiExtra EQ "">
				<cfset nrClientiExtra = 0>
			</cfif>
			<cfset perc_clienti_sav = DecimalFormat((nrClientiSav/(nrClientiSav+nrClientiExtra))*100)>
		<cfelse>
			<cfset perc_clienti_sav = 0>
			<cfset nrClientiSAV = 0>	
		</cfif>
		<cfif nrClientiExtra EQ "">
			<cfset perc_clienti_extra = 0>
			<cfset nrClientiExtra = 0>
		</cfif>
		<cfset tc_sav = tc_sav + nrClientiSAV>
		<cfset tc_extra = tc_extra + nrClientiExtra>
		<td>#nrClientiSAV# </td>
		<td>#perc_clienti_sav#%</td>
		<td>#nrClientiExtra#</td>
		<td>#DecimalFormat(100-perc_clienti_sav)#%</td>
	</tr>
<!--- <cfset totale = totale + nrprocessi> --->
</cfoutput>
	<cfoutput>
	<cfset perc_tc_sav = DecimalFormat((tc_sav/tc)*100)>
	<tr bgcolor="silver">
		<td></td>
		<td><strong>Totale </strong></td>
		<td><strong>#tc#</strong></td>
		<td><strong>#round(totale_perc)#</strong></td>
		<td><strong>#tc_sav#</strong></td>
		<td>
		<strong> #perc_tc_sav#%&nbsp;</strong>
		</td>
		<td><strong>#tc_extra#</strong></td>
		<td>
		<strong>#DecimalFOrmat(100-perc_tc_sav)#%</strong>
		</td>
		
	</tr>
	</cfoutput>
</table>
<!--- <cfdump var="#rsDetail#"> --->
<!--- <cfdump var="#rsCount#"> --->
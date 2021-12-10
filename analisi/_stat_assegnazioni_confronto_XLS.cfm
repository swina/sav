<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="yes">
<cfheader name="Pragma" value="">
<cfheader name="Cache-control" value="">
<cfheader name="Content-disposition" value="attachment; filename=confronto assegnazioni.xls">
<cfcontent type="application/vnd.ms-excel">

<cfparam name="url.dateFrom" default="#DateFormat(DateAdd('d',-7,now()),'dd/mm/yyyy')#">
<cfparam name="url.dateTo" default="#DateFormat(DateAdd('d',7,now()),'dd/mm/yyyy')#">
<cfinvoke component="statistiche" method="assegnazioniDetail" returnvariable="rsDetail">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="scopo" value="detail">
</cfinvoke>
<!--- <cfinvoke component="statistiche" method="assegnazioniClienti" returnvariable="rsCount">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.gruppi#">
	<cfinvokeargument name="mode" value="count">
</cfinvoke> --->


<cfset tc = 0>
<cfset tc_gruppo = 0>
<cfset totale_perc = 0>
<cfset tc_sav = 0>
<cfset tc_extra = 0>
<cfset tc_gruppo_sav = 0>
<cfset tc_gruppo_extra = 0>
<body style="overflow:auto">
<table width="99%" cellspacing="0" cellpadding="2" border="1">
	<tr>
		<td colspan="7" class="winblue">
		<cfoutput>
		<h2>SAVEnergy</h2>
		<strong>CONFRONTO ASSEGNAZIONI CLIENTI Periodo</strong> <strong>dal #url.dateFrom# al #url.dateTo#<!---  &nbsp;&nbsp;&nbsp;<img src="../include/css/icons/files/xls.png" onclick="createExcel('#url.id_processo#','#url.dateFrom#','#url.dateTo#','#url.tp#','#url.cs#','#url.ce#')" style="cursor:pointer" title="Crea Excel"> ---></strong>
		</cfoutput>
		</td>
	</tr>
	<tr bgcolor="silver">
		<td><strong>Gruppo/Agente</strong></td>
		<td><strong>Totale</strong></td>
		<td align="center"><strong>%</strong></td>
		<td><strong>Clienti SAV</strong></td>
		<td><strong>%</strong></td>
		<td><strong>Clienti FORNITORI</strong></td>
		<td><strong>%</strong></td>
	</tr>

<cfoutput query="rsDetail" group="ac_gruppo">
	
	<cfset perc_clienti = 0>
	<cfset totale_perc = 0>
	<cfset nrClientiSav = 1>
	<cfset nrClientiExtra = 1>
	<cfset perc_clienti_sav = 100>
	<cfset perc_clienti_extra = 100>
	<cfinvoke component="statistiche" method="contaClientiAssegnati" returnvariable="nrClientiExtra">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
		<cfinvokeargument name="id_agente" value="">
		<cfinvokeargument name="mode" value="extra">
	</cfinvoke>
	<cfinvoke component="statistiche" method="contaClientiAssegnati" returnvariable="nrClientiSAV">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
		<cfinvokeargument name="id_agente" value="">
		<cfinvokeargument name="mode" value="normal">
	</cfinvoke>
	<tr bgcolor="silver">
		<td><strong>#ac_gruppo#</strong></td>
		<td align="center"><strong>#nrClientiSAV+nrClientiExtra#</strong></td>
		<td align="center">
		<cfset perc_clienti = DecimalFormat(((nrClientiSAV+nrClientiExtra)/url.tp)*100)>
		<strong>#perc_clienti#</strong>
		</td>
		<td align="center"><strong>#nrClientiSAV#</strong></td>
		<td align="center">
		<cfset perc_SAV = DecimalFormat((nrClientiSAV/(nrClientiSAV+nrClientiExtra)*100))>
		#perc_SAV#%&nbsp;
		</td>
		<td align="center"><strong>#nrClientiExtra#</strong></td>
		<td align="center">
		#DecimalFormat(100-perc_sav)#
		</td>
	</tr>
	<cfoutput group="ac_cognome">
	
	<cfset nrClientiExtraAgente = 0>
	<cfset nrClientiSAVAgente = 0>
	
	<cfinvoke component="statistiche" method="contaClientiAssegnati" returnvariable="nrClientiExtraAgente">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="">
		<cfinvokeargument name="id_agente" value="#id_persona#">
		<cfinvokeargument name="mode" value="extra">
	</cfinvoke>
	<cfinvoke component="statistiche" method="contaClientiAssegnati" returnvariable="nrClientiSAVAgente">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="">
		<cfinvokeargument name="id_agente" value="#id_persona#">
		<cfinvokeargument name="mode" value="normal">
	</cfinvoke>
	<cfif nrClientiSAVAgente EQ "">
		<cfset nrClientiSAVAgente = 0>
	</cfif>
	<cfif nrClientiExtraAgente EQ "">
		<cfset nrClientiExtraAgente = 0>
	</cfif>
	<cfset clienti_agente = 0>
	<cfoutput>
		<cfset clienti_agente = clienti_agente + 1>
	</cfoutput>
	<cfif nrClientiSAVAgente NEQ 0 AND nrClientiExtraAgente NEQ 0>
		<cfset perc_sav_agente = DecimalFormat((nrClientiSAVAgente/(nrClientiExtraAgente+nrClientiSAVAgente)*100))>	
	<cfelse>
		<cfif nrClientiSAVAgente EQ 0>
			<cfset perc_sav_agente = 0>
		</cfif>
		<cfif nrClientiExtraAgente EQ 0>
			<cfset perc_sav_agente = 100>
		</cfif>
	</cfif>
	<tr>
		<td>#UCASE(ac_cognome)# #UCASE(ac_nome)#</td>
		<td align="center">#nrClientiSAVAgente+nrClientiExtraAgente#</td>
		<td align="center">
		<cfset perc_agente = DecimalFormat(clienti_agente/(nrClientiSAV+nrClientiExtra)*100)>
		#perc_agente#%&nbsp;
		</td>
		<td align="center">
		#nrClientiSAVAgente#
		</td>
		<td align="center">
		#perc_sav_agente#%&nbsp;
		</td>
		<td align="center">
		#nrClientiExtraAgente#
		</td>
		<td align="center">
		#DecimalFormat(100-perc_sav_agente)#%&nbsp;
		</td>
	</tr>
	</cfoutput>
</cfoutput>

</table>

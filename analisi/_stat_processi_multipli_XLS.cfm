<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="no">
<cfheader name="Pragma" value="">
<cfheader name="Cache-control" value="">
<cfheader name="Content-disposition" value="attachment; filename=stat_confronto_processi.xls">
<cfcontent type="application/vnd.ms-excel">

<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="no">
<cfparam name="url.id_processo" default="3,7">
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
<body style="overflow:auto">

<table cellspacing="0" cellpadding="2" border="1">
	<tr bgcolor="#fff">
		<td colspan="8">
		<strong>Confronto &raquo; <cfloop index="i" list="#listProcessi#"><cfoutput>[#i#] </cfoutput></cfloop> <cfoutput>dal #url.dateFrom# al #url.dateTo#</cfoutput></strong>
		</td>
	</tr>
	<tr bgcolor="#eaeaea">
		<td width="60"><input type="button" class="btn" value="Confronta" onclick="confronta()"></td>
		<td><strong>Gruppo</strong></td>
		<cfloop index="n" list="#listProcessi#">
		<cfoutput>
		<td>#n#</td>
		</cfoutput>
		</cfloop>
		<td><strong>Totale</strong></td>
		<td align="left"><strong>% sul totale periodo</strong></td>
		<td colspan="2"><strong>Clienti SAV</strong></td>
		<td colspan="2"><strong>Clienti FORNITORI</strong></td>
	</tr>
	<cfset lista_tp = "#url.tp#">
	<cfset thisGruppo = "">
<cfoutput query="rsDetail">

	<cfset totale = 0>
	<cfset totale_gruppo = 0>
	<cfset pos = listfind(url.id_processo,id_processo)>
	<cfset tp = ListGetAt(lista_tp,pos)>
	<!--- <cfset url.tp = tp> --->

	<cfif thisGruppo NEQ ac_gruppo>
	<tr id="gruppo_#id_gruppo#" style="display:;"  bgcolor="##eaeaea">
		<td>
		
		</td>
		<td>
		<strong> #ac_gruppo#</strong> 
		</td>
		<td>#nrprocessi#</td>
		<td colspan="5"></td>
	</tr>
	</cfif>
	<cfset thisGruppo = ac_gruppo>
	<tr>
		<td width="60">
		<td>
		#ac_processo#
		</td>
		<td>#nrprocessi#</td>
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
		<cfset url.cs = nrClientiSav>
		<cfset url.ce = nrClientiExtra>
		<cfset perc_processi = DecimalFormat((nrprocessi/tp)*100)>
		<cfset totale_perc = totale_perc + ((nrprocessi/tp)*100)>
		<cfset perc_clienti_sav = DecimalFormat((nrClientiSav/(nrClientiSav+nrClientiExtra))*100)>
		<td>#DecimalFormat(perc_processi)#</td>
		<td width="40">#nrClientiSAV#</td>
		<td>#perc_clienti_sav#%</td>
		<td width="40">#nrClientiExtra#</td>
		<td>#DecimalFormat(100-perc_clienti_sav)#%</td>
	</tr>
	<cfset totale = totale + nrprocessi>
	
</cfoutput>
	
</table>

<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
<script src="../include/js/functions.js"></script>
<style>
TD { text-align:right ; height:22px; border-bottom:1px solid #eaeaea}
</style>

<script>
function createExcel(processo,dal,al,tp){
	obj("excel_detail").src = "_stat_processi_rapporto_XLS.cfm?id_processo=" + processo + "&dateFrom=" + dal + "&dateTo=" + al + "&tp=" + tp;
}
</script>
<body style="overflow:auto">
<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="yes">
<cfparam name="url.id_processo" default="3,4">
<cfparam name="url.dateFrom" default="1/4/2011">
<cfparam name="url.dateTo" default="11/05/2011">
<cfparam name="url.tp" default="192,88">
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
<cfset x = 0>
<cfset a = 1>
<cfset b = 0>
<table border="0" width="800" cellpadding="2" cellspacing="0" style="border:1px solid #eaeaea">
	<tr bgcolor="#fff">
		<td colspan="8" style="text-align:left">
		<strong>RAPPORTO &raquo; <cfloop index="i" list="#listProcessi#"><cfoutput>[#i#] </cfoutput></cfloop> &nbsp;&nbsp;&nbsp;<cfoutput><img src="../include/css/icons/files/xls.png" onclick="createExcel('#url.id_processo#','#url.dateFrom#','#url.dateTo#','#url.tp#')" style="cursor:pointer" title="Crea Excel" border="0"></cfoutput></strong>
		</td>
	</tr>
	<tr>
		<td style="text-align:left"><strong>GRUPPO</strong></td>
	<cfloop index="proc" list="#listProcessi#">
		<cfoutput>
		<td><strong>#proc#</strong></td>
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
		<cfif x GT 0>
		<cfset perc_processi = DecimalFormat((nrprocessi/ListGetAt(tp,x))*100)>
		<cfset totale_perc = totale_perc + ((nrprocessi/ListGetAt(tp,x))*100)>
		<cfset perc_clienti_sav = DecimalFormat((nrClientiSav/(nrClientiSav+nrClientiExtra))*100)>
		</cfif>
		<cfif x EQ 2>
		
			<td align="right">
			<cfset rapporto = (b/a)*100>
			<cfif rapporto LT 100>
				#DecimalFormat((b/a)*100)#%
			<cfelse>
				100.00% <cfset rapporto = 100>	
			</cfif>
			<img src="../include/css/dot-trasp.png" width="#rapporto#" height="10" style="background:green;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-rapporto#" height="10" style="background:white;border:1px solid black">
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
			<td style="text-align:left">#ac_gruppo#</td>
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
	<cfif x GT 2>
		<cfset x = 0>
	</cfif>
	<cfset thisGruppo = id_gruppo>
</cfoutput>
	<cfoutput>

	<cfif x EQ 2>
	<td align="right">
		<cfset rapporto = (b/a)*100>
		<cfif rapporto LT 100>
			#DecimalFormat((b/a)*100)#%
		<cfelse>
			100.00% <cfset rapporto = 100>	
		</cfif>
		
			<img src="../include/css/dot-trasp.png" width="#rapporto#" height="10" style="background:green;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-rapporto#" height="10" style="background:white;border:1px solid black">
	</td>	
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
		<cfset perc_processi = DecimalFormat((b/ListGetAt(tp,x))*100)>
		<cfset totale_perc = totale_perc + ((b/ListGetAt(tp,x))*100)>
		<cfset perc_clienti_sav = DecimalFormat((nrClientiSav/(nrClientiSav+nrClientiExtra))*100)>
		
		<td width="40">#nrClientiSAV#</td>
		<td>#perc_clienti_sav#%</td>
		<td width="40">#nrClientiExtra#</td>
		<td>#DecimalFormat(100-perc_clienti_sav)#%</td>
	</cfif>
	</cfoutput>
	</tr>
	<tr>
		<cfoutput>
		<td></td>
		<td>#totale_a#</td>
		<td>#totale_b#</td>
		<td align="right">#DecimalFormat((totale_b/totale_a)*100)#%</td>
		<td width="40">#totale_sav#</td>
		<td>#DecimalFormat((totale_sav/totale_clienti)*100)#%</td>
		<td width="40">#totale_extra#</td>
		<td>#DecimalFormat((totale_extra/totale_clienti)*100)#%</td>
		</cfoutput>
	</tr>
	<tr>
		<td colspan="4"></td>
		<td colspan="4" align="center"  style="text-align:center"><cfoutput>Totale Clienti : #totale_clienti#</cfoutput></td>
	</tr>
</table>
<iframe id="excel_detail" name="excel_detail" style="display:none"></iframe>
</body>
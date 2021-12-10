<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
<script src="../include/js/functions.js"></script>
<style>
TD { border-bottom:1px solid #eaeaea}
</style>
<script>
function hide ( idg ){
	hideObj("gruppo_" + idg);
}

function confronta(){
	var gruppi = document.getElementById("gruppi").value;
	gruppi = gruppi.substring(0,gruppi.length-1)
	var dateFrom = getValore("dateFrom");
	var dateTo = getValore("dateTo");
	var cs = getValore("tc_sav");
	var ce = getValore("tc_extra");
	var tp = getValore("tc");
	document.location = "_stat_assegnazioni_dettaglio.cfm?id_processo=" + idp + "&gruppi=" + gruppi + "&dateFrom=" + dateFrom + "&dateTo=" + dateTo + "&cs=" + cs + "&ce=" + ce + "&tp=" + tp;
	//alert(gruppi);
}

function dettaglioGruppo(gruppo){
	setValore("gruppi" , gruppo + ",");
	confronta();
}

function setConfronta(obj,gruppo){
	if (obj.checked) {
		setValore("gruppi" , getValore("gruppi") + gruppo + ",");
		document.getElementById("gruppo_" + gruppo).style.backgroundColor = "#ffa346";
	} else {
		document.getElementById("gruppo_" + gruppo).style.backgroundColor = "#ffffff";
		var listaGruppi = getValore("gruppi");
		listaGruppi = listaGruppi.substring(0,listaGruppi.length -1);
		var aGruppi = listToArray(listaGruppi,",");
		var myLista = "";
		for ( i=0 ; i < aGruppi.length ; i++ ){
			if ( aGruppi[i] != gruppo ){
				myLista = myLista + aGruppi[i] + ",";
			}
		}
		setValore("gruppi",myLista);
	}
}

function createExcel(processo,dal,al,tp,cs,ce){
	obj("excel_detail").src = "_stat_processi_dettaglio_XLS.cfm?id_processo=" + processo + "&dateFrom=" + dal + "&dateTo=" + al + "&tp=" + tp + "&cs=" + cs + "&ce=" + ce;
}
</script>
<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="yes">
<cfparam name="url.dateFrom" default="#DateFormat(DateAdd('d',-7,now()),'dd/mm/yyyy')#">
<cfparam name="url.dateTo" default="#DateFormat(DateAdd('d',7,now()),'dd/mm/yyyy')#">
<cfinvoke component="statistiche" method="assegnazioniGruppo" returnvariable="rsDetail">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.gruppi#">
</cfinvoke>
<!--- <cfinvoke component="statistiche" method="assegnazioniClienti" returnvariable="rsCount">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.gruppi#">
	<cfinvokeargument name="mode" value="count">
</cfinvoke> --->


<cfset tc = url.tp>
<cfset tc_gruppo = url.tc_gruppo>
<cfset totale_perc = 0>
<cfset tc_sav = url.cs>
<cfset tc_extra = url.ce>
<cfset tc_gruppo_sav = 0>
<cfset tc_gruppo_extra = 0>
<body style="overflow:auto">
<table width="100%" cellspacing="0" cellpadding="2" style="border:1px solid #eaeaea">
	<tr>
		<td colspan="8">
		<cfoutput>
		ASSEGNAZIONI CLIENTI <strong>#rsDetail.ac_gruppo#</strong> Periodo <strong>dal #url.dateFrom# al #url.dateTo#<!---  &nbsp;&nbsp;&nbsp;<img src="../include/css/icons/files/xls.png" onclick="createExcel('#url.id_processo#','#url.dateFrom#','#url.dateTo#','#url.tp#','#url.cs#','#url.ce#')" style="cursor:pointer" title="Crea Excel"> ---></strong>
		</cfoutput>
		</td>
	</tr>
	<tr bgcolor="#eaeaea">
		<td width="60"><!--- <input type="button" class="btn" value="Confronta" onclick="confronta()"> ---></td>
		<td><strong>Gruppo</strong></td>
		<td><strong>Totale</strong></td>
		<td align="center"><strong>%</strong></td>
		<td></td>
		<td><strong>Clienti SAV</strong></td>
		<td><strong>Clienti FORNITORI</strong></td>
		<td><strong>% su Clienti</strong></td>
	</tr>

<cfoutput query="rsDetail">
	<cfset perc_clienti = 0>
	<cfset totale_perc = 0>
	<cfif tc_gruppo NEQ "">
	<cfset perc_clienti = DecimalFormat((nrclienti/tc_gruppo)*100)>
	<cfset totale_perc = totale_perc + ((nrclienti/tc_gruppo)*100)>
	</cfif>
	<cfset nrClientiSav = 1>
	<cfset nrClientiExtra = 1>
	<cfset perc_clienti_sav = 100>
	<cfset perc_clienti_extra = 100>
	<cfinvoke component="statistiche" method="contaClientiAssegnati" returnvariable="nrClientiExtra">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
		<cfinvokeargument name="id_agente" value="#id_persona#">
		<cfinvokeargument name="mode" value="extra">
	</cfinvoke>
	<cfinvoke component="statistiche" method="contaClientiAssegnati" returnvariable="nrClientiSAV">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
		<cfinvokeargument name="id_agente" value="#id_persona#">
		<cfinvokeargument name="mode" value="normal">
	</cfinvoke>
	<tr id="gruppo_#id_gruppo#" style="display:;">
		<td width="60">
		<!--- <input type="checkbox" value="#id_gruppo#" id="confronta" onclick="setConfronta(this,#id_gruppo#)"> --->
		<!--- <img src="../include/css/dot-trasp.png" style="background:red;cursor:pointer" alt="Escludi" title="Escludi" width="8" height="4" onclick="hide(#id_gruppo#)"> ---></td>
		<td>#UCASE(ac_cognome)# #UCASE(ac_nome)#</td>
		<td>#nrclienti#</td>
		<td>#perc_clienti#</td>
		<td><img src="../include/css/dot-trasp.png" width="#perc_clienti#" height="10" style="background:green;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#perc_clienti#" height="10" style="background:white;border:1px solid black">
		</td>
		<!--- <cfset tc_gruppo = tc_gruppo + nrclienti> --->
		
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
		<cfset tc_gruppo_sav = tc_gruppo_sav + nrClientiSAV>
		<cfset tc_gruppo_extra = tc_gruppo_extra + nrClientiExtra>
		<td>#nrClientiSAV# (#perc_clienti_sav#%)</td>
		<td>#nrClientiExtra# (#DecimalFormat(100-perc_clienti_sav)#)%</td>
		<td>
		<img src="../include/css/dot-trasp.png" width="#perc_clienti_sav#" height="10" style="background:##99ccff"><img src="../include/css/dot-trasp.png" width="#100-perc_clienti_sav#" height="10" style="background:navy">
		<input type="button" class="btn" value="Dettaglio" onclick="dettaglioGruppo(#id_gruppo#)">
		</td>
	</tr>
	
<!--- <cfset totale = totale + nrprocessi> --->
</cfoutput>
	<cfoutput>
	<tr bgcolor="##eaeaea">
		<td></td>
		<td><strong>Totale Gruppo</strong> </td>
		<td><strong>#tc_gruppo#</strong></td>
		<td><strong>#round(totale_perc)#%</strong></td>
		<td></td>
		<td><strong>#tc_gruppo_sav# (#round((tc_gruppo_sav/tc_gruppo)*100)#%)</strong></td>
		<td><strong>#tc_gruppo_extra# (#round((tc_gruppo_extra/tc_gruppo)*100)#%)</strong></td>
		<cfset perc_tc_sav = Int((tc_sav/tc)*100)>
		<td><img src="../include/css/dot-trasp.png" width="#perc_tc_sav#" height="10" style="background:##99ccff"><img src="../include/css/dot-trasp.png" width="#100-perc_tc_sav#" height="10" style="background:navy"></td>
	</tr>
	<tr bgcolor="##eaeaea">
		<cfset perc_totale = (tc_gruppo/tc)*100>
		<td></td>
		<td><strong>Totale Generale</strong></td>
		<td><strong>#tc#</strong></td>
		<td><strong>#round((tc_gruppo/tc)*100)#%</strong></td>
		<td><img src="../include/css/dot-trasp.png" width="#perc_totale#" height="10" style="background:green;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-perc_totale#" height="10" style="background:white;border:1px solid black"></td>
		<td><!--- <strong>#tc_sav#  (#round((tc_sav/tc)*100)#%)</strong> ---></td>
		<td><!--- <strong>#tc_extra#  (#round((tc_extra/tc)*100)#%)</strong> ---></td>
		<!--- <cfset perc_tc_sav = Int((tc_sav/tc)*100)> --->
		<td><!--- <img src="../include/css/dot-trasp.png" width="#perc_tc_sav#" height="10" style="background:##99ccff"><img src="../include/css/dot-trasp.png" width="#100-perc_tc_sav#" height="10" style="background:navy"> ---></td>
	</tr>
	</cfoutput>
</table>
<cfoutput>
<input type="hidden" name="gruppi" id="gruppi">
<input type="hidden" name="dateFrom" id="dateFrom" value="#url.dateFrom#">
<input type="hidden" name="dateTo" id="dateTo" value="#url.dateTo#">
<input type="hidden" name="tc_sav" id="tc_sav" value="#tc_sav#">
<input type="hidden" name="tc_extra" id="tc_extra" value="#tc_extra#">
<input type="hidden" name="tc" id="tc" value="#tc#">
<iframe id="excel_detail" name="excel_detail" style="display:none"></iframe>

</cfoutput>
<!--- </body>  --->
<!--- <cfdump var="#rsDetail#">
 --->
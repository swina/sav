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

function createExcel(dal,al,gruppi,agente,tp){
	obj("excel_detail").src = "_stat_assegnazioni_confronto_XLS.cfm?&dateFrom=" + dal + "&dateTo=" + al + "&tp=" + tp + "&id_gruppo_agenti=" + gruppi + "&id_agente=" + agente;
}
</script>
<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="yes">
<cfparam name="url.dateFrom" default="#DateFormat(DateAdd('d',-7,now()),'dd/mm/yyyy')#">
<cfparam name="url.dateTo" default="#DateFormat(DateAdd('d',7,now()),'dd/mm/yyyy')#">
<cfinvoke component="statistiche" method="assegnazioniDetail" returnvariable="rsDetail">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.gruppi#">
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
<table width="99%" cellspacing="0" cellpadding="2" style="border:1px solid #eaeaea;margin:4px">
	<tr>
		<td colspan="8" class="winblue">
		<cfoutput>
		<strong>CONFRONTO ASSEGNAZIONI CLIENTI Periodo</strong> <strong>dal #url.dateFrom# al #url.dateTo#&nbsp;&nbsp;&nbsp;<input type="button" class="btn" value="Excel"  onclick="createExcel('#url.dateFrom#','#url.dateTo#','#url.gruppi#','#url.agente#','#url.tp#')" style="cursor:pointer" title="Crea Excel"></strong>
		</cfoutput>
		</td>
	</tr>
	<tr bgcolor="silver">
		<td colspan="2"><strong>Gruppo/Agente</strong></td>
		<td><strong>Totale</strong></td>
		<td align="center"><strong>%</strong></td>
		<td></td>
		<td><strong>Clienti SAV</strong></td>
		<td><strong>Clienti FORNITORI</strong></td>
		<td><strong>% su Clienti</strong></td>
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
	<tr id="gruppo_#id_gruppo#" style="display:;background-color:##eaeaea">
		<td colspan="2"><strong>#ac_gruppo#</strong></td>
		<td><strong>#nrClientiSAV+nrClientiExtra#</strong></td>
		<td>
		<cfset perc_clienti = DecimalFormat(((nrClientiSAV+nrClientiExtra)/url.tp)*100)>
		<strong>#perc_clienti#</strong>
		</td>
		<td>
		
		<img src="../include/css/dot-trasp.png" width="#perc_clienti#" height="10" style="background:green;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-perc_clienti#" height="10" style="background:white;border:1px solid black">
		</td>
		<td><strong>#nrClientiSAV#</strong></td>
		<td><strong>#nrClientiExtra#</strong></td>
		<td>
		<cfset perc_SAV = DecimalFormat((nrClientiSAV/(nrClientiSAV+nrClientiExtra)*100))>
		<img src="../include/css/dot-trasp.png" width="#perc_sav#" height="10" style="background:##99ccff"><img src="../include/css/dot-trasp.png" width="#100-perc_sav#" height="10" style="background:navy"> #perc_sav# - #DecimalFormat(100-perc_sav)#
		<!--- <input type="button" class="btn" value="Dettaglio" onclick="dettaglioGruppo(#id_gruppo#)"> --->
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
	<tr>
		<td></td>
		<td>#UCASE(ac_cognome)# #UCASE(ac_nome)#</td>
		<td>#nrClientiSAVAgente+nrClientiExtraAgente#</td>
		<td>
		<cfset perc_agente = DecimalFormat(clienti_agente/(nrClientiSAV+nrClientiExtra)*100)>
		#perc_agente#
		</td>
		<td>
		<img src="../include/css/dot-trasp.png" width="#perc_agente#" height="10" style="background:green;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-perc_agente#" height="10" style="background:white;border:1px solid black">
		</td>
		<td>
		#nrClientiSAVAgente#
		</td>
		<td>
		#nrClientiExtraAgente#
		</td>
		<td>
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
			<img src="../include/css/dot-trasp.png" width="#perc_sav_agente#" height="10" style="background:##99ccff"><img src="../include/css/dot-trasp.png" width="#100-perc_sav_agente#" height="10" style="background:navy"> #perc_sav_agente# - #DecimalFormat(100-perc_sav_agente)#
		</td>
	</tr>
	</cfoutput>
<!--- <cfset totale = totale + nrprocessi> --->
</cfoutput>
	<cfoutput>
	<!--- <tr bgcolor="##eaeaea">
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
	</tr> --->
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
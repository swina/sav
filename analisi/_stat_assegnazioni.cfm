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
	var tc_gruppo = getValore("tc_gruppo");
	var agente = getValore("id_agente");
	parent.document.getElementById("detailFrame").src = "_stat_assegnazioni_confronto.cfm?gruppi=" + gruppi + "&dateFrom=" + dateFrom + "&dateTo=" + dateTo + "&cs=" + cs + "&ce=" + ce + "&tp=" + tp + "&tc_gruppo=" + tc_gruppo + "&agente=" + agente;
	parent.document.getElementById("detailFrame").style.display = "";
	//alert(gruppi);
}

function dettaglioGruppo(gruppo,totale){
	setValore("gruppi" , gruppo + ",");
	setValore("tc_gruppo" , totale);
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

function createExcel(processo,dal,al,gruppi,agente){
	obj("excel_detail").src = "_stat_assegnazioni_XLS.cfm?id_processo=" + processo + "&dateFrom=" + dal + "&dateTo=" + al + "&id_gruppo_agenti=" + gruppi + "&id_agente=" + agente;
}
</script>
<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="yes">
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
<table width="99%" cellspacing="0" cellpadding="2" style="border:1px solid #eaeaea;margin:4px">
	<tr>
		<td colspan="8" class="winblue">
		<strong>ASSEGNAZIONI CLIENTI</strong> Periodo <strong><cfoutput>dal #url.dateFrom# al #url.dateTo#&nbsp;&nbsp;&nbsp;<input type="button" class="btn" value="Excel" onclick="createExcel('#url.start_processo#','#url.dateFrom#','#url.dateTo#','#url.id_gruppo_agenti#','#url.id_agente#')" style="cursor:pointer" title="Crea Excel"></cfoutput></strong>
		</td>
	</tr>
	<tr bgcolor="#eaeaea">
		<td width="60"><input type="button" class="btn" value="Confronta" onclick="confronta()"></td>
		<td><strong>Gruppo</strong></td>
		<td><strong>Totale</strong></td>
		<td align="center"><strong>%</strong></td>
		<td></td>
		<td><strong>Clienti SAV</strong></td>
		<td><strong>Clienti FORNITORI</strong></td>
		<td><strong>% su Clienti</strong></td>
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
		<input type="checkbox" value="#id_gruppo#" id="confronta" onclick="setConfronta(this,#id_gruppo#)">
		<!--- <img src="../include/css/dot-trasp.png" style="background:red;cursor:pointer" alt="Escludi" title="Escludi" width="8" height="4" onclick="hide(#id_gruppo#)"> ---></td>
		<td>#ac_gruppo#</td>
		<td>#nrclienti#</td>
		<td>#perc_clienti#</td>
		<td><img src="../include/css/dot-trasp.png" width="#perc_clienti#" height="10" style="background:green;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-perc_clienti#" height="10" style="background:white;border:1px solid black">
		</td>
		
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
		<td>#nrClientiSAV# (#perc_clienti_sav#%)</td>
		<td>#nrClientiExtra# (#DecimalFormat(100-perc_clienti_sav)#)%</td>
		<td>
		<img src="../include/css/dot-trasp.png" width="#perc_clienti_sav#" height="10" style="background:##99ccff"><img src="../include/css/dot-trasp.png" width="#100-perc_clienti_sav#" height="10" style="background:navy">
		<input type="button" class="btn" value="Dettaglio" onclick="dettaglioGruppo(#id_gruppo#,#nrClientiSAV+nrClientiExtra#)">
		</td>
	</tr>
<!--- <cfset totale = totale + nrprocessi> --->
</cfoutput>
	<cfoutput>
	<tr bgcolor="##eaeaea">
		<td></td>
		<td>Totale clienti analizzati</td>
		<td><strong>#tc#</strong></td>
		<td><strong>#round(totale_perc)#</strong></td>
		<td></td>
		<td><strong>#tc_sav#</strong></td>
		<td><strong>#tc_extra#</strong></td>
		<cfset perc_tc_sav = Int((tc_sav/tc)*100)>
		<td><img src="../include/css/dot-trasp.png" width="#perc_tc_sav#" height="10" style="background:##99ccff"><img src="../include/css/dot-trasp.png" width="#100-perc_tc_sav#" height="10" style="background:navy"></td>
		
	</tr>
	</cfoutput>
</table>
<cfoutput>
<input type="hidden" name="gruppi" id="gruppi">
<input type="hidden" name="id_agente" id="id_agente" value="#url.id_agente#">
<input type="hidden" name="dateFrom" id="dateFrom" value="#url.dateFrom#">
<input type="hidden" name="dateTo" id="dateTo" value="#url.dateTo#">
<input type="hidden" name="tc_sav" id="tc_sav" value="#tc_sav#">
<input type="hidden" name="tc_extra" id="tc_extra" value="#tc_extra#">
<input type="hidden" name="tc" id="tc" value="#tc#">
<input type="hidden" name="tc_gruppo" id="tc_gruppo" value="">
<iframe id="excel_detail" name="excel_detail" style="display:none"></iframe>

</cfoutput>
</body> 
<!--- <cfdump var="#rsDetail#"> --->
<!--- <cfdump var="#rsCount#"> --->
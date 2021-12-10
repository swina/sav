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
	gruppi = gruppi.substring(0,gruppi.length-1);
	var idp = getValore("id_processo");
	var dateFrom = getValore("dateFrom");
	var dateTo = getValore("dateTo");
	var cs = getValore("cs");
	var ce = getValore("ce");
	var tp = getValore("tp");
	document.location = "_stat_processi_dettaglio.cfm?id_processo=" + idp + "&id_gruppo_agenti=" + gruppi + "&dateFrom=" + dateFrom + "&dateTo=" + dateTo + "&cs=" + cs + "&ce=" + ce + "&tp=" + tp + "&id_agente=null&confronta=false";

	//document.location = "_stat_processi_confronta.cfm?id_processo=" + idp + "&gruppi=" + gruppi + "&dateFrom=" + dateFrom + "&dateTo=" + dateTo + "&cs=" + cs + "&ce=" + ce + "&tp=" + tp;
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
		document.getElementById("gruppo_" + gruppo).style.backgroundColor = "#eaeaea";
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

function createExcel(processo,dal,al,tp,cs,ce,idg,ida){
	obj("excel_detail").src = "_stat_processi_dettaglio_XLS.cfm?id_processo=" + processo + "&dateFrom=" + dal + "&dateTo=" + al + "&tp=" + tp + "&cs=" + cs + "&ce=" + ce + "&id_gruppo_agenti=" + idg + "&id_agente=" + ida;
}
</script>
<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="yes">
<cfparam name="id_gruppo_agenti" default="">
<cfparam name="id_agente" default="">
<cfparam name="url.confronta" default=true>

<cfif url.id_gruppo_agenti NEQ "null">
	<cfset id_gruppo_agenti = url.id_gruppo_agenti>
<cfelse>
	<cfset id_gruppo_agenti = "">	
</cfif>
<cfif url.id_agente NEQ "null">
	<cfset id_agente = url.id_agente>
<cfelse>
	<cfset id_agente = "">	
</cfif>
<!--- <cfoutput>
#id_gruppo_agenti#
</cfoutput> --->
<!--- <cfinvoke component="statistiche" method="dettaglioProcessi" returnvariable="rsDetail">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="start_processo" value="#url.id_processo#">
	<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo_agenti#">
	<cfinvokeargument name="id_agente" value="#id_agente#">
</cfinvoke> --->
<cfinvoke component="statistiche" method="dettaglioProcessiAgenti" returnvariable="rsDetail">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="start_processo" value="#url.id_processo#">
	<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo_agenti#">
	<cfinvokeargument name="id_agente" value="#id_agente#">
</cfinvoke>
<cfset totale = 0>
<cfset totale_perc = 0>
<cfset nrprocessi = 0>
<cfset totale_clienti_sav = 0>
<cfset totale_clienti_extra = 0>
<body style="overflow:auto">
<table width="100%" cellspacing="0" cellpadding="2" style="border:1px solid #eaeaea">
	<tr bgcolor="#aaaaaa">
		<td colspan="8">
		ANALISI PROCESSO: <strong><cfoutput>#rsDetail.ac_processo# &nbsp;&nbsp; Dal #url.dateFrom# al #url.dateTo#&nbsp;<input type="button" class="btn" value="Excel"  onclick="createExcel('#url.id_processo#','#url.dateFrom#','#url.dateTo#','#url.tp#','#url.cs#','#url.ce#','#url.id_gruppo_agenti#','#url.id_agente#')" style="cursor:pointer" title="Crea Excel"></cfoutput></strong>
		</td>
	</tr>
	<tr bgcolor="#aaaaaa">
		<td width="60">
		<cfif url.confronta>
			<input type="button" class="btn" value="Confronta" onclick="confronta()">
		<cfelse>
			<input type="button" class="btn" value="Indietro" onclick="javascript:history.back()">	
		</cfif>	
		</td>
		<td><strong>Gruppo/Agenti</strong></td>
		<td><strong>Totale</strong></td>
		<td align="center"><strong>%</strong></td>
		<td></td>
		<td><strong>Clienti SAV</strong></td>
		<td><strong>Clienti FORNITORI</strong></td>
		<td><strong>% su Clienti</strong></td>
	</tr>
<cfoutput query="rsDetail" group="ac_gruppo">
	
	<!--- <cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiExtra">
		<cfinvokeargument name="id_processo" value="#id_processo#">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo_agenti#">
		<cfinvokeargument name="id_agente" value="#id_agente#">
	</cfinvoke>
	<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiSAV">
		<cfinvokeargument name="id_processo" value="#id_processo#">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo_agenti#">
		<cfinvokeargument name="id_agente" value="#id_agente#">
		<cfinvokeargument name="tipo_clienti" value="1">
	</cfinvoke> --->
	
	<cfset nconta = 0>
	<cfset nrprocessi = 0>
	<cfoutput group="id_persona">
	
	<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiExtra">
		<cfinvokeargument name="id_processo" value="#id_processo#">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
		<cfinvokeargument name="id_agente" value="#id_persona#">
	</cfinvoke>
	<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiSAV">
		<cfinvokeargument name="id_processo" value="#id_processo#">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
		<cfinvokeargument name="id_agente" value="#id_persona#">
		<cfinvokeargument name="tipo_clienti" value="1">
	</cfinvoke>
		<cfoutput>
			<cfset nconta = nconta + 1>
			<cfset nrprocessi = nrprocessi + 1>
		</cfoutput>
		
	</cfoutput>
	<cfset perc_processi = DecimalFormat((nrprocessi/tp)*100)>
	<cfset totale_perc = totale_perc + ((nrprocessi/tp)*100)>
	<!--- <cfset totale_clienti_sav = totale_clienti_sav + nrClientiSAV>
	<cfset totale_clienti_extra = totale_clienti_extra + nrClientiExtra> --->
	<tr id="gruppo_#id_gruppo#" style="display:;background-color:##eaeaea">
		<td width="60">
		<cfif url.confronta>
		<input type="checkbox" value="#id_gruppo#" id="confronta" onclick="setConfronta(this,#id_gruppo#)">
		</cfif>
		<!--- <img src="../include/css/dot-trasp.png" style="background:red;cursor:pointer" alt="Escludi" title="Escludi" width="8" height="4" onclick="hide(#id_gruppo#)"> ---></td>
		<td><strong>#ac_gruppo#</strong></td>
		<td><strong>#nrprocessi#</strong></td>
		<td><strong>#perc_processi#</strong></td>
		<td><img src="../include/css/dot-trasp.png" width="#perc_processi#" height="10" style="background:green;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-perc_processi#" height="10" style="background:white;border:1px solid black">
		</td>
		<cfset perc_clienti_sav = DecimalFormat((nrClientiSav/(nrClientiSav+nrClientiExtra))*100)>
		
		<td><!--- #nrClientiSAV# (#perc_clienti_sav#%) ---></td>
		<td><!--- #nrClientiExtra# (#DecimalFormat(100-perc_clienti_sav)#)% ---></td>
		<td>
		<!--- <img src="../include/css/dot-trasp.png" width="#perc_clienti_sav#" height="10" style="background:##99ccff"><img src="../include/css/dot-trasp.png" width="#100-perc_clienti_sav#" height="10" style="background:navy"> --->
		<!--- <input type="button" class="btn" value="Dettaglio" onclick="dettaglioGruppo(#id_gruppo#)"> --->
		</td>
	</tr>
	<cfoutput group="id_persona">
	<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiExtra">
		<cfinvokeargument name="id_processo" value="#id_processo#">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
		<cfinvokeargument name="id_agente" value="#id_persona#">
	</cfinvoke>
	<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiSAV">
		<cfinvokeargument name="id_processo" value="#id_processo#">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
		<cfinvokeargument name="id_agente" value="#id_persona#">
		<cfinvokeargument name="tipo_clienti" value="1">
	</cfinvoke>
	<cfset nagente = 0>
	<cfoutput>
		<cfset nagente = nagente + 1>
		<!--- <tr>
		<td colspan="10">#id_persona# #ac_cognome#</td>
		</tr> --->
	</cfoutput>
	<cfset npercagente = DecimalFormat((nagente/nrprocessi)*100)>
	<tr>
		<td></td>
		<td><li>#UCASE(ac_cognome)# #UCASE(ac_nome)#</li></td>
		<td>#nagente#</td>
		<td>#npercagente#</td>
		<td><img src="../include/css/dot-trasp.png" width="#npercagente#" height="10" style="background:##eaeaea;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-npercagente#" height="10" style="background:white;border:1px solid black;border-left:0px;">
		</td>
		<cfset tot_clienti = nrClientiSAV + nrClientiExtra>
		<cfset perc_sav = DecimalFormat((nrClientiSAV/tot_clienti)*100)>
		<cfset totale_clienti_sav = totale_clienti_sav + nrClientiSAV>
		<cfset totale_clienti_extra = totale_clienti_extra + nrClientiExtra>
		<td>#nrClientiSAV# (#perc_sav#%)</td>
		<td>#nrClientiExtra# (#DecimalFormat(100-perc_sav)#%)</td>
		<td>
		<img src="../include/css/dot-trasp.png" width="#perc_sav#" height="10" style="background:##99ccff"><img src="../include/css/dot-trasp.png" width="#100-perc_sav#" height="10" style="background:navy">
		</td>
		<td colspan="10"></td>
	</tr>
	</cfoutput>
	<!--- <cfset totale_clienti_sav = totale_clienti_sav + nrClientiSAV>
	<cfset totale_clienti_extra = totale_clienti_extra + nrClientiExtra> --->
	<cfset totale = totale + nrprocessi>
</cfoutput>
	<cfoutput>
	<cfset perc_totale = DecimalFormat((totale_clienti_sav/(totale_clienti_sav+totale_clienti_extra))*100)>
	<tr bgcolor="##eaeaea">
		<td></td>
		<td>Totale processi analizzati</td>
		<td><strong>#totale#</strong></td>
		<td><strong>#round(totale_perc)#</strong></td>
		<td></td>
		<td><strong>#totale_clienti_sav# (#perc_totale#%)</strong></td>
		<td><strong>#totale_clienti_extra# (#DecimalFormat(100-perc_totale)#%)</strong></td>
		<td><img src="../include/css/dot-trasp.png" width="#perc_totale#" height="10" style="background:##99ccff"><img src="../include/css/dot-trasp.png" width="#100-perc_totale#" height="10" style="background:navy"></td>
		
	</tr>
	</cfoutput>
</table>
<cfoutput>
<input type="hidden" name="id_processo" id="id_processo" value="#url.id_processo#">
<input type="hidden" name="gruppi" id="gruppi">
<input type="hidden" name="dateFrom" id="dateFrom" value="#url.dateFrom#">
<input type="hidden" name="dateTo" id="dateTo" value="#url.dateTo#">
<input type="hidden" name="cs" id="cs" value="#url.cs#">
<input type="hidden" name="ce" id="ce" value="#url.ce#">
<input type="hidden" name="tp" id="tp" value="#url.tp#">
<iframe id="excel_detail" name="excel_detail" style="display:none"></iframe>

</cfoutput>
</body>
<!--- <cfdump var="#rsDetail#"> --->
<script src="../include/js/functions.js"></script>
<script>
function dettaglio(idp,dal,al,clientiSav,clientiExtra,totale_processi,idga,ida){
	parent.document.getElementById("detailFrame").src = "_stat_processi_dettaglio.cfm?id_processo=" + idp + "&dateFrom=" + dal + "&dateTo=" + al + "&cs=" + clientiSav + "&ce=" + clientiExtra + "&tp=" + totale_processi + "&id_gruppo_agenti=" + idga + "&id_agente=" + ida;
	parent.document.getElementById("detailFrame").style.display = "";
}

function confronta(){
	var processi = getValore("processi");
	processi = processi.substring(0,processi.length-1);
	var tp = getValore("tp");
	tp = tp.substring(0,tp.length-1);
	var dateFrom = getValore("dateFrom");
	var dateTo = getValore("dateTo");
	var gruppo = getValore("id_gruppo_agenti");
	var agente = getValore("id_agente");
	parent.document.getElementById("detailFrame").src = "work.cfm?id_processo=" + processi + "&dateFrom=" + dateFrom + "&dateTo=" + dateTo + "&tp=" + tp + "&gruppi=" + gruppo + "&agente=" + agente;
	parent.document.getElementById("detailFrame").style.display = "";
	//alert(gruppi);
}


function confrontaProcessi(obj,idp,totali){
	if (obj.checked) {
		setValore("processi" , getValore("processi") + idp + ",");
		setValore("tp", getValore("tp") + totali + ",");
		//document.getElementById("gruppo_" + gruppo).style.backgroundColor = "#ffa346";
	} else {
		//document.getElementById("gruppo_" + gruppo).style.backgroundColor = "#ffffff";
		var listaProcessi = getValore("processi");
		listaProcessi = listaProcessi.substring(0,listaProcessi.length -1);
		var aProcessi = listToArray(listaProcessi,",");
		
		var listaTotali = getValore("tp");
		listaTotali = listaTotali.substring(0,listaTotali.length -1);
		var aTotali = listToArray(listaTotali,",");
		
		var myLista = "";
		var myTotali = "";
		for ( i=0 ; i < aProcessi.length ; i++ ){
			if ( aProcessi[i] != idp ){
				myLista = myLista + aProcessi[i] + ",";
				myTotali = myTotali + aTotali[i] + ",";
			}
		}
		setValore("processi",myLista);
		setValore("tp",myTotali);
	}
}

function createExcel(processo,dal,al,gruppo,agente){
	obj("excel").src = "_stat_processi_XLS.cfm?dateFrom=" + dal + "&dateTo=" + al + "&id_gruppo_agenti=" + gruppo + "&id_agente=" + agente;
}
</script>
<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="yes">
<cfparam name="url.dateFrom" default="#DateFormat(DateAdd('d',-7,now()),'dd/mm/yyyy')#">
<cfparam name="url.dateTo" default="#DateFormat(DateAdd('d',7,now()),'dd/mm/yyyy')#">
<cfparam name="url.metodo" default="processiInCorsoDetail">
<cfparam name="url.id_gruppo_agenti" default="">
<cfparam name="url.id_agente" default="">
<cfparam name="url.start_processo" default="">
<cfparam name="url.endprocesso" default="">
<cfparam name="url.startprocesso" default="">
<cfparam name="gruppo" default="GRUPPO: Tutti">
<cfparam name="agente" default="AGENTE: Tutti">
<!--- Query the database and get all the records --->
<cfinvoke component="statistiche" method="contaProcessi" returnvariable="rsAll">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
	<cfinvokeargument name="start_processo" value="">
	<cfinvokeargument name="end_processo" value="#url.endprocesso#">
</cfinvoke>

<cfinvoke component="analisi" method="calcola_giorni" returnvariable="ngiorni">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
</cfinvoke>

<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiExtraTotali">
	<cfinvokeargument name="id_processo" value="#url.startprocesso#">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="id_gruppo_agenti" value="">
</cfinvoke>

<cfif url.id_gruppo_agenti NEQ "">
	<cfquery name="getGruppo" datasource="#application.dsn#">
	SELECT ac_gruppo FROM tbl_gruppi WHERE id_gruppo = #url.id_gruppo_agenti#
	</cfquery>
	<cfoutput>
		<cfset gruppo = "GRUPPO: #getGruppo.ac_gruppo#">
	</cfoutput>
<cfelse>
	<cfif url.id_agente NEQ "">
		<cfoutput>
			<cfset agente = "AGENTE: #rsAll.ac_cognome#">
		</cfoutput>
	</cfif>
</cfif>
<link rel='stylesheet' type='text/css' href='../include/css/style.css'>

<style>
TD { border-bottom:1px solid #eaeaea}
</style>
</style>
<!---  ---> 
<body style="overflow:auto">
<div align="center">
<cfset totale_generale = 0>
<cfloop query="rsAll">
	<cfset totale_generale = totale_generale + rsAll.nrprocessi>
</cfloop>
<cfset perc_totale = 0>
<table width="100%" cellspacing="0" cellpadding="2" style="border:1px solid #eaeaea">
	<tr>
		<td colspan="8">
		<strong>ANALISI PROCESSI</strong> Periodo : <cfoutput><strong>#url.dateFrom# - #url.DateTo#</strong>
		&nbsp;<strong>#gruppo#</strong> - <strong>#agente#</strong> &nbsp;&nbsp;<input type="button" class="btn" value="Excel"  onclick="createExcel('#url.startprocesso#','#url.dateFrom#','#url.dateTo#','#url.id_gruppo_agenti#','#url.id_agente#')" style="cursor:pointer" title="Crea Excel"></cfoutput>
		</td>
	</tr>
	<tr bgcolor="#eaeaea">
		<td width="50">
		<strong><input type="button" class="btn" value="Confronta" onclick="confronta()"></strong>
		</td>
		<td>
		<strong>PROCESSO</strong>
		</td>
		<td>
		<strong>TOTALE</strong>
		</td>
		<td align="center">
		<strong>%</strong>
		</td>
		<td></td>
		<td>
		<strong>CLIENTI SAV</strong>
		</td>
		<td>
		<strong>CLIENTI FORNITORI</strong>
		</td>
		<td>
		<strong>TOTALE CLIENTI</strong>
		</td>
	</tr>	
<cfoutput query="rsAll" group="id_processo">
<cfset totale = 0>
<cfset clienti_sav = 0>
<cfset numero_sav = 0>
<cfset clienti_extra = 0>
<cfset numero_extra = 0>
<cfset perc = 0>


<cfoutput>
	<cfset totale = totale + nrprocessi>
	<cfif ac_segnalatore NEQ "LGI" AND ac_segnalatore NEQ "Collead">
		<cfset clienti_sav = clienti_sav + nrprocessi>
		<cfset numero_sav = numero_sav + nrprocessi>
	<cfelse>
		<cfset clienti_extra = clienti_extra + nrprocessi>
		<cfset numero_extra = numero_extra + nrprocessi>
	</cfif>
</cfoutput>
	<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiExtra">
		<cfinvokeargument name="id_processo" value="#id_processo#">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
		<cfinvokeargument name="id_agente" value="#url.id_agente#">
	</cfinvoke>
	<cfif url.start_processo EQ "" OR url.start_processo EQ id_processo>
	<tr>
		<td width="50">
			<input type="checkbox" id="id_processo" name="id_processo" onclick="confrontaProcessi(this,#id_processo#,#totale#)">
		</td>
		<td>
		<img src="../include/css/dot-trasp.png" width="10" height="10" align="absmiddle" style="background:###ac_colore#;border:1px solid black;margin-right:5px"><a href="?start_processo=#id_processo#">#ac_processo#</a>
		</td>
		<td align="right">
		<strong>#totale#</strong>
		</td>
		<td align="right">
		<cfset perc_totale = perc_totale + ((totale/totale_generale)*100)>
		<cfset perc = (totale/totale_generale)*100>
		#DecimalFormat(perc)# 
		</td>
		<td align="left"><img src="../include/css/dot-trasp.png" width="#int(perc)#" height="10" align="absmiddle" style="background:green;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-int(perc)#" height="10" align="absmiddle" style="background:white;border:1px solid black"></td>
		<td align="right">
		<cfset clienti_sav = totale-nrClientiExtra>
		<cfset perc_clienti_sav = DecimalFormat((clienti_sav/totale)*100)>
		#clienti_sav# (#perc_clienti_sav#%)</td>
		<td align="right">
		<cfset perc_clienti_extra = DecimalFormat((nrClientiExtra/totale)*100)>
		#nrClientiExtra# (#perc_clienti_extra#%)</td>
		<td align="right">
		#totale# 
		<img src="../include/css/dot-trasp.png" width="#perc_clienti_sav#" height="10" style="background:##99ccff"><img src="../include/css/dot-trasp.png" width="#perc_clienti_extra#" height="10" style="background:navy"> <a href="javascript:dettaglio(#id_processo#,'#url.dateFrom#','#url.dateTo#',#clienti_sav#,#nrClientiExtra#,#nrprocessi#,<cfif url.id_gruppo_agenti NEQ ''>#url.id_gruppo_agenti#<cfelse>null</cfif>,<cfif url.id_agente NEQ ''>#url.id_agente#<cfelse>null</cfif>)"><input type="button" class="btn" value="Dettaglio"></a></td>
	</tr>
	</cfif>
</cfoutput>
	<cfoutput>
	<tr>
	
		<td colspan="2">Totale processi analizzati: </td>
		<td>#totale_generale#</td>
		<td>#DecimalFormat(perc_totale)# %</td>
		<td><a href="?start_processo=">Vedi tutti</a></td>
	</tr>
	</cfoutput>
	<tr id="detail" style="display:none">
		<td colspan="8">
		<iframe name="dettaglio" id="dettaglio" width="100%" height="400" marginwidth="0" marginheight="0" align="left" frameborder="0"></iframe>
		</td>
	</tr>
</table>
<cfoutput>
<input type="hidden" name="processi" id="processi">
<input type="hidden" name="tp" id="tp" value="">
<input type="hidden" name="dateFrom" id="dateFrom" value="#url.dateFrom#">
<input type="hidden" name="dateTo" id="dateTo" value="#url.dateTo#">
<input type="hidden" name="id_gruppo_agenti" id="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
<input type="hidden" name="id_agente" id="id_agente" value="#url.id_agente#">
<!--- <input type="text" name="cs" id="cs" value="#clienti_sav#">
<input type="text" name="ce" id="ce" value="#nrClientiExtra#">
<input type="text" name="tp" id="tp" value="#nrprocessi#"> --->
</cfoutput>
<iframe name="excel" id="excel" style="display:none"></iframe>
</div>
</body>
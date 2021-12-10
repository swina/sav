<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="yes">
<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
<script src="../include/js/functions.js"></script>
<script>
function confronta(){
	var gruppi = document.getElementById("gruppi").value;
	gruppi = gruppi.substring(0,gruppi.length-1)
	var idp = getValore("id_processo");
	var dateFrom = getValore("dateFrom");
	var dateTo = getValore("dateTo");
	document.location = "?id_processo=" + idp + "&gruppi=" + gruppi + "&dateFrom=" + dateFrom + "&dateTo=" + dateTo;
	//alert(gruppi);
}

function setConfronta(obj,gruppo){
	if (obj.checked) {
		setValore("gruppi" , getValore("gruppi") + gruppo + ",");
		//setValore("tp" , getValore("tp") + tp + ",");
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
		//setValore("tp",myListaTP);
	}
}


function annulla(){
	setValore("gruppi",",");
	confronta();
}

function createExcel(idp,dateFrom,dateTo,gruppi){
	document.getElementById("excelFrame").src =  "workXLS.cfm?id_processo=" + idp + "&gruppi=" + gruppi + "&dateFrom=" + dateFrom + "&dateTo=" + dateTo ;
}

</script>
<style>
TD { border-bottom:1px solid #eaeaea}
</style>
<cfparam name="url.id_processo" default="3,6,7">
<cfparam name="url.dateFrom" default="#DateFormat(DateAdd('d',-15,now()),'dd/mm/yyyy')#">
<cfparam name="url.dateTo" default="#DateFormat(DateAdd('d',-1,now()),'dd/mm/yyyy')#">
<cfparam name="url.gruppi" default="">
<cfparam name="url.agente" default="">
<cfinvoke component="statistiche" method="confrontaProcessiDetail" returnvariable="rsDetail">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="start_processo" value="#url.id_processo#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.gruppi#">
	<cfinvokeargument name="id_agente" value="#url.agente#">
</cfinvoke>

<cfinvoke component="statistiche" method="getNomeProcessi" returnvariable="listProcessi">
	<cfinvokeargument name="id_processo" value="#url.id_processo#">
</cfinvoke>
<cfset totale = 0>
<cfset totale_perc = 0>
<body style="overflow:auto">

<table width="100%" cellspacing="0" cellpadding="2" style="border:1px solid #eaeaea">
	<tr bgcolor="#fff">
		<td colspan="8">
		<strong>Confronto &raquo; <cfloop index="i" list="#listProcessi#"><cfoutput>[#i#] </cfoutput></cfloop> &nbsp;&nbsp;&nbsp;<cfoutput><input type="button" class="btn" value="Excel"  onclick="createExcel('#url.id_processo#','#url.dateFrom#','#url.dateTo#','#url.gruppi#')" style="cursor:pointer" title="Crea Excel"></cfoutput></strong>
		</td>
	</tr>
	<tr bgcolor="#eaeaea">
		<td width="60">
		<cfif url.gruppi EQ "">
			<input type="button" class="btn" value="Confronta" onclick="confronta()">
		<cfelse>
			<input type="button" class="btn" value="Indietro" onclick="annulla()">			
		</cfif>
		</td>
		<td><strong>Gruppo</strong></td>
		<td><strong>Agente</strong></td>
		<td><strong>Totale</strong></td>
		<td align="left"><strong>% sul totale periodo</strong></td>
		<td><strong>Clienti SAV</strong></td>
		<td><strong>Clienti FORNITORI</strong></td>
		<td><strong>% su Clienti</strong></td>
	</tr>
	
<cfset thisGruppo = "">
<cfset listaTotali = "">
<cfset totale_generale = ArrayNew(1)>
<cfset SAV = ArrayNew(1)>
<cfset EXTRA = ArrayNew(1)>
<cfloop index="i" from="1" to="#ListLen(url.id_processo)#">
	<cfset totale_generale[i] = 0>
	<cfset SAV[i] = 0>
	<cfset EXTRA[i] = 0>
</cfloop>

<cfoutput query="rsDetail" group="ac_gruppo">
	<tr id="gruppo_#id_gruppo#" style="background-color:##eaeaea">
		<td width="40">
			<cfif url.gruppi EQ "">
			<input type="checkbox" value="#id_gruppo#" id="confronta" onclick="setConfronta(this,#id_gruppo#)">
			</cfif>
		</td>
		<td colspan="7"><strong>#ac_gruppo#</strong></td>
	</tr>
	
	<cfset n = 1>
	
		<cfoutput group="id_processo">
			<cfinvoke component="statistiche" method="contaProcessiGruppo" returnvariable="totale_processo_gruppo">
				<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
				<cfinvokeargument name="dateTo" value="#url.dateTo#">
				<cfinvokeargument name="start_processo" value="#id_processo#">
			<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
			</cfinvoke>
			<tr>
				<td></td>
				<td><img src="../include/css/dot-trasp.png" width="10" height="10" align="absmiddle" style="background:###ac_colore#;border:1px solid black;margin-right:5px">#ac_processo#</td>
				<td colspan="6"></td>
				
			</tr>
			<cfset totale_SAV = 0>
			<cfset totale_EXTRA = 0>
			<cfoutput group="ac_cognome">
				<cfset totale_processo_agente = 0>
				<cfset totale_clienti_SAV = 0>
				<cfset totale_clienti_EXTRA = 0>
				<cfoutput>
					<cfif ac_segnalatore NEQ "LGI" AND ac_segnalatore NEQ "COLLEAD">
						<cfset totale_clienti_SAV = totale_clienti_SAV + 1>
					<cfelse>
						<cfset totale_clienti_EXTRA = totale_clienti_EXTRA +1>	
					</cfif>
					<cfset totale_processo_agente = totale_processo_agente + 1>
				</cfoutput>
				<cfset totale_SAV = totale_SAV + totale_clienti_SAV>
				<cfset totale_EXTRA = totale_EXTRA + totale_clienti_EXTRA>
				<cfset perc_agente = DecimalFormat((totale_processo_agente/totale_processo_gruppo)*100)>
				<cfset perc_agente_SAV = DecimalFormat((totale_clienti_SAV/(totale_clienti_SAV+totale_clienti_EXTRA))*100)>
				<tr>
					<td></td>
					<td></td>
					<td>#UCASE(ac_cognome)#</td>
					<td>#totale_processo_agente#</td>
					<td><img src="../include/css/dot-trasp.png" width="#perc_agente#" height="10" style="background:green;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-perc_agente#" height="10" style="background:white;border:1px solid black">
					#DecimalFormat((totale_processo_agente/totale_processo_gruppo)*100)#
					</td>
					<td>
						#totale_clienti_SAV#
					</td>
					<td>
						#totale_clienti_EXTRA#
					</td>
					<td>
				<img src="../include/css/dot-trasp.png" width="#perc_agente_SAV#" height="10" style="background:##99ccff"><img src="../include/css/dot-trasp.png" width="#100-perc_agente_SAV#" height="10" style="background:navy">&nbsp;(#perc_agente_SAV# - #DecimalFormat(100-perc_agente_SAV)#)
					</td>
				</tr>
			</cfoutput>
			<cfset n = ListFind(url.id_processo,id_processo)>
			<cfset perc_sav = DecimalFormat((totale_SAV/(totale_SAV+totale_EXTRA))*100)>
			<cfset totale_generale[n]= totale_generale[n] + totale_processo_gruppo>
			<cfset SAV[n] = SAV[n] + totale_SAV>
			<cfset EXTRA[n] = EXTRA[n] + totale_EXTRA>
			
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td><strong style="font-size:12px">#totale_processo_gruppo#</strong></td>
				<td></td>
				<td><strong>#totale_SAV#</strong></td>
				<td><strong>#totale_EXTRA#</strong></td>
				<td>
				<img src="../include/css/dot-trasp.png" width="#perc_SAV#" height="10" style="background:##99ccff"><img src="../include/css/dot-trasp.png" width="#100-perc_SAV#" height="10" style="background:navy">&nbsp;(#perc_SAV# - #DecimalFormat(100-perc_SAV)#)
				</td>
			</tr>
		</cfoutput>
		
</cfoutput>
<cfoutput>
	<tr bgcolor="##eaeaea">
		<td colspan="8"><strong>TOTALE GENERALE</strong></td>
	</tr>
	<cfloop index="i" from="1" to="#ListLen(url.id_processo)#">
	<tr>
		<td></td>
		<td><strong>#ListGetAt(listProcessi,i)#</strong></td>
		<td></td>
		<td><strong>#totale_generale[i]#</strong></td>
		<td></td>
		<td><strong>#SAV[i]#</strong></td>
		<td><strong>#EXTRA[i]#</strong></td>
		<td>
		<cfset perc_clienti = DecimalFormat( ( SAV[i]/ (SAV[i]+EXTRA[i]) ) *100)>
		
		<img src="../include/css/dot-trasp.png" width="#perc_clienti#" height="10" style="background:##99ccff"><img src="../include/css/dot-trasp.png" width="#100-perc_clienti#" height="10" style="background:navy">&nbsp;(#perc_clienti# - #DecimalFormat(100-perc_clienti)#)
		</td>
	</tr>
	</cfloop>
</cfoutput>
</table>
<cfoutput>
<div style="display:none">
<input type="text" name="id_processo" id="id_processo" value="#url.id_processo#">
<input type="text" name="gruppi" id="gruppi">
<input type="text" name="dateFrom" id="dateFrom" value="#url.dateFrom#">
<input type="text" name="dateTo" id="dateTo" value="#url.dateTo#">
<iframe id="excelFrame"></iframe>
</div>
</cfoutput>
<!--- <cfdump var="#totale_generale#">
<cfdump var="#rsDetail#"> --->
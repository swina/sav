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
	var idp = getValore("id_processo");
	var dateFrom = getValore("dateFrom");
	var dateTo = getValore("dateTo");
	var cs = getValore("cs");
	var ce = getValore("ce");
	var tp = getValore("tp");
	 document.location = "_stat_processi_confronta.cfm?id_processo=" + idp + "&gruppi=" + gruppi + "&dateFrom=" + dateFrom + "&dateTo=" + dateTo + "&cs=" + cs + "&ce=" + ce + "&tp=" + tp;
	//alert(gruppi);
}

function dettaglioGruppo(idp,gruppo,cs,ce,tp){
	//setValore("gruppi" , gruppo + ",");
	//
	var dateFrom = getValore("dateFrom");
	var dateTo = getValore("dateTo");
	alert( "_stat_processi_confronta.cfm?id_processo=" + idp + "&gruppi=" + gruppo + "&dateFrom=" + dateFrom + "&dateTo=" + dateTo + "&cs=" + cs + "&ce=" + ce + "&tp=" + tp);
	document.location = "_stat_processi_confronta.cfm?id_processo=" + idp + "&gruppi=" + gruppo + "&dateFrom=" + dateFrom + "&dateTo=" + dateTo + "&cs=" + cs + "&ce=" + ce + "&tp=" + tp;
//confronta();
}

function setConfronta(obj,gruppo,tp){
	if (obj.checked) {
		setValore("gruppi" , getValore("gruppi") + gruppo + ",");
		//setValore("tp" , getValore("tp") + tp + ",");
		//document.getElementById("gruppo_" + gruppo).style.backgroundColor = "#ffa346";
	} else {
		//document.getElementById("gruppo_" + gruppo).style.backgroundColor = "#ffffff";
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
</script>
<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="yes">
<cfparam name="url.id_processo" default="3,7">
<cfparam name="url.gruppi" default="">
<cfinvoke component="statistiche" method="confrontaProcessiGruppi" returnvariable="rsDetail">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="start_processo" value="#url.id_processo#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.gruppi#">
</cfinvoke>
<cfinvoke component="statistiche" method="getNomeProcessi" returnvariable="listProcessi">
	<cfinvokeargument name="id_processo" value="#url.id_processo#">
</cfinvoke>
<cfset totale = 0>
<cfset totale_perc = 0>
<cfset nrprocessi = 0>
<body style="overflow:auto">

<table width="100%" cellspacing="0" cellpadding="2" style="border:1px solid #eaeaea">
	<tr bgcolor="#fff">
		<td colspan="8">
		<strong>Confronto &raquo; <cfloop index="i" list="#listProcessi#"><cfoutput>[#i#] </cfoutput></cfloop></strong>
		</td>
	</tr>
	<tr bgcolor="#eaeaea">
		<td width="60"><!--- <input type="button" class="btn" value="Confronta" onclick="confronta()"> ---></td>
		<td><strong>Gruppo</strong></td>
		<td><strong>Totale</strong></td>
		<td align="left" colspan="2"><strong>% sul gruppo</strong></td>
		<td><strong>% su Globale</strong></td>
		<td><strong></strong></td>
		<td><strong></strong></td>
	</tr>
	<cfset lista_tp = "#url.tp#">
	<cfset thisGruppo = "">
<cfoutput query="rsDetail" group="ac_gruppo">
	
	<cfinvoke component="statistiche" method="confrontaProcessiGruppi" returnvariable="rsContaGruppo">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="start_processo" value="#url.id_processo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
	</cfinvoke>
	<cfset totale_gruppo = rsContaGruppo.recordcount>
	<cfset totale = 0>
	
	<!--- <cfset url.tp = tp> --->

	<cfoutput group="ac_gruppo">
	<tr id="gruppo_#id_gruppo#" style="display:;"  bgcolor="##eaeaea">
		<td>
		<!--- <input type="checkbox" value="#id_gruppo#" id="confronta" onclick="setConfronta(this,#id_gruppo#,#tp#)"> --->
		</td>
		<td colspan="7">
		<strong> #ac_gruppo#</strong> 
		</td>
	</tr>
	
	
	<cfoutput group="id_processo">
	<cfinvoke component="statistiche" method="confrontaProcessiGruppi" returnvariable="rsContaAgente">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="start_processo" value="#id_processo#">
		<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
		<cfinvokeargument name="id_agente" value="#id_persona#">
	</cfinvoke>
	<cfset pos = listfind(url.id_processo,id_processo)>
	<cfset tp = ListGetAt(lista_tp,pos)>
	<cfset nrprocessi = rsContaAgente.recordcount>
	<tr>
		<td></td>
		<td colspan="7"><img src="../include/css/dot-trasp.png" width="10" height="10" align="absmiddle" style="background:###ac_colore#;border:1px solid black;margin-right:5px">
		#ac_processo#</td>
	</tr>
	<cfoutput group="id_persona">
	<tr>
		<td width="60">
		</td>
		<td style="padding-left:30px"><li>#ac_cognome# #ac_nome#</li></td>
		<td>#nrprocessi#</td>
		
		<cfset perc_processi = DecimalFormat((nrprocessi/totale_gruppo)*100)>
		<cfset totale_perc =  ((nrprocessi/tp)*100)>
		<td>#perc_processi#</td>
		<td><img src="../include/css/dot-trasp.png" width="#perc_processi#" height="10" style="background:green;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-perc_processi#" height="10" style="background:white;border:1px solid black">
		</td>
		<td>#DecimalFormat(totale_perc)# % <img src="../include/css/dot-trasp.png" width="#totale_perc#" height="10" style="background:red;border:1px solid black;"><img src="../include/css/dot-trasp.png" width="#100-totale_perc#" height="10" style="background:white;border:1px solid black;border-left:0px"></td>
		<td></td>
		<td>
		</td>
	</tr>
	</cfoutput>
	</cfoutput> 
	<cfset totale = totale + nrprocessi>
	</cfoutput>
	<tr>
		<td colspan="2"></td>
		<td colspan="6"><strong><strong>#totale_gruppo#</strong></strong></td>
	</tr>
</cfoutput>
	<!--- <tr>
		<td colspan="8">
		 <input type="button" class="btn" value="Confronta" onclick="confronta()">
		</td>
	</tr> --->
	<!--- <cfoutput>
	<tr bgcolor="##eaeaea">
		<td></td>
		<td>Totale processi analizzati</td>
		<td><strong>#totale#</strong></td>
		<td><strong>#round(totale_perc)#</strong></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		
	</tr> 
	</cfoutput>--->
</table>
	
<cfoutput>
<input type="text" name="id_processo" id="id_processo" value="#url.id_processo#">
<input type="text" name="gruppi" id="gruppi">
<input type="text" name="dateFrom" id="dateFrom" value="#url.dateFrom#">
<input type="text" name="dateTo" id="dateTo" value="#url.dateTo#">
<input type="text" name="cs" id="cs" value="#url.cs#">
<input type="text" name="ce" id="ce" value="#url.ce#">
<input type="text" name="tp" id="tp" value="#url.tp#">


</cfoutput>
</body>
<!--- <cfdump var="#rsDetail#"> --->
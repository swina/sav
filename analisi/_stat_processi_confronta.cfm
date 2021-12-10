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
	alert(gruppi);
}

function setConfronta(obj,gruppo){
	if (obj.checked) {
		setValore("gruppi" , getValore("gruppi") + gruppo + ",");
	} else {
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
</script>
<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="yes">
<cfinvoke component="statistiche" method="confrontaGruppi" returnvariable="rsDetail">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="start_processo" value="#url.id_processo#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.gruppi#">
</cfinvoke>
<body style="overflow:auto">
<!--- <cfdump var="#rsDetail#"> --->
<cfset listaTotali = ValueList(rsDetail.nrprocessi)>
<cfset myTotale = 0>
<cfloop index="i" list="#listaTotali#">
	<cfset myTotale = myTotale + i>
</cfloop>

<cfset totale = 0>
<cfset totale_perc = 0>
<cfset totale_perc_su_totale = 0>
<table width="100%" cellspacing="0" cellpadding="2" style="border:1px solid black">
	<tr bgcolor="<cfoutput>###rsDetail.ac_colore#</cfoutput>">
		<td colspan="7">
		<strong><cfoutput>#rsDetail.ac_processo#</cfoutput> <!--- <input type="button" class="btn" value="Indietro" onclick="history.back()"> ---></strong>
		</td>
	</tr>
	<tr bgcolor="#eaeaea">
		<td><input type="button" class="btn" value="Confronta" onclick="confronta()"></td>
		<td><strong>Gruppo</strong></td>
		<td><strong>Totale</strong></td>
		<td align="center"><strong>%</strong></td>
		<td></td>
		<td><strong>% su Globale</strong></td>
		<td></td>
	</tr>

<cfoutput query="rsDetail" group="ac_gruppo">
<!--- 	<cfset perc_processi = DecimalFormat((nrprocessi/tp)*100)>
	<cfset totale_perc = totale_perc + ((nrprocessi/tp)*100)> --->
	<tr id="gruppo_#id_gruppo#" style="display:;background:##eaeaea;">
		<td>
		</td>
		<td><strong>#ac_gruppo#</strong></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
	</tr>
	
	<cfoutput group="id_persona">
		<cfset perc_processi = DecimalFormat((nrprocessi/myTotale)*100)>
		<cfset perc_su_totale = DecimalFormat((nrprocessi/url.tp)*100)>
		<cfset totale_perc_su_totale = totale_perc_su_totale + perc_su_totale>
		<tr id="gruppo_#id_gruppo#" style="display:">
		<td>
		<input type="checkbox" value="#id_persona#" id="confronta" onclick="setConfronta(this,#id_gruppo#)">
		</td>
		<td><li>#ac_cognome# #ac_nome#</li></td>
		<td>#nrprocessi#</td>
		<td>#perc_processi#</td>
		<td><img src="../include/css/dot-trasp.png" width="#perc_processi#" height="10" style="background:green;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-perc_processi#" height="10" style="background:white;border:1px solid black">
		</td>
		<td width="80">
		#perc_su_totale# 
		</td>
		<td>
		<img src="../include/css/dot-trasp.png" width="#perc_su_totale#" height="10" style="background:red;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-perc_su_totale#" height="10" style="background:white;border:1px solid black;border-left:0px">
		</td>
	</tr>
	<cfset totale = totale + nrprocessi>
	</cfoutput>

</cfoutput>
	<cfoutput>
	<tr bgcolor="##eaeaea">
		<td></td>
		<td>Totale processi analizzati</td>
		<td><strong>#totale#</strong></td>
		<td><!--- <strong>#round(totale_perc)#</strong> ---></td>
		<td></td>
		<td>#totale_perc_su_totale#</td>
		<td><img src="../include/css/dot-trasp.png" width="#totale_perc_su_totale#" height="10" style="background:red;border:1px solid black"><img src="../include/css/dot-trasp.png" width="#100-totale_perc_su_totale#" height="10" style="background:white;border:1px solid black;border-left:0px"></td>
	</tr>
	</cfoutput>
</table>
<!--- <cfdump var="#rsDetail#"> --->
</body>
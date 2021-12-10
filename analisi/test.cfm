<!--- <script>
function dettaglio(idp,dal,al,clientiSav,clientiExtra,totale_processi){
	document.getElementById("dettaglio").src = "test_dettaglio.cfm?id_processo=" + idp + "&dateFrom=" + dal + "&dateTo=" + al + "&cs=" + clientiSav + "&ce=" + clientiExtra + "&tp=" + totale_processi;
	document.getElementById("detail").style.display = "";
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
<cfparam name="url.end_processo" default="">

<!--- Query the database and get all the records --->
<cfinvoke component="statistiche" method="contaProcessi" returnvariable="rsAll">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
	<cfinvokeargument name="start_processo" value="">
	<cfinvokeargument name="end_processo" value="#url.end_processo#">
</cfinvoke>
<cfinvoke component="analisi" method="calcola_giorni" returnvariable="ngiorni">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
</cfinvoke>


	<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiExtraTotali">
		<cfinvokeargument name="id_processo" value="#url.start_processo#">
		<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
		<cfinvokeargument name="dateTo" value="#url.dateTo#">
		<cfinvokeargument name="id_gruppo_agenti" value="">
	</cfinvoke>
<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
<style>
TD { border-bottom:1px solid #eaeaea}
</style>
<!---  ---> 
<div align="center">
<cfset totale_generale = 0>
<cfloop query="rsAll">
	<cfset totale_generale = totale_generale + rsAll.nrprocessi>
</cfloop>
<cfset perc_totale = 0>
<table width="100%" cellspacing="0" cellpadding="2" style="border:1px solid black">
	<tr>
		<td colspan="7">
		Periodo : <cfoutput>#url.dateFrom# - #url.DateTo#</cfoutput>
		</td>
	</tr>
	<tr bgcolor="#eaeaea">
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
	</cfinvoke>
	<cfif url.start_processo EQ "" OR url.start_processo EQ id_processo>
	<tr>
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
		<img src="../include/css/dot-trasp.png" width="#perc_clienti_sav#" height="10" style="background:##99ccff"><img src="../include/css/dot-trasp.png" width="#perc_clienti_extra#" height="10" style="background:navy"> <a href="javascript:dettaglio(#id_processo#,'#url.dateFrom#','#url.dateTo#',#clienti_sav#,#nrClientiExtra#,#nrprocessi#)"><input type="button" class="btn" value="Dettaglio"></a></td>
	</tr>
	</cfif>
</cfoutput>
	<cfoutput>
	<tr>
	
		<td>Totale processi analizzati: </td>
		<td>#totale_generale#</td>
		<td>#DecimalFormat(perc_totale)# %</td>
		<td><a href="?start_processo=">Vedi tutti</a></td>
	</tr>
	</cfoutput>
	<tr id="detail" style="display:none">
		<td colspan="7">
		<iframe name="dettaglio" id="dettaglio" width="100%" height="400" marginwidth="0" marginheight="0" align="left" frameborder="0"></iframe>
		</td>
	</tr>
</table>

</div> --->
<!--- 
<cfoutput>#totale_generale# #perc_totale#</cfoutput>

<cfdump var="#rsAll#">
<cfquery name="prova" datasource="#application.dsn#">
SELECT	tbl_status.id_processo FROM tbl_status
WHERE 
				( dt_status >= {ts '2011-03-04 00:00:00'} AND dt_status <= {ts '2011-03-19 00:00:00'} )
				AND id_processo = 2
</cfquery> --->
<cfquery name="qryEscludiContatti" datasource="#application.dsn#">
			SELECT 
				tbl_status.id_processo,
				tbl_status.id_cliente ,
				tbl_clienti.id_agente AS agente
			FROM tbl_status 
			INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			WHERE ( id_processo = 8 OR id_processo = 10 OR id_processo = 7) 
			AND id_agente = 125 
		GROUP BY id_cliente
		</cfquery>
		<cfif qryEscludiContatti.recordcount>
			<cfset nrDaEscludere = qryEscludiContatti.recordcount>
		<cfelse>
			<cfset nrDaEscludere = 0>	
		</cfif>
		<cfquery name="qryContaContatti" datasource="#application.dsn#">
			SELECT
				tbl_status.id_processo,
				tbl_clienti.id_cliente
			FROM tbl_clienti
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			INNER JOIN tbl_status ON tbl_clienti.id_cliente = tbl_status.id_cliente
			WHERE 
				tbl_persone.id_persona IN ( 125 )
			GROUP BY tbl_clienti.id_cliente	
		</cfquery>
<cfoutput>
#qryContaContatti.recordcount# - #qryContaContatti.recordcount-nrDaEscludere#
</cfoutput>
<cfdump var="#qryContaContatti#">	
<cfdump var="#qryEscludiContatti#">	


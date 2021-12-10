<cfsetting showdebugoutput="yes">
<cfsetting enablecfoutputonly="no">
<cfparam name="from" default="#CreateDate(year(now()),month(now())-3,day(now()))#">
<cfparam name="to" default="#CreateDate(year(now()),month(now()),day(now()))#">
<cfparam name="url.id_processo" default="3,8,6,4,7,13">
<cfparam name="url.id_gruppo_agenti" default="">
<cfparam name="url.id_agente" default="">
<cfparam name="id_gruppo" default="">
<cfparam name="id_agente" default="">

<script>
function createExcelThis(idp,dfrom,dto,idg,ida){
	document.getElementById("excel_detail").src = "_stat_riepilogo_generale_XLS.cfm?id_processo=" + idp + "&dateFrom=" + dfrom + "&dateTo=" + dto + "&id_gruppo_agenti=" + idg + "&id_agente=" + ida;
}
</script>

<cfif IsDefined("url.dateFrom") AND url.dateFrom NEQ "">
	<cfset from = CreateDate(ListGetAt(url.dateFrom,3,"/"),ListGetAt(url.dateFrom,2,"/"),ListGetAt(url.dateFrom,1,"/"))>
	<cfset to = CreateDate(ListGetAt(url.dateTo,3,"/"),ListGetAt(url.dateTo,2,"/"),ListGetAt(url.dateTo,1,"/"))>
</cfif>

<cfif url.id_gruppo_agenti NEQ "">
	<cfset id_gruppo = url.id_gruppo_agenti>
</cfif>

<cfif url.id_agente NEQ "">
	<cfset id_agente = url.id_agente>
</cfif>

<cfinvoke component="statistiche" method="riepilogoGenerale" returnvariable="rsRiepilogo">
	<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
	<cfinvokeargument name="dateTo" value="#url.dateTo#">
	<cfinvokeargument name="id_processo" value="#url.id_processo#">
	<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo_agenti#">
	<cfinvokeargument name="id_agente" value="#id_agente#">
</cfinvoke>

<cfinvoke component="statistiche" method="getNomeProcessi" returnvariable="listaProcessi">
	<cfinvokeargument name="id_processo" value="#url.id_processo#">
	<cfinvokeargument name="ordine" value=false>
</cfinvoke>
<style>
TD  { border-bottom:1px solid #eaeaea}
DIV { font-size:14px ; font-family: Verdana }
</style>
<script language="JavaScript" type="text/javascript">
function viewDetail(obj){
	document.getElementById(obj).style.display = "";
}
</script>
<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
<cfset ncount = 0>
<cfset naltri = 0>
<cfset myHTML = "">
<cfset totali = 0>
<cfset thisAgente = 0>
<cfset totale_agente = 0>
<cfset totale_giorni_agente = 0>
<cfset totale_clienti_sav = 0>
<cfset totale_clienti_extra = 0>
<cfset totale_contatti_periodo = 0>
<cfset totale_contatti = 0>
<cfset myData = "">
<body style="overflow:auto">
<cfif rsRiepilogo.recordcount GT 0>
<table width="100%" cellpadding="5" cellspacing="0">
	<tr>
		<td colspan="11" bgcolor="#eaeaea">
		ANALISI RIEPILOGO PROCESSI: <strong><cfoutput> Dal #url.dateFrom# al #url.dateTo#&nbsp;<input type="button" class="btn" value="Excel"  onclick="createExcelThis('#url.id_processo#','#url.dateFrom#','#url.dateTo#','#url.id_gruppo_agenti#','#url.id_agente#')" style="cursor:pointer" title="Crea Excel"> </cfoutput></strong>
		</td>
	</tr>
	<tr>
			<td width="300"><strong>Gruppo/Agenti</strong></td>
			<cfset n = 1>
			<cfloop index="p" list="#url.id_processo#">
				<cfoutput>
				<td width="65" valign="top"><strong>#ListGetAt(listaProcessi,n)#</strong></td>
				<cfset n = n + 1>
				</cfoutput>
			</cfloop>
			<td width="65" valign="top"><strong>App.ti contatti propri</strong></td>
			<td width="65" valign="top"><strong>App.ti contatti sede</strong></td>
			<td width="65" valign="top"><strong>Contatti periodo propri/sede</strong></td>
			<td width="65" valign="top"><strong>Contatti in essere</strong></td>
		</tr>
	<cfset totale_conta = 0>
	<cfset riga = 0>
	<cfset aTotali = ArrayNew(2)>
	<cfoutput query="rsRiepilogo" group="ac_gruppo">
		
		<cfset lista_totali = "">
		<tr>
			<td colspan="10"><strong>#ac_gruppo#</strong></td>
		</tr>
		
		<cfoutput group="id_persona">
		<cfset riga = riga + 1>
		<cfset nconta = 0>
		<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiExtra">
			<cfinvokeargument name="id_processo" value="3,8">
			<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
			<cfinvokeargument name="dateTo" value="#url.dateTo#">
			<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
			<cfinvokeargument name="id_agente" value="#id_persona#">
		</cfinvoke>
		<cfinvoke component="statistiche" method="contaClienti" returnvariable="nrClientiSAV">
			<cfinvokeargument name="id_processo" value="3,8">
			<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
			<cfinvokeargument name="dateTo" value="#url.dateTo#">
			<cfinvokeargument name="id_gruppo_agenti" value="#id_gruppo#">
			<cfinvokeargument name="id_agente" value="#id_persona#">
			<cfinvokeargument name="tipo_clienti" value="1">
		</cfinvoke>
		
		<cfset nrClientiTotali = 0>
		<cfinvoke component="statistiche" method="contaContatti" returnvariable="nrClientiTotali">
			<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
			<cfinvokeargument name="dateTo" value="#url.dateTo#">
			<cfinvokeargument name="id_agente" value="#id_persona#">
		</cfinvoke>
		<cfinvoke component="statistiche" method="contaContatti" returnvariable="nrClientiTotaliEXTRA">
			<cfinvokeargument name="dateFrom" value="#url.dateFrom#">
			<cfinvokeargument name="dateTo" value="#url.dateTo#">
			<cfinvokeargument name="id_agente" value="#id_persona#">
			<cfinvokeargument name="scopo" value="1">
		</cfinvoke>
		<tr>
			<td valign="top">
			#UCASE(ac_cognome)# #UCASE(ac_nome)#
			</td>
			<cfset p = 1>
			
			<cfloop index="i" list="#url.id_processo#">
				<td>
				<cfoutput>
					<cfif id_processo EQ i>
						<cfset totale_conta = totale_conta + 1>
						<cfset nconta = nconta + 1>
					</cfif>
					
				</cfoutput>
				<cfset aTotali[riga][p] = nconta>
				#nconta#
				</td>
				<cfset nconta = 0>
				<cfset p = p + 1>
				<cfset lista_totali = "#lista_totali##totale_conta#,">	
			</cfloop>
			<cfset totale_clienti_sav = totale_clienti_sav + nrClientiSAV>
			<cfset totale_clienti_extra = totale_clienti_extra + nrClientiExtra>
			<cfset totale_contatti_periodo = totale_contatti_periodo + ListGetAt(nrClientiTotali,1)>
			<cfset totale_contatti = totale_contatti + ListGetAt(nrClientiTotali,2)>
			<td>#nrClientiExtra#</td>
			<td>#nrClientiSAV#</td>
			<td>#ListGetAt(nrClientiTotali,1)# / #ListGetAt(nrClientiTotaliExtra,1)#</td>
			<td>#ListGetAt(nrClientiTotali,2)#</td>
		</tr>
		</cfoutput>
	</cfoutput>
	<tr>
			<td></td>
			<cfset thisTotale = 0>
			<cfset col_tot = ArrayNew(1)>
			<cfloop index="i" from="1" to="6">
				<cfset thisTotale = 0>
				<cfloop index="s" from="1" to="#ArrayLen(aTotali)#">
					<cfset thisTotale = thisTotale + aTotali[s][i]>
				</cfloop>
				<cfoutput>
					<td><strong>#thisTotale#</strong></td>
				</cfoutput>
			</cfloop>
			<cfoutput>
			<td><strong>#totale_clienti_extra#</strong></td>
			<td><strong>#totale_clienti_sav#</strong></td>
			<td><strong>#totale_contatti_periodo#</strong></td>
			<td><strong>#totale_contatti#</strong></td>
			</cfoutput>
	</tr>
	
</table>
<cfelse>
	<div align="center">
	<br>
	<br>
	<strong>NON CI SONO DATI DA ANALIZZARE PER IL FILTRO IMPOSTATO !!</strong>
	</div>
<!--- <cfdump var="#aTotali#"> --->
</cfif>
<iframe id="excel_detail" name="excel_detail" style="display:none"></iframe>
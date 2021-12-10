<cfinvoke component="status.status" method="getGruppiAgenti" returnvariable="rsGruppiAgenti"></cfinvoke>
<cfinvoke component="status.status" method="getAgenti" returnvariable="rsAgenti"></cfinvoke>
<cfinvoke component="status.status" method="getProcessi" returnvariable="rsProcessi"></cfinvoke>
<cfoutput>
<cfajaximport>
<form id="periodoFrm">
	<div class="winhead"><span id="stat"><strong>INDICI OPERATIVI</strong></span></div><br>
	Periodo 1
	dal <input type="text" name="dateFrom" id="dateFrom" size="10" value="#DateFormat(DateAdd('d',-15,now()),'dd/mm/yyyy')#"> 
	al <input type="text" name="dateTo" id="dateTo" size="10" value="#DateFormat(DateAdd('d',-1,now()),'dd/mm/yyyy')#"> 
	<br>
	<div style="display:">
	Periodo 2
	dal <input type="text" name="dateFrom2" id="dateFrom2" size="10" value="#DateFormat(DateAdd('d',-15,now()),'dd/mm/yyyy')#"> 
	al <input type="text" name="dateTo2" id="dateTo2" size="10" value="#DateFormat(DateAdd('d',-1,now()),'dd/mm/yyyy')#"> <br>
	Analizza entrambi i periodi <input type="checkbox" name="periodo2" id="periodo2"><br>
	</div>
	<cfif session.livello EQ 0>
		<cfset mydisplay = "">
		<cfset gruppiUtente = ValueList(rsGruppiAgenti.id_gruppo)>
		<input type="hidden" name="gruppi_controllo" id="gruppi_controllo"  value="">
	<cfelse>
		<cfset mydisplay = "none">
		<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
			<cfset mydisplay = "">
			<cfset gruppiUtente = StructFind(session.userlogin,"gruppi_controllo")>
			<input type="hidden" name="gruppi_controllo" id="gruppi_controllo"  value="#StructFind(session.userlogin,'gruppi_controllo')#">
		<cfelse>
			<input type="hidden" name="gruppi_controllo" id="gruppi_controllo"  value="">
			<cfset mydisplay = "none">	
			<cfset gruppiUtente = "">
		</cfif>
	</cfif>
	<cfset mydisplay = "">
	<table cellpadding="2" cellspacing="0" width="250">
		<tr style="display:#mydisplay#">
			<td>Gruppi Agenti</td>
			<td>
			<select name="id_gruppo_agenti" id="id_gruppo_agenti">
			<option value="">tutti</option>
			<cfloop query="rsGruppiAgenti">
				<cfoutput>
				<cfif ListFind(gruppiUtente,id_gruppo)><option value="#id_gruppo#">#ac_gruppo#</option></cfif>
				</cfoutput>
			</cfloop>
			</select>
			</td>
		</tr>	
	<!--- <div style="display:#mydisplay#">
	<div class="col80" style="display:#mydisplay#;float:left">
	Gruppi Agenti 
	</div>
	<div>
	<br>
	</div>
	</div>	 --->
	
	<cfif session.livello EQ 0>
		<cfset mydisplay = "">
	<cfelse>
		<cfset mydisplay = "none">
	</cfif>
	<cfset mydisplay = "">
	<tr style="display:#mydisplay#">
		<td valign="top">Agente</td>
		<td>
		<select name="id_agente" id="id_agente" multiple size="6">
		<option value="" selected>tutti</option>
		<cfloop query="rsAgenti">
			<cfif StructFind(session.userlogin,"id") EQ id_persona AND session.livello GT 2>
				<option value="#id_persona#" selected>#UCASE(ac_cognome)# #UCASE(ac_nome)#</option>
			<cfelse>
				<option value="#id_persona#">#UCASE(ac_cognome)# #UCASE(ac_nome)#</option>	
			</cfif>
		</cfloop>
		</select>	
		</td>
	</tr>	
	

	<tr style="display:none">
		<td>processo</td>
		<td>
		<select id="id_processo_start" name="id_processo_start">
		<option value="">tutti</option>
		<cfloop query="rsProcessi">
			<option value="#id_processo#">#ac_sigla#</option>
		</cfloop>			
	</select>
		</td>
	</tr>
	<tr style="display:none">
		<td>a processo</td>
		<td>
		<select id="id_processo_end" name="id_processo_end">
		<option value="">tutti</option>
		<cfloop query="rsProcessi">
			<option value="#id_processo#">#ac_sigla#</option>
		</cfloop>			
		</select>
		</td>
	</tr>
	<cfset mydisplay = "none">
	<tr style="display:#mydisplay#">
		<td>% su contatti</td>
		<td><input type="checkbox" id="radio_100" name="radio_100" value="contatti_100" checked></td>
	</tr>
	<tr style="display:#mydisplay#">
		<td>media giorni</td>
		<td>
		<input type="checkbox" id="media_giorni" name="media_giorni" value="media_giorni">
		</td>
	</tr>
	<tr style="display:#mydisplay#">
		<td>giorni</td>
		<td>
		<input type="checkbox" id="nr_giorni" name="nr_giorni" value="nr_giorni">
		</td>
	</tr>
	
	<tr>
		<td colspan="2" align="center">
		<input type="button" class="btn" value="Processi" onclick="setStatistiche(0)">
		<input type="button" class="btn" value="Assegnazioni" onclick="setStatistiche(1)">
		</td>
	</tr>
	<tr>
		<td colspan="2">
		<strong>Statistiche standard</strong>
		<table>
			<tr>
				<td>1� Appuntamento - Contratto</td>
				<td><input type="button" class="btn" value="Vedi" onclick="setStatistiche(2)"></td>
			</tr>
			<tr>
				<td>Richiesta Offerta - Contratto</td>
				<td> <input type="button" class="btn" value="Vedi" onclick="setStatistiche(3)"></td>
			</tr>
			<tr>
				<td>1� Contatto Tel. - Contratto</td>
				<td> <input type="button" class="btn" value="Vedi" onclick="setStatistiche(5)"></td>
			</tr>
			<tr>
				<td>Appuntamenti - Contratto</td>
				<td> <input type="button" class="btn" value="Vedi" onclick="setStatistiche(6)"></td>
			</tr>
			<tr>
				<td>Appuntamenti</td>
				<td> <input type="button" class="btn" value="Vedi" onclick="setStatistiche(7)"></td>
			</tr>
			<tr>
				<td>Asegnazioni Contatti</td>
				<td> <input type="button" class="btn" value="Vedi" onclick="setStatistiche(8)"></td>
			</tr>
			<tr>
				<td>Offerte - Contratti (riepilogo)</td>
				<td> <input type="button" class="btn" value="Vedi" onclick="setStatistiche(9)"></td>
			</tr>

			<tr>
				<td>Riepilogo Processi</td>
				<td> <input type="button" class="btn" value="Vedi" onclick="setStatistiche(4)"></td>
			</tr>

		</table>
		</td>
	</tr>
	</table>
	
</form>
</cfoutput>
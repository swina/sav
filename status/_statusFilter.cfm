

<cfform id="filterStatus">

<div class="winhead">
	<table width="98%">
		<tr>
			<td>
			<strong>Status Operativo</strong> &nbsp;
	<a href="_statusLegenda.cfm" rel="gb_page_center[300,300]" title="Legenda Azioni/Colori"><img src="../include/css/icons/knobs/icon_info.gif" border="0" title="Legenda" align="absmiddle"></a><a href="index.cfm" target="_self"><img src="../include/css/icons/knobs/action_refresh_blue.gif" title="aggiorna" align="absmiddle" onclick="reloadClienti()" style="cursor:pointer"></a><a href="javascript:printStatus(0)" target="_blank"><img src="../include/css/icons/print.png" border="0" title="Stampa" alt="stampa" align="absmiddle"></a>&nbsp;<a href="javascript:statusExcel(0)" target="_blank"><img src="../include/css/icons/files/xls.png" width="16" border="0" title="Excel" alt="Excel" align="absmiddle"></a><cfif IsDefined("url.window") IS FALSE><a href="index3.cfm?window=yes" target="extra"><img src="../include/css/icons/led-icons/application2.png" border="0" alt="Schermo intero" title="Schero intero" align="absmiddle"></a><cfelse><a href="javascript:void(0)" onclick="self.close()"><img src="../include/css/icons/knobs/action_stop.gif" border="0" alt="Chiudi finestra" title="Chiudi finestra" align="absmiddle"></a></cfif>
			</td>
			<td align="right">
			<span id="prevPage" style="display:none;">
			<input type="button" class="btn" value=" << " onclick="statusPrevPage()">	
			</span>
			<span id="statusINFO" style="color:white"></span>
			<span>
			<input type="button" class="btn" value=" >> " onclick="statusNextPage()">
			</div>
			</td>
		</tr>
	</table>
</div>

<div style="padding-left:10px;padding-top:3px">
<input type="text" id="searchValue" value="cerca cliente ..." onfocus="clearValue(this)" size="12" title="Cerca nominativo">
	
	<!--- solo direzione commerciale e resp. zona --->
	<cfif session.livello LT 3>
		<cfset mydisplay = "">
	<cfelse>
		<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
			<cfset mydisplay = "">
		<cfelse>
			<cfset mydisplay = "none">	
		</cfif>
		
	</cfif>
	
	<span style="display:<cfoutput>#mydisplay#</cfoutput>">
		<select id="id_agente_filter" name="id_agente_filter" style="display:<cfoutput>#mydisplay#</cfoutput>" title="Cerca i contatti di un agente">
	 	<option value="">Tutti gli agenti</option>
		<cfoutput>
		<option value="#StructFind(session.userlogin,'id')#">#StructFind(session.userlogin,"utente")#
		</cfoutput>
		<cfoutput query="qryAgenti">
		<option value="#id_persona#">#ac_cognome# #ac_nome#</option>
		</cfoutput>
		</select>
	</span>
	<!--- solo direzione commerciale --->	
		<cfif session.livello LT 2>
		<select id="id_gruppo_filtro" name="id_gruppo_filtro" style="display:<cfoutput>#mydisplay#</cfoutput>" title="Cerca i contatti per gruppo di appartenenza">
		<option value="">Tutti i gruppi</option>
			<cfloop query="qryGruppi">
				<cfoutput>
				<option value="#id_gruppo#">#ac_gruppo#</option>
				</cfoutput>
			</cfloop>
		</select>
		
		</cfif>
		
		<!--- solo se ha gruppi di controllo --->	
		<cfif session.livello GT 1>
		<cfif StructKeyExists(session.userlogin,"gruppi_controllo")>
			<cfset mydisplay = "">
			<cfset gruppiUtente = StructFind(session.userlogin,"gruppi_controllo")>
			<input type="checkbox" name="bl_soloagente" id="bl_soloagente" value="1" checked> solo i miei contatti 
		<cfelse>
			<cfset mydisplay = "none">	
			<cfset gruppiUtente = "">
			<input type="checkbox" name="bl_soloagente" id="bl_soloagente" value="1" checked style="display:none">
		</cfif>
		
		<select id="id_gruppo_filtro" name="id_gruppo_filtro" style="display:<cfoutput>#mydisplay#</cfoutput>" title="Cerca i contatti per gruppo di appartenenza">
			<option value="">Tutti i gruppi</option>
			<cfloop query="qryGruppi">
				<cfoutput>
				<cfif ListFind(gruppiUtente,id_gruppo)><option value="#id_gruppo#">#ac_gruppo#</option></cfif>
				</cfoutput>
			</cfloop>
		</select>
		<cfelse>
		<input type="checkbox" name="bl_soloagente" id="bl_soloagente" value="1" checked style="display:none">
		</cfif>
		<br>
	<select id="id_processo_filter" name="id_processo_filter" title="Cerca i contatti per processo">
 	<option value="">Tutti processi</option>
	<cfoutput query="myProcessi">
		<cfif session.livello GT 0>
			<cfset permission = ListGetAt(ac_permissions,session.livello)>
			<cfif permission EQ 1>
			<option value="#id_processo#">#ac_sigla#</option>
			</cfif>
		<cfelse>
			<option value="#id_processo#">#ac_sigla#</option>	
		</cfif>
	</cfoutput>
</select> &nbsp;

dal <input type="text" name="dateFrom" id="dateFrom" size="8" title="Cerca dalla data"> al <input type="text" name="dateTo" id="dateTo" size="8"  title="Cerca alla data">	
	<input type="hidden" name="start" id="start" value="<cfoutput>#start#</cfoutput>">
	<input type="button" class="btn" value="Cerca" onclick="filterProcess(0)" title="Cerca">
<!--- 	<img src="../include/css/icons/search.png" align="absmiddle" title="Cerca" alt="Cerca" onclick="filterProcess()" style="cursor:pointer"> --->
	<input type="button" class="btn" value="Tutti" onclick="resetFilter()" title="Azzera ricerca">
</div>
</cfform>
<iframe id="excelFrame" style="display:none"></iframe>
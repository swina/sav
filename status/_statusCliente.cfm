<cfset session.noOfferte = FALSE>
<cfif session.livello GT 1 AND session.livello LT 4>
	<cfinclude template="_statusNoOfferte.cfm">
</cfif>
<cfajaximport>
<style>
strong { font-weight:bold }
</style>
<cfform name="processoFrm" format="HTML">

<input type="hidden" name="id_status" id="id_status" value="0">
<input type="hidden" name="id_cliente" id="id_cliente">
<input type="hidden" name="action" id="action" value="add">
<input type="hidden" name="lista_docs" id="lista_docs" value="">
<input type="hidden" name="docs_url" id="docs_url" value="../docs/status">
<input type="hidden" name="lista_moduli" id="lista_moduli" value="<cfoutput>#moduli#</cfoutput>">
<input type="hidden" name="ac_modulo" id="ac_modulo" value="">
<input type="hidden" name="modulo_flag" id="modulo_flag" value=1>
<input type="hidden" name="documento_flag" id="documento_flag" value=1>
<div class="winhead">
<strong>Azione</strong><img src="../include/css/icons/altre/001_01.png" height="14" align="absmiddle" hspace="5" style="cursor:pointer" alt="Aggiungi azione" title="Aggiungi azione" onclick="addProcess()"><input type="button" style="display:" id="submitButton" value="Aggiungi" onclick="addNewProcess()" class="btn">&nbsp;<cfif session.livello LT 2><input type="button" style="display:" id="deleteButton" value="Elimina" onclick="deleteProcess()" class="btn"><cfelse><input type="button" id="deleteButton" value="Elimina" onclick="" class="btn" style="display:none"></cfif></div>
<select id="id_processo" name="id_processo" style="font-size:10px" onchange="checkValore();checkDocumento();checkFixedDate();checkDipendenza();" disabled>
	<cfset livello = StructFind(session.userlogin,"livello")>
	<cfoutput query="myProcessi">
		<cfif livello GT 0>
			<cfset permission = ListGetAt(ac_permissions,livello)>
			<cfif permission EQ 1>
				<cfif id_processo NEQ 6>
					<option value="#id_processo#">#ac_processo#		
				<cfelse>
					<cfif session.noOfferte IS FALSE>
						<option value="#id_processo#">#ac_processo#
					<cfelse>
						<option value="#id_processo#" disabled>#ac_processo#	
					</cfif>
				</cfif>
				
			</cfif>
		<cfelse>
			<option value="#id_processo#">#ac_processo#	
		</cfif>
	</cfoutput>
</select>

&nbsp;<span id="moduloIcon"></span>
<cfif session.livello LT 2>
	<span id="assegnazioneIcon"></span>
<cfelse>
	<span id="assegnazioneIcon" style="display:none"></span>
</cfif><br>
<input type="hidden" name="id_assegnazione" id="id_assegnazione">
<input type="hidden" name="modulo_uuid" id="modulo_uuid">
<!---- data e ora --->
<strong style="font-weight:bold">Data</strong><br>
<input type="text" id="calInput1" name="calInput1" value="<cfoutput>#DateFormat(now(),'dd/mm/yyyy')#</cfoutput>" style="width:75px;" readonly="true">
<strong>Ora</strong> 
<select name="ac_ora" id="ac_ora">
	<cfset n_ora = CreateDateTime(2010,1,1,0,0,0)>
	<cfloop index="i" from="1" to="48">
		<cfoutput>
		<cfif TimeFormat(n_ora,"HH:MM") EQ "09:00">
			<option value="#TimeFormat(n_ora,'HH:MM')#" selected>#TimeFormat(n_ora,"HH:MM")#</option>
		<cfelse>
			<option value="#TimeFormat(n_ora,'HH:MM')#">#TimeFormat(n_ora,"HH:MM")#</option>
		</cfif>
		<cfset n_ora = DateAdd("n",30,n_ora)>
		</cfoutput>
	</cfloop>
</select>

<!--- valore (visibile so processo prevede l'inserimento di un valore economico)--->
<div id="valore_field" style="display:none">
<strong>Valore &euro; </strong><input type="text" name="ac_valore" id="ac_valore" size="8" value="0">
</div>

<!--- note --->
<div>
<strong>Note</strong><br>
<textarea id="ac_note" name="ac_note" rows="4" style="width:190px;height:35px"></textarea>
</div>
<input type="hidden" name="livello" id="livello" value="<cfoutput>#session.livello#</cfoutput>">
<!--- upload documenti --->
<div style="height:50px">
<strong>Documento</strong> <img src="../include/css/icons/upcoming-work.png" onclick="uploadDocs()" style="cursor:pointer;" title="Carica Documento" align="absmiddle">&nbsp;&nbsp;<input type="button" class="btn" value="Vedi" onclick="docManager()" title="Vedi documenti caricati relativi al cliente selezionato">
<!--- 
<cfif IsDefined("session.debug") AND session.debug>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="docManager()">Vedi</a></cfif> ---><br>
<div id="docs"></div>
</div>
<!--- <input type="button" style="display:" id="submitButton" value="Aggiungi" onclick="addNewProcess()" class="btn"><cfif session.livello LT 3><input type="button" style="display:" id="deleteButton" value="Elimina" onclick="deleteProcess()" class="btn"><cfelse><input type="button" id="deleteButton" value="Elimina" onclick="" class="btn" style="display:none"></cfif> --->
</cfform>

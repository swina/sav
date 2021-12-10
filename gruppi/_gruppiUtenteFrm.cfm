<!--- <cfajaximport> --->
<cfinvoke component="gruppi" method="getGruppi" returnvariable="rsGruppi"></cfinvoke>
<cfinvoke component="gruppi" method="getGruppiAgenti" returnvariable="gruppiAgenti"></cfinvoke>
<cfoutput>
<cfform id="utenteFrm" name="utenteFrm">
<div class="winblue" style="height:450px"> 
		<cfinput type="hidden" name="id_persona" id="id_persona">
		
		<strong>Gruppo</strong>
		<select name="id_gruppo_agente" id="id_gruppo_agente" style="display:">
			<cfloop query="rsGruppi">
				<option value="#id_gruppo#">#ac_gruppo#</option>
			</cfloop>
		 </select>
		<br>
		
		<!--- <cfinput type="hidden" name="id_gruppo_agente" id="id_gruppo_agente"> --->
		<div style="float:left">
		<strong>COGNOME*</strong><br>
		<cfinput type="Text" name="ac_cognome" validateat="onSubmit" message="Inserire il cognome" validate="noblanks" required="Yes" visible="Yes" enabled="Yes" typeahead="No" id="ac_cognome" class="required" onchange="validate('txt',this,true)"><br>
		</div>
		<div>
		<strong>NOME*</strong> <br>
		<cfinput type="Text" name="ac_nome" validateat="onSubmit" message="nome obbligatorio" validate="noblanks" required="Yes" visible="Yes" enabled="Yes" typeahead="No" id="ac_nome" class="required" onchange="validate('txt',this,true)"><br>
		</div>
		<strong>Azienda</strong><br>
		<cfinput type="text" name="ac_azienda" id="ac_azienda">
		<br>

		<strong>Indirizzo</strong><br>
		<cfinput type="Text" name="ac_indirizzo" validateat="onSubmit" message="Indirizzo !!!" validate="noblanks" required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_indirizzo" size="35" class="enabled"><br>
		<strong>Città</strong><br>
		<cfinput type="Text" name="ac_citta" validateat="onSubmit" message="Città !!!" validate="noblanks" required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_citta" class="enabled">&nbsp;

		<strong>Prov.</strong>
		<cfinput type="Text" name="ac_pv" id="ac_pv" size="2" maxlength="2" required="yes" class="enabled">
		&nbsp;
		<strong>CAP</strong> 
		<cfinput type="Text" name="ac_cap" validateat="onSubmit" message="CAP !!!" validate="zipcode" required="No" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_cap" size="5" maxlength="5" onchange="validate('num',this,false)"><br>
		
		<div style="float:left">
		<strong>Telefono*</strong><br>
		<cfinput type="Text" name="ac_telefono" validateat="onSubmit" message="Telefono" required="yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_telefono" class="required" onchange="validate('num',this,true)"><br>
		</div>
		<div>
		<strong>Cellulare</strong><br>
		<cfinput type="Text" name="ac_cellulare" validateat="onSubmit" message="Cellulare" required="No" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_cellulare" onchange="validate('num',this,false)">
		</div>
		<strong>Email*</strong>	<cfinput type="Text" name="ac_email" validateat="onSubmit" message="Email !!!" validate="email" required="No" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_email" size="35" onchange="validate('mail',this,true)" class="required">
<br>
		<div style="float:left">
		<strong>Nome Utente*</strong><br>
		<cfinput type="Text" name="ac_utente" validateat="onSubmit" message="Nome utente !!!"  required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_utente" size="20" onchange="validate('txt',this,true)" class="required"><br>
		</div>
		<div>
		<strong>Password*</strong><br>
		<cfinput type="text" name="ac_password" validateat="onSubmit" message="Password !!!"  required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_password" size="20" onchange="validate('txt',this,true)" class="required"><br>
		</div><br>
		<div>
		<cfif StructFind(session.userlogin,"livello") EQ 0>
			<table>
				<tr>
					<td><strong>Gruppi di controllo</strong><br>
					<select name="id_gruppi_controllo" multiple id="id_gruppi_controllo" size="5">
						<option value="" selected>Nessuno</option>
						<cfloop query="gruppiAgenti">
							<option value="#id_gruppo#">#ac_gruppo#</option>
						</cfloop>
					 </select>
					 </td>
					 <td valign="top">
					 <span id="lista_gruppi"></span>	
					 </td>
				</tr>
			</table>
		</cfif>
		</div>
		<div>Assegnazione Nr Clienti periodo <input type="text" name="ac_sconto_riservato" id="ac_sconto_riservato" size="3" value="0"></div>
		<input type="hidden" name="nrclienti" id="nrclienti">
		<div style="float:center">
		<input type="button" name="saveData" id="saveData" class="btn" value="Salva" onclick="saveUtente()">
		<input type="button" name="closeThis" id="closeThis" onclick="closeUtenteFrm();" class="btn" value="Chiudi"></div>
</div>

	</cfform>
</cfoutput>
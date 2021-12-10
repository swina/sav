<!--- <cfajaximport> --->
<cfoutput>
<cfajaximport>
<cfform id="clienteFrm">
<div id="formEdit" class="winblue" style="height:100%;background:##d2e9f7;display:none;margin:0px"> 
	
		<div style="text-align:left;margin:5px;font-size:10px;font-family:verdana">
		<input type="hidden" name="id_cliente" id="id_cliente">
		<div style="float:left">
		<strong>COGNOME*</strong><br>
<cfinput type="Text" name="ac_cognome" validateat="onSubmit" message="Inserire il cognome" validate="noblanks" required="Yes" visible="Yes" enabled="Yes" typeahead="No" id="ac_cognome" class="required"><br>
		</div>
		<div>
		<strong>NOME*</strong><br>
<cfinput type="Text" name="ac_nome" validateat="onSubmit" message="nome obbligatorio" validate="noblanks" required="Yes" visible="Yes" enabled="Yes" typeahead="No" id="ac_nome" class="required"><br>
		</div>
		<br>
		
		<strong>Azienda</strong><br>
		<cfinput type="text" name="ac_azienda" id="ac_azienda" size="45" class="enabled">
		<br>
		<br>

		<strong>Indirizzo*</strong><br>
		<cfinput type="Text" name="ac_indirizzo" validateat="onSubmit" message="Indirizzo !!!" validate="noblanks" required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_indirizzo" size="45" class="required"><br>

		<div style="float:left">
		<strong>Città*</strong><br>
		<cfinput type="Text" name="ac_citta" validateat="onSubmit" message="Città !!!" validate="noblanks" required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_citta" class="required">&nbsp;
		<strong>prov.</strong>
		<cfinput type="Text" name="ac_pv" id="ac_pv" size="2" maxlength="2" required="yes" class="required">
		</div>
		<div>
		<strong>CAP</strong><br>
		<cfinput type="Text" name="ac_cap" validateat="onSubmit" message="CAP !!!" validate="zipcode" required="No" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_cap" size="5" maxlength="5" class="enabled"><br>
		</div>
		<br>
		
		<div style="float:left">
		<strong>Telefono*</strong><br>
		<cfinput type="Text" name="ac_telefono" validateat="onSubmit" message="Telefono" required="yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_telefono" class="required"><br>
		</div>
		<div>
		<strong>Cellulare</strong><br>
		<cfinput type="Text" name="ac_cellulare" validateat="onSubmit" message="Cellulare" required="No" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_cellulare" class="enabled"><br>
		</div>
		<strong>Email</strong><br>
		
		<cfinput type="Text" name="ac_email" validateat="onSubmit" message="Email !!!" validate="email" required="No" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_email" size="35" class="enabled"><br>
<br>

		<strong>Segnalato da</strong><br>
		<input type="Text" name="ac_segnalatore" id="ac_segnalatore" size="35" class="enabled"><br>
		<cfif session.livello GT 2>
			<br>
			<br>
			
			<div style="display:none">
			<br>
			<br>
			<br>
			
		<cfelse>
			<div style="display:">
		</cfif>
		<strong>Agente</strong><br>
		
		<select id="id_agente" name="id_agente" class="enabled">
			<option value="0">Non Assegnato</option>
			<cfloop query="agentiQry">
				<cfoutput>
				<option value="#agentiQry.id_persona#">#agentiQry.agente#</option>
				</cfoutput>	
			</cfloop>
		</select>
		<br>
		<br>
		</div>
		<div style="float:center">
		<input type="button" name="saveData" id="saveData" class="btn" value="Salva" onclick="saveAnagrafica()">
		<input type="button" name="closeThis" id="closeThis" onclick="closeForm();" class="btn" value="Chiudi"></div>
		</div>
	</div>
	</cfform>

</cfoutput>

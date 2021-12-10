<!--- <cfajaximport> --->

<cfoutput>
<div id="formEdit" class="winblue" style="height:100%"> 
		<cfform id="clienteFrm" name="clienteFrm" action="_clientiSave.cfm">

		<div style="text-align:left;margin:5px;font-size:10px;font-family:verdana">
		<cfinput type="Hidden" name="id_cliente" id="id_cliente">
		<div style="float:left">
		<strong>COGNOME*</strong><br>
		<cfinput type="Text" name="ac_cognome" validateat="onSubmit" message="Inserire il cognome" validate="noblanks" required="Yes" visible="Yes" enabled="Yes" typeahead="No" id="ac_cognome"><br>
		</div>
		<div>
		<strong>NOME*</strong> <br>
		<cfinput type="Text" name="ac_nome" validateat="onSubmit" message="nome obbligatorio" validate="noblanks" required="Yes" visible="Yes" enabled="Yes" typeahead="No" id="ac_nome" class=""><br>
		</div>
		<div>
		<strong>Azienda</strong><br>
		<cfinput type="text" name="ac_azienda" id="ac_azienda">
		<br>
		</div>
		
		<strong>Indirizzo*</strong><br>
		<cfinput type="Text" name="ac_indirizzo" validateat="onSubmit" message="Indirizzo !!!" validate="noblanks" required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_indirizzo" size="35" class=""><br>

		<strong>Città*</strong><br>
		<cfinput type="Text" name="ac_citta" validateat="onSubmit" message="Città !!!" validate="noblanks" required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_citta" class="">&nbsp;
		<strong>Prov.</strong>
		<cfinput type="Text" name="ac_pv" id="ac_pv" size="2" maxlength="2" required="yes" class="" onchange="validate('txt',this,false)">&nbsp;
		<strong>CAP</strong> 
		<cfinput type="Text" name="ac_cap" validateat="onSubmit" message="CAP !!!" validate="zipcode" required="No" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_cap" size="5" maxlength="5"><br>

		<strong>Telefono*</strong><br>
		<cfinput type="Text" name="ac_telefono" validateat="onSubmit" message="Telefono" required="yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_telefono" class="" ><br>

		<strong>Cellulare</strong><br>
		<cfinput type="Text" name="ac_cellulare" validateat="onSubmit" message="Cellulare" required="No" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_cellulare" ><br>

		<strong>Email</strong><br>
		
		<cfinput type="Text" name="ac_email" validateat="onSubmit" message="Email !!!" validate="email" required="No" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" id="ac_email" size="35"><br>
		
		<cfif session.livello GT 2>
			<cfset mydisplay = "none">
		<cfelse>
			<cfif session.livello EQ 2>
				<cfset mydisplay = "">
			<cfelse>
				<cfset mydisplay = "none">	
			</cfif>
			<cfif session.livello LT 2>
				<cfset mydisplay = "">
			</cfif>
		</cfif>
		<div style="display:#mydisplay#">
		<input type="hidden" name="id_agente_old" id="id_agente_old">
		<strong>Agente</strong><br>
		
		<select id="id_agente" name="id_agente">
			<option value="0">Non Assegnato</option>
			<cfloop query="agentiQry">
				<cfoutput>
				<option value="#agentiQry.id_persona#">#agentiQry.agente#</option>
				</cfoutput>	
			</cfloop>
		</select>
		</div>
		<br>
		<strong>Segnalatore</strong><br>
		<input type="text" name="ac_segnalatore" id="ac_segnalatore" size="35">
		<br>
		<br>
		
		<div style="float:center">
		<input type="button" name="saveData" id="saveData" class="btn" value="Salva" onclick="saveAnagrafica()">
		<input type="button" name="closeThis" id="closeThis" onclick="closeForm();" class="btn" value="Chiudi"></div>
		</div>
	</cfform>
</div>
</cfoutput>
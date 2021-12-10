<cfinvoke component="gruppi" method="getGruppiUtenti" returnvariable="rsGruppiUtenti"></cfinvoke>
<cfajaximport>
<cfform id="gruppiFrm">
<div class="winblue" style="height:250px"> 
	<cfinput type="hidden" name="action" id="action" value=0>
	<cfinput type="hidden" name="id_gruppo" id="id_gruppo" value=0>
	
	<strong>Gruppo</strong><br>
	<cfinput type="text" id="ac_gruppo" name="ac_gruppo" required="yes" size="30">
	<br>
	<br>
	
	<strong>Gruppo di riferimento</strong><br>
	<select id="id_gruppo_padre" name="id_gruppo_padre">
		<cfoutput query="rsGruppiUtenti">
			<option value="#id_gruppo#">#ac_gruppo#</option>
		</cfoutput>
	</select>
	<br>
	<br>
	
	<strong>Livello</strong><br>
	<select id="int_livello" name="int_livello">
		<option value="0"> Amministratore</option>
		<option value="1"> Dir. Commerciale</option>
		<option value="2"> Resp. Zona</option>
		<option value="3"> Commerciale</option>
		<option value="4"> Uff. Tecnico</option>
	</select>
	<br>
	<br>
	
	<input type="button" class="btn" value="Salva" onclick="saveGruppo()"><input type="button" class="btn" value="Chiudi" onclick="closeGruppiFrm()">
</div>	
</cfform>

<!--- <cfajaximport> --->
<script src="../include/js/functions.js"></script>
<!--- <script src="clienti.js"></script> --->
<cfparam name="url.idc" default="2904">
<cfparam name="form.provincia" default="">
<cfparam name="form.provincia_id" default=0>
<cfparam name="form.comune" default="">
<cfparam name="form.comune_id" default=0>
<cfif IsDefined("form.saveData")>
	<cfquery name="aggiornaCliente" datasource="#application.dsn#">
		UPDATE tbl_clienti 
			SET
				ac_cognome 		= "#HTMLEditFormat(form.ac_cognome)#",
				ac_nome 		= "#HTMLEditFormat(form.ac_nome)#",
				ac_azienda 		= "#HTMLEditFormat(form.ac_azienda)#",
				ac_indirizzo	= "#HTMLEditFormat(form.ac_indirizzo)#",
				<cfif IsDefined("form.comune") AND form.comune NEQ "">
				ac_citta		= "#HTMLEditFormat(form.comune)#",
				</cfif>
				<cfif IsDefined("form.comune_id") AND form.comune_id NEQ "">
				id_comune		= #form.comune_id#,
				</cfif>
				<cfif IsDefined("form.provincia")>
				ac_pv			= "#form.provincia#",
				</cfif>
				<cfif IsDefined("form.provincia_id") AND form.provincia_id NEQ "">
				id_provincia 	= #form.provincia_id#,
				</cfif>
				ac_cap			= "#form.ac_cap#",
				ac_telefono		= "#form.ac_telefono#",
				ac_cellulare	= "#form.ac_cellulare#",
				ac_email		= "#form.ac_email#",
				<cfif form.id_agente NEQ "0">id_agente		= #form.id_agente#,</cfif>
				ac_segnalatore	= "#form.ac_segnalatore#"
				<cfif form.id_agente NEQ "">
				,bl_attivo		= 1
				</cfif>
				
			WHERE
				id_cliente		= #form.id_cliente#
	</cfquery>
	<cfif (form.id_agente NEQ form.id_agente_old) AND form.id_agente NEQ "0">
		<cfinvoke component="clienti" method="assegnaAgente" returnvariable="msg">
			<cfinvokeargument name="id_cliente" value="#form.id_cliente#">
			<cfinvokeargument name="id_agente" value="#form.id_agente#">
		</cfinvoke>
		<script>
		alert("Agente assegnato");
		</script>
	</cfif>
	<script>
	parent.parent.GB_hide();
	//doGetData();
	</script>
</cfif>
<cfquery name="getCliente" datasource="#application.dsn#">
	SELECT 
		tbl_clienti.* 			,
		tbl_persone.ac_cognome
	 FROM tbl_clienti 
	 LEFT JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
	 WHERE id_cliente = #url.idc#
</cfquery>
<cfinvoke component="clienti" method="getAgenti" returnvariable="agentiQry"></cfinvoke>

<cfoutput query="getCliente">
	<cfset id_cliente 		= id_cliente>
	<cfset ac_cognome 		= ac_cognome>
	<cfset ac_nome 			= ac_nome>
	<cfset ac_azienda 		= ac_azienda>
	<cfset ac_indirizzo 	= ac_indirizzo>
	<cfset ac_citta			= ac_citta>
	<cfset ac_pv			= ac_pv>
	<cfset ac_cap			= ac_cap>
	<cfset ac_telefono		= ac_telefono>
	<cfset ac_cellulare		= ac_cellulare>
	<cfset ac_email			= ac_email>
	<cfset id_agente_old	= id_agente>
	<cfset ac_segnalatore 	= ac_segnalatore>
	
</cfoutput>
<style>
INPUT , SELECT { font-size:12px }
</style>
<body style="margin:0 auto;background:#a6d2ff">

<div id="formEdit" class="winblue" style="height:100%;background:##a6d2ff;"> 
		<form id="clienteFrm" name="clienteFrm" action="#script_name#" method="post">
		<cfoutput query="getCliente">
		<div style="text-align:left;margin:5px;font-size:10px;font-family:verdana">
		<input type="Hidden" name="id_cliente" id="id_cliente" value="#id_cliente#">
		<div style="float:left">
		<strong>COGNOME*</strong><br>
		<input type="Text" name="ac_cognome" id="ac_cognome" value="#ac_cognome#"><br>
		</div>
		<div>
		<strong>NOME*</strong> <br>
		<input type="Text" name="ac_nome" id="ac_nome" value="#ac_nome#"><br>
		</div>
		<div>
		<strong>Azienda</strong><br>
		<input type="text" name="ac_azienda" id="ac_azienda" value="#ac_azienda#">
		<br>
		</div>
		
		<strong>Indirizzo*</strong><br>
		<input type="Text" name="ac_indirizzo" id="ac_indirizzo" size="35" value="#ac_indirizzo#"><br>
		<strong>Comune</strong><br>
		<input type="text" name="ac_citta" id="ac_citta" value="#ac_citta#"> <strong>Prov.</strong><input type="text" name="ac_pv" id="ac_pv" value="#ac_pv#">
		<strong>CAP</strong><input type="text" name="ac_cap" id="ac_cap" value="#getCliente.ac_cap#" size="5"><br><br>
		
		<cfinclude template="province.cfm">
		<br>
		<input type="hidden" name="comune" id="comune" value="#ac_citta#">
		<input type="hidden" name="provincia" id="provincia" value="#form.provincia#">
		<input type="hidden" name="comune_id" id="comune_id" value="#id_comune#">
		<input type="hidden" name="provincia_id" id="provincia_id" value="#id_provincia#">
		<strong>Telefono*</strong><br>
		<input type="Text" name="ac_telefono" id="ac_telefono" value="#ac_telefono#"><br>

		<strong>Cellulare</strong><br>
		<input type="Text" name="ac_cellulare" id="ac_cellulare" value="#ac_cellulare#"><br>

		<strong>Email</strong><br>
		
		<input type="Text" name="ac_email" id="ac_email" size="35" value="#ac_email#"><br>
		
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
		</cfoutput>
		<select id="id_agente" name="id_agente">
			<option value="0">Non Assegnato</option>
			<cfoutput>
			<option value="#StructFind(session.userlogin,'id')#">#StructFind(session.userlogin,"utente")#</option>
			</cfoutput>
			<cfoutput query="agentiQry">
				<cfif agentiQry.id_persona EQ getCliente.id_agente>
					<option value="#id_persona#" selected>#agente#</option>
				<cfelse>
					<option value="#id_persona#">#agente#</option>	
				</cfif>
			</cfoutput>
		</select>
		</div>
		<cfoutput query="getCliente">
		<strong>Segnalatore</strong><br>
		<input type="text" name="ac_segnalatore" id="ac_segnalatore" size="35" value="#ac_segnalatore#">
		<br>
		</cfoutput>
		<div style="float:center">
		<input type="submit" name="saveData" id="saveData" class="btn" value="Salva">
		<!--- <input type="button" name="closeThis" id="closeThis" onclick="closeForm();" class="btn" value="Chiudi"></div> --->
		</div>
	</form>
</div>

</body>

<cfcomponent output="false">


   <cfset THIS.dsn="#application.dsn#">

   <cffunction name="getGruppi" access="remote" returntype="any">
      <!--- Get data --->
      <cfquery name="qry" datasource="#THIS.dsn#">
      SELECT *
      FROM tbl_gruppi
	  ORDER BY id_gruppo_padre , Int_livello
      </cfquery>
	  <cfreturn qry>
   </cffunction>
   	
	<cffunction name="getGruppiAgenti" access="remote" returntype="query">
		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT * FROM tbl_gruppi WHERE int_livello = 3 OR int_livello = 2 ORDER BY ac_gruppo
		</cfquery>
		<cfreturn qry>
	</cffunction>
   
   	<cffunction name="getUtenti" access="remote" returntype="query">
	   	<cfargument name="id_gruppo" required="yes" type="numeric">
		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT * FROM tbl_persone 
		WHERE id_gruppo = #arguments.id_gruppo#
		ORDER BY ac_cognome , ac_nome
		</cfquery>
		<cfreturn qry>
   	</cffunction>
	
	<cffunction name="getUtentiB" access="remote" returntype="query">
	   	<cfargument name="id_gruppo" required="yes" type="numeric">
		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT 
		DISTINCT(tbl_persone.id_persona) AS idp,
		COUNT(tbl_clienti.id_cliente) AS clienti,
		UPPER(tbl_persone.ac_cognome) AS cognome,
		UPPER(tbl_persone.ac_nome) AS nome,
		tbl_persone.*
		FROM tbl_persone 
		LEFT JOIN tbl_clienti ON tbl_persone.id_persona = tbl_clienti.id_agente
		WHERE tbl_persone.id_gruppo = #arguments.id_gruppo#
		GROUP BY idp
		ORDER BY ac_cognome, ac_nome
		</cfquery>
		<cfreturn qry>
   	</cffunction>
   
   <cffunction name="getGruppiUtenti" access="remote" returntype="any">
   		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT * FROM tbl_gruppi WHERE int_Livello < 4
		</cfquery>
		<cfreturn qry>
   </cffunction>

	<!--- SALVA GRUPPO --->
	<cffunction name="saveGruppo" access="remote" returntype="any">
		<cfargument name="action" required="yes" type="numeric">
		<cfargument name="id_gruppo" required="yes" type="numeric">
		<cfargument name="id_gruppo_padre" required="yes" type="numeric">
		<cfargument name="ac_gruppo" required="Yes" type="string">
		<cfargument name="int_livello" required="Yes" type="numeric">

		<cfif arguments.action NEQ -1>
			<cfif arguments.id_gruppo NEQ 0>
				
				<cfquery name="qry" datasource="#THIS.dsn#">
				UPDATE tbl_gruppi
				SET
					id_gruppo_padre = #arguments.id_gruppo_padre#,
					ac_gruppo 		= "#arguments.ac_gruppo#",
					int_livello 	= #arguments.int_livello#
				WHERE
					id_gruppo = #arguments.id_gruppo#
				</cfquery>
				<cfscript>
					LogAction("MOD Gruppo", arguments.ac_gruppo ,StructFind(session.userlogin,"utente"));
				</cfscript> 
				<cfreturn "Gruppo Modificato">
			<cfelse>
				<cfquery name="qry" datasource="#THIS.dsn#">
				INSERT INTO tbl_gruppi
				(
					id_gruppo_padre,
					ac_gruppo,
					int_livello
				)
				VALUES
				(
					#arguments.id_gruppo_padre#,
					"#arguments.ac_gruppo#",
					#arguments.int_livello#
				)
				</cfquery>		
				<cfscript>
					LogAction("ADD Gruppo", arguments.ac_gruppo ,StructFind(session.userlogin,"utente"));
				</cfscript> 
				<cfreturn "Gruppo Inserito">
			</cfif>
		<cfelse>
			<cfquery name="qry" datasource="#THIS.dsn#">
			DELETE FROM tbl_gruppi WHERE id_gruppo = #arguments.id_gruppo#
			</cfquery>	
			<cfreturn "Gruppo Eliminato">
		</cfif>
	</cffunction>   
   
   <!--- SALVA UTENTE --->
	<cffunction name="saveUtente" access="remote" returntype="any">
		<cfargument name="id_persona" required="Yes" type="numeric">
		<cfargument name="id_gruppo" required="Yes" type="any">
		<cfargument name="ac_cognome" required="yes" type="string">
		<cfargument name="ac_nome" required="yes" type="string">
		<cfargument name="ac_azienda" required="yes" type="string">
		<cfargument name="ac_indirizzo" required="yes" type="string">
		<cfargument name="ac_citta" required="yes" type="string">
		<cfargument name="ac_pv" required="yes" type="string">
		<cfargument name="ac_cap" required="yes" type="string">
		<cfargument name="ac_telefono" required="yes" type="string">
		<cfargument name="ac_cellulare" required="yes" type="string">
		<cfargument name="ac_email" required="yes" type="string">
		<cfargument name="ac_utente" required="yes" type="string">
		<cfargument name="ac_password" required="yes" type="string">
		<cfargument name="ac_gruppi" required="yes">
		<cfargument name="ac_sconto_riservato" required="yes">
		
		<cfquery name="checkDuplicatedLogin" datasource="#THIS.dsn#">
		SELECT id_persona FROM tbl_persone WHERE ac_utente = "#arguments.ac_utente#" AND ac_password = "#arguments.ac_password#"
		</cfquery>
		
		<cfif arguments.ac_azienda EQ "">
			<cfset arguments.ac_azienda = "#arguments.ac_cognome# #arguments.ac_nome#">
		</cfif>
		
		
		
			<cfif arguments.id_persona NEQ 0>
			
				<cfif checkDuplicatedLogin.recordcount EQ 0 OR checkDuplicatedLogin.id_persona EQ arguments.id_persona>
				<!--- AGGIORNAMENTO ANAGRAFICA --->
				
				<cfquery name="qry" datasource="#THIS.dsn#">
				UPDATE tbl_persone 
				SET
					id_gruppo		= #arguments.id_gruppo#,
					ac_cognome 		= "#arguments.ac_cognome#",
					ac_nome 		= "#arguments.ac_nome#",
					ac_azienda 		= "#arguments.ac_azienda#",
					ac_indirizzo	= "#arguments.ac_indirizzo#",
					ac_citta		= "#arguments.ac_citta#",
					ac_pv			= "#arguments.ac_pv#",
					ac_cap			= "#arguments.ac_cap#",
					ac_telefono		= "#arguments.ac_telefono#",
					ac_cellulare	= "#arguments.ac_cellulare#",
					ac_email		= "#arguments.ac_email#",
					ac_utente		= "#arguments.ac_utente#",
					ac_password		= "#arguments.ac_password#",
					ac_gruppi		= "#arguments.ac_gruppi#",
					ac_sconto_riservato = "#arguments.ac_sconto_riservato#"
				WHERE
					id_persona		= #arguments.id_persona#
				</cfquery>
				<cfscript>
					LogAction("MOD Anagrafica Utente", arguments.ac_cognome ,StructFind(session.userlogin,"utente"));
				</cfscript> 
				<cfreturn "Utente Modificato">
				<cfelse>
					<cfreturn false>
				</cfif>
			<cfelse>
			
				<cfif checkDuplicatedLogin.recordcount EQ 0>
				<!--- INSERIMENTO ANAGRAFICA DELL'AGENTE--->
				<cfquery name="qry" datasource="#THIS.dsn#">
					INSERT INTO tbl_persone 
					(
						id_gruppo		,
						ac_cognome 		,
						ac_nome 		,
						ac_azienda 		,
						ac_indirizzo	,
						ac_citta		,
						ac_pv			,
						ac_cap			,
						ac_telefono		,
						ac_cellulare	,
						ac_email		,
						ac_utente		,
						ac_password		,
						ac_gruppi		,
						ac_sconto_riservato 
					)
					VALUES
					(
						#arguments.id_gruppo#,
						"#arguments.ac_cognome#",
						"#arguments.ac_nome#",
						"#arguments.ac_azienda#",
						"#arguments.ac_indirizzo#",
						"#arguments.ac_citta#",
						"#arguments.ac_pv#",
						"#arguments.ac_cap#",
						"#arguments.ac_telefono#",
						"#arguments.ac_cellulare#",
						"#arguments.ac_email#",
						"#arguments.ac_utente#",
						"#arguments.ac_password#",
						"#arguments.ac_gruppi#",
						"#arguments.ac_sconto_riservato#"
					)
				</cfquery>
				<cfscript>
					LogAction("ADD Anagrafica Utente", arguments.ac_cognome ,StructFind(session.userlogin,"utente"));
				</cfscript>
				<cfreturn "Inserito Utente">
				<cfelse>
					<cfreturn false>
				</cfif>
			</cfif>
		
	</cffunction>
   
   <cffunction name="enableUtente" access="remote" returntype="any">
   		<cfargument name="id_persona" required="yes" type="numeric">
		<cfargument name="bl_cancellato" required="yes">
		<cfif arguments.bl_cancellato NEQ 3>
			<cfquery name="qry" datasource="#THIS.dsn#">
			UPDATE tbl_persone 
				SET bl_cancellato = <cfif arguments.bl_cancellato EQ "true">1<cfelse>0</cfif>
			WHERE id_persona = #arguments.id_persona#
			</cfquery>
			<cfreturn "OK">
		<cfelse>
			<cfquery name="qry" datasource="#THIS.dsn#">
			DELETE FROM tbl_persone 
			WHERE id_persona = #arguments.id_persona#
			</cfquery>	
			<cfreturn "Deleted">
		</cfif>
   </cffunction>
   
   <cffunction name="LogAction" access="private">
		<cfargument name="action" required="yes">
		<cfargument name="target" required="yes">
		<cfargument name="valore" requider="yes">
		<cflog text="#arguments.action# > #arguments.target# > #arguments.valore#" file="sav_actions" type="Information">
   	</cffunction>
   
	<cffunction name="subgruppi" access="remote" returntype="any">
   	<cfargument name="id_gruppo" required="yes" type="numeric">
      <!--- Get data --->
      <cfquery name="qry" datasource="#THIS.dsn#">
      SELECT 
	  	id_gruppo,
		id_gruppo_padre,
	  	ac_gruppo,
		int_livello
      FROM tbl_gruppi
	  WHERE id_gruppo_padre = #arguments.id_gruppo#
	  ORDER BY Int_livello
      </cfquery>
	  <cfreturn ValueList(qry.ac_gruppo)>
   </cffunction>
</cfcomponent>

<cfcomponent>
	<cfset THIS.dsn = "#application.dsn#">
	
	<!--- dati configurazione --->
	<cffunction name="getConfig" access="remote" returntype="any">
		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT tbl_config.* FROM tbl_config
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	<cffunction name="saveConfig" access="remote" returntype="anye">
		<cfargument name="ac_app_name" required="yes" type="string">
		<!--- <cfargument name="ac_admin_username" required="yes" type="string">
		<cfargument name="ac_admin_password" required="yes" type="string"> --->
		<cfargument name="ac_admin_email" required="yes" type="string">
		<cfargument name="ac_admin_alert_from" required="yes" type="string">
		<cfargument name="ac_admin_alert_email" required="yes" type="string">
		<cfargument name="ac_admin_pin" required="yes" type="string">
		<cfquery name="qry" datasource="#THIS.dsn#">
		UPDATE tbl_config
		SET
			ac_app_name 		= "#arguments.ac_app_name#",
			<!--- ac_admin_username 	= "#arguments.ac_admin_username#",
			ac_admin_password 	= "#arguments.ac_admin_password#", --->
			ac_admin_email 		= "#arguments.ac_admin_email#",
			ac_admin_alert_from = "#arguments.ac_admin_alert_from#",
			ac_admin_alert_email= "#arguments.ac_admin_alert_email#",
			ac_admin_pin 		= "#arguments.ac_admin_pin#"
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<!--- SALVA PROFILO UTENTE --->
	<cffunction name="saveProfilo" access="remote" returntype="string">
		<cfargument name="ac_nome" required="yes" type="string">
		<cfargument name="ac_cognome" required="yes" type="string">
		<cfargument name="ac_password" required="yes" type="string">
		<cfargument name="ac_utente" required="yes" type="string">
		<cfargument name="ac_indirizzo" required="yes" type="string">
		<cfargument name="ac_citta" required="yes" type="string">
		<cfargument name="ac_cap" required="yes" type="string">
		<cfargument name="ac_pv" required="yes" type="string">
		
		<cfquery name="checklogin" datasource="#THIS.dsn#">
		SELECT * FROM tbl_persone 
		WHERE 
			ac_utente = "#arguments.ac_utente#" 
			AND
			ac_password = "#arguments.ac_password#"
		</cfquery>
		<cfif checklogin.recordcount EQ 0>
			<cfquery name="qry" datasource="#THIS.dsn#">
				UPDATE tbl_persone
				SET
					ac_nome 		= "#arguments.ac_nome#",
					ac_cognome		= "#arguments.ac_cognome#",
					ac_password		= "#arguments.ac_password#",
					ac_utente		= "#arguments.ac_utente#",
					ac_indirizzo 	= "#arguments.ac_indirizzo#",
					ac_citta		= "#arguments.ac_citta#",
					ac_cap			= "#arguments.ac_cap#",
					ac_pv			= "#arguments.ac_pv#"
				WHERE
					id_persona		= #StructFind(session.userlogin,"id")#	
			</cfquery>
			<cfreturn "Profilo Aggiornato">
		<cfelse>
			<cfreturn "Il nome utente è già utilizzato dal sistema">
		</cfif>
	</cffunction>
	
	<!--- RECUPERA PROCESSI --->
	<cffunction name="getProcessi" access="remote" returntype="query">
		<cfquery name="qry" datasource="#THIS.dsn#">
		Select * FROM tbl_processi
		ORDER BY int_ordine
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	<!--- SALVA COLONNA TABELLA PROCESSI --->
	<cffunction name="saveProcessCol" access="remote" returntype="any">
		<cfargument name="id_processo" required="yes" type="numeric">
		<cfargument name="tbl_field" required="yes" type="string">
		<cfargument name="field_value" required="yes" type="any">
		<cfargument name="field_type" required="yes" type="string">
		
		<cfif arguments.id_processo NEQ 0>
			<cfif arguments.tbl_field EQ "int_status">
				<cfquery name="resetStatus" datasource="#THIS.dsn#">
				UPDATE tbl_processi SET int_status = 0
				</cfquery>
			</cfif>
			<cfquery name="qry" datasource="#THIS.dsn#">
			UPDATE tbl_processi
			SET #arguments.tbl_field# = 
				<cfif arguments.field_type EQ "str">
					"#arguments.field_value#"
				<cfelse>
					#arguments.field_value#	
				</cfif>
			WHERE 
				id_processo = #arguments.id_processo#	
			</cfquery>
		<cfelse>
			<cfquery name="qry" datasource="#THIS.dsn#">
			INSERT INTO tbl_processi
			(
				#arguments.tbl_field#
			)
			VALUES
			(
				<cfif arguments.field_type EQ "str">
					"#arguments.field_value#"
				<cfelse>
					#arguments.field_value#
				</cfif>
			)
			</cfquery>	
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<!--- SALVA PERMISSION PROCESSI --->
	<cffunction name="savePermissions" access="remote" returntype="any">
		<cfargument name="id_processo" required="yes" type="any">
		<cfargument name="ac_permissions" required="yes" type="any">
	 	<cfquery name="qry" datasource="#THIS.dsn#">
			UPDATE tbl_processi
			SET
				ac_permissions = "#arguments.ac_permissions#"
			WHERE 
				id_processo = #arguments.id_processo#
		</cfquery> 
		<cfreturn arguments.ac_permissions>
	</cffunction>
	
	<!--- IMPOSTA ORDINE PROCESSO --->
	<cffunction name="saveOrdine" access="remote" returntype="any">
		<cfargument name="id_processo_ordine" required="Yes">
		<cfargument name="int_ordine" required="Yes">
		<cfquery name="qry1" datasource="#THIS.dsn#">
		UPDATE tbl_processi SET int_ordine = #arguments.int_ordine# WHERE int_ordine = #arguments.int_ordine-1#
		</cfquery>
		<cfquery name="qry2" datasource="#THIS.dsn#">
		UPDATE tbl_processi SET int_ordine = #arguments.int_ordine-1# WHERE id_processo = #arguments.id_processo_ordine#
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<!--- RECUPERA TABELLA QUALIFICA CLIENTI --->
	<cffunction name="getQualificaClienti" access="remote" returntype="query">
		<cfquery name="qry" datasource="#THIS.dsn#">
		Select * FROM tbl_gruppi_clienti
		</cfquery>
		<cfreturn qry>
	</cffunction>		

	
	<!--- SALVA COLONNA TABELLA GRUPPI CLIENTI --->
	<cffunction name="saveGruppiClientiCol" access="remote" returntype="any">
		<cfargument name="id_gruppo" required="yes" type="numeric">
		<cfargument name="tbl_field" required="yes" type="string">
		<cfargument name="field_value" required="yes" type="any">
		<cfargument name="field_type" required="yes" type="string">
		
		<cfif arguments.id_gruppo NEQ 0>
			<cfquery name="qry" datasource="#THIS.dsn#">
			UPDATE tbl_gruppi_clienti
			SET #arguments.tbl_field# = 
				<cfif arguments.field_type EQ "str">
					"#arguments.field_value#"
				<cfelse>
					#arguments.field_value#	
				</cfif>
			WHERE 
				id_gruppo = #arguments.id_gruppo#	
			</cfquery>
		<cfelse>
			<cfquery name="qry" datasource="#THIS.dsn#">
			INSERT INTO tbl_gruppi_clienti
			(
				#arguments.tbl_field#
			)
			VALUES
			(
				<cfif arguments.field_type EQ "str">
					"#arguments.field_value#"
				<cfelse>
					#arguments.field_value#
				</cfif>
			)
			</cfquery>	
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="deleteGruppoCliente" access="remote" returntype="any">
		<cfargument name="id_gruppo_delete" required="yes" type="numeric">
		<cfquery name="checkIfUsed" datasource="#THIS.dsn#">
			SELECT * FROM tbl_clienti WHERE id_qualifica = #arguments.id_gruppo_delete#
		</cfquery>
		<cfif checkIfUsed.recordcount EQ 0>
			<cfquery name="qry" datasource="#THIS.dsn#">
			DELETE FROM tbl_gruppi_clienti WHERE id_gruppo = #arguments.id_gruppo_delete#
			</cfquery>
			<cfreturn true>
		<cfelse>
			<cfreturn false>	
		</cfif>
	</cffunction>
	
	
	
	<!--- lista dei moduli associata ai processi ---->
	<cffunction name="getModuli" access="remote" returntype="any">
		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT ac_modulo FROM tbl_moduli 
		</cfquery>
		<cfreturn ValueList(qry.ac_modulo)>
	</cffunction>
	
</cfcomponent>
<cfcomponent>
	<cfset THIS.dsn = "crm">
	
	<cffunction name="provincia" access="remote" returntype="string">
		<cfargument name="ac_pv" required="yes" type="string">
		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT * FROM tbl_province WHERE UPPER(ac_provincia) = "#UCASE(arguments.ac_pv)#" 
		</cfquery>
		<cfreturn qry.ac_sigla>
	</cffunction>
	
	<cffunction name="importAnagrafica" access="remote" returntype="any">
		<cfargument name="id_cliente" required="Yes" type="numeric">
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
		<cfargument name="id_agente" required="yes" type="numeric">
		<cfargument name="ac_info" required="yes" type="string">
		<cfargument name="id_fornitore" required="yes" type="numeric">
		
		<cfquery name="qry" datasource="#THIS.dsn#">
		INSERT INTO tbl_clienti 
				(
					ac_cognome 		,
					ac_azienda 		,
					ac_indirizzo	,
					ac_citta		,
					ac_pv			,
					ac_cap			,
					ac_telefono		,
					ac_cellulare	,
					ac_email		,
					ac_info			,
					id_agente		,
					id_fornitore	
				)
				VALUES
				(
					"#arguments.ac_azienda#",
					"#arguments.ac_azienda#",
					"#arguments.ac_indirizzo#",
					"#arguments.ac_citta#",
					"#arguments.ac_pv#",
					"#arguments.ac_cap#",
					"#arguments.ac_telefono#",
					"#arguments.ac_cellulare#",
					"#arguments.ac_email#",
					"#arguments.ac_info#",
					0,
					#arguments.id_fornitore#
				)
		</cfquery>
		<cfreturn "Anagrafica aggiunta">
	</cffunction>
</cfcomponent>
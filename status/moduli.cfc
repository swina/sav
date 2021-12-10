<cfcomponent>
	<cfset THIS.dsn = "#application.dsn#">
	
	<!--- aggiunge un processo direttamente da un modulo --->
	<cffunction name="addProcessoFromModulo" access="remote" returntype="any">
		<cfargument name="id_cliente" required="yes" type="numeric">
		<cfargument name="id_processo" required="yes" type="numeric">
		<cfargument name="dt_status" required="yes" type="string">
		<cfargument name="processo_modulo_uuid" required="yes" type="string">

		<cfset data_status = CreateDateTime(ListGetAt(arguments.dt_status,3,"/"),ListGetAt(arguments.dt_status,2,"/"),ListGetAt(arguments.dt_status,1,"/"),9,0,0)>

		<cfset data_presentazione = "">
		<cfif arguments.id_processo EQ 6>
			<cfquery name="check" datasource="#THIS.dsn#">
			SELECT id_status, dt_status FROM tbl_status 
			WHERE 
				id_cliente = #arguments.id_cliente#
				AND
				id_processo = 4
			ORDER BY dt_status DESC	
			</cfquery>
			<cfset data_presentazione = CreateDateTime(year(check.dt_status),month(check.dt_status),day(check.dt_status),hour(check.dt_status),minute(check.dt_status),0)>
		</cfif>
		<cfquery name="qry" datasource="#THIS.dsn#">
			INSERT INTO tbl_status
			(
				id_cliente		,
				id_processo		,
				dt_status		,
				<cfif data_presentazione NEQ "">
				dt_next_status 	,
				</cfif>
				ac_note			,
				ac_modulo_uuid
			)
			VALUES
			(
				#arguments.id_cliente#		,
				#arguments.id_processo#		,
				#data_status#				,
				<cfif data_presentazione NEQ "">
				#data_presentazione#		,
				</cfif>
				""		,
				"#arguments.processo_modulo_uuid#"
			)
		</cfquery>
		<cfreturn arguments.processo_modulo_uuid>		

	</cffunction>
	
	<cffunction name="saveModulo" access="remote" returntype="any">
		<cfargument name="id_modulo" required="yes" type="numeric">
		<cfargument name="valori" required="yes" type="string">
		<cfargument name="modulo_uuid" required="yes" type="string">
		<cfquery name="qry" datasource="#THIS.dsn#">
			INSERT INTO tbl_moduli_data
			(
				ac_modulo_UUID	,
				id_modulo		,
				id_utente		,
				dt_registrazione,
				dt_modifica		,
				ac_dati
			)
			VALUES
			(
				"#arguments.modulo_uuid#",
				#arguments.id_modulo#,
				#StructFind(session.userlogin,"id")#,
				#now()#,
				#now()#,
				"#arguments.valori#"
			)
		</cfquery> 
		<!--- <cfscript>
			LogAction("ADD Modulo #arguments.id_modulo#" , arguments.id_status , #StructFind(session.userlogin,"ID")#);
		</cfscript> --->
		<cfreturn arguments.modulo_uuid>		
	</cffunction>
	
	<cffunction name="getModulo" access="remote" returntype="query">
		<cfargument name="modulo_uuid" required="yes" type="string">
		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT 
			tbl_moduli_data.* ,
			tbl_moduli_fields.ac_field,
			tbl_moduli_fields.ac_label,
			tbl_moduli_fields.ac_sezione,
			tbl_moduli.ac_modulo
		FROM tbl_moduli_data
		INNER JOIN tbl_moduli_fields ON tbl_moduli_data.id_modulo = tbl_moduli_fields.id_modulo
		INNER JOIN tbl_moduli ON tbl_moduli_fields.id_modulo = tbl_moduli.id_modulo
		WHERE
			tbl_moduli_data.ac_modulo_uuid = "#arguments.modulo_uuid#"	
		ORDER BY int_ordine, ac_sezione
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	
	<cffunction name="getModuloPrint" access="remote" returntype="query">
		<cfargument name="modulo_uuid" required="yes" type="string">
		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT 
			tbl_moduli_data.* ,
			tbl_moduli_fields.id_field,
			tbl_moduli_fields.ac_field,
			tbl_moduli_fields.ac_label,
			tbl_moduli_fields.ac_sezione,
			tbl_moduli_fields.int_ordine,
			tbl_moduli.ac_modulo,
			tbl_status.id_status,
			tbl_processi.id_processo,
			CONCAT ( tbl_clienti.ac_cognome , " " , tbl_clienti.ac_nome , "<br>" , tbl_clienti.ac_azienda) AS cliente 
		FROM tbl_moduli_data
		INNER JOIN tbl_moduli_fields ON tbl_moduli_data.id_modulo = tbl_moduli_fields.id_modulo
		INNER JOIN tbl_moduli ON tbl_moduli_fields.id_modulo = tbl_moduli.id_modulo
		INNER JOIN tbl_status ON tbl_moduli_data.ac_modulo_uuid = tbl_status.ac_modulo_uuid
		INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
		INNER JOIN tbl_processi ON tbl_status.id_processo = tbl_processi.id_processo
		WHERE
			tbl_moduli_data.ac_modulo_uuid = "#arguments.modulo_uuid#"	
		ORDER BY tbl_moduli_fields.int_ordine, ac_sezione , ac_label
		</cfquery>
		<cfreturn qry>
	</cffunction>
	<!--- Crea log delle operazioni principali effettuate --->
	<cffunction name="LogAction" access="private">
		<cfargument name="action" required="yes">
		<cfargument name="target" required="yes">
		<cfargument name="valore" requider="yes">
		<cflog text="#arguments.action# > #arguments.target# > #arguments.valore#" file="sav_actions" type="Information">
   	</cffunction>
</cfcomponent>
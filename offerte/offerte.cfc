<cfcomponent>
	<cfset THIS.dsn = "#application.dsn#">
	
	<cffunction name="plan" access="remote" returntype="query">
		<cfargument name="dateFrom" required="no" default="#now()#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="ac_cliente" required="no" default="">
		<cfargument name="id_agente" required="no" default="">
		<cfargument name="id_gruppo_agenti" required="no" default="">
		<cfargument name="id_processo" required="no" default="">
		<cfargument name="id_persona" required="no" default="">
		<cfargument name="noOfferte" required="no" default=true>
		
		<cfif ListLen(arguments.dateFrom,"/") GT 0>
			<cfscript>
				dFrom 	= stringToDate(arguments.dateFrom);
				dTo		= stringToDate(arguments.dateTo);
			</cfscript>
		<cfelse>
			<cfscript>
				dFrom	= arguments.dateFrom;
				dTo		= arguments.dateTo;
			</cfscript>	
		</cfif>
		
		<cfquery name="qry" datasource="#application.dsn#">
		SELECT * FROM
		(Select 
			tbl_status.id_status,
			dt_status,
			DATE_FORMAT(tbl_status.dt_status,'%d/%m/%Y') AS data_status,
			DATE_FORMAT(tbl_status.dt_status,'%H:%i') AS ora_status,
			DATE_FORMAT(tbl_status.dt_next_status,'%d/%m/%Y') AS data_next_status,
			DATE_FORMAT(tbl_status.dt_next_status,'%H:%i') AS ora_next_status,
			tbl_status.ac_note,
			tbl_status.ac_docs,
			tbl_status.bl_evasa,
			tbl_status.ac_modulo_uuid,
			tbl_status.id_persona,
			tbl_status.ac_valore,
			tbl_clienti.id_cliente,
			tbl_clienti.id_agente,
			tbl_clienti.ac_cognome,
			tbl_clienti.ac_nome,
			tbl_clienti.ac_azienda,
			tbl_clienti.ac_citta,
			tbl_clienti.ac_indirizzo,
			tbl_clienti.ac_telefono,
			tbl_clienti.ac_cellulare,
			tbl_clienti.ac_email,
			tbl_gruppi_clienti.id_gruppo AS id_qualifica,
			tbl_gruppi_clienti.ac_icona,
			tbl_gruppi_clienti.ac_gruppo AS qualifica,
			tbl_processi.id_processo,
			tbl_processi.ac_processo,
			tbl_processi.ac_sigla,
			tbl_processi.ac_colore,
			tbl_processi.ac_permissions,
			tbl_processi.ac_modulo,
			tbl_processi.bl_documento,
			tbl_processi.bl_assegnazione,
			tbl_processi.int_ordine,
			tbl_persone.ac_cognome AS agente,
			tbl_gruppi.id_gruppo AS gruppo,
			tbl_gruppi.ac_gruppo AS nome_gruppo,
			persone.ac_cognome AS assegnato
			From
			tbl_status
			Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
			Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			LEFT JOIN tbl_gruppi_clienti ON tbl_clienti.id_qualifica = tbl_gruppi_clienti.id_gruppo
			INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
			LEFT JOIN tbl_persone AS persone ON tbl_status.id_persona = persone.id_persona
			WHERE ( tbl_status.dt_next_status >= #dFrom# AND tbl_status.dt_next_status <= #dTo# )
				
				<cfif session.livello LT 2>
					<cfif arguments.id_gruppo_agenti NEQ "">
						AND tbl_persone.id_gruppo = #arguments.id_gruppo_agenti#
					</cfif>
					<cfif arguments.id_agente NEQ "">
						AND tbl_persone.id_persona = #arguments.id_agente#
					</cfif>
					<cfif arguments.id_processo NEQ "">
						
						<cfif arguments.noOfferte>
						AND  tbl_status.id_processo = #arguments.id_processo# 
						<cfelse>
						AND tbl_status.id_processo = #arguments.id_processo#
						</cfif>
					</cfif>
				<cfelse>
					<cfif session.livello LT 4>
						AND tbl_persone.id_persona = #StructFind(session.userlogin,"id")#	
					</cfif>
				</cfif>	
				
				<cfif session.livello EQ 4>
					AND tbl_status.id_persona = #StructFind(session.userlogin,"id")#
				</cfif>
				
				<cfif arguments.ac_cliente NEQ "">
					AND 
					(
						tbl_clienti.ac_cognome LIKE "%#arguments.ac_cliente#%" 
						OR
						tbl_clienti.ac_nome LIKE "%#arguments.ac_cliente#%"
						OR 
						tbl_clienti.ac_azienda LIKE "%#arguments.ac_cliente#%"
					)
				</cfif>
				<cfif arguments.id_persona NEQ "">
					AND tbl_status.id_persona = #arguments.id_persona#
				</cfif>
				
			ORDER BY  tbl_processi.int_ordine, dt_next_status ASC ,tbl_clienti.ac_cognome,   tbl_clienti.id_cliente ,   tbl_status.id_status DESC ) AS result
			<cfif arguments.noOfferte>
			WHERE result.bl_evasa = 0 AND ( result.id_processo = 6 OR result.id_processo = 14 )
			</cfif>
			</cfquery>
		
		<cfreturn qry>
	</cffunction>

	<cffunction name="offertaModulo" access="remote" returntype="any">
		<cfargument name="ac_modulo_uuid" required="yes">
		<cfquery name="getModulo" datasource="#application.dsn#">
		SELECT * FROM tbl_moduli_data
		WHERE
			ac_modulo_uuid = "#arguments.ac_modulo_uuid#"
		</cfquery>
		<cfreturn getModulo.ac_dati>
	</cffunction>
	
	
	<cffunction name="getModulo" access="remote" returntype="query">
		<cfargument name="modulo_uuid" required="yes" type="string">
		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT 
			tbl_moduli_data.* ,
			tbl_moduli_data.ac_dati AS valori,
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
	
	<cffunction name="ut" access="remote" returntype="query">
		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT 
			tbl_persone.*,
			tbl_gruppi.int_livello
			FROM tbl_persone
		INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
		WHERE tbl_gruppi.int_livello = 4
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	<cffunction name="assegnaPersona" access="remote" returntype="any">
		<cfargument name="id_status_assegna" required="yes">
		<cfargument name="id_persona_assegna" required="yes">
		
		<cfif IsNumeric(arguments.id_persona_assegna)>
		<cfquery name="qry" datasource="#THIS.dsn#">
		UPDATE tbl_status
			SET id_persona = #arguments.id_persona_assegna#
		WHERE 
			id_status = #arguments.id_status_assegna#
		</cfquery>
		<cfif id_persona_assegna NEQ 0>
			<cfquery name="getAssegnato" datasource="#THIS.dsn#">
				SELECT ac_cognome FROM tbl_persone WHERE id_persona = #arguments.id_persona_assegna#
			</cfquery>
			<cfreturn UCASE(getAssegnato.ac_cognome)>	
		<cfelse>
			<cfreturn "NON ASSEGNATO">
		</cfif>
		<cfelse>
			<cfreturn arguments.id_persona_assegna>
		</cfif>
		
	</cffunction>
	
	<cffunction name="offertaPresentazione" access="remote" returntype="any">
		<cfargument name="id_cliente" required="yes">
		<cfquery name="getPresentazione" datasource="#THIS.dsn#">
		SELECT * FROM tbl_status WHERE id_cliente = #arguments.id_cliente# AND id_processo = 4
		</cfquery>
		<cfreturn DateFormat(getPresentazione.dt_status,"dd.mm.yyyy")>
	</cffunction>
	
	
	<cffunction name="getGruppiAgenti" access="remote" returntype="query" hint="Restituisce i gruppi Agenti/Commerciali">
		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT * FROM tbl_gruppi 
		WHERE 
			<cfif session.livello LT 2>
				int_livello = 3
			<cfelse>
				<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
					id_gruppo IN  ( #StructFind(session.userlogin,"gruppi_controllo")# )
				<cfelse>
					id_gruppo = #StructFind(session.userlogin,"id_gruppo")#					
				</cfif>		
			</cfif>
		 ORDER BY ac_gruppo
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	<cffunction name="getAgenti" access="remote" returntype="query">
		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT id_persona,ac_cognome,ac_nome
		FROM tbl_persone
		WHERE 
			<cfif session.livello LT 2>
				id_gruppo <> 0
			<cfelse>
				<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
					id_gruppo IN ( #StructFind(session.userlogin,"gruppi_controllo")# )	
				<cfelse>
					id_gruppo = #StructFind(session.userlogin,"id_gruppo")#				
				</cfif>
			</cfif>
			
		ORDER BY ac_cognome, ac_nome
		</cfquery>
		
		<cfreturn qry>
		
	</cffunction>
	
	<cffunction name="getUT" access="remote" returntype="query">
		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT 
			id_persona,ac_cognome,ac_nome
		FROM tbl_persone
		INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
		WHERE 
			int_livello = 4
		ORDER BY ac_cognome, ac_nome
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	<!--- sposta i documenti caricati nella cartella del cliente --->
	<cffunction name="moveDocs" access="remote" returntype="any">
		<cfargument name="id_cliente" required="yes" type="any">
		<cfargument name="id_status" required="yes" type="any">
		<cfargument name="id_agente" required="yes" type="any">
		<cfargument name="lista_docs" required="yes" type="any">
		<cfargument name="ac_modulo_uuid" required="yes" type="any">
		<cfargument name="add_status" required="yes" type="any">
		<cfargument name="ac_valore" required="yes" type="any">
		
		<cfparam name = "THIS.docs_folder" default = "#expandpath('..')#\docs\status">
		<cfif DirectoryExists("#THIS.docs_folder#\#arguments.id_cliente#") IS FALSE>
			<cfdirectory action="CREATE" directory="#THIS.docs_folder#\#arguments.id_cliente#">
		</cfif>
		
		<cfloop index="i" list="#arguments.lista_docs#">
			<cffile action="MOVE" source="#THIS.docs_folder#\#i#" destination="#THIS.docs_folder#\#arguments.id_cliente#\">
		</cfloop>
		
		<!--- <cfquery name="getDocs" datasource="#THIS.dsn#">
		SELECT ac_docs FROM tbl_status WHERE id_status = #arguments.id_status#
		</cfquery>

		<cfset myDocs = "#getDocs.ac_docs##arguments.lista_docs#">
		<cfquery name="qry" datasource="#THIS.dsn#">
			UPDATE tbl_status
			SET ac_docs = '#myDocs#'
			WHERE id_status = #arguments.id_status#
		</cfquery> 
		<cfset myLog = "ADD Allegati #arguments.lista_docs#">
		<cfscript>
			LogAction(myLog,arguments.id_status,StructFind(session.userlogin,"utente"));
		</cfscript>
		--->
		<cfquery name="checkOfferta" datasource="#THIS.dsn#">
		SELECT * FROM tbl_status WHERE ac_modulo_uuid = "#arguments.ac_modulo_uuid#" AND id_processo = 9
		</cfquery>
		<cfif checkOfferta.recordcount EQ 0>
			<cfquery name="addStatusOfferta" datasource="#THIS.dsn#">
			INSERT INTO tbl_status
			(
				id_cliente		,
				id_processo		,
				id_persona		,
				dt_status		,
				ac_docs			,
				ac_modulo_uuid  ,
				ac_valore
			)
			VALUES
			(
				#arguments.id_cliente#,
				9,
				#StructFind(session.userlogin,"id")#,
				#now()#,
				'#arguments.lista_docs#',
				"#arguments.ac_modulo_uuid#" ,
				"#arguments.ac_valore#"
			)
			</cfquery>
		
		<cfelse>
			<cfquery name="updateStatusOfferta" datasource="#THIS.dsn#">
			UPDATE tbl_status
			SET
				dt_status 	= #now()#,
				ac_docs		= "#arguments.lista_docs#",
				ac_valore 	= "#arguments.ac_valore#"
			WHERE
				id_status = #checkOfferta.id_status#
			</cfquery>
		</cfif>
		<cfquery name="updateRichieste" datasource="#THIS.dsn#">
			UPDATE tbl_status
			SET bl_evasa = 1 WHERE id_processo = 6 AND id_cliente = #arguments.id_cliente#
		</cfquery>
		
		<cfreturn arguments.id_cliente>
	</cffunction>
	
	<cffunction name="getNote" access="remote" returntype="any">
		<cfargument name="id_cliente" required="Yes">
		<cfquery name="qryNote" datasource="#THIS.dsn#">
		SELECT * FROM tbl_status WHERE id_cliente = #arguments.id_cliente#
		</cfquery>
		<cfreturn qryNote>
	</cffunction>
	
		<cffunction name="getOfferte" access="remote" returntype="query">
		<cfargument name="dateFrom" required="no" default="#now()#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="ac_cliente" required="no" default="">
		<cfargument name="id_agente" required="no" default="">
		<cfargument name="id_gruppo_agenti" required="no" default="">
		<cfargument name="id_processo" required="no" default="">
		<cfargument name="id_persona" required="no" default="">
		<cfargument name="noOfferte" required="no" default=true>
		
		<cfif ListLen(arguments.dateFrom,"/") GT 0>
			<cfscript>
				dFrom 	= stringToDate(arguments.dateFrom);
				dTo		= stringToDate(arguments.dateTo);
			</cfscript>
		<cfelse>
			<cfscript>
				dFrom	= arguments.dateFrom;
				dTo		= arguments.dateTo;
			</cfscript>	
		</cfif>
		
		<cfquery name="qry" datasource="#application.dsn#">
		SELECT * FROM
		(Select 
			tbl_status.id_status,
			dt_status,
			DATE_FORMAT(tbl_status.dt_status,'%d/%m/%Y') AS data_status,
			DATE_FORMAT(tbl_status.dt_status,'%H:%i') AS ora_status,
			tbl_status.ac_note,
			tbl_status.ac_docs,
			tbl_status.bl_evasa,
			tbl_status.ac_modulo_uuid,
			tbl_status.id_persona,
			tbl_status.ac_valore,
			tbl_clienti.id_cliente,
			tbl_clienti.id_agente,
			tbl_clienti.ac_cognome,
			tbl_clienti.ac_nome,
			tbl_clienti.ac_azienda,
			tbl_clienti.ac_citta,
			tbl_clienti.ac_indirizzo,
			tbl_clienti.ac_telefono,
			tbl_clienti.ac_cellulare,
			tbl_clienti.ac_email,
			tbl_gruppi_clienti.id_gruppo AS id_qualifica,
			tbl_gruppi_clienti.ac_icona,
			tbl_gruppi_clienti.ac_gruppo AS qualifica,
			tbl_processi.id_processo,
			tbl_processi.ac_processo,
			tbl_processi.ac_sigla,
			tbl_processi.ac_colore,
			tbl_processi.ac_permissions,
			tbl_processi.ac_modulo,
			tbl_processi.bl_documento,
			tbl_processi.bl_assegnazione,
			tbl_processi.int_ordine,
			tbl_persone.ac_cognome AS agente,
			tbl_gruppi.id_gruppo AS gruppo,
			tbl_gruppi.ac_gruppo AS nome_gruppo,
			persone.ac_cognome AS assegnato
			From
			tbl_status
			Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
			Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			LEFT JOIN tbl_gruppi_clienti ON tbl_clienti.id_qualifica = tbl_gruppi_clienti.id_gruppo
			INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
			LEFT JOIN tbl_persone AS persone ON tbl_status.id_persona = persone.id_persona
			WHERE ( tbl_status.dt_status >= #dFrom# AND tbl_status.dt_status <= #dTo# )
				
				<cfif session.livello LT 2>
					<cfif arguments.id_gruppo_agenti NEQ "">
						AND tbl_persone.id_gruppo = #arguments.id_gruppo_agenti#
					</cfif>
					<cfif arguments.id_agente NEQ "">
						AND tbl_persone.id_persona = #arguments.id_agente#
					</cfif>
					<cfif arguments.id_processo NEQ "">
						
						<cfif arguments.noOfferte>
						AND  tbl_status.id_processo = #arguments.id_processo# 
						<cfelse>
						AND tbl_status.id_processo = #arguments.id_processo#
						</cfif>
					</cfif>
				<cfelse>
					<cfif session.livello LT 4>
						AND tbl_persone.id_persona = #StructFind(session.userlogin,"id")#	
					</cfif>
				</cfif>	
				
				<cfif session.livello EQ 4>
					AND tbl_status.id_persona = #StructFind(session.userlogin,"id")#
				</cfif>
				
				<cfif arguments.ac_cliente NEQ "">
					AND 
					(
						tbl_clienti.ac_cognome LIKE "%#arguments.ac_cliente#%" 
						OR
						tbl_clienti.ac_nome LIKE "%#arguments.ac_cliente#%"
						OR 
						tbl_clienti.ac_azienda LIKE "%#arguments.ac_cliente#%"
					)
				</cfif>
				<cfif arguments.id_persona NEQ "">
					AND tbl_status.id_persona = #arguments.id_persona#
				</cfif>
				
			ORDER BY  tbl_processi.int_ordine, dt_status ASC ,tbl_clienti.ac_cognome,   tbl_clienti.id_cliente ,   tbl_status.id_status DESC ) AS result
			<cfif arguments.noOfferte>
			WHERE result.bl_evasa = 0 AND ( result.id_processo = 6 OR result.id_processo = 4 )
			</cfif>
			</cfquery>
		
		<cfreturn qry>
	</cffunction>
	
	
	<cffunction name="stringToDate" access="private" returntype="date">
		<cfargument name="data" required="yes" type="string">
		<cfset myData = CreateDate(ListGetAt(arguments.data,3,"/"),ListGetAt(arguments.data,2,"/"),ListGetAt(arguments.data,1,"/"))>
		<cfreturn myData>
	</cffunction>
	
</cfcomponent>
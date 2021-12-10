<cfcomponent>
	<cfset THIS.dsn = "#application.dsn#">
	
	<cffunction name="plan" access="remote" returntype="query">
		<cfargument name="dateFrom" required="no" default="#DateFormat(DateAdd('d',-7,now()),'dd/mm/yyyy')#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="id_agente" required="no" default="">
		<cfargument name="id_gruppo_agenti" required="no" default="">
		<cfargument name="id_processo" required="no" default="">
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
			Select 
			tbl_status.id_status,
			dt_status,
			DATE_FORMAT(tbl_status.dt_status,'%d/%m/%Y') AS data_status,
			DATE_FORMAT(tbl_status.dt_status,'%H:%i') AS ora_status,
			tbl_status.ac_note,
			tbl_status.ac_docs,
			tbl_status.ac_modulo_uuid,
			tbl_status.id_persona,
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
			tbl_clienti.ac_segnalatore,
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
			tbl_gruppi.ac_gruppo AS nome_gruppo
			From
			tbl_status
			Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
			Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			LEFT JOIN tbl_gruppi_clienti ON tbl_clienti.id_qualifica = tbl_gruppi_clienti.id_gruppo
			INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
			WHERE ( tbl_status.dt_status >= #dFrom# AND tbl_status.dt_status <= #dTo# )
				
				<cfif session.livello LT 2>
					<cfif arguments.id_gruppo_agenti NEQ "">
						AND tbl_gruppi.id_gruppo = #arguments.id_gruppo_agenti#
					</cfif>
					<cfif arguments.id_agente NEQ "">
						AND tbl_persone.id_persona = #arguments.id_agente#
					</cfif>
					<cfif arguments.id_processo NEQ "">
						AND tbl_status.id_processo = #arguments.id_processo#
					</cfif>
				<cfelse>
					<cfif arguments.id_gruppo_agenti EQ "" AND arguments.id_agente EQ "" AND arguments.id_processo EQ "">
						AND ( tbl_persone.id_persona = #StructFind(session.userlogin,"id")#	
						<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
					OR tbl_gruppi.id_gruppo IN (#StructFind(session.userlogin,"gruppi_controllo")#)
						</cfif>
						)
					<cfelse>
						<cfif arguments.id_gruppo_agenti NEQ "">
							AND tbl_gruppi.id_gruppo = #arguments.id_gruppo_agenti#
						</cfif>
						<cfif arguments.id_agente NEQ "">
							AND tbl_persone.id_persona = #arguments.id_agente#
						</cfif>
						<cfif arguments.id_processo NEQ "">
							AND tbl_status.id_processo = #arguments.id_processo#
						</cfif>
					</cfif>
				</cfif>
				<!---
				<cfif session.livello LT 3 AND session.livello GT 1>
				
					<cfif arguments.id_gruppo_agenti NEQ "">
						AND ( 
							tbl_persone.id_gruppo = #arguments.id_gruppo_agenti# 
	
							<cfif session.livello GT 2>
								OR tbl_persone.id_persona = #StructFind(session.userlogin,"id")#
							</cfif>
							)
					<cfelse>
						<cfif session.livello GT 1>
						AND (
							<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
								tbl_persone.id_persona = #StructFind(session.userlogin,"id")#
								
								<cfloop index="i" list="#StructFind(session.userlogin,'gruppi_controllo')#">
								OR tbl_persone.id_gruppo = #i#
								</cfloop>
							<cfelse>
								tbl_persone.id_persona = #StructFind(session.userlogin,"id")#
							</cfif>
							)
						<!--- <cfelse>
							<cfif session.livello NEQ 1>
								AND
								tbl_persone.id_persona = #StructFind(session.userlogin,"id")#	
							</cfif> --->
						</cfif>	
						
					</cfif>
				<cfelse>
					
					<cfif arguments.id_gruppo_agenti EQ "">
						<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
							AND (tbl_persone.id_gruppo IN ( #StructFind(session.userlogin,"gruppi_controllo")#)
							OR tbl_clienti.id_agente = #StructFind(session.userlogin,"id")#)
						<cfelse>
							AND tbl_clienti.id_agente = #StructFind(session.userlogin,"id")#
						</cfif>
					<cfelse>
						AND tbl_persone.id_gruppo = #arguments.id_gruppo_agenti#
					</cfif>
				</cfif>	
				<cfif arguments.id_processo NEQ "">
					AND tbl_processi.id_processo = #arguments.id_processo#
				</cfif>	
				</cfif>
				--->
<!--- 			 <cfif session.livello GT 2>
					AND tbl_clienti.id_agente = #StructFind(session.userlogin,"id")#
				</cfif> --->
				
			ORDER BY  tbl_processi.int_ordine, dt_status ASC ,tbl_clienti.ac_cognome,   tbl_clienti.id_cliente ,   tbl_status.id_status DESC 
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
	
	<cffunction name="getClienteStatus" access="remote" returntype="any">
		<cfargument name="id_cliente" required="yes">
		<cfquery name="qryCliente" datasource="#THIS.dsn#">
		Select 
		tbl_status.id_status,
		tbl_status.dt_status,
		DATE_FORMAT(tbl_status.dt_status,'%d/%m/%Y') AS data_status,
		DATE_FORMAT(tbl_status.dt_status,'%H:%i') AS ora_status,
		tbl_status.ac_note,
		tbl_status.ac_docs,
		tbl_status.ac_modulo_uuid,
		tbl_status.ac_valore,
		tbl_status.id_persona,
		tbl_clienti.id_cliente,
		tbl_clienti.id_agente,
		tbl_clienti.ac_cognome,
		tbl_clienti.ac_azienda,
		tbl_clienti.ac_citta,
		tbl_clienti.ac_pv,
		tbl_clienti.ac_indirizzo,
		tbl_clienti.ac_telefono,
		tbl_clienti.ac_cellulare,
		tbl_clienti.ac_email,
		tbl_clienti.ac_info,
		tbl_processi.id_processo,
		tbl_processi.int_tipo,
		tbl_processi.ac_processo,
		tbl_processi.ac_sigla,
		tbl_processi.ac_colore,
		tbl_processi.ac_modulo,
		tbl_processi.bl_documento,
		tbl_processi.ac_permissions,
		tbl_processi.bl_assegnazione,
		CONCAT( tbl_persone.ac_cognome, " " , tbl_persone.ac_nome ) AS assegnazione,
		tbl_persone.id_persona AS agente,
		tbl_gruppi.id_gruppo AS gruppo
		From
		tbl_status
		Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
		Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
		LEFT JOIN tbl_persone ON tbl_status.id_persona = tbl_persone.id_persona
		LEFT JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
		WHERE tbl_clienti.id_cliente = #arguments.id_cliente#
		</cfquery>
		<cfreturn qryCliente>
	</cffunction>
	
	<cffunction name="stringToDate" access="private" returntype="date">
		<cfargument name="data" required="yes" type="string">
		<cfset myData = CreateDate(ListGetAt(arguments.data,3,"/"),ListGetAt(arguments.data,2,"/"),ListGetAt(arguments.data,1,"/"))>
		<cfreturn myData>
	</cffunction>
</cfcomponent>
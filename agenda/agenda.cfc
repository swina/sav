<cfcomponent>
	<cfset THIS.dsn = "#application.dsn#">
	
	<cffunction name="events" access="remote" returntype="query">
		<cfargument name="id_agente" required="yes" default="">
		<cfargument name="id_gruppo_agenti" required="yes" default="">
		<cfargument name="soloagente" required="yes" default=1>
		<cfargument name="date_from" required="no">
		<cfargument name="date_to" required="no">
		
		<cfset thisDay = DateAdd("d",-7,now())>
		<cfset operatore = "WHERE ">
		
		<cfquery name="qry" datasource="#THIS.dsn#">
			SELECT 
				tbl_status.*,
				tbl_processi.ac_processo,
				tbl_processi.ac_sigla,
				tbl_processi.ac_colore,
				tbl_clienti.ac_cognome,
				tbl_clienti.ac_nome,
				tbl_clienti.ac_azienda,
				tbl_clienti.ac_indirizzo,
				tbl_clienti.ac_citta,
				tbl_clienti.id_agente,
				CONCAT ( tbl_persone.ac_cognome , " " , tbl_persone.ac_nome ) AS agente,
				tbl_gruppi.ac_gruppo
			 FROM tbl_status
			 LEFT JOIN tbl_processi ON tbl_status.id_processo = tbl_processi.id_processo
			 LEFT JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			 LEFT JOIN tbl_persone ON (tbl_clienti.id_agente = tbl_persone.id_persona OR tbl_status.id_persona = tbl_persone.id_persona)
			 LEFT JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
			 WHERE ( dt_status >= #DateAdd("d",-45,now())# AND dt_status <= #DateAdd("d",45,now())# )
			 <cfset operatore = " AND ">
			 <cfif StructFind(session.userlogin,"livello") GT 2>
			 
				<cfif arguments.soloagente EQ 1>
				 	#operatore# tbl_persone.id_persona = #StructFind(session.userlogin,"id")#
					<cfset operatore = " AND ">
				<cfelse>
					<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
						<cfif arguments.id_agente EQ "" AND arguments.id_gruppo_agenti EQ "">
							#operatore# (tbl_gruppi.id_gruppo IN ( #StructFind(session.userlogin,"gruppi_controllo")# ))
							<cfset operatore = " AND ">
						</cfif>
						<cfif arguments.id_agente NEQ "">
							#operatore# tbl_persone.id_persona = #arguments.id_agente#
							<cfset operatore = "AND ">
						</cfif>	
						<cfif arguments.id_gruppo_agenti NEQ "">
							#operatore# tbl_gruppi.id_gruppo = #arguments.id_gruppo_agenti#
							<cfset operatore = " AND ">
						</cfif>
					<cfelse>	
					 	#operatore# 
						(tbl_clienti.id_agente = #StructFind(session.userlogin,"id")#
						OR 
						tbl_status.id_persona = #StructFind(session.userlogin,"id")#
						)
					</cfif>	
				</cfif>
			<cfelse>
				<cfif arguments.soloagente EQ 1>
					#operatore# tbl_persone.id_persona = #StructFind(session.userlogin,"id")#
					<cfset operatore = " AND ">
				<cfelse>
					<cfif arguments.id_agente NEQ "">
						#operatore# tbl_persone.id_persona	 = #arguments.id_agente#
						<cfset operatore = "AND ">
					</cfif>	
					<cfif arguments.id_gruppo_agenti NEQ "">
						#operatore# tbl_gruppi.id_gruppo = #arguments.id_gruppo_agenti#
						<cfset operatore = " AND ">
					</cfif>
				</cfif>
			</cfif>
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	
	<cffunction name="addAgendaEvent" access="remote" returntype="any">
		<cfargument name="id_persona" 		required="yes">
		<cfargument name="dt_start" 	required="yes">
		<cfargument name="ora" 			required="yes">
		<cfargument name="ac_evento"	required="yes">
		<cfargument name="action" 		required="yes">
		<cfargument name="ora_end"		required="no">
		<cfif arguments.ora_end EQ "">
			<cfset ora_end = ListGetAt(ora,1,":") + 1>
		</cfif>	
		<cfset myDateStart = CreateDateTime(ListGetAt(arguments.dt_start,3,"/"),ListGetAt(arguments.dt_start,2,"/"),ListGetAt(arguments.dt_start,1,"/"),ListGetAt(arguments.ora,1,":"),ListGetAt(arguments.ora,2,":"),0)>
		<cfset myDateEnd = CreateDateTime(ListGetAt(arguments.dt_start,3,"/"),ListGetAt(arguments.dt_start,2,"/"),ListGetAt(arguments.dt_start,1,"/"),ListGetAt(arguments.ora_end,1,":"),ListGetAt(arguments.ora_end,2,":"),0)>
 
 		<cfif arguments.action EQ 0>
			<cfquery name="qryAddAgendaEvent" datasource="#THIS.dsn#">
				INSERT INTO tbl_status
				(
					id_cliente		,
					id_processo		,
					id_persona		,
					dt_status		,
					dt_status_end	,
					ac_note
				)
				VALUES
				(
					0,
					0,
					#arguments.id_persona#						,
					#myDateStart#							,
					#myDateEnd#								,
					'#arguments.ac_evento#'
				)
			</cfquery>
			<cfquery name="getLastID" datasource="#THIS.dsn#">
				SELECT * FROM tbl_status ORDER BY id_status DESC LIMIT 0,1
			</cfquery>
			<cfreturn getLastID.id_status>
		<cfelse>
			<cfquery name="updateAgendaEvent" datasource="#THIS.dsn#">
			UPDATE tbl_status SET
				dt_status 	= #myDateStart#				,
				ac_note 	= '#arguments.ac_evento#'
			WHERE
				id_status 	= #arguments.action#
			</cfquery>
			<cfreturn "OK">
		</cfif>
		
	</cffunction>
	
	<cffunction name="deleteAgendaEvent" access="remote" returntype="any">
		<cfargument name="id" 	required="yes">
		<cfquery name="qryDeleteEvent" datasource="#THIS.dsn#">
		DELETE FROM tbl_status WHERE id_status = #arguments.id#
		</cfquery>
		<cfreturn "OK">
	</cffunction>
	
	
	<cffunction name="getTimeEvent" access="remote" returntype="any">
		<cfargument name="id"	required="yes">
		<cfargument name="tipo" required="yes" default="start">
		<cfquery name="rsTime" datasource="#THIS.dsn#">
			SELECT * FROM tbl_status WHERE id_status = #arguments.id#
		</cfquery>
		<cfif arguments.tipo EQ "start">
			<cfreturn TimeFormat(rsTime.dt_status,"HH:MM")>
		<cfelse>
			<cfreturn TimeFormat(rsTime.dt_status_end,"HH:MM")>
		</cfif>
	</cffunction>
</cfcomponent>
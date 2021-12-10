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
				 	#operatore# tbl_clienti.id_agente = #StructFind(session.userlogin,"id")#
					<cfset operatore = " AND ">
				<cfelse>
					<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
						<cfif arguments.id_agente EQ "" AND arguments.id_gruppo_agenti EQ "">
							#operatore# (tbl_gruppi.id_gruppo IN ( #StructFind(session.userlogin,"gruppi_controllo")# ))
							<cfset operatore = " AND ">
						</cfif>
						<cfif arguments.id_agente NEQ "">
							#operatore# tbl_clienti.id_agente = #arguments.id_agente#
							<cfset operatore = "AND ">
						</cfif>	
						<cfif arguments.id_gruppo_agenti NEQ "">
							#operatore# tbl_gruppi.id_gruppo = #arguments.id_gruppo_agenti#
							<cfset operatore = " AND ">
						</cfif>
					<cfelse>	
					 	#operatore# tbl_clienti.id_agente = #StructFind(session.userlogin,"id")#
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
	
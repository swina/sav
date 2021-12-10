<cfcomponent>
	<cfset THIS.dsn = "#application.dsn#">
	
	<cffunction name="events" access="remote" returntype="query">
		<cfargument name="soloagente" required="yes" default=1>
		<cfargument name="date_from" required="no">
		<cfargument name="date_to" required="no">
		
		<cfset thisDay = DateAdd("d",-7,now())>
		
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
				CONCAT ( tbl_persone.ac_cognome , " " , tbl_persone.ac_nome ) AS agente,
				tbl_gruppi.ac_gruppo
			 FROM tbl_status
			 INNER JOIN tbl_processi ON tbl_status.id_processo = tbl_processi.id_processo
			 INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			 INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			 INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
			 <cfif StructFind(session.userlogin,"livello") GT 1>
			 WHERE
				<cfif arguments.soloagente EQ 1>
				 	tbl_clienti.id_agente = #StructFind(session.userlogin,"id")#
				<cfelse>
				 	tbl_clienti.id_agente = #StructFind(session.userlogin,"id")#
					<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
						<cfset gruppi_abilitati = StructFind(session.userlogin,"gruppi_controllo")>
						OR  (tbl_gruppi.id_gruppo IN ( #gruppi_abilitati# )) 
					</cfif>
				</cfif>
			 </cfif>
			 <!--- WHERE
			 	(
					tbl_status.dt_status >= #thisDay# 
					AND
					tbl_status.dt_status <= #DateAdd("d",7,thisDay)#
				) --->
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
</cfcomponent>
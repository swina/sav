<cfcomponent>

	<cfset THIS.dsn = "#application.dsn#">
	
	<cffunction name="processiInCorso" access="remote" returntype="any">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-7,now())#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="id_agente" required="no" default="">
		<cfargument name="id_gruppo_agenti" required="no" default="">
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
		<cfquery name="qry" datasource="#THIS.dsn#">
			SELECT
			tbl_processi.ac_processo,
			tbl_processi.ac_colore,
			COUNT(tbl_status.id_processo) AS nrprocessi,
			tbl_persone.id_persona,
			tbl_persone.ac_cognome,
			MAX(tbl_persone.id_persona) AS agenti
			FROM tbl_status
			Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
			Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			WHERE 
				( dt_status >= #dFrom# AND dt_status <= #DateAdd("d",1,dTo)# )
				<cfif arguments.id_agente NEQ "">
				AND tbl_persone.id_persona = #arguments.id_agente#
				</cfif>
				<cfif arguments.id_gruppo_agenti NEQ "">
					AND ( 
						tbl_persone.id_gruppo = #arguments.id_gruppo_agenti# 

						<cfif session.livello GT 2>
							OR tbl_persone.id_persona = #StructFind(session.userlogin,"id")#
						</cfif>
						)
				<cfelse>
					<cfif session.livello GT 2>
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
					</cfif>	
				</cfif>
			GROUP BY tbl_status.id_processo
			ORDER BY nrprocessi DESC
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	<cffunction name="processiInCorsoDetail" access="remote" returntype="any">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-7,now())#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="id_agente" required="no" default="">
		<cfargument name="id_gruppo_agenti" required="no" default="">
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
		<cfquery name="qry" datasource="#THIS.dsn#">
			SELECT
			tbl_processi.ac_processo,
			tbl_processi.ac_colore,
			tbl_processi.int_ordine,
			COUNT(tbl_status.id_processo) AS nrprocessi,
			tbl_persone.id_persona,
			tbl_persone.ac_cognome,
			tbl_persone.ac_nome,
			MAX(tbl_persone.id_persona) AS agenti
			FROM tbl_status
			Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
			Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			WHERE 
				( dt_status >= #dFrom# AND dt_status <= #DateAdd("d",1,dTo)# )
				<cfif arguments.id_agente NEQ "">
				AND tbl_persone.id_persona = #arguments.id_agente#
				</cfif>
				<!--- <cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "" AND arguments.id_gruppo_agenti EQ "">
					AND 
					tbl_persone.id_gruppo IN ( #StructFind(session.userlogin,"gruppi_controllo")# )
				<cfelse>
					AND tbl_persone.id_gruppo = #arguments.id_gruppo_agenti#	
				</cfif>		 --->		

				<cfif arguments.id_gruppo_agenti NEQ "">
					AND ( 
						tbl_persone.id_gruppo = #arguments.id_gruppo_agenti# 
						<cfif session.livello GT 2>
							OR tbl_persone.id_persona = #StructFind(session.userlogin,"id")#
						</cfif>
						)
				<cfelse>
					<cfif session.livello GT 2>
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
					</cfif> 
					
				</cfif>
				
			GROUP BY tbl_persone.id_persona, tbl_status.id_processo
			ORDER BY tbl_persone.ac_cognome, tbl_persone.id_persona, tbl_processi.int_ordine, nrprocessi DESC , id_persona
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	
	<cffunction name="calcola_giorni" access="remote" returntype="numeric">
		<cfargument name="dateFrom" required="yes" default="#DateAdd('d',-7,now())#">
		<cfargument name="dateTo" required="yes" default="#DateAdd('d',7,now())#">
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
		<cfset ngiorni = DateDiff("d",dFrom,dTo)+1>
		<cfreturn ngiorni>
	</cffunction>
	
	<cffunction name="stringToDate" access="private" returntype="date">
		<cfargument name="data" required="yes" type="string">
		<cfset myData = CreateDate(ListGetAt(arguments.data,3,"/"),ListGetAt(arguments.data,2,"/"),ListGetAt(arguments.data,1,"/"))>
		<cfreturn myData>
	</cffunction>
</cfcomponent>
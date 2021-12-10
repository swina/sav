<cfcomponent>

	<cfset THIS.dsn = "#application.dsn#">
	
	
	
	<cffunction name="contaProcessi" access="remote" returntype="any">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-7,now())#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="id_agente" required="no" default="">
		<cfargument name="id_gruppo_agenti" required="no" default="">
		<cfargument name="start_processo" required="no" default="">
		<cfargument name="end_processo" required="no" default="">
		
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
			SELECT * FROM (SELECT
			tbl_processi.ac_processo,
			tbl_processi.ac_colore,
			tbl_processi.id_processo,
			COUNT(tbl_status.id_processo) AS nrprocessi,
			SUM(tbl_status.id_processo) AS totale_processi,
			tbl_persone.id_persona,
			tbl_persone.ac_cognome,
			tbl_persone.ac_nome,
			MAX(tbl_persone.id_persona) AS agenti,
			tbl_clienti.ac_segnalatore
			FROM tbl_status
			Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
			Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			
			WHERE 
				( dt_status >= #dFrom# AND dt_status <= #DateAdd("d",1,dTo)# )
				<cfif arguments.id_agente NEQ "">
				AND tbl_persone.id_persona = #arguments.id_agente#
				</cfif>
				<cfif arguments.start_processo NEQ "">
					AND (
					<cfif arguments.end_processo EQ "">
					 	tbl_processi.id_processo = #arguments.start_processo#	
					<cfelse>
						<cfif arguments.start_processo LT arguments.end_processo>
							tbl_processi.id_processo >= #arguments.start_processo# AND tbl_processi.id_processo <= #arguments.end_processo#	
						<cfelse>
							tbl_processi.id_processo >= #arguments.end_processo# AND tbl_processi.id_processo <= #arguments.start_processo#
						</cfif>
						
					</cfif>
					)
				</cfif>		
				
				<cfif arguments.id_gruppo_agenti NEQ "">
					AND ( 
						tbl_persone.id_gruppo = #arguments.id_gruppo_agenti# 

						<cfif session.livello GT 2>
							OR tbl_persone.id_persona = #StructFind(session.userlogin,"id")#
						</cfif>
						)
<!--- 				<cfelse>
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
					</cfif>	
 --->				</cfif>
			GROUP BY tbl_status.id_processo
			) AS result
			
			
			ORDER BY id_processo, nrprocessi DESC
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	<cffunction name="contaClienti" access="remote" returntype="any">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-7,now())#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="id_processo" required="no" default="">
		<cfargument name="id_gruppo_agenti" required="no" default="">
		<cfargument name="tipo_clienti" required="no" default="0">
		<cfargument name="id_agente" required="no" default="">
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
				tbl_status.id_processo
				
			FROM tbl_status
			INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			WHERE 
			( dt_status >= #dFrom# AND dt_status <= #DateAdd("d",1,dTo)# )
			AND
				<cfif arguments.tipo_clienti EQ 0>
					(tbl_clienti.ac_segnalatore = 'LGI' OR tbl_clienti.ac_segnalatore = 'Collead')
				<cfelse>
					(tbl_clienti.ac_segnalatore <> 'LGI' AND tbl_clienti.ac_segnalatore <> 'Collead')		
				</cfif>
			
			<cfif arguments.id_processo NEQ "">
			AND
				<cfif ListLen(arguments.id_processo) EQ 1>
					id_processo = #arguments.id_processo#
				<cfelse>
					id_processo IN (#arguments.id_processo#)
				</cfif>
			</cfif>
			<cfif arguments.id_gruppo_agenti NEQ "">
			AND tbl_persone.id_gruppo = #arguments.id_gruppo_agenti#
			</cfif>
			<cfif arguments.id_agente NEQ "">
			AND tbl_clienti.id_agente = #arguments.id_agente#
			</cfif>
		</cfquery>
		<cfreturn qry.recordcount>
	</cffunction>
	
	<cffunction name="contaContatti" access="remote" returntype="any">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-7,now())#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="id_agente" required="yes">
		<cfargument name="scopo" required="no" default="">
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
		<cfquery name="qryContaContatti" datasource="#THIS.dsn#">
			SELECT 
				tbl_status.id_cliente,
				tbl_clienti.ac_segnalatore
			FROM tbl_status
			INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			WHERE 
				( dt_status >= #dFrom# AND dt_status <= #DateAdd("d",1,dTo)# )
				AND
				tbl_persone.id_persona IN ( #arguments.id_agente# )
				AND
				tbl_status.id_processo = 2
				<cfif arguments.scopo EQ "">
				AND
				(
					tbl_clienti.ac_segnalatore <> "LGI" 
					AND
					tbl_clienti.ac_segnalatore <> "COLLEAD"
					AND
					tbl_clienti.ac_segnalatore <> "OPTIMAMENTE"
				
				)	
				<cfelse>
				AND
				(
					tbl_clienti.ac_segnalatore = "LGI" 
					OR
					tbl_clienti.ac_segnalatore = "COLLEAD"
					OR
					tbl_clienti.ac_segnalatore = "OPTIMAMENTE"
				)
				</cfif>
				GROUP BY tbl_status.id_cliente, tbl_status.id_processo
		</cfquery>
		<cfquery name="qryEscludiContatti" datasource="#THIS.dsn#">
			SELECT 
				tbl_status.id_processo,
				tbl_status.id_cliente ,
				tbl_clienti.id_agente AS agente,
				tbl_clienti.ac_segnalatore
				FROM tbl_status 
			INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			WHERE 
				( dt_status >= #dFrom# AND dt_status <= #DateAdd("d",1,dTo)# )
				AND
				( id_processo = 8 OR id_processo = 10 OR id_processo = 7) 
				<cfif arguments.scopo EQ "">
				AND
				(
					tbl_clienti.ac_segnalatore <> "LGI" 
					AND
					tbl_clienti.ac_segnalatore <> "COLLEAD"
					AND
					tbl_clienti.ac_segnalatore <> "OPTIMAMENTE"
				
				)	
				<cfelse>
				AND
				(
					tbl_clienti.ac_segnalatore = "LGI" 
					OR
					tbl_clienti.ac_segnalatore = "COLLEAD"
					OR
					tbl_clienti.ac_segnalatore = "OPTIMAMENTE"
				)
				</cfif>
			AND id_agente = #arguments.id_agente# 
			GROUP BY id_cliente
		</cfquery>
		<cfif qryEscludiContatti.recordcount>
			<cfset nrDaEscludere = qryEscludiContatti.recordcount>
		<cfelse>
			<cfset nrDaEscludere = 0>	
		</cfif>
		<cfset myContatti = "#qryContaContatti.recordcount#">
		<cfquery name="qryEscludiContatti" datasource="#THIS.dsn#">
			SELECT 
				tbl_status.id_processo,
				tbl_status.id_cliente ,
				tbl_clienti.id_agente AS agente
				FROM tbl_status 
			INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			WHERE ( id_processo = 8 OR id_processo = 10 OR id_processo = 7) 
			AND id_agente = #arguments.id_agente# 
		GROUP BY id_cliente
		</cfquery>
		<cfif qryEscludiContatti.recordcount>
			<cfset nrDaEscludere = qryEscludiContatti.recordcount>
		<cfelse>
			<cfset nrDaEscludere = 0>	
		</cfif>
		<cfquery name="qryContaContatti" datasource="#THIS.dsn#">
			SELECT
				tbl_clienti.id_cliente
			FROM tbl_clienti
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			WHERE 
				tbl_persone.id_persona IN ( #arguments.id_agente# )
		</cfquery>
		<cfset myContatti = "#myContatti#,#qryContaContatti.recordcount-nrDaEscludere#">
		<cfreturn myContatti>	
	</cffunction>
	
	
	<cffunction name="dettaglioProcessi" access="remote" returntype="any">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-7,now())#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="id_agente" required="no" default="">
		<cfargument name="id_gruppo_agenti" required="no" default="">
		<cfargument name="start_processo" required="no" default="">
		<cfargument name="end_processo" required="no" default="">
		
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
			SELECT * FROM (SELECT
			COUNT(tbl_status.id_processo) AS nrprocessi,
			tbl_persone.id_gruppo,
			tbl_processi.ac_processo,
			tbl_processi.ac_colore,
			tbl_processi.id_processo,
			tbl_persone.id_persona,
			tbl_persone.ac_cognome,
			tbl_persone.ac_nome,
			tbl_gruppi.ac_gruppo,
			tbl_gruppi.int_livello,
			tbl_clienti.ac_segnalatore
			FROM tbl_status
			Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
			Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
			WHERE 
				( dt_status >= #dFrom# AND dt_status <= #DateAdd("d",1,dTo)# )
				<cfif arguments.id_agente NEQ "">
				AND tbl_persone.id_persona = #arguments.id_agente#
				</cfif>
				<cfif arguments.start_processo NEQ "">
					AND (
					<cfif arguments.end_processo EQ "">
					 	tbl_processi.id_processo = #arguments.start_processo#	
					<cfelse>
						<cfif arguments.start_processo LT arguments.end_processo>
							tbl_processi.id_processo >= #arguments.start_processo# AND tbl_processi.id_processo <= #arguments.end_processo#	
						<cfelse>
							tbl_processi.id_processo >= #arguments.end_processo# AND tbl_processi.id_processo <= #arguments.start_processo#
						</cfif>
						
					</cfif>
					)
				</cfif>		
				
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
					</cfif>	
				</cfif>
			GROUP BY tbl_persone.id_gruppo
			) AS result
			WHERE result.int_livello > 1
			
			ORDER BY nrprocessi DESC , ac_gruppo ASC , id_processo 
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	<cffunction name="dettaglioProcessiAgenti" access="remote" returntype="any">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-7,now())#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="id_agente" required="no" default="">
		<cfargument name="id_gruppo_agenti" required="no" default="">
		<cfargument name="start_processo" required="no" default="">
		<cfargument name="end_processo" required="no" default="">
		
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
			SELECT * FROM (SELECT
			
			tbl_persone.id_gruppo,
			tbl_processi.ac_processo,
			tbl_processi.ac_colore,
			tbl_processi.id_processo,
			tbl_persone.id_persona,
			tbl_persone.ac_cognome,
			tbl_persone.ac_nome,
			tbl_gruppi.ac_gruppo,
			tbl_gruppi.int_livello,
			tbl_clienti.ac_segnalatore
			FROM tbl_status
			Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
			Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
			WHERE 
				( dt_status >= #dFrom# AND dt_status <= #DateAdd("d",1,dTo)# )
				<cfif arguments.id_agente NEQ "">
				AND tbl_persone.id_persona = #arguments.id_agente#
				</cfif>
				<cfif arguments.start_processo NEQ "">
					AND (
					<cfif arguments.end_processo EQ "">
					 	tbl_processi.id_processo = #arguments.start_processo#	
					<cfelse>
						<cfif arguments.start_processo LT arguments.end_processo>
							tbl_processi.id_processo >= #arguments.start_processo# AND tbl_processi.id_processo <= #arguments.end_processo#	
						<cfelse>
							tbl_processi.id_processo >= #arguments.end_processo# AND tbl_processi.id_processo <= #arguments.start_processo#
						</cfif>
						
					</cfif>
					)
				</cfif>		
				
				<cfif arguments.id_gruppo_agenti NEQ "">
					AND ( 
						<cfif ListLen(arguments.id_gruppo_agenti) LT 2>
							tbl_persone.id_gruppo = #arguments.id_gruppo_agenti# 
						<cfelse>
							tbl_persone.id_gruppo IN ( #arguments.id_gruppo_agenti# )
						</cfif>
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
					</cfif>	
				</cfif>
			
			) AS result
			<!--- WHERE result.int_livello > 1 --->
			
			ORDER BY ac_gruppo ASC , ac_cognome, id_persona , id_processo 
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	<cffunction name="riepilogoGenerale" access="remote" returntype="any">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-7,now())#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="id_agente" required="no" default="">
		<cfargument name="id_processo" required="no" default="">
		<cfargument name="id_gruppo_agenti" required="no" default="">
		
		<cfargument name="end_processo" required="no" default="">
		
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
		<cfquery name="qryRiepilogo" datasource="#THIS.dsn#">
		SELECT * FROM (SELECT
			
			tbl_persone.id_gruppo,
			tbl_processi.ac_processo,
			tbl_processi.ac_colore,
			tbl_processi.id_processo,
			tbl_persone.id_persona,
			tbl_persone.ac_cognome,
			tbl_persone.ac_nome,
			tbl_gruppi.ac_gruppo,
			tbl_gruppi.int_livello,
			tbl_clienti.ac_segnalatore,
			tbl_status.id_cliente
			FROM tbl_status
			Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
			Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
			WHERE 
				( dt_status >= #dFrom# AND dt_status <= #dTo# )
				AND 
				(
					tbl_status.id_processo IN ( #arguments.id_processo# ) 
				)
				<cfif arguments.id_gruppo_agenti NEQ "">
				AND
				(
					tbl_persone.id_gruppo IN ( #arguments.id_gruppo_agenti# )
				)
				</cfif>
				<cfif arguments.id_agente NEQ "">
				AND
				(
					<cfif ListLen(arguments.id_agente) EQ 1>
						<cfset ida = Left(arguments.id_agente,len(arguments.id_agente)-1)>
						tbl_persone.id_persona IN ( #ListGetAt(arguments.id_agente,1)# )
					<cfelse>
						tbl_persone.id_persona IN ( #arguments.id_agente# )	
					</cfif>
					
				)
				</cfif>			
			) AS result
			WHERE result.int_livello > 1
			ORDER BY  ac_gruppo ASC ,  ac_cognome , id_processo , id_persona 
		</cfquery>	
		<cfreturn qryRiepilogo>
	</cffunction>
	
	<cffunction name="confrontaGruppi" access="remote" returntype="any">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-7,now())#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="id_agente" required="no" default="">
		<cfargument name="id_gruppo_agenti" required="no" default="">
		<cfargument name="start_processo" required="no" default="">
		<cfargument name="end_processo" required="no" default="">
		
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
			SELECT * FROM (SELECT
			COUNT(tbl_status.id_processo) AS nrprocessi,
			tbl_persone.id_gruppo,
			tbl_processi.ac_processo,
			tbl_processi.ac_colore,
			tbl_processi.id_processo,
			tbl_persone.id_persona,
			tbl_persone.ac_cognome,
			tbl_persone.ac_nome,
			tbl_gruppi.ac_gruppo,
			tbl_gruppi.int_livello,
			tbl_clienti.ac_segnalatore
			FROM tbl_status
			Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
			Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
			WHERE 
				( dt_status >= #dFrom# AND dt_status <= #DateAdd("d",1,dTo)# )
				<cfif arguments.id_agente NEQ "">
				AND tbl_persone.id_persona = #arguments.id_agente#
				</cfif>
				<cfif arguments.start_processo NEQ "">
					AND  tbl_processi.id_processo IN ( #arguments.start_processo# )
				</cfif>
<!--- 				<cfif arguments.start_processo NEQ "">
					AND (
					<cfif arguments.end_processo EQ "">
					 	tbl_processi.id_processo = #arguments.start_processo#	
					<cfelse>
						<cfif arguments.start_processo LT arguments.end_processo>
							tbl_processi.id_processo >= #arguments.start_processo# AND tbl_processi.id_processo <= #arguments.end_processo#	
						<cfelse>
							tbl_processi.id_processo >= #arguments.end_processo# AND tbl_processi.id_processo <= #arguments.start_processo#
						</cfif>
						
					</cfif>
					)
				</cfif>		 --->
				
				<cfif arguments.id_gruppo_agenti NEQ "">
				AND tbl_persone.id_gruppo IN ( #arguments.id_gruppo_agenti# )
				</cfif>

				GROUP BY id_persona
			) AS result
			WHERE result.int_livello > 1
			
			ORDER BY ac_gruppo ASC , nrprocessi DESC , id_persona , id_processo 
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	
	<cffunction name="confrontaProcessi" access="remote" returntype="any">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-7,now())#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="id_agente" required="no" default="">
		<cfargument name="id_gruppo_agenti" required="no" default="">
		<cfargument name="start_processo" required="no" default="">
		<cfargument name="end_processo" required="no" default="">
		
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
			SELECT * FROM (SELECT
			COUNT(tbl_status.id_processo) AS nrprocessi,
			tbl_persone.id_gruppo,
			tbl_processi.ac_processo,
			tbl_processi.ac_colore,
			tbl_processi.id_processo,
			tbl_persone.id_persona,
			tbl_persone.ac_cognome,
			tbl_persone.ac_nome,
			tbl_gruppi.ac_gruppo,
			tbl_gruppi.int_livello,
			tbl_clienti.ac_segnalatore
			FROM tbl_status
			Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
			Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
			WHERE 
				( dt_status >= #dFrom# AND dt_status <= #DateAdd("d",1,dTo)# )
				
				<cfif arguments.start_processo NEQ "">
					AND 
					(
						tbl_status.id_processo IN ( #arguments.start_processo# ) 
					)
				</cfif>		
				
				
			GROUP BY tbl_persone.id_gruppo, tbl_status.id_processo
			) AS result
			WHERE result.int_livello > 1
			
			ORDER BY  ac_gruppo ASC , id_processo 
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	
	<cffunction name="confrontaProcessiDetail" access="remote" returntype="any">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-7,now())#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="id_agente" required="no" default="">
		<cfargument name="id_gruppo_agenti" required="no" default="">
		<cfargument name="start_processo" required="no" default="">
		<cfargument name="end_processo" required="no" default="">
		<cfargument name="scope" required="no" default="">
		
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
			SELECT * FROM (SELECT
			
			tbl_persone.id_gruppo,
			tbl_processi.ac_processo,
			tbl_processi.ac_colore,
			tbl_processi.id_processo,
			tbl_persone.id_persona,
			tbl_persone.ac_cognome,
			tbl_persone.ac_nome,
			tbl_gruppi.ac_gruppo,
			tbl_gruppi.int_livello,
			tbl_clienti.ac_segnalatore
			FROM tbl_status
			Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
			Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
			WHERE 
				( dt_status >= #dFrom# AND dt_status <= #DateAdd("d",1,dTo)# )
				
				<cfif arguments.start_processo NEQ "">
					AND 
					(
						tbl_status.id_processo IN ( #arguments.start_processo# ) 
					)
				</cfif>		
				<cfif arguments.id_gruppo_agenti NEQ "">
					AND
					(
						tbl_persone.id_gruppo IN ( #arguments.id_gruppo_agenti# )
					)
				</cfif>
				<cfif arguments.id_agente NEQ "">
					AND
					(
						tbl_persone.id_persona IN ( #arguments.id_agente# )
					)
				</cfif>
			
			) AS result
			WHERE result.int_livello > 1
			<cfif arguments.scope EQ "">
				ORDER BY  ac_gruppo ASC , id_processo ,  ac_cognome ASC 
			<cfelse>
				ORDER BY  ac_gruppo ASC ,  ac_cognome ASC , id_processo	
			</cfif>
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	
	<cffunction name="contaProcessiGruppo" access="remote" returntype="any">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-7,now())#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="id_agente" required="no" default="">
		<cfargument name="id_gruppo_agenti" required="no" default="">
		<cfargument name="start_processo" required="no" default="">
		<cfargument name="end_processo" required="no" default="">
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
	<cfquery name="contaProcessi" datasource="#THIS.dsn#">
	SELECT SUM(result.nrprocessi) AS totale  FROM (SELECT * FROM (SELECT
			COUNT(tbl_status.id_processo) AS nrprocessi,
			tbl_persone.id_gruppo,
			tbl_processi.ac_processo,
			tbl_processi.ac_colore,
			tbl_processi.id_processo,
			tbl_persone.id_persona,
			tbl_persone.ac_cognome,
			tbl_persone.ac_nome,
			tbl_gruppi.ac_gruppo,
			tbl_gruppi.int_livello,
			tbl_clienti.ac_segnalatore
			FROM tbl_status
			Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
			Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
			WHERE 
				( dt_status >= #dFrom# AND dt_status <= #DateAdd("d",1,dTo)# )
				
				<cfif arguments.start_processo NEQ "">
					AND 
					(
						tbl_status.id_processo IN ( #arguments.start_processo# ) 
					)
				</cfif>		
						
				
				
			GROUP BY tbl_persone.id_gruppo, tbl_status.id_processo
			) AS result
			WHERE result.int_livello > 1
			
			ORDER BY  ac_gruppo ASC , id_processo 
) AS RESULT
<cfif arguments.id_gruppo_agenti NEQ "">
WHERE id_gruppo IN (#arguments.id_gruppo_agenti#)
</cfif>
		</cfquery>
		<cfreturn contaProcessi.totale>
	</cffunction>
	
	<cffunction name="confrontaProcessiGruppi" access="remote" returntype="query">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-7,now())#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="id_agente" required="no" default="">
		<cfargument name="id_gruppo_agenti" required="no" default="">
		<cfargument name="start_processo" required="no" default="">
		<cfargument name="end_processo" required="no" default="">
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
		<cfquery name="getProcessiGruppi" datasource="#THIS.dsn#">
		SELECT * FROM (SELECT
			tbl_persone.id_gruppo,
			tbl_processi.ac_processo,
			tbl_processi.ac_colore,
			tbl_processi.id_processo,
			tbl_persone.id_persona,
			tbl_persone.ac_cognome,
			tbl_persone.ac_nome,
			tbl_gruppi.ac_gruppo,
			tbl_gruppi.int_livello,
			tbl_clienti.ac_segnalatore
			FROM tbl_status
			Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
			Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
			WHERE 
				( dt_status >= #dFrom# AND dt_status <= #DateAdd("d",1,dTo)# )
			<cfif arguments.start_processo NEQ "">
				AND  tbl_processi.id_processo IN ( #arguments.start_processo# )
			</cfif>		
			<cfif arguments.id_gruppo_agenti NEQ "">
				AND tbl_persone.id_gruppo IN ( #arguments.id_gruppo_agenti# )
			</cfif>	
			<cfif arguments.id_agente NEQ "">
				AND tbl_persone.id_persona IN ( #arguments.id_agente# )
			</cfif>	
				
			) AS result
			WHERE result.int_livello > 1
			
			ORDER BY ac_gruppo ASC , id_processo , id_persona 
		</cfquery>
		<cfreturn getProcessiGruppi>
	</cffunction>
	
	
	<cffunction name="getNomeProcessi" access="remote" returntype="any">
		<cfargument name="id_processo" required="yes">
		<cfargument name="ordine" required="no" default=true>
		<cfquery name="nomeProcessi" datasource="#THIS.dsn#">
		SELECT ac_processo FROM tbl_processi WHERE id_processo IN (#arguments.id_processo#) 
		<cfif arguments.ordine>
		ORDER BY int_ordine
		<cfelse>
		ORDER BY int_ordine_stat
		</cfif>
		</cfquery>
		<cfreturn ValueList(nomeProcessi.ac_processo)>
	</cffunction>
	
	
	<cffunction name="assegnazioniClienti" access="remote" returntype="any">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-7,now())#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="id_gruppo_agenti" required="no" default="">
		<cfargument name="id_agente" required="no" default="">
		<cfargument name="mode" required="no" default="normal">
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
		<cfquery name="qryAssegnazioni" datasource="#THIS.dsn#">
			SELECT <cfif arguments.mode NEQ "normal">SUM(result.nrclienti) AS totale_clienti,</cfif> result.*  FROM (SELECT * FROM (SELECT
			COUNT(tbl_clienti.id_cliente) AS nrclienti,
			tbl_gruppi.ac_gruppo,
			tbl_gruppi.int_livello,
			tbl_persone.id_gruppo,
			tbl_persone.ac_cognome,
			tbl_persone.ac_nome
			FROM tbl_clienti
			Inner Join tbl_persone ON tbl_persone.id_persona = tbl_clienti.id_agente
			Inner Join tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
			WHERE 
				( tbl_clienti.dt_data_registrazione >= #dFrom# AND tbl_clienti.dt_data_registrazione <= #DateAdd("d",1,dTo)# )
				
				<cfif arguments.id_gruppo_agenti NEQ "">
					AND 
					(
						tbl_gruppi.id_gruppo IN ( #arguments.id_gruppo_agenti# ) 
					)
				</cfif>		
				<cfif arguments.id_agente NEQ "">
					AND
					(
						tbl_persone.id_persona IN ( #arguments.id_agente# )
					)
				</cfif>
			<cfif arguments.id_gruppo_agenti EQ "">
				GROUP BY tbl_persone.id_gruppo
				</cfif>
			) AS result
			WHERE result.int_livello > 1
			
			ORDER BY  nrclienti DESC , ac_gruppo ASC  
) AS RESULT
		</cfquery>
		<cfreturn qryAssegnazioni>
	</cffunction>
	
	<cffunction name="assegnazioniGruppo" access="remote" returntype="query">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-7,now())#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="id_gruppo_agenti" required="no" default="">
		<cfargument name="id_agente" required="no" default="">
		<cfargument name="mode" required="no" default="normal">
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
		<cfquery name="qryAssegnazioniGruppo" datasource="#THIS.dsn#">
		SELECT 
		COUNT(tbl_clienti.id_cliente) AS nrclienti, 
		tbl_gruppi.ac_gruppo, 
		tbl_gruppi.int_livello,
		tbl_persone.id_persona, 
		tbl_persone.id_gruppo, 
		tbl_persone.ac_cognome, 
		tbl_persone.ac_nome ,
		tbl_persone.ac_sconto_riservato AS nrassegnazioni
		FROM tbl_clienti 
		Inner Join tbl_persone ON tbl_persone.id_persona = tbl_clienti.id_agente 
		Inner Join tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo 
		WHERE 
			( 
				tbl_clienti.dt_data_registrazione >= #dFrom# 
				AND 
				tbl_clienti.dt_data_registrazione <= #dTo#
			) 
			AND 
			( 
				tbl_gruppi.id_gruppo IN ( #arguments.id_gruppo_agenti# ) 
			) 
		GROUP BY id_persona
		ORDER BY nrclienti DESC
		</cfquery>
		<cfreturn qryAssegnazioniGruppo>
	</cffunction>

	<cffunction name="contaClientiAssegnati" access="remote" returntype="any">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-7,now())#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="id_gruppo_agenti" required="no" default="">
		<cfargument name="id_agente" required="no" default="">
		<cfargument name="mode" required="no" default="normal">
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
		<cfquery name="qryConta" datasource="#THIS.dsn#">
			SELECT SUM(result.nrclienti) AS totale_clienti FROM (SELECT * FROM (SELECT
			COUNT(tbl_clienti.id_cliente) AS nrclienti,
			tbl_gruppi.ac_gruppo,
			tbl_gruppi.int_livello,
			tbl_persone.id_persona,
			tbl_persone.id_gruppo,
			tbl_persone.ac_cognome,
			tbl_persone.ac_nome
			FROM tbl_clienti
			Inner Join tbl_persone ON tbl_persone.id_persona = tbl_clienti.id_agente
			Inner Join tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
			WHERE 
				( tbl_clienti.dt_data_registrazione >= #dFrom# AND tbl_clienti.dt_data_registrazione <= #DateAdd("d",1,dTo)# )
				
				<cfif arguments.id_gruppo_agenti NEQ "">
					AND 
					(
						tbl_gruppi.id_gruppo IN ( #arguments.id_gruppo_agenti# ) 
					)
				</cfif>		
				<cfif arguments.id_agente NEQ "">
					AND
					(
						tbl_persone.id_persona IN ( #arguments.id_agente# )
					)
				</cfif>
				<cfif arguments.mode EQ "normal">
					AND 
					(
						tbl_clienti.ac_segnalatore <> "Collead" AND tbl_clienti.ac_segnalatore <> "LGI"
					)
				<cfelse>
					AND
					(
						(tbl_clienti.ac_segnalatore = "Collead" OR tbl_clienti.ac_segnalatore = "LGI")
					)	
				</cfif>
				<cfif arguments.id_gruppo_agenti EQ "">
				GROUP BY tbl_persone.id_gruppo
				</cfif>
			) AS result
			WHERE result.int_livello > 1
			
			ORDER BY  ac_gruppo ASC  
) AS RESULT
		</cfquery>
		<cfreturn qryConta.totale_clienti>
	</cffunction>
	
	
	<cffunction name="assegnazioniDetail" access="remote" returntype="any">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-7,now())#">
		<cfargument name="dateTo" required="no" default="#DateAdd('d',7,now())#">
		<cfargument name="id_gruppo_agenti" required="no" default="">
		<cfargument name="id_agente" required="no" default="">
		<cfargument name="mode" required="no" default="normal">
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
		<cfquery name="qryAssegnazioni" datasource="#THIS.dsn#">
			SELECT
				tbl_gruppi.ac_gruppo,
				tbl_gruppi.int_livello,
				tbl_persone.id_gruppo,
				tbl_persone.id_persona,
				tbl_persone.ac_cognome,
				tbl_persone.ac_nome,
				tbl_clienti.id_cliente
				FROM tbl_clienti
				Inner Join tbl_persone ON tbl_persone.id_persona = tbl_clienti.id_agente
				Inner Join tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
				WHERE 
					( tbl_clienti.dt_data_registrazione >= #dFrom# AND tbl_clienti.dt_data_registrazione <= #dTo# )
				<cfif arguments.id_gruppo_agenti NEQ "">
					AND
					(
						tbl_persone.id_gruppo IN ( #arguments.id_gruppo_agenti# )
					)
				</cfif>	
					AND int_livello > 1				
				ORDER BY  ac_gruppo ASC  , ac_cognome ASC
		</cfquery>
		<cfreturn qryAssegnazioni>
	</cffunction>
	
	<cffunction name="findStatus" access="remote" returntype="any">
		<cfargument name="id_cliente" required="yes">
		<cfargument name="id_processo" required="yes">
		<cfargument name="lista_clienti" required="no" default="">
		<cfquery name="qryStatus" datasource="#THIS.dsn#">
		SELECT * FROM tbl_status 
		WHERE 
			<cfif arguments.lista_clienti EQ "">
				id_cliente = #arguments.id_cliente#
			<cfelse>
				id_cliente IN ( #arguments.lista_clienti# )	
			</cfif>
			AND
			id_processo = #arguments.id_processo#
		</cfquery>
		<cfif arguments.lista_clienti EQ "">
			<cfif qryStatus.recordcount GT 0>
				<cfreturn 1>
			<cfelse>
				<cfreturn 0>	
			</cfif>
		<cfelse>
			<cfreturn qryStatus.recordcount>	
		</cfif>
	</cffunction>
	
	<cffunction name="stringToDate" access="private" returntype="date">
		<cfargument name="data" required="yes" type="string">
		<cfset myData = CreateDate(ListGetAt(arguments.data,3,"/"),ListGetAt(arguments.data,2,"/"),ListGetAt(arguments.data,1,"/"))>
		<cfreturn myData>
	</cffunction>
	
</cfcomponent>
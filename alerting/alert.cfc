<cfcomponent>
	<cfset THIS.dsn = "#application.dsn#">
	
	<cffunction name="blackList" access="remote" returntype="query">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-30,now())#">
		<cfargument name="dateTo" required="no" default="#now()#">
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
			SELECT * FROM (SELECT * FROM (
				SELECT tbl_status.id_status,
				tbl_status.id_cliente AS idc,
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
				tbl_clienti.ac_comunicazioni,
				tbl_gruppi_clienti.id_gruppo AS id_qualifica,
				tbl_gruppi_clienti.ac_icona,
				tbl_gruppi_clienti.ac_gruppo AS qualifica,
				tbl_processi.id_processo,
				tbl_processi.int_ordine,
				tbl_processi.ac_processo,
				tbl_processi.ac_sigla,
				tbl_processi.ac_colore,
				tbl_processi.ac_permissions,
				tbl_processi.ac_modulo,
				tbl_processi.bl_documento,
				tbl_processi.bl_assegnazione,
				tbl_processi.int_postalert,
				tbl_persone.ac_cognome AS agente,
				tbl_persone.ac_email AS mailto,
				tbl_gruppi.id_gruppo AS id_gruppo,
				tbl_gruppi.ac_gruppo AS gruppo
				From
				tbl_status
				Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
				Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
				INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
				LEFT JOIN tbl_gruppi_clienti ON tbl_clienti.id_qualifica = tbl_gruppi_clienti.id_gruppo
				INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
				ORDER BY dt_status DESC) AS myresult GROUP BY idc
				ORDER BY dt_status DESC ) 
				
				AS result
				
			WHERE (dt_status <= #DateAdd("d",-2,dTo)# AND dt_status >= #dFrom#)
			
			<cfif session.livello GT 1>
				<cfif arguments.id_gruppo_agenti EQ "" AND arguments.id_processo EQ "" AND arguments.id_agente EQ "">
					<cfset arguments.id_agente = StructFind(session.userlogin,"id")>
				</cfif>
			</cfif>
			
			<cfif arguments.id_gruppo_agenti NEQ "">
				AND result.id_gruppo = #arguments.id_gruppo_agenti#
			</cfif>
			
			<cfif arguments.id_agente NEQ "">
				AND result.id_agente = #arguments.id_agente#
			</cfif>
			
			<cfif arguments.id_processo NEQ "">
				AND result.id_processo = #arguments.id_processo#
			<cfelse>
				AND ( result.int_postalert > 0 )
			</cfif>
			
			ORDER BY  result.int_ordine, dt_status DESC ,result.ac_cognome,   result.id_cliente ,   result.id_status DESC 
			<!--- LIMIT #arguments.start#,#records# --->
				
			</cfquery>
			<cfreturn qry>
	</cffunction>
	
	
	<cffunction name="blackListMail" access="remote" returntype="query">
		<cfargument name="dateFrom" required="no" default="#DateAdd('d',-30,now())#">
		<cfargument name="dateTo" required="no" default="#now()#">
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
			SELECT * FROM (SELECT * FROM (
				SELECT tbl_status.id_status,
				tbl_status.id_cliente AS idc,
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
				tbl_clienti.ac_comunicazioni,
				tbl_gruppi_clienti.id_gruppo AS id_qualifica,
				tbl_gruppi_clienti.ac_icona,
				tbl_gruppi_clienti.ac_gruppo AS qualifica,
				tbl_processi.id_processo,
				tbl_processi.int_ordine,
				tbl_processi.ac_processo,
				tbl_processi.ac_sigla,
				tbl_processi.ac_colore,
				tbl_processi.ac_permissions,
				tbl_processi.ac_modulo,
				tbl_processi.bl_documento,
				tbl_processi.bl_assegnazione,
				tbl_processi.int_postalert,
				tbl_persone.ac_cognome AS agente,
				tbl_persone.ac_email AS mailto,
				tbl_persone.bl_cancellato,
				tbl_gruppi.id_gruppo AS id_gruppo,
				tbl_gruppi.ac_gruppo AS gruppo
				From
				tbl_status
				Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
				Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
				INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
				LEFT JOIN tbl_gruppi_clienti ON tbl_clienti.id_qualifica = tbl_gruppi_clienti.id_gruppo
				INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
				ORDER BY dt_status DESC) AS myresult GROUP BY idc
				ORDER BY dt_status DESC ) 
				
				AS result
				
			WHERE 
				(dt_status <= #DateAdd("d",-2,dTo)# AND dt_status >= #dFrom#)
				AND  
				result.bl_cancellato = 0
			
			
			<cfif arguments.id_gruppo_agenti NEQ "">
				AND result.id_gruppo = #arguments.id_gruppo_agenti#
			</cfif>
			
			<cfif arguments.id_agente NEQ "">
				AND result.id_agente = #arguments.id_agente#
			</cfif>
			
			<cfif arguments.id_processo NEQ "">
				AND result.id_processo = #arguments.id_processo#
			<cfelse>
				AND ( result.int_postalert > 0 )
			</cfif>
			
			ORDER BY  result.mailto , result.int_ordine, dt_status ASC ,result.ac_cognome,   result.id_cliente ,   result.id_status DESC 
			<!--- LIMIT #arguments.start#,#records# --->
				
			</cfquery>
			<cfreturn qry>
	</cffunction>
	
	
	<cffunction name="tutors" access="remote" returntype="query">
		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT id_persona , ac_cognome, ac_nome FROM tbl_persone WHERE ac_gruppi <> ''
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	<cffunction name="stringToDate" access="private" returntype="date">
		<cfargument name="data" required="yes" type="string">
		<cfset myData = CreateDate(ListGetAt(arguments.data,3,"/"),ListGetAt(arguments.data,2,"/"),ListGetAt(arguments.data,1,"/"))>
		<cfreturn myData>
	</cffunction>
	
</cfcomponent>
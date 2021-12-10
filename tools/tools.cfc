<cfcomponent>
	<cfset THIS.dsn = "#application.dsn#">
	
	 <!--- Lookup used for auto suggest --->
    <cffunction name="ToDoList" access="remote" returntype="query">
		<cfquery name="qry" datasource="#THIS.dsn#">
		Select DISTINCT(tbl_status.id_cliente) AS idc,
		tbl_status.id_status,
		dt_status,
		DATE_FORMAT(tbl_status.dt_status,'%d/%m/%y') AS data_status,
		DATE_FORMAT(tbl_status.dt_status,'%H:%i') AS ora_status,
		tbl_status.ac_note,
		tbl_status.id_persona,
		tbl_clienti.id_cliente,
		tbl_clienti.id_agente,
		tbl_clienti.ac_cognome,
		tbl_clienti.ac_azienda,
		tbl_clienti.ac_citta,
		tbl_clienti.ac_indirizzo,
		tbl_clienti.ac_telefono,
		tbl_clienti.ac_cellulare,
		tbl_clienti.ac_email,
		tbl_processi.id_processo,
		tbl_processi.ac_processo,
		tbl_processi.ac_sigla,
		tbl_processi.ac_colore,
		tbl_processi.ac_permissions,
		tbl_persone.ac_cognome AS agente
		From
		tbl_status
		Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
		Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
		LEFT JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
		WHERE Day(dt_status) = #day(now())# AND month(dt_status) = #month(now())# AND Year(dt_status) = #year(now())#
		<cfif StructFind(session.userlogin,"livello") GT 1 AND StructFind(session.userlogin,"livello") LT 4>
		AND tbl_clienti.id_agente = #StructFind(session.userlogin,"ID")#
		</cfif>
		<cfif StructFind(session.userlogin,"livello") EQ 4>
		AND tbl_status.id_persona = #StructFind(session.userlogin,"ID")#
		</cfif>
		ORDER BY dt_status ASC 
		</cfquery>
		
			
        <!--- And return it --->
		<cfreturn qry>
    </cffunction>
    
	
</cfcomponent>
<cfcomponent output="false">


   <cfset THIS.dsn="#application.dsn#">


   <!--- Get artists --->
  <!--- Get artists --->
   <cffunction name="getCustomers" access="remote" returntype="query">
    
		
      <!--- Get data --->
      <cfquery name="qry" datasource="#THIS.dsn#">
      SELECT 
	  	id_cliente,
		id_agente,
	  	ac_nome,
		ac_cognome,
		ac_azienda,
		ac_indirizzo,
		ac_citta,
		ac_pv,
		ac_cap,
		ac_telefono
      FROM tbl_clienti
	  ORDER BY dt_data_registrazione DESC
	  </cfquery>

	  <cfreturn qry>
    </cffunction>

   	<cffunction name="getImportati" access="remote" returntype="any">
   		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT 
			id_cliente
	  		FROM tbl_clienti
			WHERE bl_attivo = -1 ORDER BY ac_azienda, ac_cognome
		</cfquery>
   		<cfreturn qry.recordcount>
	</cffunction>
	
	
	<cffunction name="getClienti" access="remote" returntype="any">
		<cfargument name="page" required="yes" type="numeric" default=0>
		<cfargument name="pagesize" required="no" type="numeric" default=30>
		<cfargument name="searchString" required="no" type="string" default="">
		
		<cfset initRow = arguments.page * arguments.pagesize>
      	
		
		<!--- Get data --->
		
      	<cfquery name="qry" datasource="#THIS.dsn#">
      	SELECT 
			tbl_clienti.*
	  		FROM tbl_clienti
			
			<cfif arguments.searchString NEQ "">
				WHERE ac_cognome LIKE '#arguments.searchString#%'
			</cfif>
			ORDER BY ac_cognome
			<cfif arguments.page NEQ -1 AND arguments.searchString EQ "">
				LIMIT #initRow#,#arguments.pagesize#
			</cfif>	
	  	</cfquery>
      <cfreturn qry>
	  
   </cffunction>

   	<cffunction name="getClientiAdvanced" access="remote" returntype="any">
		<cfargument name="page" required="yes" type="numeric" default=0>
		<cfargument name="pagesize" required="no" type="numeric" default=27>
		<cfargument name="searchString" required="no" type="string" default="">
		<cfargument name="id_agente" required="no" default="-1">
		<cfargument name="id_qualifica" required="no" default="1">
		<cfargument name="ac_pv" required="no" type="string" default="">
		<cfargument name="bl_attivo" required="no" type="string" default="1">
		<cfargument name="id_agente_assegnato" required="no" default="">
		<cfargument name="dFrom" required="no" default="">
		<cfargument name="dTo" required="no" default="">
		<cfargument name="fornitore" required="no" default="">
		<cfargument name="fornitore_search" required="no" default="">
		<cfargument name="scopo" required="no" type="numeric" default=0>
		<cfset operatore = "WHERE ">		
		
		<cfif arguments.dFrom NEQ "">
			<cfset date_from = CreateDate(ListGetAt(arguments.dFrom,3,"/"),ListGetAt(arguments.dFrom,2,"/"),ListGetAt(arguments.dFrom,1,"/"))>
		</cfif>
		<cfif arguments.dTo NEQ "">
			<cfset date_to = CreateDate(ListGetAt(arguments.dTo,3,"/"),ListGetAt(arguments.dTo,2,"/"),ListGetAt(arguments.dTo,1,"/"))>
		</cfif>
		
		
		<!--- imposto da quale record iniziare la lettura --->		
		<cfset initRow = arguments.page * arguments.pagesize>
		
		
		<!--- Get data --->
      	<cfquery name="qry" datasource="#THIS.dsn#">
      	Select 
		tbl_persone.id_gruppo,
		tbl_persone.ac_cognome AS agente,
		tbl_clienti.*,
		tbl_gruppi_clienti.id_gruppo AS id_qualifica,
		tbl_gruppi_clienti.ac_icona,
		tbl_gruppi_clienti.ac_gruppo AS qualifica,
		
		tbl_gruppi.id_gruppo AS gruppo
		From
		tbl_clienti
		<cfif arguments.bl_attivo EQ 1>
			INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			LEFT JOIN tbl_gruppi_clienti ON tbl_clienti.id_qualifica = tbl_gruppi_clienti.id_gruppo
			INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
		<cfelse>
			LEFT JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
			LEFT JOIN tbl_gruppi_clienti ON tbl_clienti.id_qualifica = tbl_gruppi_clienti.id_gruppo
			LEFT JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
		
		</cfif>



			<!--- verifica permission --->
			<cfif session.livello LT 4>
			
				<cfif StructFind(session.userlogin,"livello") GT 1>
					#operatore# 
					(tbl_clienti.id_agente = #StructFind(session.userlogin,"id")#
						<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
							<cfset gruppi_abilitati = StructFind(session.userlogin,"gruppi_controllo")>
						OR  tbl_gruppi.id_gruppo IN ( #gruppi_abilitati# )
						</cfif>
					)
					<cfset operatore = " AND ">
				</cfif>	
			<cfelse>
				#operatore# 
				tbl_clienti.id_agente = #StructFind(session.userlogin,"id")#
				<cfset operatore = " AND ">
			</cfif>
			
			<!--- ricerca cognome --->
			<cfif arguments.searchString NEQ "" AND arguments.searchString NEQ "null">
				#operatore# ( tbl_clienti.ac_cognome LIKE '%#arguments.searchString#%' OR tbl_clienti.ac_azienda LIKE '%#arguments.searchString#%' )
				<cfset operatore = " AND ">
			</cfif>
			
			<!--- ricerca per provincia --->
			<cfif arguments.ac_pv NEQ "null">
				#operatore# tbl_clienti.ac_pv = '#arguments.ac_pv#'
				<cfset operatore = " AND ">
			</cfif>
			
			
			<!--- ricerca per agente --->
			<cfif arguments.id_agente_assegnato NEQ "">
				#operatore# tbl_clienti.id_agente = #arguments.id_agente_assegnato#
				<cfset operatore = "AND ">
			<cfelse>
				<!--- ricerca se assegnati o meno (oppure ignora filtro) --->
				<cfif arguments.id_agente NEQ -1>
					<cfif arguments.id_agente EQ 0>
						#operatore# tbl_clienti.id_agente = 0
						<cfset operatore = " AND ">
					<cfelse>	
						#operatore# tbl_clienti.id_agente <> 0
						<cfset operatore = " AND ">
					</cfif>
				</cfif>
			</cfif>
					
			<!--- ricerca per gruppo di appartenenza (attivi, inesistenti, ecc.) --->
			<cfif arguments.id_qualifica NEQ -1>
				<cfif arguments.id_qualifica NEQ -2>
					#operatore# tbl_clienti.id_qualifica = #arguments.id_qualifica#
				<cfelse>
					#operatore# tbl_clienti.id_qualifica > 1	
				</cfif>
				<cfset operatore = " AND ">
			</cfif>
			
			
			<!--- ricerca per periodo di registrazione --->
			<cfif arguments.dFrom NEQ "">
				#operatore# tbl_clienti.dt_data_registrazione >= #date_from#
				<cfset operatore = "AND ">
			</cfif>
			<cfif arguments.dTo NEQ "">
				#operatore# tbl_clienti.dt_data_registrazione <= #date_to#
				<cfset operatore = "AND ">
			</cfif>
			
			<!--- ricerca per segnalatore --->
			<cfif arguments.fornitore NEQ "">
				#operatore# tbl_clienti.ac_segnalatore LIKE "%#arguments.fornitore#%"
				<cfset operatore = "AND ">
			</cfif>
			<cfif arguments.fornitore_search NEQ "">
				#operatore# tbl_clienti.ac_segnalatore LIKE "%#arguments.fornitore_search#%"
				<cfset operatore = "AND ">
			</cfif>
			
			#operatore# tbl_clienti.bl_attivo = #arguments.bl_attivo#
			
			ORDER BY dt_data_registrazione DESC, ac_cognome
			<cfif arguments.scopo EQ 0>
				LIMIT #initRow#,#arguments.pagesize#
			</cfif>
			
	  	</cfquery>
		<cfif arguments.scopo EQ 0>
	      	<cfreturn qry>
		<cfelse>
			<cfif arguments.scopo EQ 2>
				<cfreturn qry>
			<cfelse>
				<cfset pagine = int(qry.recordcount / arguments.pagesize)>
				<cfreturn pagine>		
			</cfif>
		</cfif>	
	  
   </cffunction>

   
   	<!--- ottieni totale clienti --->
   	<cffunction name="totaleClienti" access="remote" returntype="numeric">
		<cfargument name="pagesize" required="yes" default="30" type="numeric">
		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT COUNT(id_cliente) AS numRecords FROM tbl_clienti
		<cfif session.livello GT 2>WHERE id_agente = #StructFind(session.userlogin,"id")#</cfif>
		</cfquery>
		<cfset numOfPages = Int(qry.numRecords/arguments.pagesize)+1>
		<cfreturn numOfPages>
	</cffunction>
	
	
	<!--- assegna agenti --->
	<cffunction name="assegnaAgente" access="remote" returntype="any">
		<cfargument name="id_cliente" required="yes" default="0">
		<cfargument name="id_agente" required="yes" default="0" type="numeric">
		
		<cfif arguments.id_cliente NEQ 0 AND arguments.id_agente NEQ 0>
			<cfset myDate = CreateDateTime(year(now()),month(now()),day(now()),12,0,0)>
			<cfloop index="i" list="#arguments.id_cliente#">
				<cfquery name="qry" datasource="#THIS.dsn#">
					UPDATE tbl_clienti 
					SET 
						id_agente = #arguments.id_agente#,
						bl_attivo = 1
					WHERE id_cliente = #i#
				</cfquery>
				
				<cfquery name="qry" datasource="#THIS.dsn#">
					INSERT INTO tbl_status
					(
						id_cliente,
						id_processo,
						dt_status
					)
					VALUES
					(
						#i#,
						2,
						#myDate#
					)
				</cfquery>
			</cfloop>
		</cfif>
		<cfscript>
		LogAction("Assegna Agente",arguments.id_cliente, arguments.id_agente);
		</cfscript>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="testSave" access="remote" returntype="any">
		<cfargument name="id_cliente" required="no" default="">
		<cfreturn "pippo">
	</cffunction>
	
	
	<!--- SALVA ANAGRAFICA --->
	<cffunction name="saveAnagrafica" access="remote" returntype="any">
	
		<cfargument name="id_cliente" required="Yes">
		<cfargument name="ac_cognome" required="yes" type="string">
		<cfargument name="ac_nome" required="yes" type="string">
		<cfargument name="ac_azienda" required="yes" type="string">
		<cfargument name="ac_indirizzo" required="yes" type="string">
		<cfargument name="ac_citta" required="yes" type="string">
		<cfargument name="ac_pv" required="yes" type="string">
		<cfargument name="ac_cap" required="yes" type="string">
		<cfargument name="ac_telefono" required="yes" type="string">
		<cfargument name="ac_cellulare" required="yes" type="string">
		<cfargument name="ac_email" required="yes" type="string">
		<cfargument name="id_agente_old" required="yes">
		<cfargument name="id_agente" required="no" default="0">
		<cfargument name="ac_segnalatore" required="no" default="">
		
		<cfif arguments.ac_azienda EQ "">
			<cfset arguments.ac_azienda = "#arguments.ac_cognome# #arguments.ac_nome#">
		</cfif>
		
		<cfif arguments.id_cliente NEQ 0>
			<!--- AGGIORNAMENTO ANAGRAFICA --->
			<cfquery name="qry" datasource="#THIS.dsn#">
			UPDATE tbl_clienti 
			SET
				ac_cognome 		= "#Replace(arguments.ac_cognome,'&','e','ALL')#",
				ac_nome 		= "#replace(arguments.ac_nome,'&','e','ALL')#",
				ac_azienda 		= "#replace(arguments.ac_azienda,'&','e','ALL')#",
				ac_indirizzo	= "#arguments.ac_indirizzo#",
				ac_citta		= "#arguments.ac_citta#",
				ac_pv			= "#arguments.ac_pv#",
				ac_cap			= "#arguments.ac_cap#",
				ac_telefono		= "#arguments.ac_telefono#",
				ac_cellulare	= "#arguments.ac_cellulare#",
				ac_email		= "#arguments.ac_email#",
				<cfif arguments.id_agente NEQ "0">id_agente		= #arguments.id_agente#,</cfif>
				ac_segnalatore	= "#arguments.ac_segnalatore#"
				<cfif arguments.id_agente NEQ "">
				,bl_attivo		= 1
				</cfif>
				
			WHERE
				id_cliente		= #arguments.id_cliente#
			</cfquery>
			
			<cfif arguments.id_agente_old NEQ arguments.id_agente AND arguments.id_agente NEQ 0>
				<cfquery name="getAutoProcesso" datasource="#THIS.dsn#">
					SELECT * FROM tbl_processi WHERE int_status = 1
				</cfquery>
				<cfset myDate = CreateDateTime(year(now()),month(now()),day(now()),12,0,0)>
				<cfquery name="qry" datasource="#THIS.dsn#">
					INSERT INTO tbl_status
					(
						id_cliente,
						id_processo,
						dt_status
					)
					VALUES
					(
						#arguments.id_cliente#,
						#getAutoProcesso.id_processo#,
						#myDate#
					)
				</cfquery>
			
			</cfif>
			
			<cfscript>
				LogAction("MOD Anagrafica Cliente", arguments.ac_cognome ,StructFind(session.userlogin,"utente"));
			</cfscript> 
			<cfreturn "Modificata Anagrafica">
		<cfelse>
			<cfif StructFind(session.userlogin,"livello") GT 2>
				<!--- INSERIMENTO ANAGRAFICA DELL'AGENTE--->
				<cfquery name="qry" datasource="#THIS.dsn#">
				INSERT INTO tbl_clienti 
				(
					ac_cognome 		,
					ac_nome 		,
					ac_azienda 		,
					ac_indirizzo	,
					ac_citta		,
					ac_pv			,
					ac_cap			,
					ac_telefono		,
					ac_cellulare	,
					ac_email		,
					id_agente		,
					id_fornitore	,
					ac_segnalatore  ,
					dt_data_registrazione
				)
				VALUES
				(
					"#Replace(arguments.ac_cognome,'&','e','ALL')#",
					"#replace(arguments.ac_nome,'&','e','ALL')#",
					"#replace(arguments.ac_azienda,'&','e','ALL')#",
					"#arguments.ac_indirizzo#",
					"#arguments.ac_citta#",
					"#arguments.ac_pv#",
					"#arguments.ac_cap#",
					"#arguments.ac_telefono#",
					"#arguments.ac_cellulare#",
					"#arguments.ac_email#",
					#StructFind(session.userlogin,"id")#,
					#StructFind(session.userlogin,"id")#,
					"#arguments.ac_segnalatore#",
					#now()#
				)
				</cfquery>
				<cfquery name="getLastId" datasource="#THIS.dsn#">
					SELECT MAX(id_cliente) AS LastId FROM tbl_clienti
				</cfquery>
				<cfquery name="getAutoProcesso" datasource="#THIS.dsn#">
					SELECT * FROM tbl_processi WHERE int_status = 1
				</cfquery>
				<cfset myDate = CreateDateTime(year(now()),month(now()),day(now()),12,0,0)>
				<cfquery name="qry" datasource="#THIS.dsn#">
					INSERT INTO tbl_status
					(
						id_cliente,
						id_processo,
						dt_status
					)
					VALUES
					(
						#getLastId.LastId#,
						#getAutoProcesso.id_processo#,
						#myDate#
					)
				</cfquery>
				<cfscript>
				LogAction("ADD Anagrafica Cliente", arguments.ac_cognome ,StructFind(session.userlogin,"utente"));
				</cfscript>
				<cfreturn "Inserita nuova Anagrafica">
			<cfelse>
				<cfquery name="qry" datasource="#THIS.dsn#">
				INSERT INTO tbl_clienti 
				(
					ac_cognome 		,
					ac_nome 		,
					ac_azienda 		,
					ac_indirizzo	,
					ac_citta		,
					ac_pv			,
					ac_cap			,
					ac_telefono		,
					ac_cellulare	,
					ac_email		,
					id_agente		,
					ac_segnalatore	,
					bl_attivo		,
					dt_data_registrazione
					
				)
				VALUES
				(
					"#arguments.ac_cognome#",
					"#arguments.ac_nome#",
					"#arguments.ac_azienda#",
					"#arguments.ac_indirizzo#",
					"#arguments.ac_citta#",
					"#arguments.ac_pv#",
					"#arguments.ac_cap#",
					"#arguments.ac_telefono#",
					"#arguments.ac_cellulare#",
					"#arguments.ac_email#",
					
					<cfif arguments.id_agente EQ 0 AND session.livello EQ 2>
						#StructFind(session.userlogin,"id")#,
					<cfelse>
						#arguments.id_agente#,
					</cfif>
					<cfif arguments.ac_segnalatore EQ "">
						"#StructFind(session.userlogin,'utente')#",
					<cfelse>
						"#ac_segnalatore#",
					</cfif>
					1,
					#now()#
				)
				</cfquery>
				<cfquery name="getLastId" datasource="#THIS.dsn#">
					SELECT MAX(id_cliente) AS LastId FROM tbl_clienti
				</cfquery>
				<cfquery name="getAutoProcesso" datasource="#THIS.dsn#">
					SELECT * FROM tbl_processi WHERE int_status = 1
				</cfquery>
				<cfset myDate = CreateDateTime(year(now()),month(now()),day(now()),Hour(now()),0,0)>
				<cfquery name="qry" datasource="#THIS.dsn#">
					INSERT INTO tbl_status
					(
						id_cliente,
						id_processo,
						dt_status
					)
					VALUES
					(
						#getLastId.LastId#,
						#getAutoProcesso.id_processo#,
						#myDate#
					)
				</cfquery>
				<cfscript>
				LogAction("ADD Anagrafica Cliente", arguments.ac_cognome ,StructFind(session.userlogin,"utente"));
				</cfscript>
				<cfreturn "Inserita nuova Anagrafica">	
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="deleteAnagrafica" access="remote" returntype="any">
		<cfargument name="id_cliente_delete" required="yes" type="numeric">
		<cfquery name="checkStatus" datasource="#THIS.dsn#">
		SELECT id_cliente FROM tbl_status WHERE id_cliente = #arguments.id_cliente_delete#
		</cfquery>
		
		<cfif checkStatus.recordcount GT 0>
			<cfreturn false>
		<cfelse>
			<cfquery name="qry" datasource="#THIS.dsn#">
			DELETE FROM tbl_clienti WHERE  id_cliente = #arguments.id_cliente_delete#
			</cfquery>
			<cfreturn true>	
		</cfif>
		
	</cffunction>
	<!--- ottieni la lista della qualifica dei clienti --->
	<cffunction name="getQualificaClienti" access="remote" returntype="any">
		<cfquery name="qry" datasource="#THIS.dsn#">
		Select * FROM tbl_gruppi_clienti
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	<!--- salva nuova qualifica del cliente --->
	<cffunction name="saveQualifica" access="remote" returntype="any">
		<cfargument name="id_cliente" required="yes" type="numeric">
		<cfargument name="id_qualifica" required="yes" type="numeric">
		<cfquery name="qry" datasource="#THIS.dsn#">
		UPDATE tbl_clienti 
			SET id_qualifica = #arguments.id_qualifica# 
		WHERE id_cliente = #arguments.id_cliente#
		</cfquery> 
		<cfscript>
				LogAction("MOD Qualifica Cliente", arguments.id_cliente ,StructFind(session.userlogin,"utente"));
			</cfscript>
		<cfreturn arguments.id_qualifica>
	</cffunction>
	
   <!--- Edit an artist --->
   <cffunction name="editCustomer" access="remote">
      <cfargument name="gridaction" type="string" required="yes">
      <cfargument name="gridrow" type="struct" required="yes">
      <cfargument name="gridchanged" type="struct" required="yes">

      <!--- Local variables --->
      <cfset var colname="">
      <cfset var value="">

      <!--- Process gridaction --->
      <cfswitch expression="#ARGUMENTS.gridaction#">
         <!--- Process updates --->
         <cfcase value="U">
            <!--- Get column name and value --->
            <cfset colname=StructKeyList(ARGUMENTS.gridchanged)>
            <cfset value=ARGUMENTS.gridchanged[colname]>
            <!--- Perform actual update --->
            <cfquery datasource="#THIS.dsn#">
            UPDATE tbl_clienti
            SET #colname# = '#value#'
            WHERE id_cliente = #ARGUMENTS.gridrow.id_cliente#
            </cfquery>
         </cfcase>
		 
		 
         <!--- Process deletes --->
         <cfcase value="D">
            <!--- Perform actual delete --->
            <cfquery datasource="#THIS.dsn#">
            DELETE FROM tbl_clienti
            WHERE id_cliente = #ARGUMENTS.gridrow.id_cliente#
            </cfquery>
         </cfcase>
      </cfswitch>
   </cffunction>


    <!--- Lookup used for auto suggest --->
    <cffunction name="lookupCustomer" access="remote" returntype="string">
		<cfargument name="search" type="any" required="false" default="">

		<!--- Define variables --->
		<!--- <cfset var data="">
		<cfset var result=ArrayNew(1)> --->
		
		<!--- Do search --->
		<cfquery datasource="#THIS.dsn#" name="data">
		SELECT DISTINCT ac_cognome
		FROM tbl_clienti
		WHERE 
			UCase(ac_cognome) = Ucase('#ARGUMENTS.search#')
		ORDER BY ac_cognome
		</cfquery>
		
			
        <!--- And return it --->
		<cfreturn ValueList(data.ac_cognome)>
    </cffunction>
    
	<cffunction name="getAgenti" access="remote" returntype="query">
		<cfset operatore = " WHERE ">
		
		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT id_persona,
		UPPER(CONCAT(ac_cognome," " ,ac_nome)) AS agente,
		ac_cognome,
		ac_nome
		FROM tbl_persone
		
			<cfif session.livello LT 2>
				#operatore# id_gruppo <> 0
			<cfelse>
				<cfif session.livello EQ 2>
					<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
					#operatore#
					( 
						id_gruppo IN ( #StructFind(session.userlogin,"gruppi_controllo")# )
					)
					<cfelse>
					#operatore#
						id_gruppo = #StructFind(session.userlogin,"id_gruppo")#
					</cfif>
				<cfelse>
					<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
					#operatore#
					( 
						id_gruppo IN ( #StructFind(session.userlogin,"gruppi_controllo")# )
					)
					<cfelse>
					#operatore#
						id_gruppo = #StructFind(session.userlogin,"id_gruppo")#
					</cfif>		
				</cfif>
			</cfif>
		
		ORDER BY ac_cognome, ac_nome
		</cfquery>
		
		<cfreturn qry>
		
	</cffunction>
	
	
	
   <!--- Lookup used for auto suggest --->
    <cffunction name="getCustomerData" access="remote" returntype="any">
		<cfargument name="search" type="any" required="false" default="">

		<!--- Define variables --->
		<!--- <cfset var data="">
		<cfset var result=ArrayNew(1)> --->
		
		<!--- Do search --->
		<cfquery datasource="#THIS.dsn#" name="data">
		SELECT *
		FROM tbl_clienti
		WHERE 
			UCase(ac_cognome) = Ucase('#ARGUMENTS.search#')
			
		ORDER BY ac_azienda
		</cfquery>
		
		<!--- <!--- Build result array --->
		<cfloop query="data">
		<cfset ArrayAppend(result, artname)>
		</cfloop> --->
		
        <!--- And return it --->
		<cfreturn data>
    </cffunction>
   
   
   
   
   
   <cffunction name="getSchedule" access="remote" returntype="struct">
     <cfargument name="page" type="numeric" required="yes">
      <cfargument name="pageSize" type="numeric" required="yes">
      <cfargument name="gridsortcolumn" type="string" required="no" default="">
      <cfargument name="gridsortdir" type="string" required="no" default="">

      <!--- Local variables --->
      <cfset var artists="">
	 <!--- CONCAT(Dayofmonth(dt_schedule) ,'/' ,  Month(dt_schedule) ,'/', Year(dt_schedule)) --->
      <!--- Get data --->
      <cfquery name="events" datasource="mood">
      SELECT Date_format(dt_schedule,'%d-%m-%y') AS dt_event, ac_venue
      FROM tbl_scheduling
      <cfif ARGUMENTS.gridsortcolumn NEQ ""
         and ARGUMENTS.gridsortdir NEQ "">
         ORDER BY #ARGUMENTS.gridsortcolumn# #ARGUMENTS.gridsortdir#
      <cfelse>
	  	ORDER BY dt_schedule DESC	 
      </cfif>
      </cfquery>

      <!--- And return it as a grid structure --->
      <cfreturn QueryConvertForGrid(events,
                     ARGUMENTS.page,
                     ARGUMENTS.pageSize)>
   </cffunction>

   
   <cffunction name="province" access="remote" returntype="query">
   		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT * FROM tbl_province WHERE ac_sigla_nazione = 'IT' ORDER BY ac_sigla
		</cfquery>
		<cfreturn qry>
   </cffunction>
   
   
   	<cffunction name="LogAction" access="private">
		<cfargument name="action" required="yes">
		<cfargument name="target" required="yes">
		<cfargument name="valore" requider="yes">
		<cflog text="#arguments.action# > #arguments.target# > #arguments.valore#" file="sav_actions" type="Information">
   	</cffunction>
   
   <cffunction name="getProvince" access="remote" returntype="any">
   		<cfquery name="qryProvince" datasource="configuratore">
		SELECT * FROM istat_province
		ORDER BY sigla_automobilistica
		</cfquery>
		<cfreturn qryProvince>
   </cffunction>
   
   <cffunction name="getComune" access="remote" returntype="any">
   		<cfargument name="id_provincia" required="yes">
		<cfquery name="qryComuni" datasource="configuratore">
			SELECT * FROM istat_comuni
			WHERE id_provincia = #arguments.id_provincia#
			ORDER BY denominazione
		</cfquery>
		<cfreturn qryComuni>
   </cffunction>
   
</cfcomponent>

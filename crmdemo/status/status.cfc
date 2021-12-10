<cfcomponent>
	<cfset THIS.docs_folder = "#expandpath('..')#\docs\status">
	
	<cffunction name="getAgenti" access="remote" returntype="query">
	
		<cfset operatore = " WHERE ">
		
		<cfquery name="qry" datasource="#application.dsn#">
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
					#operatore#
					id_persona = #StructFind(session.userlogin,"id")#			
				</cfif>
			</cfif>
		
		ORDER BY ac_cognome, ac_nome
		</cfquery>
		
		<cfreturn qry>
		
	</cffunction>
	
	<cffunction name="getGruppiAgenti" access="remote" returntype="query" hint="Restituisce i gruppi Agenti/Commerciali">
		<cfquery name="qry" datasource="#application.dsn#">
		SELECT * FROM tbl_gruppi WHERE int_livello = 3 ORDER BY ac_gruppo
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	<cffunction name="getProcessi" access="remote" returntype="query">
		<cfquery name="qryP" datasource="#application.dsn#">
		SELECT * FROM tbl_processi
		ORDER BY int_ordine
		</cfquery>
		<cfreturn qryP>
	</cffunction>
	
	<cffunction name="getProcessiAgente" access="remote" returntype="query">
		<cfquery name="qryP" datasource="#application.dsn#">
		SELECT 
			tbl_processi.*,
			tbl_clienti.id_cliente,
			tbl_clienti.id_agente
			
		 FROM tbl_processi
		 INNER JOIN tbl_clienti ON tbl_processi.id_cliente = tbl_clienti.id_clienti
		 WHERE tbl_clienti.id_agente = #StructFind(session.userlogin,"id")#
		ORDER BY int_ordine
		</cfquery>
		<cfreturn qryP>
	</cffunction>
	
	<cffunction name="getUtentiGruppo" access="remote" returntype="query">
		<cfargument name="id_gruppo" required="yes" type="numeric">
		<cfquery name="qry" datasource="#application.dsn#">
		SELECT * FROM tbl_persone 
		WHERE id_gruppo = #arguments.id_gruppo#
		ORDER BY ac_cognome, ac_nome
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	<!--- aggiunge un processo allo status --->
	<cffunction name="addProcesso" access="remote" returntype="any">
		<cfargument name="id_status" required="yes" type="numeric">
		<cfargument name="id_cliente" required="yes" type="numeric">
		<cfargument name="id_processo" required="Yes" type="numeric">
		<cfargument name="dt_status" required="Yes" type="string">
		<cfargument name="ac_ora" required="Yes" type="string">
		<cfargument name="ac_valore" required="Yes" type="string">
		<cfargument name="ac_note" required="Yes" type="string">
		<cfargument name="modulo_uuid" required="Yes" type="string"> 
		<cfargument name="lista_docs" required="Yes" type="string">
		
		<cfset data_status = CreateDateTime(ListGetAt(arguments.dt_status,3,"/"),ListGetAt(arguments.dt_status,2,"/"),ListGetAt(arguments.dt_status,1,"/"),Int(ListGetAt(arguments.ac_ora,1,":")),Int(ListGetAt(arguments.ac_ora,2,":")),0)>
		
			<cfquery name="qry" datasource="#application.dsn#">
			INSERT INTO tbl_status
			(
				id_cliente		,
				id_processo		,
				dt_status		,
				ac_valore		,
				ac_note			,
				ac_modulo_uuid	,
				ac_docs
			)
			VALUES
			(
				#arguments.id_cliente#		,
				#arguments.id_processo#		,
				#data_status#				,
				"#arguments.ac_valore#"		,
				"#arguments.ac_note#"		,
				"#arguments.modulo_uuid#"	,
				"#arguments.lista_docs#"	
			)
			</cfquery>
			<cfif arguments.id_processo EQ 9>
				<cfquery name="updateRichieste" datasource="#application.dsn#">
				UPDATE tbl_status
				SET bl_evasa = 1 WHERE id_processo = 6 AND id_cliente = #arguments.id_cliente#
				</cfquery>
			</cfif>
		<!--- LOG INSERIMENTO PROCESSO ---->
		<cfscript>
			LogAction("ADD Processo" , arguments.id_status , StructFind(session.userlogin,"utente")); 
		</cfscript>
		<cfreturn arguments.modulo_uuid>
	</cffunction>
	
	<!--- modifica un processo dello status --->
	<cffunction name="saveProcesso" access="remote" returntype="any">
		<cfargument name="id_status" required="yes" type="numeric">
		<cfargument name="ac_ora" required="Yes" type="string">
		<cfargument name="dt_status" required="Yes" type="string">
		<cfargument name="ac_valore" required="Yes" type="string">
		<cfargument name="ac_note" required="No" type="string" default=""> 
		<cfargument name="ac_modulo_uuid" required="No" type="string" default=""> 
		<cfargument name="lista_docs" required="No" type="string" default="">
		
		<cfset data_status = CreateDateTime(ListGetAt(arguments.dt_status,3,"/"),ListGetAt(arguments.dt_status,2,"/"),ListGetAt(arguments.dt_status,1,"/"),Int(ListGetAt(arguments.ac_ora,1,":")),Int(ListGetAt(arguments.ac_ora,2,":")),0)>
		
			<cfquery name="qry" datasource="#application.dsn#">
			UPDATE tbl_status
			SET
				dt_status 		= #data_status#,
				ac_note 		= '#arguments.ac_note#',
				ac_modulo_uuid 	= "#arguments.ac_modulo_uuid#",
				ac_valore		= "#arguments.ac_valore#",
				ac_docs			= "#arguments.lista_docs#"
			WHERE 
				id_status = #arguments.id_status#	
			</cfquery>
			
			
			
		<!--- LOG MODIFICA PROCESSO ---->	
		<cfscript>
			LogAction("MOD Processo " , arguments.id_status , StructFind(session.userlogin,"utente"));
		</cfscript>
		<cfreturn arguments.dt_status>
	</cffunction>
	
	<!--- rimuove un processo --->
	<cffunction name="deleteProcesso" access="remote" returntype="any">
		<cfargument name="id_status" required="Yes" type="numeric">
		<cfquery name="dati" datasource="#application.dsn#">
		SELECT * FROM tbl_status WHERE id_status = #arguments.id_status#
		</cfquery>
		<cfset folder = dati.id_cliente>
		<cfset docs = dati.ac_docs>
		<cfif docs NEQ "">
			<cfloop index="i" list="#docs#">
				<cffile action="DELETE" file="#expandpath('..')#\docs\status\#folder#\#i#">
			</cfloop>
		</cfif>
		<cfset thisCliente = dati.id_cliente>
		<cfset thisProcesso = dati.id_processo>
		<cfif thisProcesso EQ 9>
			<cfquery name="updateRichiesta" datasource="#application.dsn#">
			UPDATE tbl_status SET
			bl_evasa = 0 WHERE id_cliente = #thisCliente# AND id_processo = 6
			</cfquery>
		</cfif>
		<cfquery name="qry" datasource="#application.dsn#">
			DELETE FROM tbl_status WHERE id_status = #arguments.id_status#
		</cfquery>
		<cfoutput>
		<cfset myLog = "DEL Processo (#dati.id_processo#) Cliente">
		</cfoutput>
		
		<!--- LOG ELIMINA PROCESSO ---->
		<cfscript>
			LogAction(myLog, dati.id_cliente , StructFind(session.userlogin,"utente")); 
		</cfscript>
		<cfreturn "Deleted">
	</cffunction>
	
	<cffunction name="nextWorkDate" access="remote" returntype="any">
		<cfargument name="data" required="yes" type="date">
		<cfargument name="ore" required="yes" type="numeric" default=24>
		<cfset myDate = arguments.data>
		<cfset ore = arguments.ore>
		
		<!--- calcolo pasqua --->
		<cfset anno = year(data)>
		<cfset a = anno mod 19>
		<cfset b = anno mod 4>
		<cfset c = anno mod 7>
		<cfset d = ((19 * a)+24) mod 30>
		<cfset e = ((2*b) + (4*c) + (6*d) + 5) mod 7>
		<cfset calcolo = d + e>
		<cfif calcolo GT 10>
			<cfset calcolo = calcolo - 9>
			<cfif calcolo EQ 26 OR calcolo EQ 25>
				<cfset calcolo = calcolo-7>
			</cfif>
			<cfset pasqua = "#calcolo#/04">
			<cfset pasquetta = "#calcolo+1#/04">
		<cfelse>
			<cfset calcolo = calcolo + 22>
			<cfset pasqua = "#calcolo#/03">
			<cfset pasquetta = "#calcolo+1#/03">
		</cfif>
		<!--- FESTIVITA  --->
		<cfset myFestivita = "01/01,06/01,#pasqua#,#pasquetta#,01/05,02/06,15/08,01/11,08/11,25/12,26/12">

		<cfset checkFestivita = DateFormat(now(),"dd/mm")>
		<!--- calcolo la nuova ipotetica data --->
		<cfset newTrigger = DateAdd("H",ore,myDate)>
		<!--- controllo se è sabato (calcolo per la pasqua) --->
		<cfif DayOfWeek(newTrigger) EQ 7>
			<cfset newTrigger = DateAdd("H",24,newTrigger)>
		</cfif>
		<!--- controllo se la data è una festivita --->		
		<cfloop index="i" list="#myFestivita#">
			<cfif i EQ DateFormat(newTrigger,"dd/mm")>
				<cfset newTrigger = DateAdd("H",24,newTrigger)>
				<cfset myDate = newTrigger>
			</cfif>
		</cfloop>
			
		<cfif DayOfWeek(newTrigger) EQ "1">
			<!--- se la nuova data è domenica --->
			<cfset newTrigger = DateAdd("H",24,newTrigger)>
		</cfif>
		<cfif DayOfWeek(newTrigger) EQ 7>
			<!--- se la nuova data e sabato --->
			<cfset newTrigger = DateAdd("H",48,newTrigger)>
		</cfif>
		
		<cfreturn newTrigger>
	</cffunction>
	
	<!--- sposta i documenti caricati nella cartella del cliente --->
	<cffunction name="moveDocs" access="remote" returntype="any">
		<cfargument name="id_cliente" required="yes" type="any">
		<cfargument name="id_status" required="yes" type="any">
		<cfargument name="lista_docs" required="yes" type="any">
		
		<cfif DirectoryExists("#THIS.docs_folder#\#arguments.id_cliente#") IS FALSE>
			<cfdirectory action="CREATE" directory="#THIS.docs_folder#\#arguments.id_cliente#">
		</cfif>
		
		<cfloop index="i" list="#arguments.lista_docs#">
			<cffile action="MOVE" source="#THIS.docs_folder#\#i#" destination="#THIS.docs_folder#\#arguments.id_cliente#\">
		</cfloop>
		
		<cfquery name="getDocs" datasource="#application.dsn#">
		SELECT ac_docs FROM tbl_status WHERE id_status = #arguments.id_status#
		</cfquery>
		<cfset myDocs = "#getDocs.ac_docs##arguments.lista_docs#">
		<cfquery name="qry" datasource="#application.dsn#">
			UPDATE tbl_status
			SET ac_docs = '#myDocs#'
			WHERE id_status = #arguments.id_status#
		</cfquery>
		<cfset myLog = "ADD Allegati #arguments.lista_docs#">
		<cfscript>
			LogAction(myLog,arguments.id_status,StructFind(session.userlogin,"utente"));
		</cfscript>
		<cfreturn true>
	</cffunction>
	
	<!--- lista dei moduli associata ai processi ---->
	<cffunction name="getModuli" access="remote" returntype="any">
		<cfquery name="qry" datasource="#application.dsn#">
		SELECT int_ordine, ac_modulo FROM tbl_processi ORDER BY int_ordine
		</cfquery>
		<cfreturn ValueList(qry.ac_modulo)>
	</cffunction>
	
	<!--- lista dei campi associata al modulo richiesto ---->
	<cffunction name="getCampiModulo" access="remote" returntype="query">
		<cfargument name="ac_modulo" required="yes" type="string">
		<cfquery name="qry" datasource="#application.dsn#">
		SELECT 
		tbl_moduli_fields.* ,
		tbl_moduli.ac_modulo,
		tbl_processi.ac_processo,
		tbl_processi.ac_sigla
		FROM tbl_moduli_fields 
		INNER JOIN tbl_moduli ON tbl_moduli_fields.id_modulo = tbl_moduli.id_modulo
		LEFT JOIN tbl_processi ON tbl_moduli_fields.id_processo = tbl_processi.id_processo
		WHERE tbl_moduli.ac_modulo = '#arguments.ac_modulo#'
		ORDER BY ac_sezione, tbl_moduli_fields.int_ordine
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	<!--- cancella un documento dello status ---->
	<cffunction name="deleteDoc" access="remote" returntype="any">
		<cfargument name="file" required="yes" type="string">
		<cfargument name="folder" required="yes" type="numeric">
		<cfargument name="id_status" required="yes" type="numeric">

		<cfquery name="getDocs" datasource="#application.dsn#">
		SELECT ac_docs FROM tbl_status WHERE id_status = #arguments.id_status#
		</cfquery>
		<cfif ListLen(getDocs.ac_docs) GT 1>
			<cfset findPos = ListFindNoCase(getDocs.ac_docs,arguments.file)>
			<cfset myNewList = ListDeleteAt(getDocs.ac_docs,findPos)>
		<cfelse>
			<cfset myNewList = "">	
		</cfif>
		
		<cfquery name="qry" datasource="#application.dsn#">
		UPDATE tbl_status SET ac_docs = '#myNewList#' WHERE id_status = #arguments.id_status#
		</cfquery>		
		<cffile action="DELETE" file="#expandpath('..')#\docs\status\#arguments.folder#\#arguments.file#">

		<cfset myLog = "DEL Allegato #arguments.file#">
		<cfscript>
			LogAction(myLog, arguments.folder , StructFind(session.userlogin,"utente"));
		</cfscript>
		<cfreturn arguments.id_status>
	</cffunction>
	
	
	<!--- Crea log delle operazioni principali effettuate --->
	<cffunction name="LogAction" access="private">
		<cfargument name="action" required="yes">
		<cfargument name="target" required="yes">
		<cfargument name="valore" requider="yes">
		<cflog text="#arguments.action# > #arguments.target# > #arguments.valore#" file="sav_actions" type="Information">
   	</cffunction>
	
	
	<!--- ottieni la lista della qualifica dei clienti --->
	<cffunction name="getQualificaClienti" access="remote" returntype="any">
		<cfquery name="qry" datasource="#application.dsn#">
		Select * FROM tbl_gruppi_clienti
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	<!--- salva la nuova qualifica del cliente --->
	<cffunction name="saveQualifica" access="remote" returntype="any">
		<cfargument name="id_cliente" required="yes" type="numeric">
		<cfargument name="id_qualifica" required="yes">
		<cfquery name="qry" datasource="#application.dsn#">
		UPDATE tbl_clienti 
			SET id_qualifica = #arguments.id_qualifica# 
		WHERE id_cliente = #arguments.id_cliente#
		</cfquery> 
		<cfscript>
				LogAction("MOD Qualifica Cliente", arguments.id_cliente ,StructFind(session.userlogin,"utente"));
			</cfscript>
		<cfreturn arguments.id_qualifica>
	</cffunction>
	
	<!--- salva l'assegnazione di un processo ad un utente specifico ---->
	<cffunction name="saveAssegnazioneProcesso" access="remote" returntype="any">
		<cfargument name="id_status" required="yes" type="numeric">
		<cfargument name="id_persona" required="yes" type="numeric">
		<cfquery name="qry" datasource="#application.dsn#">
		UPDATE tbl_status
			SET id_persona = #arguments.id_persona#
		WHERE id_status = #arguments.id_status#
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getStatus" access="remote" returntype="any">
		<cfargument name="id_status" type="numeric" default="2" required="yes">
		<cfquery name="qry" datasource="#application.dsn#">
		SELECT 
			tbl_status.* ,
			DATE_FORMAT(dt_status,'%d/%m/%y') AS data_status,
			DATE_FORMAT(dt_status,'%H:%i') AS ora_status
		FROM tbl_status 
		WHERE id_status = #arguments.id_status#
		</cfquery>
		<cfscript>

// Define the local scope.
var LOCAL = StructNew();

// Get the column names as an array.
LOCAL.Columns = ListToArray( qry.ColumnList );

// Create an array that will hold the query equivalent.
LOCAL.QueryArray = ArrayNew( 1 );

// Loop over the query.
for (LOCAL.RowIndex = 1 ; LOCAL.RowIndex LTE qry.RecordCount ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){

// Create a row structure.
LOCAL.Row = StructNew();

// Loop over the columns in this row.
for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE ArrayLen( LOCAL.Columns ) ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){

// Get a reference to the query column.
LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];

// Store the query cell value into the struct by key.
LOCAL.Row[ LOCAL.ColumnName ] = qry[ LOCAL.ColumnName ][ LOCAL.RowIndex ];

}

// Add the structure to the query array.
ArrayAppend( LOCAL.QueryArray, LOCAL.Row );

}

// Return the array equivalent.
return( LOCAL.QueryArray );

</cfscript>
	</cffunction>
</cfcomponent>

<!--- DATE_FORMAT(dt_status,'%d/%m%y') AS data_status,
			DATE_FORMAT(dt_status,'%H:%i') AS ora_status --->
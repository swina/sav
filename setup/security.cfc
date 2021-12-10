<cfcomponent>
	<cfset THIS.dsn = "#application.dsn#">
	
	<!---- autenticazione utente  --->
	<cffunction name="checkLogin" access="remote" returntype="any">
   		<cfargument name="ac_utente" required="yes" type="string">
		<cfargument name="ac_password" required="yes" type="string">
		<cfset h_password = hash(arguments.ac_password,"MD5")>
		<cfif arguments.ac_utente NEQ "" OR arguments.ac_password NEQ "">
		<cfquery name="qry" datasource="#THIS.dsn#">
			SELECT 
				tbl_persone.* ,
				tbl_gruppi.ac_gruppo,
				tbl_gruppi.int_livello
			FROM tbl_persone 
			INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
			WHERE 
				ac_utente = '#arguments.ac_utente#'
				AND
				ac_password = '#arguments.ac_password#'
				AND
				bl_cancellato = 0
		</cfquery>
		<cfif qry.recordcount GT 0>
			<cfscript>
				session.userlogin = StructNew();
				StructInsert(session.userlogin,"login", true);
				StructInsert(session.userlogin,"utente", "#qry.ac_nome# #qry.ac_cognome#");
				StructInsert(session.userlogin,"email", qry.ac_email);
				StructInsert(session.userlogin,"id", qry.id_persona);
				StructInsert(session.userlogin,"gruppi_controllo",qry.ac_gruppi);
				StructInsert(session.userlogin,"id_gruppo", qry.id_gruppo);
				StructInsert(session.userlogin,"gruppo", qry.ac_gruppo);
				StructInsert(session.userlogin,"livello", qry.int_livello);
			</cfscript>
			<cfset session.livello = qry.int_livello>
			<cfset session.login = true>
			<!--- <cfset application.sessions = application.sessions + 1> --->
			<cfscript>
			LogLogin(session.userlogin,"login");
			</cfscript>
			<cfset username = "#qry.ac_nome#">
			<cfreturn username>
		<cfelse>
			<cfreturn "KO">
		</cfif>
		<cfelse>
			<cfreturn "KO">
		</cfif>
   </cffunction>
   
   <!--- logout ---->
   <cffunction name="logout" access="remote" returntype="any">
   		<cfset session.login = false>
		<cfif IsDefined("application.sessions")>
			<cfset application.sessions = application.sessions - 1>
		</cfif>
		<cfset utente = StructFind(session.userlogin,"utente")>
		<cfscript>
		LogLogin(session.userlogin,"logout");
		</cfscript>
		<cfreturn utente>
		
   </cffunction>
	
	<!--- recupera dati profilo utente --->
	<cffunction name="getProfilo" access="remote" returntype="query">
		<cfquery name="qry" datasource="#THIS.dsn#">
		SELECT * FROM tbl_persone WHERE id_persona = #StructFind(session.userlogin,"id")#
		</cfquery>
		<cfreturn qry>
	</cffunction>
	
	<cffunction name="LogLogin" access="private">
		<cfargument name="structLogin" required="Yes" type="struct">
		<cfargument name="tipo" requider="Yes" type="string">
		<cfset myLog = StructFind(arguments.structLogin,"login")>
		<cfset myUser = StructFind(arguments.structLogin,"utente")>
		<cflog text="#UCASE(arguments.tipo)# User #myUser# (#UCASE(myLog)#)" log="APPLICATION" file="sav_login" type="Information"> 
	</cffunction>	
	
</cfcomponent>
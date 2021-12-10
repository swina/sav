<cfcomponent>
	<cfset THIS.dsn = "#application.dsn#">
	
	<cffunction name="getMsg" access="remote" returntype="any">
		<cfargument name="dateFrom"			required="yes">
		<cfargument name="dateTo"			required="yes">
		<cfargument name="id_gruppo_agenti"	required="yes">
		<cfargument name="id_agente"		required="yes">
		<cfargument name="tutti" 			required="no" default="false">
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
		
		<cfquery name="qryMessages" datasource="#application.dsn#">
		SELECT 
			tbl_messages.* 			,
			tbl_gruppi.ac_gruppo	,
			tbl_persone.ac_cognome	
		FROM tbl_messages
		LEFT JOIN tbl_gruppi ON tbl_messages.id_to_gruppo = tbl_gruppi.id_gruppo
		LEFT JOIN tbl_persone ON tbl_messages.id_to = tbl_persone.id_persona
		WHERE
			( dt_message >= #dFrom# AND dt_message <= #DateAdd("d",1,dTo)# )
			<cfif arguments.tutti IS FALSE>
			
				<cfif arguments.id_gruppo_agenti NEQ "">
				AND
				(
					id_to_gruppo IN ( #arguments.id_gruppo_agenti# )
				)
				<cfelse>
					<cfif arguments.id_agente NEQ "">
						AND
						(
							id_to IN ( #arguments.id_agente# )
						)
					<cfelse>
						<cfif session.livello GT 1>
						AND 
						( 
							id_to_gruppo IN ( #StructFind(session.userlogin,"gruppi_controllo")# )
							OR
							id_to IN ( #StructFind(session.userlogin,"id")# )
							OR
							id_to = -1
						)
						</cfif>
					</cfif>	
				</cfif>	
				
			<cfelse>
				<cfif session.livello GT 1>
				AND 
				( 
					id_to_gruppo IN ( #StructFind(session.userlogin,"gruppi_controllo")# )
					OR
					id_to IN ( #StructFind(session.userlogin,"id")# )
					OR
					id_to = -1
				)
				
				</cfif>	
			</cfif>
		ORDER BY id_message DESC	
			
		</cfquery> 
		<cfreturn qryMessages>
	</cffunction>
	
	<cffunction name="addMsg" access="remote" returntype="any">
		<cfargument name="id_from" 			required="yes">
		<cfargument name="id_gruppo" 		required="yes">
		<cfargument name="id_agente" 		required="yes">
		<cfargument name="ac_subject" 		required="yes">
		<cfargument name="ac_message"		required="yes">
		<cfargument name="invio_generale" 	required="yes">
		<cfif arguments.invio_generale EQ "-1">
			<cfset arguments.id_gruppo = -1>
			<cfset arguments.id_agente = -1>
		</cfif>
		
		<cfquery name="qryAdd" datasource="#application.dsn#">
		INSERT INTO tbl_messages
			(
				id_from		 ,
				id_to_gruppo ,
				id_to		 ,
				dt_message	 ,
				ac_subject	 ,
				ac_message
			)
			VALUES
			(
				#arguments.id_from#			,
				#arguments.id_gruppo#		,
				#arguments.id_agente#		,
				#now()#						,
				"#arguments.ac_subject#"	,
				"#arguments.ac_message#"
			)
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getMessagesReceived" access="remote" returntype="any">
		
		<cfquery name="qryMessages" datasource="#application.dsn#">
		SELECT 
			tbl_messages.* 			,
			tbl_gruppi.ac_gruppo	,
			tbl_persone.ac_cognome	
		FROM tbl_messages
		LEFT JOIN tbl_gruppi ON tbl_messages.id_to_gruppo = tbl_gruppi.id_gruppo
		LEFT JOIN tbl_persone ON tbl_messages.id_to = tbl_persone.id_persona
		WHERE
			(dt_message >= #DateAdd("d",-2,now())# AND dt_message <= #now()#)
			AND
			(
			id_to_gruppo = #StructFind(session.userlogin,"id_gruppo")#
			OR
			id_to = #StructFind(session.userlogin,"ID")#
			OR
			id_to = -1
			)
		ORDER BY id_message DESC	
			
		</cfquery> 
		<cfreturn qryMessages>
	</cffunction>
	
	<cffunction name="deleteMsg" access="remote" returntype="any">
		<cfargument name="id_message" required="yes">
		<cfquery name="qryDeleteMsg" datasource="#THIS.dsn#">
		DELETE FROM tbl_messages WHERE id_message = #arguments.id_message#
		</cfquery>
		<cfreturn true>
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
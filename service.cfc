<cfcomponent output="false">


   <cfset THIS.dsn="#application.dsn#">


   <!--- Get artists --->
  <!--- Get artists --->
   <cffunction name="getCustomers" access="remote" returntype="query">
     <!--- <cfargument name="page" type="numeric" required="yes">
      <cfargument name="pageSize" type="numeric" required="yes">
      <cfargument name="gridsortcolumn" type="string" required="no" default="">
      <cfargument name="gridsortdir" type="string" required="no" default="">
 --->

      <!--- Get data --->
      <cfquery name="qry" datasource="#THIS.dsn#">
      SELECT 
	  	id_cliente,
	  	ac_nome,
		ac_cognome,
		ac_azienda,
		ac_indirizzo,
		ac_citta,
		ac_pv,
		ac_cap,
		ac_telefono
      FROM tbl_clienti
      <!--- <cfif ARGUMENTS.gridsortcolumn NEQ ""
         and ARGUMENTS.gridsortdir NEQ "">
         ORDER BY #ARGUMENTS.gridsortcolumn# #ARGUMENTS.gridsortdir#
      </cfif> --->
      </cfquery>

	  <cfreturn qry>
      <!--- And return it as a grid structure --->
<!---       <cfreturn QueryConvertForGrid(qry,
                     ARGUMENTS.page,
                     ARGUMENTS.pageSize)> --->
   </cffunction>

   
   <cffunction name="getClienti" access="remote" returntype="any">

      <!--- Get data --->
      <cfquery name="qry" datasource="#THIS.dsn#">
      SELECT id_cliente,ac_azienda,ac_cognome,ac_nome FROM tbl_clienti
      </cfquery>
      <cfreturn qry>
	  
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
		SELECT 
		tbl_clienti.ac_azienda
		FROM tbl_clienti
		LEFT JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
		WHERE 
			UCASE(tbl_clienti.ac_azienda) LIKE UCASE('#ARGUMENTS.search#%')
			<cfif session.livello GT 1>
				<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
					AND 
					( tbl_persone.id_gruppo IN ( #StructFind(session.userlogin,"gruppi_controllo")# )
					  OR 
					  tbl_clienti.id_agente = #StructFind(session.userlogin,"id")#
					)
				<cfelse>
					AND tbl_clienti.id_agente = #StructFind(session.userlogin,"id")#		
				</cfif>
			
			</cfif>
		ORDER BY ac_azienda
		</cfquery>
        <!--- And return it --->
		<cfreturn ValueList(data.ac_azienda)>
    </cffunction>
    
   <!--- Lookup used for auto suggest --->
    <cffunction name="getCustomerData" access="remote" returntype="any">
		<cfargument name="search" type="any" required="false" default="">

		<!--- Define variables --->
		<!--- <cfset var data="">
		<cfset var result=ArrayNew(1)> --->
		
		<!--- Do search --->
		<cfquery datasource="#THIS.dsn#" name="data">
		SELECT ac_azienda, ac_cognome, ac_indirizzo, ac_citta, ac_cap, ac_pv, ac_telefono, ac_cellulare,ac_email
		FROM tbl_clienti
		WHERE UCase(ac_azienda) = Ucase('#ARGUMENTS.search#')
		ORDER BY ac_azienda
		</cfquery>
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

   
</cfcomponent>

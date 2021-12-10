

<cfcomponent
	displayname="Application"
	output="true"
	hint="Handle the application.">

 	<cfscript>
       this.name = "SavEnergy";
       this.applicationTimeout = createTimeSpan(0,8,0,0);
       this.clientmanagement= "yes";
       this.loginstorage = "session" ;
       this.sessionmanagement = "yes";
       this.sessiontimeout = createTimeSpan(0,8,0,0);
       this.setClientCookies = "yes";
       this.setDomainCookies = "no";
       this.scriptProtect = "all";    
	 </cfscript>
 
 	
	<!--- Define the page request properties. --->
	<cfsetting
		requesttimeout="20"
		showdebugoutput="false"
		enablecfoutputonly="false"
		/>
 
 
	<cffunction
		name="OnApplicationStart"
		access="public"
		returntype="boolean"
		output="false"
		hint="Fires when the application is first created.">
		<cfset application.dhtmlxurl = "https://savcrm.moodgiver.com/sav/include/dhtmlx">
		<cfset application.dsn = "savenergy">
		
		<!--- Return out. --->
		<cfreturn true />
	</cffunction>
 
 
	<cffunction
		name="OnSessionStart"
		access="public"
		returntype="void"
		output="false"
		hint="Fires when the session is first created.">
 		 
		 <cfscript>
         session.started = now();
		 session.login = false;
      	 </cfscript>
      
      <cflock scope="application" timeout="5" type="Exclusive">
	  	<cfif IsDefined("application.sessions") IS FALSE>
			<cfset application.sessions = 0>
		</cfif>
         <cfset application.sessions = application.sessions + 1>
      </cflock>
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
 
	<cffunction
		name="OnRequestStart"
		access="public"
		returntype="boolean"
		output="false"
		hint="Fires at first part of page processing.">
		
 		
		<!--- Define arguments. --->
		<cfargument
			name="TargetPage"
			type="string"
			required="true"
			/>
		<cfif StructKeyExists(URL,"reloadApp")>
			<cfset OnApplicationStart()>
		</cfif>
		<!--- Return out. --->
		<cfreturn true />
	</cffunction>
 
 
	<cffunction
		name="OnRequest"
		access="public"
		returntype="void"
		output="true"
		hint="Fires after pre page processing is complete.">
 
		<!--- Define arguments. --->
		<cfargument
			name="TargetPage"
			type="string"
			required="true"
			/>
 
		<!--- Include the requested page. --->
		<cfinclude template="#ARGUMENTS.TargetPage#" />
 
 		<cfif IsDefined("session.login") IS FALSE>
			<cfscript>
				session.started = now();
			 	session.login = false;
			</cfscript>
			<!--- <cflock scope="application" timeout="5" type="Exclusive">
				<cfif IsDefined("application.sessions") IS FALSE>
					<cfset application.sessions = 0>
				</cfif>
				<cfset application.sessions = application.sessions + 1>
      		</cflock> --->
		</cfif>
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
 
	<!--- <cffunction
		name="OnRequestEnd"
		access="public"
		returntype="void"
		output="true"
		hint="Fires after the page processing is complete.">
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction> --->
 
 
	<cffunction
		name="OnSessionEnd"
		access="public"
		returntype="void"
		output="false"
		hint="Fires when the session is terminated.">
 
		<!--- Define arguments. --->
		<cfargument
			name="SessionScope"
			type="struct"
			required="true"
			/>
 
		<cfargument
			name="ApplicationScope"
			type="struct"
			required="false"
			default="#StructNew()#"
			/>
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
 
	<cffunction
		name="OnApplicationEnd"
		access="public"
		returntype="void"
		output="false"
		hint="Fires when the application is terminated.">
 
		<!--- Define arguments. --->
		<cfargument
			name="ApplicationScope"
			type="struct"
			required="false"
			default="#StructNew()#"
			/>
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
 
  <cffunction name="onError" output="true">
       <cfargument name="exception" required=true/>
       <cfargument name="eventName" type="String" required=true/>
       <!--- Log all errors. --->
       
       
       <!--- Display an error message if there is a page context. --->
       <cfif (trim(arguments.eventName) IS NOT "onSessionEnd") AND (trim(arguments.eventName) IS NOT "onApplicationEnd")>
            <cflog file="#this.name#" type="error" 
                text="Event name: #arguments.eventName#" >
            <cflog file="#this.name#" type="error" 
                text="Message: #arguments.exception.message#">
                
            <cfoutput>
                <h2>An unexpected error occurred.</h2>
                <p>Please provide the following information to technical support:</p>
                <p>Error Event: #arguments.eventName#</p>
                <p>Error details:</p>
            </cfoutput>    
            <cfdump var=#arguments.exception#> 
         <cfelseif (arguments.eventName IS "onApplicationEnd")>
               <cflog file="#this.name#" type="Information" 
            text="Application #this.name# Ended" >
		</cfif>
</cffunction>
 
 
	<!--- <cffunction
		name="OnError"
		access="public"
		returntype="void"
		output="true"
		hint="Fires when an exception occures that is not caught by a try/catch.">
 
		<!--- Define arguments. --->
		<cfargument
			name="Exception"
			type="any"
			required="true"
			/>
 
		<cfargument
			name="EventName"
			type="string"
			required="false"
			default=""
			/>
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction> --->
 
</cfcomponent>
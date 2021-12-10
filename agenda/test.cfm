<!--- <cfoutput query="session.agenda_test">
#currentrow# - (#id_status#) #id_agente# #dt_status#  [#id_agenda# > #id_utente# > #agenda_start#]<br>
</cfoutput> --->
<cfparam name="url.id_agente" default="">
<cfparam name="url.id_gruppo_agenti" default="">
<cfparam name="url.soloagente" default=0>

<cfinvoke component="agenda" method="events" returnvariable="rsAll">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
	<cfinvokeargument name="soloagente" value="#url.soloagente#">
</cfinvoke>
<cfdump var="#rsAll#">
<!--- <cfdump var="#session.userlogin.livello#">
 --->
 

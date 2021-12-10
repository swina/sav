<cfinvoke component="setup" method="saveProfilo" returnvariable="done">
	<cfinvokeargument name="ac_nome" value="#form.ac_nome#">
	<cfinvokeargument name="ac_cognome" value="#form.ac_cognome#">
	<cfinvokeargument name="ac_password" value="#form.ac_password#">
	<cfinvokeargument name="ac_utente" value="#form.ac_utente#">
	<cfinvokeargument name="ac_indirizzo" value="#form.ac_indirizzo#">
	<cfinvokeargument name="ac_citta" value="#form.ac_citta#">
	<cfinvokeargument name="ac_cap" value="#form.ac_cap#">
	<cfinvokeargument name="ac_pv" value="#form.ac_pv#">
</cfinvoke>
<cfoutput>#done#</cfoutput>
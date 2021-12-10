<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="yes">
<cfoutput>
<cfinvoke component="gruppi" method="saveUtente" returnvariable="done">
	<cfinvokeargument name="id_persona" value="#form.id_persona#">
	<cfinvokeargument name="id_gruppo" value="#form.id_gruppo_agente#">
	<cfinvokeargument name="ac_cognome" value="#form.ac_cognome#">
	<cfinvokeargument name="ac_nome" value="#form.ac_nome#">
	<cfinvokeargument name="ac_azienda" value="#form.ac_azienda#">
	<cfinvokeargument name="ac_indirizzo" value="#form.ac_indirizzo#">
	<cfinvokeargument name="ac_citta" value="#form.ac_citta#">
	<cfinvokeargument name="ac_pv" value="#form.ac_pv#">
	<cfinvokeargument name="ac_cap" value="#form.ac_cap#">
	<cfinvokeargument name="ac_telefono" value="#form.ac_telefono#">
	<cfinvokeargument name="ac_cellulare" value="#form.ac_cellulare#">
	<cfinvokeargument name="ac_email" value="#form.ac_email#">
	<cfinvokeargument name="ac_utente" value="#form.ac_utente#">
	<cfinvokeargument name="ac_password" value="#form.ac_password#">
	<cfinvokeargument name="ac_gruppi" value="#form.id_gruppi_controllo#">
	<cfinvokeargument name="ac_sconto_riservato" value="#form.ac_sconto_riservato#">
</cfinvoke>
</cfoutput>
<cfoutput>#done#</cfoutput>

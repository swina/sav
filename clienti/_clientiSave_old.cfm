<cfoutput>
<script>
alert("#form.id_cliente#");
</script>
<cfinvoke component="clienti" method="testSave" returnvariable="done">
	<cfinvokeargument name="id_cliente" value="TEST">
	<!--- <cfinvokeargument name="id_cliente" value="#form.id_cliente#">
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
	<cfinvokeargument name="id_agente" value="#form.id_agente#">
	<cfinvokeargument name="ac_segnalatore" value="#form.ac_segnalatore#"> --->
</cfinvoke>
</cfoutput>
<cfoutput>#done#</cfoutput>

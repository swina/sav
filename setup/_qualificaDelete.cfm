<cfinvoke component="setup" method="deleteGruppoCliente" returnvariable="done">
	<cfinvokeargument name="id_gruppo_delete" value="#form.id_gruppo_delete#">
</cfinvoke>
<cfoutput>#done#</cfoutput>
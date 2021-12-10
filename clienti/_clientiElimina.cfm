<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="yes">
<cfoutput>
<cfinvoke component="clienti" method="deleteAnagrafica" returnvariable="done">
	<cfinvokeargument name="id_cliente_delete" value="#form.id_cliente_delete#">
</cfinvoke>
</cfoutput>
<cfoutput>#done#</cfoutput>

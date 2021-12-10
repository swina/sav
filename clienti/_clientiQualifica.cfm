<cfoutput>
<cfinvoke component="clienti" method="saveQualifica" returnvariable="done">
	<cfinvokeargument name="id_cliente" value="#form.id_cliente_qualifica#">
	<cfinvokeargument name="id_qualifica" value="#form.id_qualifica#">
</cfinvoke>
#done#
</cfoutput>

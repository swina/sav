<cfinvoke component="offerte" method="offertaPresentazione" returnvariable="done">
	<cfinvokeargument name="id_cliente" value="#form.id_cliente#">
</cfinvoke>
<cfoutput>#done#</cfoutput>
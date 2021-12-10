<cfinvoke component="offerte" method="offertaModulo" returnvariable="done">
	<cfinvokeargument name="ac_modulo_uuid" value="#form.ac_modulo_uuid#">
</cfinvoke>
<cfoutput>#done#</cfoutput>
<cfinvoke component="setup" method="saveOrdine" returnvariable="done">
	<cfinvokeargument name="id_processo_ordine" value="#form.id_processo_ordine#">
	<cfinvokeargument name="int_ordine" value="#form.int_ordine#">
</cfinvoke>
<cfoutput>#done#</cfoutput>
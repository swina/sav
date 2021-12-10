<cfinvoke component="status" method="moveDocs" returnvariable="done">
	<cfinvokeargument name="id_cliente" value="#form.id_cliente#">
	<cfinvokeargument name="id_status" value="#form.id_status#">
	<cfinvokeargument name="lista_docs" value="#form.lista_docs#">
</cfinvoke>
<cfoutput>Echo: #done#</cfoutput>
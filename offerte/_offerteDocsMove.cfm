<cfinvoke component="offerte" method="moveDocs" returnvariable="done">
	<cfinvokeargument name="id_cliente" value="#form.id_cliente#">
	<cfinvokeargument name="id_status" value="#form.id_status#">
	<cfinvokeargument name="id_agente" value="#form.id_agente#">
	<cfinvokeargument name="lista_docs" value="#form.lista_docs#">
	<cfinvokeargument name="ac_modulo_uuid" value="#form.ac_modulo_uuid_2#">
	<cfinvokeargument name="add_status" value="#form.add_status#">
	<cfinvokeargument name="ac_valore" value="#form.ac_valore#">
</cfinvoke>
<cfoutput>Echo: #done#</cfoutput>
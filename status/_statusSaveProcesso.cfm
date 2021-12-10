<cfinvoke component="status" method="saveProcesso" returnvariable="done">
 	<cfinvokeargument name="id_status" value="#form.id_status#">
	<cfinvokeargument name="dt_status" value="#form.calInput1#">
 	<cfinvokeargument name="ac_ora" value="#form.ac_ora#">
	<cfinvokeargument name="ac_valore" value="#form.ac_valore#">
	<cfinvokeargument name="ac_note" value="#form.ac_note#">
	<cfinvokeargument name="modulo_uuid" value="#form.modulo_uuid#">
	<cfinvokeargument name="lista_docs" value="#form.lista_docs#">
</cfinvoke>
<cfoutput>Echo: #done# </cfoutput>
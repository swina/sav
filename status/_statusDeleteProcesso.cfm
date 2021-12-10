<cfinvoke component="status" method="deleteProcesso" returnvariable="done">
	<cfinvokeargument name="id_status" value="#form.id_status#">
</cfinvoke>
<cfoutput>Echo: #done# </cfoutput>
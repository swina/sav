<cfinvoke component="msg" method="deleteMsg" returnvariable="done">
 	<cfinvokeargument name="id_message" value="#form.id_message#">
</cfinvoke>
<cfoutput>#done# </cfoutput>
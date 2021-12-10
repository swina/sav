<cfinvoke component="msg" method="addMsg" returnvariable="done">
 	<cfinvokeargument name="id_from" value="#StructFind(session.userlogin,'ID')#">
	<cfinvokeargument name="id_gruppo" value="#form.id_gruppo_agenti#">
 	<cfinvokeargument name="id_agente" value="#form.id_agente#">
	<cfinvokeargument name="ac_subject" value="#form.ac_subject#">
	<cfinvokeargument name="ac_message" value="#form.ac_message#">
	<cfinvokeargument name="invio_generale" value="#form.invio_generale#">
</cfinvoke>
<cfoutput>Echo: #done# </cfoutput>
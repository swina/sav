<cfinvoke component="offerte" method="assegnaPersona" returnvariable="done">
	<cfinvokeargument name="id_status_assegna" value="#form.id_status_assegna#">
	<cfinvokeargument name="id_persona_assegna" value="#form.id_persona_assegna#">
</cfinvoke>
<cfoutput>#done#</cfoutput>
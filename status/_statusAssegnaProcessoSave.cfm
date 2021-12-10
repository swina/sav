<cfinvoke component="status" method="saveAssegnazioneProcesso" returnvariable="done">
	<cfinvokeargument name="id_status" value="#form.id_status_assegnazione#">
	<cfinvokeargument name="id_persona" value="#form.id_persona_assegnazione#">
</cfinvoke>
<cfoutput>#done# </cfoutput>
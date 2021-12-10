<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="yes">
<cfoutput>
<cfinvoke component="gruppi" method="enableUtente" returnvariable="done">
	<cfinvokeargument name="id_persona" value="#form.id_utente_enable#">
	<cfinvokeargument name="bl_cancellato" value="#form.bl_cancellato#">
</cfinvoke>
</cfoutput>
<cfoutput>#done#</cfoutput>

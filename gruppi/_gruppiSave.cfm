<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="yes">
<cfoutput>
<cfinvoke component="gruppi" method="saveGruppo" returnvariable="done">
	<cfinvokeargument name="action" value="#form.action#">
	<cfinvokeargument name="id_gruppo" value="#form.id_gruppo#">
	<cfinvokeargument name="id_gruppo_padre" value="#form.id_gruppo_padre#">
	<cfinvokeargument name="ac_gruppo" value="#form.ac_gruppo#">
	<cfinvokeargument name="int_livello" value="#form.int_livello#">
</cfinvoke>
</cfoutput>
<cfoutput>#done#</cfoutput>

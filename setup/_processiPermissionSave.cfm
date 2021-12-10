<cfinvoke component="setup" method="savePermissions" returnvariable="done">
	<cfinvokeargument name="id_processo" value="#form.id_processo_perm#">
	<cfinvokeargument name="ac_permissions" value="#form.ac_permissions#">
</cfinvoke>
<cfoutput>#done#</cfoutput>
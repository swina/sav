<cfinvoke component="setup" method="saveGruppiClientiCol" returnvariable="done">
	<cfinvokeargument name="id_gruppo" value="#form.id_gruppo#">
	<cfinvokeargument name="tbl_field" value="#form.table_column#">
	<cfinvokeargument name="field_value" value="#form.column_value#">
	<cfinvokeargument name="field_type" value="#form.column_type#">
</cfinvoke>
<cfoutput>#form.id_gruppo#</cfoutput>
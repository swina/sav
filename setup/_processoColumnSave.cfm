<cfinvoke component="setup" method="saveProcessCol" returnvariable="done">
	<cfinvokeargument name="id_processo" value="#form.id_processo#">
	<cfinvokeargument name="tbl_field" value="#form.table_column#">
	<cfinvokeargument name="field_value" value="#form.column_value#">
	<cfinvokeargument name="field_type" value="#form.column_type#">
</cfinvoke>
<cfoutput>#form.id_processo#</cfoutput>
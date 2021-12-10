<cfinvoke component="setup" method="saveConfig" returntype="done">
	<cfinvokeargument name="ac_app_name" value="#form.ac_app_name#">
	<!--- <cfinvokeargument name="ac_admin_username" value="#form.ac_admin_username#">
	<cfinvokeargument name="ac_admin_password" value="#form.ac_admin_password#"> --->
	<cfinvokeargument name="ac_admin_email" value="#form.ac_admin_email#">
	<cfinvokeargument name="ac_admin_alert_from" value="#form.ac_admin_alert_from#">
	<cfinvokeargument name="ac_admin_alert_email" value="#form.ac_admin_alert_email#">
	<cfinvokeargument name="ac_admin_pin" value="#form.ac_admin_pin#">
</cfinvoke>
<cfoutput>#done#</cfoutput>
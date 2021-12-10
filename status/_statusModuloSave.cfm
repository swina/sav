<cfinvoke component="moduli" method="saveModulo" returnvariable="done">
	<cfinvokeargument name="id_modulo" value="#form.id_modulo#">
	<cfinvokeargument name="valori" value="#form.valori#">
	<cfinvokeargument name="modulo_uuid" value="#form.modulo_uuid#">
</cfinvoke>
<cfoutput>#done# </cfoutput>

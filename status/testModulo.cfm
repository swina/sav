<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="yes">

<cfparam name="form.id_cliente" default="5619">
<cfparam name="form.id_processo" default="6">
<cfparam name="form.dt_processo" default="#DateFormat(now(),'dd/mm/yyyy')#">
<cfparam name="form.processo_modulo_uuid" default="0255E68A-5056-8B39-7D6AFACE57F652BF">

<cfinvoke component="moduli" method="addProcessoFromModulo" returnvariable="done">
	<cfinvokeargument name="id_cliente" value="#form.id_cliente#">
	<cfinvokeargument name="id_processo" value="#form.id_processo#">
	<cfinvokeargument name="dt_status" value="#form.dt_processo#">
	<cfinvokeargument name="processo_modulo_uuid" value="#form.processo_modulo_uuid#">

</cfinvoke>
<cfoutput>#done# </cfoutput>
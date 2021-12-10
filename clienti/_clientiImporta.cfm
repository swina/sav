<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="yes">
<cfoutput>
<cfinvoke component="clienti" method="importaContatti" returnvariable="done"></cfinvoke>
</cfoutput>
<cfoutput>#done#</cfoutput>

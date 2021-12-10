<cfsetting showdebugoutput="no">
<!--- Send the headers --->
<cfheader name="Content-type" value="text/xml">
<cfheader name="Pragma" value="public">
<cfheader name="Cache-control" value="private">
<cfheader name="Expires" value="-1">
<cfsetting enablecfoutputonly="no"><?xml version="1.0" encoding="ISO-8859-1"?>
<rows>
	<row id="perm">
		<cfoutput>
		<userdata name="id_processo">#url.id_processo#</userdata>
		<userdata name="lista_permission">#url.ac_permission#</userdata>
		</cfoutput>
		<cfloop index="i" list="#url.ac_permission#">
			<cfoutput>
			<cfif i EQ 1>
				<cell>../include/css/icons/check.png^Abilitato</cell>
			<cfelse>
				<cell>../include/css/icons/busy.png^Non Abilitato</cell>	
			</cfif>
			</cfoutput>
		</cfloop>
	</row>	
</rows>
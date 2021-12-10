<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfquery name="rs" datasource="#application.dsn#">
SELECT ac_note FROM tbl_status WHERE id_status = #url.id#
</cfquery>
<cfoutput>#HTMLEditFormat(rs.ac_note)#</cfoutput>
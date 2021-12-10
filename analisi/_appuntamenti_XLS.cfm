<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="no">
<cfheader name="Pragma" value="">
<cfheader name="Cache-control" value="">
<cfheader name="Content-disposition" value="attachment; filename=appuntamenti.xls">
<cfcontent type="application/vnd.ms-excel">
<cfset a = SetLocale("Italian (Standard)")>
<cfoutput>
<table border="1" width="100" cellpadding="4">
	<tr>
		<td colspan="6">
		<strong style="font-size:14px">SAVEnergy</strong><br>
		<!--- <strong>APPUNTAMENTI</strong>&nbsp;
		Periodo dal #LSDateFormat(url.from,"dd mmm yyyy")# al #LSDateFormat(url.to,"dd mmm yyyy")# --->
		</td>
	</tr>
	#session.Excel#
</table>
</cfoutput>
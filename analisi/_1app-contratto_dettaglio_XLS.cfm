<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="no">
<cfparam name="url.mode" default="richiesta-contratto">
<cfparam name="nome_file" default="ANALISI-1APPUNTAMENTO-CONTRATTO.xls">
<cfif url.mode EQ "richiesta-contratto">
	<cfset nome_file = "ANALISI-RICHIESTA_OFFERTA-CONTRATTO.xls">
</cfif>
<cfif url.mode EQ "1app">
	<cfset nome_file = "ANALISI RICHIESA OFFERTA-CONTRATTO.xls">
</cfif>
<cfif url.mode EQ "1tele">
	<cfset nome_file = "ANALISI 1 CONTATTO TELEFONICO-CONTRATTO.xls">
</cfif>
<cfif url.mode EQ "apps">
	<cfset nome_file = "ANALISI APPUNTAMENTI-CONTRATTO.xls">
</cfif>
<cfheader name="Pragma" value="">
<cfheader name="Cache-control" value="">
<cfheader name="Content-disposition" value="attachment; filename=#nome_file#.xls">
<cfcontent type="application/vnd.ms-excel">
<cfset a = SetLocale("Italian (Standard)")>
<cfoutput>
<table border="1" width="100" cellpadding="4">
	<tr>
		<td colspan="7">
		<strong style="font-size:14px">SAVEnergy</strong><br>
		<cfif url.mode EQ "1app">
			<strong>ANALISI 1° APPUNTAMENTO - CONTRATTO</strong><br>
		</cfif>
		<cfif url.mode EQ "richiesta-contratto">
			<strong>ANALISI RICHIESTA OFFERTA - CONTRATTO</strong><br>
		</cfif>
		<cfif url.mode EQ "1tele">
			<strong>ANALISI 1° CONTATTO TELEFONICO - CONTRATTO</strong>
		</cfif>
		<cfif url.mode EQ "apps">
			<strong>ANALISI 1° +APPUNTAMENTI - CONTRATTO</strong>
		</cfif>
		Periodo dal #LSDateFormat(url.from,"dd mmm yyyy")# al #LSDateFormat(url.to,"dd mmm yyyy")#
		</td>
	</tr>
	
	#session.Excel#
</table>
</cfoutput>
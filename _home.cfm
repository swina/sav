<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<link rel="stylesheet" type="text/css" href="include/css/screen.css">
	<script>
	function activate(tab){
		parent.tabbar.setTabActive(tab);
	}
	</script>
</head>
<style>
	.icon {
		font-family: Tahoma,Helvetica;
		font-size:13px;
		width:60px;
		height:70px;
		border:1px solid #eaeaea;
		padding:0px;
		float:left;
		margin-right:10px;
		margin-bottom:10px;
	}
	.icon .title {
		background:#eaeaea;
		font-size:12px;
		font-weight:bold;
		height:14px;
		padding:4px;
		border-bottom:1px solid #c3c3c3;
		text-align:center;
		vertical-align:middle;
	} 
	.icon img {
		margin-top:4px;
		padding:10px;
		cursor:pointer;
		margin:0 auto;
	}
</style>
<cfset a = SetLocale("Italian (Standard)")>
<body style="margin:0 auto;overflow:auto">
<div align="center">
<table width="95%" style="margin:4px">
	<tr>
		<td>
<div style="width:100%;margin:20px">
	Oggi: <cfoutput>#LSDateFormat(now(),"DD mmm YYYY")# #LSDateFormat(now(),"dddd")#</cfoutput><br>
	<br>

	<div class="icon">
		<div class="title">
		Status
		</div>
		<img src="include/img/ksirtet_bw.png" width="25" onclick="activate('a1')">
	</div>
	<div class="icon">
		<div class="title">Agenda</div>
		<img src="include/img/date_bw.png" width="25" onclick="activate('a2')">
	</div>
	<div class="icon">
		<div class="title">Contatti</div>
		<img src="include/img/kaddressbook_bw.png" width="25" onclick="activate('a3')">
	</div>
	<cfif session.livello LT 2>
	<div class="icon">
		<div class="title">Utenti</div>
		<img src="include/img/kdmconfig_bw.png" width="25" onclick="activate('a4')">
	</div>
	</cfif>
	<div class="icon">
		<div class="title">Analisi</div>
		<img src="include/img/kchart_bw.png" width="25" onclick="activate('a5')">
	</div>
	<div class="icon">
		<div class="title">Documenti</div>
		<img src="include/img/file-manager_bw.png" width="25" onclick="activate('a6')">
	</div>
	<div class="icon">
		<div class="title">Setup</div>
		<img src="include/img/advancedsettings_bw.png" width="25" onclick="activate('a7')">
	</div>
	<div class="icon">
		<div class="title">Plan</div>
		<img src="include/img/cal_bw.png" width="25" onclick="activate('a10')">
	</div>
	<cfif session.livello LT 4>
	<div class="icon">
		<div class="title">Alerts</div>
		<img src="include/img/xclock_bw.png" width="25" onclick="activate('a11')">
	</div>
	</cfif>
</div>
</td>
	</tr>
	<tr>
		<td>
		<cfinclude template="_msgReceived.cfm">
		<br>
		
		<div style="background:#cbe2fe;padding:2px"><strong>Documenti aggiornati</strong></div>
		<cfinclude template="_docsUploaded.cfm">
		<!---- ALERTING HOME PAGE ---->
		<div style="background:#cbe2fe;padding:2px"><strong>Attività scadute negli ultimi 3 giorni (verificare lo status)</strong></div>
		<div style="margin-left:0px;overflow:auto;height:250px;font-size:11px;border:1px solid #eaeaea">
		<cfinclude template="_alert.cfm">
		</div>
		<!--- <cfset session.noOfferte = FALSE>
		<cfif session.livello GT 1 AND session.livello LT 4>
			<cfinclude template="_noOfferte.cfm">
			<cfif session.noOfferte>Attenzione ! Con attività scadute non potrai caricare nuove richieste di offerta. Aggiornare le attività e quindi riaccedere al sistema per poter inserire nuove richieste di offerta.</cfif>
		</cfif> --->

		</td>
	</tr>
</table>
</div>
</body>
</html>

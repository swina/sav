<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
	<script src="../include/js/functions.js"></script>
	<script src="setup.js"></script>
	<title>Untitled</title>
</head>
<cfinvoke component="setup" method="getConfig" returnvariable="myConfig"></cfinvoke>
<body>
<cfajaximport>
<div style="width:500px;padding:5px;" class="winblue">
<div style="border:1px solid #ffeeff">
<div class="winhead"><strong>Configurazione</strong></div><br>
<cfoutput>
<cfform id="configFrm">
	<div class="fieldLabel">Nome Applicazione</div><div><cfinput name="ac_app_name" id="ac_app_name" size="45" maxlentgh="255" value="#myConfig.ac_app_name#" tooltip="Nome Applicazione" class="enabled"></div>
	<br>
	<!--- <div class="fieldLabel">Utente Admin*</div><div><cfinput type="Text" name="ac_admin_username" value="#myConfig.ac_admin_username#" tooltip="Nome utente Amministratore" required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" size="45" id="ac_admin_username" maxlentgh="255" class="required"></div>

	<br>
	<div class="fieldLabel">Password Admin*</div><div><cfinput type="Password" name="ac_admin_password" validateat="onSubmit" size="12" value="#myConfig.ac_admin_password#" visible="Yes" enabled="Yes" tooltip="Password Amministratore" id="ac_admin_password" maxlentgh="12" class="required"></div>

	<br>
	<div class="fieldLabel">Confirm Password*</div><div><cfinput type="Password" name="password_confirm" validateat="onSubmit" size="12" value="#myConfig.ac_admin_password#" visible="Yes" enabled="Yes" tooltip="Conferma Password Amministratore" id="password_confirm" maxlentgh="12" class="required"></div>
	
	<br> --->
	<div class="fieldLabel">Email Admin*</div><div><cfinput type="Text" name="ac_admin_email" value="#myConfig.ac_admin_email#" tooltip="Indirizzo Email Amministratore" required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" size="45" id="ac_admin_email" maxlentgh="255" class="required"></div>
	<br>
	
	<div class="fieldLabel">Email Alerting From*</div><div><cfinput type="Text" name="ac_admin_alert_from" value="#myConfig.ac_admin_alert_from#" validate="email" tooltip="Indirizzo Email del mittente degli alert" required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" size="45" id="ac_admin_alert_from" maxlentgh="255" class="required"></div>
	<br>
	
	<div class="fieldLabel">Email Alerting Copy To*</div><div><cfinput type="Text" name="ac_admin_alert_email" value="#myConfig.ac_admin_alert_email#" validate="email" tooltip="Indirizzo Email a cui inviare copia degli alert" required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" size="45" id="ac_admin_alert_email" maxlentgh="255" class="required"></div>
	<br>
	
	<div class="fieldLabel">Admin PIN Code*</div><div><cfinput type="Text" name="ac_admin_pin" value="#myConfig.ac_admin_pin#" validate="email" tooltip="Inserire il PIN CODE di sicurezza" required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" size="45" id="ac_admin_pin" maxlentgh="12" class="required"></div>
	<br>
	<div align="center"><input type="button" class="btn" value="Salva" title="Salva Configurazione" onclick="saveConfig()"></div>
</cfform>
</cfoutput>
</div>
</div>

</body>
</html>

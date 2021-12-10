<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
	<script src="../include/js/functions.js"></script>
	<script src="setup.js"></script>
	<title>Untitled</title>
</head>
<cfinvoke component="security" method="getProfilo" returnvariable="myConfig"></cfinvoke>
<body>
<cfajaximport>
<div style="width:550px;padding:5px;" class="winblue">
<div style="border:1px solid #ffeeff">
<div class="winhead"><strong>Profilo Utente</strong></div><br>
<cfoutput>
<cfform id="profiloFrm">
	<div class="fieldLabel">Nome*</div><div><cfinput type="Text" name="ac_nome" value="#myConfig.ac_nome#" tooltip="Nome" required="Yes" visible="Yes" enabled="Yes" size="45" id="ac_nome" maxlentgh="255" class="required"></div>
	<br>
	<div class="fieldLabel">Cognome*</div><div><cfinput name="ac_cognome" id="ac_cognome" size="45" maxlentgh="255" value="#myConfig.ac_cognome#" required="yes" tooltip="Cognome" class="required"></div>
	<br>

	<div class="fieldLabel">Nome utente*</div><div><cfinput type="Text" name="ac_utente" value="#myConfig.ac_utente#" tooltip="Nome utente" required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" size="45" id="ac_utente" maxlentgh="255" class="required"></div>

	<br>
	<div class="fieldLabel">Password*</div><div><cfinput type="Password" name="ac_password" validateat="onSubmit" size="12" value="#myConfig.ac_password#" visible="Yes" enabled="Yes" tooltip="Password" id="ac_password" maxlentgh="12" class="required"></div>

	<br>
	<div class="fieldLabel">Confirm Password*</div><div><cfinput type="Password" name="password_confirm" validateat="onSubmit" size="12" value="#myConfig.ac_password#" visible="Yes" enabled="Yes" tooltip="Conferma Password Amministratore" id="password_confirm" maxlentgh="12" class="required"></div>
	<!--- <br>
	<div class="fieldLabel">Email*</div><div><cfinput type="Text" name="ac_email" value="#myConfig.ac_email#" tooltip="Indirizzo Email" required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" size="45" id="ac_email" maxlentgh="255" class="required"></div> --->
	<br>
	<div class="fieldLabel">Indirizzo</div><div><cfinput type="Text" name="ac_indirizzo" value="#myConfig.ac_indirizzo#" tooltip="Indirizzo" required="No" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" size="45" id="ac_indirizzo" maxlentgh="255" class="enabled"></div>
	<br>
	<div class="fieldLabel">Città</div><div><cfinput type="Text" name="ac_citta" value="#myConfig.ac_citta#" tooltip="Indirizzo" required="No" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" size="22" id="ac_citta" maxlentgh="255" class="enabled"> Prov. <cfinput type="Text" name="ac_pv" value="#myConfig.ac_pv#" tooltip="Provincia" required="No" visible="Yes" enabled="Yes" typeahead="No" size="2" maxlength="2" id="ac_pv" class="enabled"> CAP <cfinput type="Text" name="ac_cap" value="#myConfig.ac_cap#" validateat="onSubmit" validate="zipcode" tooltip="CAP" required="No" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" size="6" maxlength="5" id="ac_cap" class="enabled"></div>
	<!--- 
	<div class="fieldLabel">Email Alerting From*</div><div><cfinput type="Text" name="ac_admin_alert_from" value="#myConfig.ac_admin_alert_from#" validate="email" tooltip="Indirizzo Email del mittente degli alert" required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" size="45" id="ac_admin_alert_from" maxlentgh="255" class="required"></div>
	<br>
	
	<div class="fieldLabel">Email Alerting Copy To*</div><div><cfinput type="Text" name="ac_admin_alert_email" value="#myConfig.ac_admin_alert_email#" validate="email" tooltip="Indirizzo Email a cui inviare copia degli alert" required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" size="45" id="ac_admin_alert_email" maxlentgh="255" class="required"></div>
	<br>
	
	<div class="fieldLabel">Admin PIN Code*</div><div><cfinput type="Text" name="ac_admin_pin" value="#myConfig.ac_admin_pin#" validate="email" tooltip="Inserire il PIN CODE di sicurezza" required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="False" typeahead="No" size="45" id="ac_admin_pin" maxlentgh="12" class="required"></div>
	<br> ---><br>
	<br>
	
	<div align="center"><input type="button" class="btn" value="Salva" title="Salva Configurazione" onclick="saveProfilo()"></div>
</cfform>
</cfoutput>
</div>
</div>

</body>
</html>
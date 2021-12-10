<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Importazione Dati</title>
	<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
	<script src="../include/js/functions.js"></script>
	<script src="clienti.js"></script>
</head>
<cfset myColumns = "Data Registrazione|Regione|Provincia|Tipo Impianto|Tipo Cliente|Ragione Sociale|Email|Titolo|Telefono|Indirizzo|Citta|CAP|Regione|Tipologia|Fabbricato|Inclinazione|MQ|MQ Utili|Energia|Orientamento|Tempi">
<body>
<cfif IsDefined("form.importa")>
	<cfset myData = form.importa>
	<cfset myLista = "">
	<cfset n = 1>
	<cfloop index="i" list="#myData#" delimiters="#chr(10)#">
	<cfoutput>
		<cfif len(i) GT 2>
			<cfif n mod 2><cfelse><cfset myLista="#myLista##i#|"></cfif>
			<cfset n = n + 1>
		</cfif>
	
	</cfoutput>
	</cfloop>
	<!--- <cfdump var="#myLista#"> --->

<cfset ac_azienda = "#ListGetAt(myLista,6,'|')#">
<cfset ac_indirizzo = "#ListGetAt(myLista,10,'|')#">
<cfset ac_telefono = "#ListGetAt(myLista,9,'|')#">
<cfset ac_citta = "#ListGetAt(myLista,11,'|')#">
<cfset ac_cap = "#ListGetAt(myLista,12,'|')#">
<cfset ac_pv = "#ListGetAt(myLista,3,'|')#">
<cfset ac_email = "#ListGetAt(myLista,7,'|')#">
<cfset ac_info = "Tipo Impianto:#ListGetAt(myLista,4,'|')##chr(10)#">
<cfset ac_info = "#ac_info#Esposizione:#ListGetAt(myLista,14,'|')##chr(10)#">
<cfset ac_info = "#ac_info#Fabbricato:#ListGetAt(myLista,15,'|')##chr(10)#">
<cfset ac_info = "#ac_info#Inclinazione:#ListGetAt(myLista,16,'|')##chr(10)#">
<cfset ac_info = "#ac_info#MQ:#ListGetAt(myLista,17,'|')#(#ListGetAt(myLista,18,'|')#)#chr(10)#">
<cfset ac_info = "#ac_info#Energia:#ListGetAt(myLista,19,'|')##chr(10)#">
<cfset ac_info = "#ac_info#Orientamento:#ListGetAt(myLista,20,'|')##chr(10)#">
<cfset ac_info = "#ac_info#Tempi:#ListGetAt(myLista,21,'|')##chr(10)#">

<cfinvoke component="import" method="provincia" returnvariable="pv">
	<cfinvokeargument name="ac_pv" value="#ac_pv#">
</cfinvoke>
<cfset ac_pv = pv>
<cfoutput>
<div style="display:none">
<cfform name="importAnagrafica" id="importAnagrafica">
		<input type="text" name="id_cliente" value="0">
		<input type="text" name="ac_cognome" value="#ac_azienda#">
		<input type="text" name="ac_nome" value="">
		<input type="text" name="ac_azienda" value="#ac_azienda#">
		<input type="text" name="ac_indirizzo" value="#ac_indirizzo#">
		<input type="text" name="ac_citta" value="#ac_citta#">
		<input type="text" name="ac_pv" value="#ac_pv#">
		<input type="text" name="ac_cap" value="#ac_cap#">
		<input type="text" name="ac_telefono" value="#ac_telefono#">
		<input type="text" name="ac_cellulare" value="">
		<input type="text" name="ac_email" value="#ac_email#">
		<input type="text" name="id_agente" value="0">
		<textarea name="ac_info">#ac_info#</textarea>
		<input type="text" name="id_fornitore" value="1">
</cfform>
</div>
</cfoutput>
<div class="winblue">
<strong>Importa Dati</strong><hr>
<cfoutput>
<strong>Cliente</strong>: #ac_azienda#<br>
<strong>Indirizzo</strong>: #ac_indirizzo# <br>
<strong>Città</strong>: #ac_citta#<br>
<strong>Prov</strong>: #ac_pv#<br>
<strong>CAP</strong>: #ac_cap# <br>
<strong>Telefono</strong>: #ac_telefono#<br>
<strong>Email</strong>: #ac_email#<br>
<strong>Note Commerciali</strong>:<br>
<cfloop index="i" list="#ac_info#" delimiters="#chr(10)#">
	#i#<br>
</cfloop>
</cfoutput>
<div align="center"><input type="button" value="Importa" class="btn" onclick="importAnagrafica()"></div>
</div>
</cfif>
<div class="winblue">
<form action="#script_name#" method="post">
Incolla il testo della mail:<br>
<textarea name="importa" style="width:490px;height:250px;font-size:11px;font-family:Verdana"></textarea>

<input type="submit" value="Importa" class="btn">
</form>
</div>
</body>
</html>

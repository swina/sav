<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
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
</cfif>
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
Dati Importati:<hr>

<cfoutput>
Cliente: #ac_azienda#<br>
Indirizzo: #ac_indirizzo# #ac_citta# #ac_cap# #ac_pv#<br>
Telefono: #ac_telefono#<br>
Email: #ac_email#<br>
Info Commerciali:<br>
<cfloop index="i" list="#ac_info#" delimiters="#chr(10)#">
	#i#<br>
</cfloop>
</cfoutput>


<cfset n = 1>

<!--- <cfloop index="i" list="#myColumns#" delimiters="|">
	<cfoutput>
		#n#. #i#>#ListGetAt(myLista,n,"|")#<br>
	</cfoutput>
	<cfset n = n + 1>
</cfloop> --->
<form action="#script_name#" method="post">
<textarea name="importa" style="width:600px;height:400px;font-size:11px;font-family:Verdana"></textarea>

<input type="submit" value="Importa">
</form>
</body>
</html>

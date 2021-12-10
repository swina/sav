<cfinvoke component="crmdemo.status.moduli" method="getModuloPrint" returnvariable="qryModulo">
	<cfinvokeargument name="modulo_uuid" value="#url.uuid#">
</cfinvoke>
<?xml version=�1.0? encoding=�UTF-8??>
<!DOCTYPE html PUBLIC �-//W3C//DTD XHTML 1.0 Transitional//EN�https:////www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd�>
<html xmlns=�https://www.w3.org/1999/xhtml�>
<head>
	<cfoutput>
	<title>SAVEnergy - #qryModulo.ac_modulo#</title>
	</cfoutput>
	
</head>
<body>

<cfdocument  format="PDF" pagetype="A4" orientation="portrait" unit="in" encryption="none" fontembed="no" backgroundvisible="No" bookmark="False" localurl="Yes">

<table cellspacing="0" cellpadding="3" style="width:98%;border:1px solid black">
	<cfoutput>
	<tr>
		<td colspan="2" style="font-family:Verdana;border-bottom:1px solid ##eaeaea" align="center">
		<p style="height:35px">
		<strong style="font-size:22px;font-family:Verdana">SAVEnergy</strong>
		</p>
		<br>
		<br>
		
		</td>
	</tr>
	<tr>
		<td style="font-family:Verdana;border-bottom:1px solid ##eaeaea" valign="top">
		Cliente:	<strong>#qryModulo.ac_cognome# #qryModulo.ac_nome# <br>
		#qryModulo.ac_azienda#<br>
		#UCASE(qryModulo.ac_citta)# <cfif qryModulo.ac_pv NEQ "null">#UCASE(qryModulo.ac_pv)#</cfif></strong>
		</td>
		<td style="font-family:Verdana;border-bottom:1px solid ##eaeaea" align="left" valign="top">
		Documento: <strong>#qryModulo.ac_modulo#</strong><br/>
		Data: #DateFormat(qryModulo.dt_registrazione,"dd.mm.yyyy")#
		</td>
	</tr>
	</cfoutput>
<cfoutput query="qryModulo" group="ac_sezione">
	<tr>
		<td colspan="2" style="font-family:Verdana;border-bottom:1px solid ##eaeaea"><h4>#ac_sezione#</h4></td>
	</tr>
	<cfoutput group="ac_label">
	<cfset myValore = ListGetAt(ac_dati,int_ordine,"|")>
	<tr>
		<td valign="top" style="font-family:Verdana;border-bottom:1px solid ##eaeaea">#ac_label#</td>
		<td valign="top" style="font-family:Verdana;border-bottom:1px solid ##eaeaea"><cfif myValore NEQ "null" AND myValore NEQ 0>#ListGetAt(ac_dati,int_ordine,"|")#<cfelse>&nbsp;</cfif></td>
	</tr>
	<!--- <cfset myValore = ListGetAt(ac_dati,currentrow,"|")>
	<tr>
		<td valign="top" style="font-family:Verdana;border-bottom:1px solid ##eaeaea">#ac_label#</td>
		<td valign="top" style="font-family:Verdana;border-bottom:1px solid ##eaeaea"><cfif myValore NEQ "null" AND myValore NEQ 0><strong>#myValore#</strong></cfif></td>
	</tr> --->
	</cfoutput>
</cfoutput>
</table>
<br>
<br>
</cfdocument> 
</body>
</html>
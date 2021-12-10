<cfinvoke component="clienti" method="getClientiAdvanced" returnvariable="rsAll">
	<cfinvokeargument name="page" value="#url.startpage#">
	<cfinvokeargument name="pagesize" value="#url.pagesize#">
	<cfinvokeargument name="searchString" value="#url.search#">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="id_qualifica" value="#url.id_gruppo#">
	<cfinvokeargument name="ac_pv" value="#url.pv#">
	<cfinvokeargument name="id_agente_assegnato" value="#url.id_agente_assegnato#">
	<cfinvokeargument name="dFrom" value="#url.dFrom#">
	<cfinvokeargument name="dTo" value="#url.dTo#">
	<cfinvokeargument name="fornitore" value="#url.fornitore#">
	<cfinvokeargument name="bl_attivo" value="#url.import#">
	<cfinvokeargument name="scopo" value=2>
</cfinvoke>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>
<cfheader name="Content-Disposition" 
value="inline; filename=clienti_export.xls">
<cfcontent type="application/vnd.ms-excel">
<table border="1">
	<tr>
		<td><strong>Contatto</strong></td>
		<td><strong>Indirizzo</strong></td>
		<td><strong>Città</strong></td>
		<td><strong>Prov</strong></td>
		<td><strong>Telefono</strong></td>
		<td><strong>Cellulare</strong></td>
		<td><strong>Email</strong></td>
		<td><strong>Agente</strong></td>
		<td><strong>Fornitore</strong></td>
		<td><strong>Data</strong></td>
		<td><strong>Qualifica</strong></td>
	</tr>
	<cfoutput query="rsAll">
	<tr>
		<td>
		<cfif ac_azienda NEQ "">#UCASE(ac_azienda)#<cfelse>#UCASE(ac_cognome)# #UCASE(ac_nome)#</cfif>
		</td>
		<td>#UCASE(ac_indirizzo)#</td>
		<td>#UCASE(ac_citta)#</td>
		<td>#UCASE(ac_pv)#</td>
		<td>#ac_telefono#</td>
		<td>#ac_cellulare#</td>
		<td>#ac_email#</td>
		<td>#agente#</td>
		<td>#UCASE(ac_segnalatore)#</td>
		<td><cfif dt_data_registrazione NEQ "">#DateFormat(dt_data_registrazione,"dd/mm/yyyy")#</cfif></td>
		<td>#UCASE(qualifica)#</td>
	</tr>
	</cfoutput>
</table>

</body>
</html>

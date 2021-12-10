<cfif IsDefined("form.id_cliente") AND form.id_cliente NEQ "">
	<cfloop index="i" list="#form.id_cliente#">
		<cfoutput>#i#</cfoutput><br>
		<cfset myDate = CreateDateTime(year(now()),month(now()),day(now()),12,0,0)>
		<cfquery name="qry" datasource="#application.dsn#">
					INSERT INTO tbl_status
					(
						id_cliente,
						id_processo,
						dt_status
					)
					VALUES
					(
						#i#,
						2,
						#myDate#
					)
		</cfquery>
	</cfloop>
</cfif>
<cfquery name="getClienti" datasource="#application.dsn#">
	SELECT tbl_clienti.* ,
	tbl_persone.ac_cognome AS Agente
	FROM tbl_clienti
	INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
	WHERE tbl_clienti.bl_attivo = 1 AND id_agente <> 0
	and ( year(tbl_clienti.dt_data_registrazione) > 2010 AND month(tbl_clienti.dt_data_registrazione) > 9)
	ORDER BY ac_azienda ASC
</cfquery>
<link rel="stylesheet" type="text/css" href="../include/css/style.css">
<h2>Contatti da riassegnare</h2>
<body style="overflow:auto">
<table border="1">
<form action="#script_name#" method="post">
	<tr>
		<td><strong>Azienda</strong></td>
		<td><strong>Cognome</strong></td>
		<td><strong>Nome</strong></td>
		<td><strong>Agente</strong></td>
		<td></td>
	</tr>
<cfoutput query="getClienti">
	<cfquery name="checkStatus" datasource="#application.dsn#">
	SELECT * FROM tbl_status WHERE id_cliente = #id_cliente#
	</cfquery>
	
	<cfif checkStatus.recordcount EQ 0>
	<tr>
		<td>#UCASE(ac_azienda)#</td>
		<td>#UCASE(ac_cognome)#</td>
		<td>#UCASE(ac_nome)#</td>
		<td>#UCASE(agente)#</td>
		<td><input type="checkbox" name="id_cliente" id="id_cliente" value="#id_cliente#"></td>
	</tr>
	
	</cfif>
</cfoutput>
<tr>
	<td colspan="5" align="center">
	Selezionare i contatti da riassegnare e premere OK<br>
	<input type="submit" value="OK">
	
	</td>
</tr>
</form>
</table>
<cfif IsDefined("form.id_cliente")>
	<cfoutput>
	#form.id_cliente#
	</cfoutput>
</cfif>
</body>
<cfsetting requestTimeout = "600">
<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfquery name="getOldClienti" datasource="#application.dsn#">
	SELECT id_cliente,ac_cognome FROM tbl_clienti WHERE id_agente = #url.from# ORDER BY ac_cognome, ac_nome , ac_azienda
</cfquery>

<cfif getOldClienti.recordcount GT 100>
	<cfoutput>
	<script>
		alert("Sono stati selezionati oltre 100 clienti\nIl sistema potrà elaborarne 100 per volta\nRipetere l'operazione per riassegnare tutti i clienti");
	</script>
	</cfoutput>
	<cfquery name="getOldClienti" datasource="#application.dsn#">
		SELECT id_cliente,ac_cognome FROM tbl_clienti WHERE id_agente = #url.from# ORDER BY ac_cognome, ac_nome , ac_azienda LIMIT 0,100
	</cfquery>
</cfif>

<!--- 
<cfdump var="#getOldClienti#"> --->
<cfloop query="getOldClienti">
	<cfquery name="getStatus" datasource="#application.dsn#">
	SELECT * FROM tbl_status WHERE id_cliente = #id_cliente# ORDER BY dt_status DESC
	</cfquery>
</cfloop>

<!--- azzero status --->
<cfif url.azzera IS "true">
	<cfloop query="getOldClienti">
		<cfquery name="updateStatus" datasource="#application.dsn#">
		UPDATE tbl_status SET bl_attivo = 0 WHERE id_cliente = #id_cliente#
		</cfquery>
	</cfloop>
</cfif>

<!--- aggiorno agente --->
<cfloop query="getOldClienti">
	<cfquery name="updateAgente" datasource="#application.dsn#">
	UPDATE tbl_clienti SET id_agente = #url.to# WHERE id_agente = #url.from#
	</cfquery>
</cfloop>

<cfset myDate = CreateDateTime(year(now()),month(now()),day(now()),12,0,0)>
<cfset riga = 1>
<cfloop query="getOldClienti">
	<cfquery name="qry" datasource="#application.dsn#">
		INSERT INTO tbl_status
		(
			id_cliente,
			id_processo,
			dt_status
		)
		VALUES
		(
			#id_cliente#,
			2,
			#myDate#
		)
	</cfquery>
	<cfset riga = riga + 1>
	<cfoutput>
	<script>
	parent.document.getElementById("message-riassegna").innerHTML = "Elaborazione record : #riga#";

	</script>
	</cfoutput>

</cfloop>
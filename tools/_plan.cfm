<cfparam name="dateFrom" default="#now()#">
<cfparam name="dateTo" default="#DateAdd('d',7,now())#">
<cfquery name="rsAll" datasource="#application.dsn#">
Select 
tbl_status.id_status,
dt_status,
DATE_FORMAT(tbl_status.dt_status,'%d/%m/%Y') AS data_status,
DATE_FORMAT(tbl_status.dt_status,'%H:%i') AS ora_status,
tbl_status.ac_note,
tbl_status.ac_docs,
tbl_status.ac_modulo_uuid,
tbl_status.id_persona,
tbl_clienti.id_cliente,
tbl_clienti.id_agente,
tbl_clienti.ac_cognome,
tbl_clienti.ac_nome,
tbl_clienti.ac_azienda,
tbl_clienti.ac_citta,
tbl_clienti.ac_indirizzo,
tbl_clienti.ac_telefono,
tbl_clienti.ac_cellulare,
tbl_clienti.ac_email,
tbl_gruppi_clienti.id_gruppo AS id_qualifica,
tbl_gruppi_clienti.ac_icona,
tbl_gruppi_clienti.ac_gruppo AS qualifica,
tbl_processi.id_processo,
tbl_processi.ac_processo,
tbl_processi.ac_sigla,
tbl_processi.ac_colore,
tbl_processi.ac_permissions,
tbl_processi.ac_modulo,
tbl_processi.bl_documento,
tbl_processi.bl_assegnazione,
tbl_processi.int_ordine,
tbl_persone.ac_cognome AS agente,
tbl_gruppi.id_gruppo AS gruppo
From
tbl_status
Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
LEFT JOIN tbl_gruppi_clienti ON tbl_clienti.id_qualifica = tbl_gruppi_clienti.id_gruppo
INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
WHERE ( tbl_status.dt_status >= #dateFrom# AND tbl_status.dt_status <= #dateTo# )
	<cfif session.livello GT 2>
		AND tbl_clienti.id_agente = #StructFind(session.userlogin,"id")#
	</cfif>

ORDER BY  tbl_processi.int_ordine, data_status ASC ,tbl_clienti.ac_cognome,   tbl_clienti.id_cliente ,   tbl_status.id_status DESC 
</cfquery>

<cfoutput query="rsAll" group="int_ordine">
	<div style="background:###ac_colore#">#ac_processo#</div>

	<ul>
		<cfoutput>
		<li>#data_status# #ora_status# - #UCASE(ac_cognome)# #UCASE(ac_nome)# [#UCASE(agente)#]</li>
		</cfoutput>
	</ul>
</cfoutput>
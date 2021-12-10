<cfquery name="checkModuli" datasource="#application.dsn#">
Select
tbl_status.id_cliente,
tbl_moduli_data.id_modulo_data,
tbl_moduli_data.ac_modulo_UUID,
tbl_status.id_status,
tbl_moduli_data.dt_registrazione
From
tbl_moduli_data
Left Join tbl_status ON tbl_moduli_data.ac_modulo_UUID = tbl_status.ac_modulo_uuid
WHERE tbl_status.id_status IS NULL
ORDER BY tbl_status.id_cliente ASC , tbl_status.id_status ASC
</cfquery>

<cfdump var="#checkModuli#">
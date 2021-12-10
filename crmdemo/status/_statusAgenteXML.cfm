<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfparam name="url.clientesearch" default="">
<cfquery name="rsAll" datasource="#application.dsn#">
Select DISTINCT(tbl_status.id_cliente) AS idc,
tbl_status.id_status,
dt_status,
DATE_FORMAT(tbl_status.dt_status,'%d/%m/%y') AS data_status,
DATE_FORMAT(tbl_status.dt_status,'%H:%i') AS ora_status,
tbl_status.ac_note,
tbl_status.ac_docs,
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
tbl_processi.id_processo,
tbl_processi.ac_processo,
tbl_processi.ac_sigla,
tbl_processi.ac_colore,
tbl_processi.bl_assegnazione,
tbl_persone.ac_cognome AS agente
From
tbl_status
Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
LEFT JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
WHERE tbl_clienti.id_agente = #StructFind(session.userlogin,"id")#
<cfif IsDefined("url.clientesearch") AND url.clientesearch NEQ "">
AND tbl_clienti.ac_cognome LIKE '#url.clientesearch#%'
</cfif>
<cfif IsDefined("url.processo") AND url.processo NEQ "">
AND tbl_status.id_processo = #url.processo#
</cfif>
<cfif IsDefined("url.idcliente")>
AND tbl_status.id_cliente= #url.idcliente#
</cfif>
ORDER BY  tbl_clienti.ac_cognome , dt_status DESC 
</cfquery>
<cfset listaColumn = "ac_cognome,ac_citta,ac_indirizzo,data_status,ac_sigla">
<cfset ColumnNames = ListToArray(listaColumn)>


<!--- <cfset ColumnNames = ListToArray(rsAll.ColumnList)> --->
<!--- Send the headers --->
<cfheader name="Content-type" value="text/xml">
<cfheader name="Pragma" value="public">
<cfheader name="Cache-control" value="private">
<cfheader name="Expires" value="-1">
<cfsetting enablecfoutputonly="no"><?xml version="1.0" encoding="ISO-8859-1"?>
<rows>
	<cfoutput query="rsAll" group="idc">
	<cfset myColor = ac_colore>
	<row id="#id_status#">
		<userdata name="id_cliente">#id_cliente#</userdata>
		<userdata name="id_status">#id_status#</userdata>
		<userdata name="id_processo">#id_processo#</userdata>
		<userdata name="cliente">#UCASE(ac_cognome)# #UCASE(ac_nome)#</userdata>
		<userdata name="status_data">#data_status#</userdata>
		<userdata name="status_ora">#ora_status#</userdata>
		<userdata name="status_processo">#ac_processo#</userdata>
		<userdata name="status_indirizzo">#ac_indirizzo#</userdata>
		<userdata name="status_citta">#ac_citta#</userdata>
		<userdata name="status_telefono">#ac_telefono#</userdata>
		<userdata name="status_cellulare">#ac_cellulare#</userdata>
		<userdata name="status_email">#ac_email#</userdata>
		<userdata name="status_note">#ac_note#</userdata>
		<userdata name="ac_colore">#ac_colore#</userdata>
		<userdata name="ac_docs">#ac_docs#</userdata>
		<userdata name="bl_assegnazione">#bl_assegnazione#</userdata>
		<cfloop from="1" to="#ArrayLen(ColumnNames)#" index="index">
		<cfset column = LCase(ColumnNames[index])>
		<cfset value = UCASE(rsAll[column][rsAll.CurrentRow])>
			<cell style="background:###mycolor#;cursor:pointer" <cfif column EQ "ac_sigla">title="#ac_note#"<cfelse>title="#ac_indirizzo# #ac_citta# #ac_telefono# #ac_cellulare#"</cfif>><![CDATA[#value#]]></cell>
		</cfloop>
			<cell style="background:###mycolor#;cursor:pointer;"></cell>
			<!---- background:###mycolor#; ---->
			<!--- <cell style="background:###mycolor#;cursor:pointer;">../include/css/icons/calendar.png^vedi^javascript:statusCliente()^_self</cell> --->
		<!--- <cfif id_processo NEQ 1><cfelse>
			<cell style="background:###mycolor#;cursor:pointer;">../include/css/icons/flag.png^In attesa^javascript:selectAgente()^_self</cell> --->
		<!--- </cfif> --->
	</row>
	<cfoutput></cfoutput>
    </cfoutput>
</rows>


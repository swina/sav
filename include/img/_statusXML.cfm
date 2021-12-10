<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfquery name="rsAll" datasource="crm">
Select DISTINCT(tbl_status.id_cliente) AS idc,
tbl_status.id_status,
DATE_FORMAT(tbl_status.dt_status,'%d-%m-%y') AS data_status,
tbl_clienti.id_cliente,
tbl_clienti.id_agente,
tbl_clienti.ac_cognome,
tbl_clienti.ac_azienda,
tbl_clienti.ac_citta,
tbl_processi.id_processo,
tbl_processi.ac_sigla,
tbl_processi.ac_colore
From
tbl_status
Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
<cfif IsDefined("url.cliente") AND url.cliente NEQ "">
WHERE ac_cognome LIKE '#url.cliente#%'
</cfif>
ORDER BY  ac_cognome , dt_status DESC 
</cfquery>

<cfset listaColumn = "id_cliente,id_agente,ac_cognome,ac_citta,data_status,ac_sigla">
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
	<row id="#id_status#" style="background:###mycolor#;" class="overRow">
		<cfloop from="1" to="#ArrayLen(ColumnNames)#" index="index">
		<cfset column = LCase(ColumnNames[index])>
		<cfset value = UCASE(rsAll[column][rsAll.CurrentRow])>
			<cell><![CDATA[#value#]]></cell>
		</cfloop>
		<cfif id_processo NEQ 1>
			<cell style="background:###mycolor#;cursor:pointer;">../include/css/icons/calendar.png^vedi^javascript:statusCliente()</cell>
		<cfelse>
			<cell style="background:###mycolor#;cursor:pointer;">../include/css/icons/process.png^In attesa^javascript:hideStatusCliente()</cell>
		</cfif>
	
	</row>
    </cfoutput>
</rows>

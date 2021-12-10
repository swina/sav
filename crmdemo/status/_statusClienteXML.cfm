<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfquery name="rsAll" datasource="#application.dsn#">
Select 
tbl_status.id_status,
DATE_FORMAT(tbl_status.dt_status,'%d/%m/%Y') AS data_status,
DATE_FORMAT(tbl_status.dt_status,'%H:%i') AS ora_status,
tbl_status.ac_note,
tbl_status.ac_docs,
tbl_status.ac_modulo_uuid,
tbl_status.ac_valore,
tbl_status.id_persona,
tbl_clienti.id_cliente,
tbl_clienti.id_agente,
tbl_clienti.ac_cognome,
tbl_clienti.ac_azienda,
tbl_clienti.ac_citta,
tbl_processi.id_processo,
tbl_processi.int_tipo,
tbl_processi.ac_processo,
tbl_processi.ac_sigla,
tbl_processi.ac_colore,
tbl_processi.ac_modulo,
tbl_processi.bl_documento,
tbl_processi.ac_permissions,
tbl_processi.bl_assegnazione,
CONCAT( tbl_persone.ac_cognome, " " , tbl_persone.ac_nome ) AS assegnazione,
tbl_persone.id_persona AS agente,
tbl_gruppi.id_gruppo AS gruppo
From
tbl_status
Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
LEFT JOIN tbl_persone ON tbl_status.id_persona = tbl_persone.id_persona
LEFT JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
WHERE tbl_clienti.id_cliente = #url.cliente#

<cfset operatore = " AND ">

<!--- <cfif StructFind(session.userlogin,"livello") GT 2 AND StructFind(session.userlogin,"livello") LT 4>
	#operatore# tbl_clienti.id_agente = #StructFind(session.userlogin,"id")#
	<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
		<cfset gruppi_abilitati = StructFind(session.userlogin,"gruppi_controllo")>
		OR  tbl_gruppi.id_gruppo IN ( #gruppi_abilitati# )
	</cfif>
	<cfset operatore = " AND ">

</cfif>  --->

<!--- <cfif StructFind(session.userlogin,"livello") EQ 2>
	#operatore# gruppo = #StructFind(session.userlogin,"id_gruppo")#
	<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
		<cfset gruppi_abilitati = StructFind(session.userlogin,"gruppi_controllo")>
		OR  tbl_gruppi.id_gruppo IN ( #gruppi_abilitati# )
	</cfif>
	<cfset operatore = " AND ">
</cfif>
 --->
<cfif StructFind(session.userlogin,"livello") EQ 4>
	OR (tbl_status.id_persona = #StructFind(session.userlogin,"id")#)
	<cfset operatore = " AND ">
</cfif>
ORDER BY  dt_status DESC 
</cfquery>

<cfset listaColumn = "data_status,ora_status,ac_sigla,id_processo">
<cfset ColumnNames = ListToArray(listaColumn)>
<!--- <cfset ColumnNames = ListToArray(rsAll.ColumnList)> --->
<!--- Send the headers --->
<cfheader name="Content-type" value="text/xml">
<cfheader name="Pragma" value="public">
<cfheader name="Cache-control" value="private">
<cfheader name="Expires" value="-1">
<cfsetting enablecfoutputonly="no"><?xml version="1.0" encoding="ISO-8859-1"?>
<rows>
	<cfoutput query="rsAll">
	<cfset permission = 0>
	<cfif session.livello GT 0>
		<cfset permission = ListGetAt(ac_permissions,session.livello)>
	<cfelse>
		<cfset permission = 1>	
	</cfif>
	<cfif permission EQ 1>
	<cfset myColor = ac_colore>
	<row id="#currentrow-1#">
		<userdata name="id_status">#id_status#</userdata>
		<userdata name="ac_note">#ac_note#</userdata>
		<userdata name="id_processo">#id_processo#</userdata>
		<userdata name="int_tipo">#int_tipo#</userdata>
		<userdata name="ac_valore">#ac_valore#</userdata>
		<userdata name="ac_processo">#ac_processo#</userdata>
		<userdata name="ac_ora">#ora_status#</userdata>
		<userdata name="ac_data">#data_status#</userdata>
		<userdata name="ac_docs">#ac_docs#</userdata>
		<userdata name="ac_modulo">#ac_modulo#</userdata>
		<userdata name="modulo_uuid">#ac_modulo_uuid#</userdata>
		<userdata name="bl_documento">#bl_documento#</userdata>
		<userdata name="bl_assegnazione">#bl_assegnazione#</userdata>
		<userdata name="id_assegnazione">#id_persona#</userdata>
		<userdata name="assegnata">#assegnazione#</userdata>
		<!--- <cell></cell> --->
		<cfloop from="1" to="#ArrayLen(ColumnNames)#" index="index">
		<cfset column = LCase(ColumnNames[index])>
		<cfset value = UCASE(rsAll[column][rsAll.CurrentRow])>
			<cell style="background:###mycolor#;cursor:pointer"><![CDATA[#value#]]></cell>
		</cfloop>
	</row>
	</cfif>
    </cfoutput>
</rows>

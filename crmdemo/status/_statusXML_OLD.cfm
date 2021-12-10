<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfparam name="url.clientesearch" default="">
<cfparam name="operatore" default=" WHERE ">
<cfparam name="url.sort" default="ASC">
<cfparam name="url.gruppo" default="">
<cfparam name="url.soloagente" default=1>
<cfparam name="url.start" default=-1>

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
tbl_clienti.ac_comunicazioni,
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
tbl_persone.ac_cognome AS agente,
tbl_gruppi.id_gruppo AS gruppo
From
tbl_status
Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
LEFT JOIN tbl_gruppi_clienti ON tbl_clienti.id_qualifica = tbl_gruppi_clienti.id_gruppo
INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo

<cfif StructFind(session.userlogin,"livello") GT 2 AND StructFind(session.userlogin,"livello") LT 4>
	<cfif url.gruppo EQ "">
	#operatore# 
	( tbl_clienti.id_agente = #StructFind(session.userlogin,"id")#
	
	<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "" AND url.soloagente EQ 0>
		<cfset gruppi_abilitati = StructFind(session.userlogin,"gruppi_controllo")>
		OR  (tbl_gruppi.id_gruppo IN ( #gruppi_abilitati# )) 
	</cfif> 
	)
	<cfset operatore = " AND ">
	
	</cfif>
</cfif> 

<cfif StructFind(session.userlogin,"livello") EQ 2>
	<cfif url.gruppo NEQ "" AND url.soloagente EQ 0>
	#operatore# 
	( tbl_gruppi.id_gruppo = #StructFind(session.userlogin,"id_gruppo")#
	<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
		<cfset gruppi_abilitati = StructFind(session.userlogin,"gruppi_controllo")>
		OR  tbl_gruppi.id_gruppo IN ( #gruppi_abilitati# )
	</cfif>
		OR
		tbl_clienti.id_agente = #StructFind(session.userlogin,"id")#
	)
	
	<cfset operatore = " AND ">
	<cfelse>
	#operatore#
	( tbl_clienti.id_agente = #StructFind(session.userlogin,"id")# )
	<cfset operarore = " AND ">
	</cfif>
</cfif>

 <cfif StructFind(session.userlogin,"livello") EQ 4>
	AND tbl_status.id_persona = #StructFind(session.userlogin,"id")#
	<cfset operatore = " AND ">
</cfif> 

<cfif IsDefined("url.clientesearch") AND url.clientesearch NEQ "" AND url.clientesearch NEQ "cerca cliente ...">
	#operatore# (tbl_clienti.ac_cognome LIKE '%#url.clientesearch#%' OR tbl_clienti.ac_azienda LIKE '%#url.clientesearch#%' OR tbl_clienti.ac_nome LIKE '%#url.clientesearch#%')
	<cfset operatore = " AND ">
</cfif>

<cfif IsDefined("url.processo") AND url.processo NEQ "">
	#operatore# tbl_status.id_processo = #url.processo#
	<cfset operatore = " AND ">
</cfif>

<cfif IsDefined("url.idcliente") AND url.idcliente NEQ "">
	#operatore# tbl_status.id_cliente= #url.idcliente#
	<cfset operatore = " AND ">
</cfif>
<cfif IsDefined("url.agente") AND url.agente NEQ "">
	#operatore# tbl_clienti.id_agente= #url.agente#
	<cfset operatore = " AND ">
</cfif>
<cfif IsDefined("url.gruppo") AND url.gruppo NEQ "" AND session.livello LT 2>
	#operatore# tbl_gruppi.id_gruppo = #url.gruppo#
	<cfset operatore = " AND ">
</cfif>
<cfif IsDefined("url.from") AND url.from NEQ "">
	<cfset startDate = CreateDateTime(ListGetAt(url.from,3,"/"),ListGetAt(url.from,2,"/"),ListGetAt(url.from,1,"/"),0,0,0)>
	#operatore# tbl_status.dt_status >= #startDate#
	<cfset operatore = " AND ">
</cfif>
<cfif IsDefined("url.todate") AND url.todate NEQ "">
	<cfset endDate = CreateDateTime(ListGetAt(url.todate,3,"/"),ListGetAt(url.todate,2,"/"),ListGetAt(url.todate,1,"/"),0,0,0)>
	#operatore# tbl_status.dt_status <= #endDate#
	<cfset operatore = " AND ">
</cfif>


ORDER BY tbl_clienti.ac_cognome,   tbl_clienti.id_cliente ,  tbl_status.dt_status DESC , tbl_status.id_status DESC 

LIMIT #url.start+1#,100
</cfquery>
<cfif session.livello LT 2 OR StructFind(session.userlogin,"gruppi_controllo") NEQ "">
	<cfset listaColumn = "ac_cognome,agente,ac_citta,data_status,ac_sigla">
<cfelse>
	<cfset listaColumn = "ac_cognome,ac_indirizzo,ac_citta,data_status,ac_sigla">		
</cfif>	
<cfquery name="getUfficioTecnico" datasource="#application.dsn#">
	SELECT 
		tbl_persone.*,
		tbl_gruppi.int_livello
	FROM tbl_persone
	INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
	WHERE tbl_gruppi.int_livello = 4
</cfquery>
<cfset assegnatari_id = ValueList(getUfficioTecnico.id_persona)>
<cfset assegnatari_name = ValueList(getUfficioTecnico.ac_cognome)>

<cfset ColumnNames = ListToArray(listaColumn)> 
<!--- Send the headers --->
<cfheader name="Content-type" value="text/xml">
<cfheader name="Pragma" value="public">
<cfheader name="Cache-control" value="private">
<cfheader name="Expires" value="-1">
<cfsetting enablecfoutputonly="no"><?xml version="1.0" encoding="ISO-8859-1"?>
<rows>
	<cfset permission = 0>
	<cfset livello = StructFind(session.userlogin,"livello")>
	<cfoutput query="rsAll" group="id_cliente">
	<cfif livello GT 0>
		<cfset permission = ListGetAt(ac_permissions,livello)>
	<cfelse>
		<cfset permission = 1>	
	</cfif>
	<cfif permission EQ 1>
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
		<userdata name="ac_modulo">#ac_modulo#</userdata>
		<userdata name="modulo_uuid">#ac_modulo_uuid#</userdata>
		<userdata name="bl_documento">#bl_documento#</userdata>
		<userdata name="id_qualifica">#id_qualifica#</userdata>
		<userdata name="ac_icona">#ac_icona#</userdata>
		<userdata name="qualifica">#qualifica#</userdata>
		<userdata name="permission">#ac_permissions#</userdata>
		<userdata name="livello">#StructFind(session.userlogin,"livello")#</userdata>
		<userdata name="bl_assegnazione">#bl_assegnazione#</userdata>
		<userdata name="id_persona">#id_persona#</userdata>
		<userdata name="ac_comunicazioni">#ac_comunicazioni#</userdata>
		<cell style="cursor:pointer;"><cfif ac_icona NEQ "">../include/css/icons/#ac_icona#^#qualifica#</cfif></cell>
		<cfloop from="1" to="#ArrayLen(ColumnNames)#" index="index">
		<cfset column = LCase(ColumnNames[index])>
		<cfset value = UCASE(rsAll[column][rsAll.CurrentRow])>
			<cell style="background:###mycolor#;cursor:pointer" <cfif column EQ "ac_sigla">title="#ac_note#"<cfelse>title="#ac_indirizzo# #ac_citta# #ac_telefono# #ac_cellulare#"</cfif>><cfif column EQ "ac_cognome">#UCASE(ac_Cognome)# #UCASE(ac_nome)#<cfelse><![CDATA[#value#]]></cfif></cell>
		</cfloop>
			<cell style="cursor:pointer;"><cfif ac_modulo_uuid NEQ "" AND ac_modulo NEQ "No"><cfif id_persona NEQ 0>
			<cfset pos = ListFind(assegnatari_id,id_persona)>
			<cfset assegnato_a = ListGetAt(assegnatari_name,pos)>
../include/css/icons/business-contact.png^#assegnato_a#<cfelse> ../include/css/icons/knobs/action_paste.gif^Vedi</cfif><cfelse>../include/css/icons/empty.png</cfif></cell>
	</row>
	</cfif>
    </cfoutput>
</rows>


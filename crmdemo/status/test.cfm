<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="yes">
<cfparam name="url.clientesearch" default="">
<cfparam name="operatore" default=" WHERE ">
<cfparam name="url.sort" default="ASC">
<cfparam name="url.gruppo" default="">
<cfparam name="url.soloagente" default=0>
<cfparam name="url.start" default=0>

<cfquery name="rsAll" datasource="#application.dsn#">
SELECT * FROM (SELECT * FROM (
SELECT tbl_status.id_status,
tbl_status.id_cliente AS idc,
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
tbl_gruppi.id_gruppo AS id_gruppo
From
tbl_status
Inner Join tbl_processi ON tbl_processi.id_processo = tbl_status.id_processo 
Inner Join tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
INNER JOIN tbl_persone ON tbl_clienti.id_agente = tbl_persone.id_persona
LEFT JOIN tbl_gruppi_clienti ON tbl_clienti.id_qualifica = tbl_gruppi_clienti.id_gruppo
INNER JOIN tbl_gruppi ON tbl_persone.id_gruppo = tbl_gruppi.id_gruppo
ORDER BY dt_status DESC) AS myresult GROUP BY idc
ORDER BY dt_status DESC ) AS result

<cfif StructFind(session.userlogin,"livello") GT 2 AND StructFind(session.userlogin,"livello") LT 4>
	<cfif url.gruppo EQ "">
	#operatore# 
	( result.id_agente = #StructFind(session.userlogin,"id")#
	
	<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "" AND url.soloagente EQ 0>
		<cfset gruppi_abilitati = StructFind(session.userlogin,"gruppi_controllo")>
		OR  (result.id_gruppo IN ( #gruppi_abilitati# )) 
	</cfif> 
	)
	<cfset operatore = " AND ">
	</cfif>
</cfif> 

<cfif StructFind(session.userlogin,"livello") EQ 2>
	<cfif url.soloagente EQ 0>
		<cfif url.gruppo EQ "">
			#operatore# 
			( 
			<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
				<cfset gruppi_abilitati = StructFind(session.userlogin,"gruppi_controllo")>
				result.id_gruppo IN ( #gruppi_abilitati# )
				<cfset operatore = " AND "> 
			<cfelse>
				result.id_agente = #StructFind(session.userlogin,"id")#	
				<cfset operatore = " AND ">
			</cfif>
			)
			
		<cfelse>
			#operatore#
			(
				result.id_gruppo IN ( #url.gruppo# ) 
			)	
			<cfset operatore = " AND ">
		</cfif>	
		
	<cfelse>
		
		#operatore#
		( result.id_agente = #StructFind(session.userlogin,"id")# )
		<cfset operatore = " AND ">
	</cfif>
	
</cfif>

 <cfif StructFind(session.userlogin,"livello") EQ 4>
	AND result.id_persona = #StructFind(session.userlogin,"id")#
	<cfset operatore = " AND ">
</cfif> 

<cfif IsDefined("url.clientesearch") AND url.clientesearch NEQ "" AND url.clientesearch NEQ "cerca cliente ...">
	#operatore# (result.ac_cognome LIKE '%#url.clientesearch#%' OR result.ac_azienda LIKE '%#url.clientesearch#%' OR result.ac_nome LIKE '%#url.clientesearch#%')
	<cfset operatore = " AND ">
</cfif>

<cfif IsDefined("url.processo") AND url.processo NEQ "">
	#operatore# result.id_processo = #url.processo#
	<cfset operatore = " AND ">
</cfif>

<cfif IsDefined("url.idcliente") AND url.idcliente NEQ "">
	#operatore# result.id_cliente= #url.idcliente#
	<cfset operatore = " AND ">
</cfif>


<cfif IsDefined("url.agente") AND url.agente NEQ "">
	#operatore# result.id_agente= #url.agente#
	<cfset operatore = " AND ">
</cfif>

<cfif IsDefined("url.gruppo") AND url.gruppo NEQ "" AND session.livello LT 4>
	#operatore# result.id_gruppo = #url.gruppo#
	<cfset operatore = " AND ">
</cfif>
<cfif IsDefined("url.from") AND url.from NEQ "">
	<cfset startDate = CreateDateTime(ListGetAt(url.from,3,"/"),ListGetAt(url.from,2,"/"),ListGetAt(url.from,1,"/"),0,0,0)>
	#operatore# result.dt_status >= #startDate#
	<cfset operatore = " AND ">
</cfif>
<cfif IsDefined("url.todate") AND url.todate NEQ "">
	<cfset endDate = CreateDateTime(ListGetAt(url.todate,3,"/"),ListGetAt(url.todate,2,"/"),ListGetAt(url.todate,1,"/"),0,0,0)>
	#operatore# result.dt_status <= #endDate#
	<cfset operatore = " AND ">
</cfif>
GROUP BY idc
ORDER BY dt_status DESC
LIMIT #url.start#,35
</cfquery>
<cfdump var="#rsAll#">
<!--- <cfif session.livello LT 2 OR StructFind(session.userlogin,"gruppi_controllo") NEQ "">
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


<cfoutput query="rsAll" group="id_cliente">
#id_cliente# #agente# #ac_cognome# #ac_processo# #data_status# #ora_status#
<hr>
</cfoutput>
<cfoutput>
#session.livello#<br>
</cfoutput>
<cfdump var="#session.userlogin#">
 --->
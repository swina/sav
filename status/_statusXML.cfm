<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfsetting requestTimeOut = "10000">
<cfparam name="url.clientesearch" default="">
<cfparam name="operatore" default=" WHERE ">
<cfparam name="url.sort" default="ASC">
<cfparam name="url.gruppo" default="">
<cfparam name="url.soloagente" default=1>
<cfparam name="url.start" default=0>
<cfparam name="url.processo" default="">
<cfparam name="operatore" default=" WHERE ">

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
tbl_status.id_persona AS ut,
tbl_status.bl_attivo,
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
tbl_clienti.ac_segnalatore,
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
	#operatore# result.ut = #StructFind(session.userlogin,"id")#
	<cfset operatore = " AND ">
</cfif> 

<cfif IsDefined("url.clientesearch") AND url.clientesearch NEQ "" AND url.clientesearch NEQ "cerca cliente ...">
	#operatore# (result.ac_cognome LIKE '%#url.clientesearch#%' OR result.ac_azienda LIKE '%#url.clientesearch#%' OR result.ac_nome LIKE '%#url.clientesearch#%')
	<cfset operatore = " AND ">
</cfif>

<cfif IsDefined("url.processo") AND url.processo NEQ "">
	#operatore# result.id_processo = #url.processo# <!--- <cfif url.processo EQ 6>OR result.id_processo = 4</cfif> --->
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
<cfif remote_addr EQ "89.118.53.254">
	#operatore# result.bl_attivo = 1
</cfif>
LIMIT #url.start#,30
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
	<cfif rsAll.recordcount GT 0>
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
	<!--- #UCASE(replace(htmleditformat(ac_Cognome),"&","&amp;amp;","ALL"))# #UCASE(replace(htmleditformat(ac_nome),"&","&amp;amp;","ALL"))#
	replace(htmleditformat(ac_note),"&","&amp;amp","ALL")
	#UCASE(replace(htmleditformat(ac_nome),"&","&amp;amp;","ALL"))#
	#UCASE(replace(htmleditformat(ac_azienda),"&","&amp;amp;","ALL"))#
	--->
	<row id="#id_status#" style="background:###ac_colore#">
		<userdata name="id_cliente">#id_cliente#</userdata>
		<userdata name="id_status">#id_status#</userdata>
		<userdata name="id_processo">#id_processo#</userdata>
		<userdata name="cliente"><![CDATA[#UCASE(ac_cognome)# #UCASE(ac_nome)#]]></userdata>
		<userdata name="status_data"><![CDATA[#data_status#]]></userdata>
		<userdata name="status_ora"><![CDATA[#ora_status#]]></userdata>
		<userdata name="status_processo"><![CDATA[#ac_processo#]]></userdata>
		<userdata name="status_indirizzo"><![CDATA[#ac_indirizzo#]]></userdata>
		<userdata name="status_citta"><![CDATA[#ac_citta#]]></userdata>
		<userdata name="status_telefono"><![CDATA[#ac_telefono#]]></userdata>
		<userdata name="status_cellulare"><![CDATA[#ac_cellulare#]]></userdata>
		<userdata name="status_email"><![CDATA[#ac_email#]]></userdata>
		<userdata name="status_note"><!--- #URLEncodedFormat(ac_note,'iso-8859-1')# ---><!--- <![CDATA[#ac_note#]]> ---></userdata>
		<userdata name="ac_colore"><![CDATA[#ac_colore#]]></userdata>
		<userdata name="ac_docs"><![CDATA[#ac_docs#]]></userdata>
		<userdata name="ac_modulo"><![CDATA[#ac_modulo#]]></userdata>
		<userdata name="modulo_uuid"><cfif len(ac_modulo_uuid) GT 0><![CDATA[#ac_modulo_uuid#]]></cfif></userdata>
		<userdata name="bl_documento"><![CDATA[#bl_documento#]]></userdata>
		<userdata name="id_qualifica"><![CDATA[#id_qualifica#]]></userdata>
		<userdata name="ac_icona"><![CDATA[#ac_icona#]]></userdata>
		<userdata name="qualifica"><![CDATA[#qualifica#]]></userdata>
		<userdata name="permission"><![CDATA[#ac_permissions#]]></userdata>
		<userdata name="livello"><![CDATA[#StructFind(session.userlogin,"livello")#]]></userdata>
		<userdata name="bl_assegnazione"><![CDATA[#bl_assegnazione#]]></userdata>
		<userdata name="id_persona"><![CDATA[#id_persona#]]</userdata>
		<userdata name="ac_comunicazioni"><![CDATA[#htmleditformat(ac_comunicazioni)#]]></userdata>
		<cell style="cursor:pointer;"><cfif ac_icona NEQ "">../include/css/icons/#ac_icona#^#qualifica#</cfif></cell>
		<cfif session.livello LT 2 OR StructFind(session.userlogin,"gruppi_controllo") NEQ "">
			<cell title="#ac_segnalatore#"><![CDATA[#UCASE(ac_cognome)#]]></cell>
			<cell><![CDATA[#UCASE(agente)#]]></cell>
			<cell title="#ac_indirizzo#"><![CDATA[#UCASE(ac_citta)#]]></cell>
			<cell><![CDATA[#UCASE(data_status)#]]></cell>
			<cell><![CDATA[#UCASE(ac_sigla)#]]></cell>
		<cfelse>
			<cell title="#ac_cognome# #ac_nome#"><![CDATA[#UCASE(ac_cognome)#]]></cell>
			<cell title="#ac_indirizzo#"><![CDATA[#UCASE(ac_indirizzo)#]]></cell>
			<cell><![CDATA[#UCASE(ac_citta)#]]></cell>
			<cell><![CDATA[#UCASE(data_status)#]]></cell>
			<cell title=""><![CDATA[#UCASE(ac_sigla)#]]></cell>	
		</cfif>
		
			<cell style="cursor:pointer;"><cfif ac_modulo_uuid NEQ "" AND ac_modulo NEQ "No"><cfif id_persona NEQ 0>
			<cfset pos = ListFind(assegnatari_id,id_persona)>
			<cfset assegnato_a = ListGetAt(assegnatari_name,pos)>
../include/css/icons/business-contact.png^#assegnato_a#<cfelse> ../include/css/icons/knobs/action_paste.gif^Vedi</cfif><cfelse>../include/css/icons/empty.png^</cfif></cell>
	</row>
	</cfif>
    </cfoutput>
	<cfelse>
		<row id="null">
		<cell>../include/css/icons/empty.png</cell>
		<cfset EOF = "Non esistono altri records">
		<cfloop from="1" to="#ArrayLen(ColumnNames)#" index="index">
			<cell><cfoutput>#EOF#</cfoutput></cell>
			<cfset EOF = "">
		</cfloop>
		<cell>../include/css/icons/empty.png</cell>
		</row>
	</cfif>
</rows>
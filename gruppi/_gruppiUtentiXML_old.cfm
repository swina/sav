<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<!--- Query the database and get all the records --->
<cfinvoke component="gruppi" method="getUtentiB" returnvariable="rsAll">
	<cfinvokeargument name="id_gruppo" value="#url.id_gruppo#">
</cfinvoke>


<cfset listaColumn = "cognome,nome,ac_email,clienti,ac_utente,ac_password,bl_cancellato,ac_sconto_riservato">
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
	<row id="#id_persona#">
		<userdata name="id_persona">#id_persona#</userdata>
		<userdata name="id_gruppo">#id_gruppo#</userdata>
		<userdata name="ac_cognome">#UCASE(ac_cognome)#</userdata>
		<userdata name="ac_nome">#UCASE(ac_nome)#</userdata>
		<userdata name="ac_indirizzo">#UCASE(ac_indirizzo)#</userdata>
		<userdata name="ac_citta">#UCASE(ac_citta)#</userdata>
		<userdata name="ac_pv">#UCASE(ac_pv)#</userdata>
		<userdata name="ac_cap">#UCASE(ac_cap)#</userdata>
		<userdata name="ac_telefono">#ac_telefono#</userdata>
		<userdata name="ac_cellulare">#ac_cellulare#</userdata>
		<userdata name="ac_email">#ac_email#</userdata>
		<userdata name="ac_utente">#ac_utente#</userdata>
		<userdata name="ac_password">#ac_password#</userdata>
		<userdata name="ac_gruppi">#ac_gruppi#</userdata>
		<userdata name="ac_sconto_riservato">#ac_sconto_riservato#</userdata>
		<userdata name="nrclienti">#clienti#</userdata>
		<cfloop from="1" to="#ArrayLen(ColumnNames)#" index="index">
		<cfset column = LCase(ColumnNames[index])>
		<cfset value = (rsAll[column][rsAll.CurrentRow])>
			<cell title="#ac_utente# #ac_password#" style="cursor:pointer"><![CDATA[#value#]]></cell>
		</cfloop>
	</row>
    </cfoutput>
</rows>

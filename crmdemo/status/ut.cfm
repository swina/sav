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
<cfoutput>
<cfset pos= ListFindNoCase(assegnatari_id,59)>
#assegnatari_id#<br>
#pos#<br>
#ListFind(assegnatari_name,pos)#<br>

</cfoutput>
<cfoutput query="getUfficioTecnico">
#id_persona# #ac_cognome#<br>

</cfoutput>
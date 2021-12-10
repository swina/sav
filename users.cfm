<cfsetting showdebugoutput="yes">
<cfquery name="getSav" datasource="savenergy">
SELECT 
	id_persona AS utenti_sav , 
	ac_nome, 
	ac_cognome, 
	ac_email 
FROM tbl_persone WHERE bl_cancellato = 0 ORDER BY ac_cognome
</cfquery>
<cfquery name="getFranchising" datasource="savmarket">
SELECT id_persona AS utenti_franchising , 
	ac_nome, 
	ac_cognome, 
	ac_email 
FROM tbl_persone 
WHERE bl_cancellato = 0
 ORDER BY ac_cognome
</cfquery>

<cfoutput>
<h4>Numero di utenti SAVEnergy : #getSav.recordcount#</h4>
</cfoutput>

<cfoutput query="getSav">
#numberformat(currentrow,'09')#. #UCASE(ac_cognome)# #UCASE(ac_nome)#  #ac_email#<br>
</cfoutput>
<hr>
<cfoutput>

<h4>Numero di utenti SAVFranchising : #getFranchising.recordcount#<br></h4>
</cfoutput>
<cfoutput query="getFranchising">
#numberformat(currentrow,'09')#. #UCASE(ac_cognome)# #UCASE(ac_nome)#  #ac_email#<br>
</cfoutput>

<br>
<br>
<cfoutput>
Totali = #getSav.recordcount+getFranchising.recordcount#<br>
</cfoutput>
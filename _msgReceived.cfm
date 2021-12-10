<cfinvoke component="messages.msg" method="getMessagesReceived" returnvariable="rsMsg">
</cfinvoke>

<cfset docs = false>
<cfset checkDate = DateFormat(now(),"YYYYMMDD")>
<div id="docs" style="display:;background:#cbe2fe;padding:4px"><strong>Messaggi recenti</strong></div>
<cfif rsMsg.recordcount GT 0>
<table width="100%">
	<tr>
		<td><strong>Data</strong></td>
		<td><strong>A</strong></td>
		<td><strong>Oggetto</strong></td>
		<td><strong>Messaggio</strong></td>
	</tr>
	<tr>
		<td colspan="4" style="border-bottom:1px solid black;font-size:4px">&nbsp;</td>
	</tr>
	<cfoutput query="rsMsg">
		<tr>
			<td valign="top">#DateFormat(dt_message,"dd.mm.yyyy")# #DateFormat(dt_message,"HH:MM")#</td>
			<td valign="top"><cfif id_to NEQ -1><cfif id_to EQ StructFind(session.userlogin,"ID")>#ac_cognome#<cfelse>#ac_gruppo#</cfif><cfelse>Tutti</cfif></td>
			<td valign="top">#ac_subject#</td>
			<td valign="top">#ac_message#</td>
		</tr>	

</cfoutput>
</table>
<cfelse>
Nessun messaggio ricevuto
</cfif>

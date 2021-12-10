<cfset locale = SetLocale("Italian (Standard)")>
<script>
function viewStatus(idc,cognome){
	window.frames[0].location = "status/index.cfm?idcliente=" + idc + "&cognome=" + cognome;
}
</script>
<cfinvoke component="tools" method="ToDoList" returnvariable="qry"></cfinvoke>
<cfif qry.recordcount GT 0>
<table class="winblue" cellpadding="2" cellspacing="0" style="width:95%;margin-right:2px;">
	<tr>
		<td style="border-bottom:1px solid black" colspan="3">
		<cfoutput>#LSDateFormat(now(),"ddd dd/mm/yy")#</cfoutput><br>
		<strong>ToDo List</strong></td>
	</tr>
	<cfoutput query="qry">
	<cfset permission = 0>
	<cfif StructFind(session.userlogin,"livello") GT 0>
		<cfif ListGetAt(ac_permissions,StructFind(session.userlogin,"livello")) EQ 1>
			<cfset permission = 1>
		</cfif>
	<cfelse>
		<cfset permission = 1>
	</cfif>
	<cfif permission EQ 1>
	<tr style="background:###ac_colore#;" title="#ac_indirizzo# #ac_citta# #ac_telefono# #ac_cellulare#">
		<td style="font-size:10px" valign="top">#ora_status#</td>
		<td style="font-size:10px" valign="top">#UCASE(ac_cognome)#</td>
		<td style="font-size:10px" valign="top"><a href="##" onclick="viewStatus(#id_cliente#,'#UCASE(ac_cognome)#')">#ac_sigla#</a></td>
	</tr>
	</cfif>
	</cfoutput>
	
</table>
</cfif>

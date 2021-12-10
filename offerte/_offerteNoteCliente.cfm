<cfinvoke component="offerte" method="getNote" returnvariable="rsNote">
	<cfinvokeargument name="id_cliente" value="#url.id_cliente#">
</cfinvoke>

<cfset myNotes = "">
<cfoutput query="rsNote">
	<cfif ac_note NEQ "">
	#dateFormat(dt_status,"dd/mm/yyyy")#<br>
	#ac_note#<br>
	<hr>
	<cfset myNotes = "#myNotes#<br>#ac_note#">
	</cfif>
</cfoutput>


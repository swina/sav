<cfinvoke component="crmdemo.plan.plan" method="getGruppiAgenti" returnvariable="rsGruppiAgenti"></cfinvoke>
<cfinvoke component="crmdemo.plan.plan" method="getAgenti" returnvariable="rsAgenti"></cfinvoke>
<cfinvoke component="crmdemo.status.status" method="getProcessi" returnvariable="rsProcessi"></cfinvoke>
<cfoutput>
<cfajaximport>
<cfform id="periodoFrm">
<div style="width:250px">
	<div class="winhead"><span id="stat"><strong>Messaggi Periodo</strong></span></div><br>
	
	dal <input type="text" name="dateFrom" id="dateFrom" size="10" value="#DateFormat(DateAdd('d',-30,now()),'dd/mm/yyyy')#"> 
	al <input type="text" name="dateTo" id="dateTo" size="10" value="#DateFormat(now(),'dd/mm/yyyy')#"> 
	<br>
	<cfif session.livello LT 2>
		<cfset mydisplay = "">
		<cfset gruppiUtente = ValueList(rsGruppiAgenti.id_gruppo)>
		<input type="hidden" name="gruppi_controllo" id="gruppi_controllo"  value="">
	<cfelse>
		<cfset mydisplay = "none">
		<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
			<cfset mydisplay = "">
			<cfset gruppiUtente = StructFind(session.userlogin,"gruppi_controllo")>
			<input type="hidden" name="gruppi_controllo" id="gruppi_controllo"  value="#StructFind(session.userlogin,'gruppi_controllo')#">
		<cfelse>
			<input type="hidden" name="gruppi_controllo" id="gruppi_controllo"  value="">
			<cfset mydisplay = "none">	
			<cfset gruppiUtente = "">
		</cfif>
	</cfif>
	<table cellpadding="2" cellspacing="0" width="100%">
		<tr style="display:#mydisplay#">
			<td>Gruppi Agenti</td>
			<td>
			<select name="id_gruppo_agenti" id="id_gruppo_agenti">
			<option value="0">...</option>
			<cfloop query="rsGruppiAgenti">
				<cfoutput>
				<!--- <cfif ListFind(gruppiUtente,id_gruppo)> ---><option value="#id_gruppo#">#ac_gruppo#</option><!--- </cfif> --->
				</cfoutput>
			</cfloop>
			</select>
			</td>
		</tr>	
	
	
	<cfif session.livello LT 3>
		<cfset mydisplay = "">
	<cfelse>
		<cfif StructFind(session.userlogin,"gruppi_controllo") NEQ "">
			<cfset mydisplay = "">
		<cfelse>
			<cfset mydisplay = "none">	
		</cfif>
	</cfif>
	
	<tr style="display:#mydisplay#">
		<td>Agente</td>
		<td>
		<select name="id_agente" id="id_agente">
		<option value="0">...</option>
		<cfloop query="rsAgenti">
			<cfif StructFind(session.userlogin,"id") EQ id_persona AND session.livello GT 2>
				<option value="#id_persona#" selected>#UCASE(ac_cognome)# #UCASE(ac_nome)#</option>
			<cfelse>
				<option value="#id_persona#">#UCASE(ac_cognome)# #UCASE(ac_nome)#</option>	
			</cfif>
		</cfloop>
		</select>	
		</td>
	</tr>	
	
	<tr>
		<td colspan="2">
		<cfif session.livello LT 2>
			<cfset mydisplay = "">
		<cfelse>
			<cfset mydisplay = "none">	
		</cfif>
		<div style="display:<cfoutput>#myDisplay#</cfoutput>">
		<input type="checkbox" name="id_to" id="id_to" value="-1" style="display:<cfoutput>#mydisplay#</cfoutput>"> Tutti
		</div>
		<input type="hidden" name="invio_generale" id="invio_generale" value="0">
		</td>
	</tr>
	<!--- <tr>
		<td>Processo</td>
		<td>
		<select id="id_processo" name="id_processo">
		<option value="">...</option>
		<cfloop query="rsProcessi">
			<option value="#id_processo#">#ac_sigla#</option>
		</cfloop>			
	</select>
		</td>
	</tr> --->
	
	<tr>
		<td colspan="2" align="center">
		<input type="button" class="btn" value="Vedi" onclick="viewMsg()"> <input type="button" class="btn" value="Nuovo" onclick="createMsg()" style="display:<cfoutput>#myDisplay#</cfoutput>">
		</td>
	</tr>
	
	<tr id="newMsg" style="display:none">
		<td colspan="2">
		Oggetto:<br>
		<input type="text" name="ac_subject" id="ac_subject" size="45"><br>
		Testo:<br>
		<textarea name="ac_message" id="ac_message" rows="20" cols="45"></textarea><br>
		<input type="button" class="btn" value="Invia" onclick="sendMsg()">
		
		</td>
	</tr>
	
	</table>
	
</div>	
</cfform>
</cfoutput>
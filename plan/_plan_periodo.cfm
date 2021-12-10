<cfinvoke component="plan" method="getGruppiAgenti" returnvariable="rsGruppiAgenti"></cfinvoke>
<cfinvoke component="plan" method="getAgenti" returnvariable="rsAgenti"></cfinvoke>
<cfinvoke component="status.status" method="getProcessi" returnvariable="rsProcessi"></cfinvoke>
<cfoutput>
<cfform id="periodoFrm">
<div style="width:250px">
	<div class="winhead"><span id="stat"><strong>PIANO OPERATIVO PERIODO</strong></span></div><br>
	
	dal <input type="text" name="dateFrom" id="dateFrom" size="10" value="#DateFormat(DateAdd('d',-7,now()),'dd/mm/yyyy')#"> 
	al <input type="text" name="dateTo" id="dateTo" size="10" value="#DateFormat(DateAdd('d',7,now()),'dd/mm/yyyy')#"> 
	<br>
	<cfif session.livello EQ 0>
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
			<option value="">tutti</option>
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
			<cfset mydisplay="none">
		</cfif>
	</cfif>
	
	<tr style="display:#mydisplay#">
		<td>Agente</td>
		<td>
		<select name="id_agente" id="id_agente">
		<option value="">tutti</option>
		<option value="#StructFind(session.userlogin,'id')#">#StructFind(session.userlogin,"utente")#
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
		<td>Processo</td>
		<td>
		<select id="id_processo" name="id_processo">
		<option value="">tutti</option>
		<cfloop query="rsProcessi">
			<option value="#id_processo#">#ac_sigla#</option>
		</cfloop>			
	</select>
		</td>
	</tr>
	
	<tr>
		<td colspan="2" align="center">
		<input type="button" class="btn" value="Vedi" onclick="setPlan()">
		</td>
	</tr>
	</table>
	
</div>	
</cfform>
</cfoutput>
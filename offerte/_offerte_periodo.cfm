<cfinvoke component="offerte" method="getGruppiAgenti" returnvariable="rsGruppiAgenti"></cfinvoke>
<cfinvoke component="offerte" method="getAgenti" returnvariable="rsAgenti"></cfinvoke>
<cfinvoke component="offerte" method="getUT" returnvariable="rsUT"></cfinvoke>
<cfinvoke component="crmdemo.status.status" method="getProcessi" returnvariable="rsProcessi"></cfinvoke>
<cfoutput>
<cfform id="periodoFrm">
<div style="width:100%">
	<div class="winhead"><span id="stat"><strong>GESTIONE OFFERTE</strong></span></div>
	<table cellpadding="2" cellspacing="5">
	
		<tr>
			<td valign="top">
			dal <input type="text" name="dateFrom" id="dateFrom" size="10" value="#DateFormat(DateAdd('d',-7,now()),'dd/mm/yyyy')#"> 
	al <input type="text" name="dateTo" id="dateTo" size="10" value="#DateFormat(DateAdd('d',7,now()),'dd/mm/yyyy')#"> 
	
	
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
			</td>
			<td valign="top">
			<strong>Rich. Offerte da evadere</strong> <input type="checkbox" id="noOfferte" name="noOfferte" checked></td>
<!--- 		</tr>

		<tr> --->
			<td style="display:#mydisplay#" valign="top">
			Cliente 
			<input type="text" name="ac_cliente" id="ac_cliente" value="">
			</td>
<!--- 		</tr>	
		<tr> --->
			<td style="display:#mydisplay#" valign="top">Gruppi Agenti 
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
	<tr>
	
	<cfif session.livello LT 3>
		<cfset mydisplay = "">
	<cfelse>
		<cfset mydisplay = "none">
	</cfif>
	
	<!--- <tr style="display:#mydisplay#"> --->
		<td style="display:#mydisplay#" valign="top">Agente 
		<select name="id_agente_filter" id="id_agente_filter">
		<option value="">tutti</option>
		<cfloop query="rsAgenti">
			<cfif StructFind(session.userlogin,"id") EQ id_persona AND session.livello GT 2>
				<option value="#id_persona#" selected>#UCASE(ac_cognome)# #UCASE(ac_nome)#</option>
			<cfelse>
				<option value="#id_persona#">#UCASE(ac_cognome)# #UCASE(ac_nome)#</option>	
			</cfif>
		</cfloop>
		</select>	
		</td>
	<!--- </tr>	 --->
	
	<cfif session.livello LT 2>
		<!--- <tr> --->
			<td style="display:#mydisplay#" valign="top">Ufficio Tecnico 
			<select name="id_ut" id="id_ut">
				<option value="">tutti</option>
				<cfloop query="rsUT">
					<cfoutput>
						<option value="#id_persona#">#UCASE(ac_cognome)# #UCASE(ac_nome)#</option>
					</cfoutput>
				</cfloop>
			</select>
			</td>
		<!--- </tr> --->
		<cfelse>
			<select name="id_ut" id="id_ut" style="display:none">
				<option value="" selected>
			</select>
		</cfif>
	<!--- <tr> --->
		<td valign="top">Processo <select id="id_processo" name="id_processo">
		<option value="">tutti</option>
		<cfloop query="rsProcessi">
			<option value="#id_processo#">#ac_sigla#</option>
		</cfloop>			
	</select>
		</td>
	<!--- </tr>
	<tr> --->
		<td align="right" valign="top">
		<input type="button" class="btn" value="   Vedi  " onclick="setPlan()">
		</td>
	</tr>
	</table>
	
</div>	
</cfform>
<form id="moduloFrm">
	
	<input type="hidden" name="ac_modulo_uuid" id="ac_modulo_uuid">
</form>
</cfoutput>
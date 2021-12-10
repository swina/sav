<cfinvoke component="crm.status.status" method="getGruppiAgenti" returnvariable="rsGruppiAgenti"></cfinvoke>
<cfinvoke component="crm.status.status" method="getAgenti" returnvariable="rsAgenti"></cfinvoke>
<cfinvoke component="crm.status.status" method="getProcessi" returnvariable="rsProcessi"></cfinvoke>
<cfoutput>
<cfform id="periodoFrm">
	<span id="stat"><strong>INDICI OPERATIVI</strong></span><br>
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
	
	<div style="display:#mydisplay#">
	<div class="col80" style="display:#mydisplay#">
	Gruppi Agenti 
	</div>
	<div>
	<select name="id_gruppo_agenti" id="id_gruppo_agenti">
		<option value="">tutti</option>
		<cfloop query="rsGruppiAgenti">
				<cfoutput>
				<cfif ListFind(gruppiUtente,id_gruppo)><option value="#id_gruppo#">#ac_gruppo#</option></cfif>
				</cfoutput>
		</cfloop>
		<!--- <cfloop query="rsGruppiAgenti">
			<option value="#id_gruppo#">#UCASE(ac_gruppo)#</option>
		</cfloop> --->
	</select><br>
	</div>
	</div>	
	
	<cfif session.livello EQ 0>
		<cfset mydisplay = "">
	<cfelse>
		<cfset mydisplay = "none">
	</cfif>
	
	<div style="display:#mydisplay#">
	<div class="col80" style="display:#mydisplay#">
	Agente 
	</div>
	<div>
	<select name="id_agente" id="id_agente">
		<option value="" selected>tutti</option>
		<cfloop query="rsAgenti">
			<cfif StructFind(session.userlogin,"id") EQ id_persona AND session.livello GT 2>
				<option value="#id_persona#" selected>#UCASE(ac_cognome)# #UCASE(ac_nome)#</option>
			<cfelse>
				<option value="#id_persona#">#UCASE(ac_cognome)# #UCASE(ac_nome)#</option>	
			</cfif>
		</cfloop>
	</select><br>
	</div>
	</div>
	<div class="col80">
	processo 
	</div>
	<div>
	<select id="id_processo_start" name="id_processo_start">
		<option value="">tutti</option>
		<cfloop query="rsProcessi">
			<option value="#id_processo#">#ac_sigla#</option>
		</cfloop>			
	</select>
	</div>
	<div class="col80">
	a processo 
	</div>
	<div>
	<select id="id_processo_end" name="id_processo_end">
		<option value="">tutti</option>
		<cfloop query="rsProcessi">
			<option value="#id_processo#">#ac_sigla#</option>
		</cfloop>			
	</select>
	</div>
	<div class="col80">
	% su contatti
	</div>
	<div>
	<input type="checkbox" id="radio_100" name="radio_100" value="contatti_100" checked>
	</div>
	<div class="col80">
	media giorni
	</div>
	<div>
	<input type="checkbox" id="media_giorni" name="media_giorni" value="media_giorni">
	</div>
	<div class="col80">
	giorni
	</div>
	<div>
	<input type="checkbox" id="nr_giorni" name="nr_giorni" value="nr_giorni">
	</div>
	<input type="button" class="btn" value="Vedi" onclick="setAnalisi(0)">
</cfform>
</cfoutput>
<cfinvoke component="plan.plan" method="getGruppiAgenti" returnvariable="rsGruppiAgenti"></cfinvoke>
<cfinvoke component="plan.plan" method="getAgenti" returnvariable="rsAgenti"></cfinvoke>
<cfinvoke component="status.status" method="getProcessi" returnvariable="rsProcessi"></cfinvoke>
<cfoutput>
<cfajaximport>
<form id="periodoFrm">
		<div style="float:left;margin-right:20px"><input type="checkbox" id="bl_soloagente" name="bl_soloagente" onclick="reloadAgenda(this)"> solo i miei contatti</div>
		<div style="float:left;margin-right:20px;display:none">
		dal <input type="text" name="dateFrom" id="dateFrom" size="10" value="#DateFormat(DateAdd('m',-3,now()),'dd/mm/yyyy')#"> 
		al <input type="text" name="dateTo" id="dateTo" size="10" value="#DateFormat(now(),'dd/mm/yyyy')#"> 
		</div>
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
	<div style="display:#mydisplay#;float:left">
	Gruppi Agenti
	<select name="id_gruppo_agenti" id="id_gruppo_agenti">
			<option value="">tutti</option>
			<cfloop query="rsGruppiAgenti">
				<cfoutput>
				<option value="#id_gruppo#">#ac_gruppo#</option>
				</cfoutput>
			</cfloop>
			</select>
	</div>
	<cfif session.livello LT 3 OR StructFind(session.userlogin,"gruppi_controllo") NEQ "">
		<cfset mydisplay = "">
	<cfelse>
		<cfset mydisplay = "none">
	</cfif>
		
	<div style="display:#mydisplay#;float:left">
	Agente
	<select name="id_agente" id="id_agente">
		<option value="">tutti</option>
		<cfloop query="rsAgenti">
			<cfif StructFind(session.userlogin,"id") EQ id_persona AND session.livello GT 2>
				<option value="#id_persona#" selected>#UCASE(ac_cognome)# #UCASE(ac_nome)#</option>
			<cfelse>
				<option value="#id_persona#">#UCASE(ac_cognome)# #UCASE(ac_nome)#</option>	
			</cfif>
		</cfloop>
		</select>	
	</div>	
	<div style="float:left">
		<input type="button" class="btn" value="Vedi" onclick="setAgenda()">
	</div>
	<div id="warning" style="float:left;display:;vertical-align:middle;color:white;background:orange;padding:4px">Caricamento in corso ...</div>
</cfoutput>	

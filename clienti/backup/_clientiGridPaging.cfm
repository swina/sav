<cfinvoke component="clienti" method="province" returnvariable="rsProvince"></cfinvoke>
<cfinvoke component="clienti" method="totaleClienti" returnvariable="pagine">

<cfinvokeargument name="pagesize" value="27">
</cfinvoke> 
<cfinvoke component="clienti" method="getQualificaClienti" returnvariable="qualifiche"></cfinvoke>
<cfoutput>
<cfform id="assegnaFrm">
<div style="float:left">
<input type="button" id="btnStartPage" value="|&laquo;" class="btn" onclick="startPage()" style="display:none">
<input type="button" id="btnPrevPage" value="&laquo;" class="btn" onclick="prevPage()" style="display:none"> <!--- <span class="btn"> ---> Pag. <input type="text" id="currentPage" value="1" size="2" style="width:22px" readonly> di <input type="text" id="totalPages" value="#pagine#" size="2" style="width:22px" readonly><!---  </span> --->
<input type="button" id="btnNextPage" value="&raquo;" class="btn" onclick="nextPage()"><input type="button" id="btnEndPage" value="&raquo;|" class="btn" onclick="endPage()" style="display:">
</div>
<div style="float:left;margin-left:10px;vertical-align:center">
		<div style="float:left; display:" id="filterDIV">
		<input type="text" id="searchValue" value="cerca cliente ..." onfocus="clearValue(this)" size="10">
		<!---  UTILIZZATO PER FILTRO RICERCA --->
		<select id="filtro_posizione" name="filtro_posizione" <cfif session.livello GT 1>style="display:none"</cfif>>
			<option value="-1">Tutti</option>
			<option value="0">da assegnare</option>
			<option value="1">assegnati</option>
		</select>
		&nbsp;
		 Qualifica <select id="filtro_gruppo" name="filtro_gruppo">
			<option value="-1">Tutti</option>
			<cfloop query="qualifiche">
				<option value="#id_gruppo#">#ac_gruppo#</option>
			</cfloop>
		</select>
		<select id="qualifica" name="qualifica" style="display:none">
			<cfloop query="qualifiche">
				<option value="#ac_icona#">#ac_gruppo#</option>
			</cfloop>
		</select>
		<input type="hidden" id="bl_attivo" name="bl_attivo" value=1>
		<input type="hidden" id="id_cliente_qualifica" name="id_cliente_qualifica">
		<input type="hidden" id="id_qualifica" name="id_qualifica">
		&nbsp;
		Prov. <select id="filtro_pv" name="filtro_pv">
			<option value="null">Tutte</option>
			<cfloop query="rsProvince">
				<option value="#ac_sigla#">#ac_sigla#</option>
			</cfloop>
		</select>
		&nbsp;
		<img src="../include/css/icons/search.png" onclick="doSearch()" title="Cerca cliente" alt="Cerca cliente" align="absmiddle" style="cursor:pointer">
		</div>
		
		
		<cfif session.livello GT 2>
			<div style="display:none;float:left">
		<cfelse>
			<div style="display:;float:left">
		</cfif>
		<!--- UTILIZZATO PER ASSEGNAZIONE AGENTE --->
		<input type="button" id="btnAssegna" value="Assegna" class="btn" onclick="doAssegnaMultiple()">
		<select id="id_agente_assegna" name="id_agente_assegna" style="display:none" onchange="assegnaAgente(this)">
			<option value="">Non Assegnato</option>
			<cfloop query="agentiQry">
				<cfoutput>
				<option value="#agentiQry.id_persona#">#agentiQry.agente#</option>
				</cfoutput>	
			</cfloop>
		</select> <img src="../include/css/icons/knobs/action_refresh_blue.gif" title="aggiorna" align="absmiddle" onclick="reloadClienti()" style="cursor:pointer"><img src="../include/css/icons/files/XLS.png" onclick="printClienti()" title="Crea Excel" style="cursor:pointer;" align="absmiddle">
		</div>
		<cfinput type="hidden" id="id_da_assegnare" name="id_da_assegnare">	
		<input type="hidden" name="currentFilter" id="currentFilter">	
</div>
</cfform>
</cfoutput>
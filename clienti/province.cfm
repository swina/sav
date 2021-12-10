<script>
function getComuni(){
	setValore("provincia",comboGet("id_provincia")[1]);
	setValore("provincia_id",comboGet("id_provincia")[0]);
	document.getElementById("clienteFrm").submit();
	
}

function setCap(obj){
	var indice = comboGetIndex("id_comune");
	setValore("provincia_id",comboGet("id_provincia")[0]);
	setValore("comune",comboGet("id_comune")[1]);
	setValore("comune_id",comboGet("id_comune")[0]);
	comboSetIndex("cap",indice);
	setValore("ac_cap",comboGet("cap")[0]);
}
</script>
<cfif form.provincia EQ "">
	<cfset form.provincia = ac_pv>
</cfif>
<cfsetting showdebugoutput="yes">
<cfif IsDefined("form.id_provincia") AND form.id_provincia NEQ "">
	<cfinvoke component="clienti" method="getComune" returnvariable="qryComuni">
		<cfinvokeargument name="id_provincia" value="#form.id_provincia#">
	</cfinvoke>
	
</cfif><cfinvoke component="clienti" method="getProvince" returnvariable="qryProv"></cfinvoke>
<fieldset>
	<legend><strong>Valori ISTAT (valori obbligatori per configuratore)</strong></legend>

<strong>Provincia* </strong> <select name="id_provincia" id="id_provincia" onchange="getComuni()" >
	 <option value="0">----
	<cfoutput query="qryProv">
		<cfif IsDefined("form.id_provincia")>
			<cfif form.id_provincia EQ id_provincia>
				<option value="#id_provincia#" selected>#sigla_automobilistica#
			<cfelse>
				<option value="#id_provincia#">#sigla_automobilistica#		
			</cfif>
		</cfif>
		<!---
		<cfelse>
			<cfif getCliente.ac_pv EQ sigla_automobilistica>
				<option value="#id_provincia#" selected>#sigla_automobilistica#	
			<cfelse> --->
				<option value="#id_provincia#">#sigla_automobilistica#		
			<!--- </cfif>
			
		</cfif>
		 --->
	</cfoutput>
</select>
<br>

<cfif IsDefined("form.id_provincia") AND form.id_provincia NEQ "">
<strong>Comune* </strong>
<select id="id_comune" name="id_comune" onchange="setCap()">
		<option value="0">seleziona comune
		<cfoutput query="qryComuni">
			<option value="#id_comune#">#denominazione#
		</cfoutput>
	</select>
	<cfoutput>
	
	</cfoutput>
	<select id="cap" name="cap" style="display:none">
		<option value="0">-----
		<cfoutput query="qryComuni">
			<option value="#cap#">#cap#
		</cfoutput>
	</select>
	
</cfif>

</fieldset>


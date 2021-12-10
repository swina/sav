<cfinvoke component="status" method="getQualificaClienti" returnvariable="qualifiche"></cfinvoke>
<cfform id="qualificaCliente">
	<cfoutput>
	<input type="hidden" name="id_cliente_qualifica" id="id_cliente_qualifica">
	<input type="hidden" name="id_qualifica" id="id_qualifica">
 	<select id="filtro_gruppo" name="filtro_gruppo" style="display:none">
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
	</cfoutput>	
</cfform>
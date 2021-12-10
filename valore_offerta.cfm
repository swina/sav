<cfif IsDefined("url.idc") AND isDefined("url.valore") AND IsDefined("url.docs")>
	<cfquery name="getStatusOfferta" datasource="#application.dsn#">
		SELECT * FROM tbl_status WHERE id_cliente = #url.idc# AND id_processo = 9 ORDER BY dt_status DESC 
	</cfquery>
	<cfquery name="getStatusRichiesta" datasource="#application.dsn#">
		SELECT * FROM tbl_status WHERE id_cliente = #url.idc# AND id_processo = 6 ORDER BY dt_status DESC 
	</cfquery>
	<cfif getStatusOfferta.recordcount EQ 0 AND getStatusRichiesta.recordcount GT 0>
		<cfquery name="addOfferta" datasource="#application.dsn#">
		INSERT INTO tbl_status
		(
			id_cliente 				,
			id_processo				,
			dt_status				,
			ac_valore				,
			ac_docs					,
			ac_modulo_uuid			,
			bl_evasa
		)
		VALUES
		(
			#url.idc#								,
			9										,
			#now()#									,
			"#url.valore#"							,
			"#url.docs#"							,
			"#getStatusRichiesta.ac_modulo_uuid#"	,
			1
		)
		</cfquery>
	</cfif>
	<!--- <cfdump var="#getStatusOfferta#">	 --->
</cfif>
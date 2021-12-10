<!--- <cffile action="READ" file="#expandpath('..')#\import\agenti.txt" variable="rsClienti">
<cfset rsClienti = replace(rsClienti,";;", ";null;","ALL")>
<cfset rsClienti = replace(rsClienti,";;", ";null;","ALL")>
<cfloop index="i" list="#rsclienti#" delimiters="#chr(10)#">
<cfoutput>#i#<br>
</cfoutput>
</cfloop> --->
<br>
<br>

<!---
IMPORT CLIENTI
 <cfloop index="i" list="#rsClienti#" delimiters="#chr(10)#">
	<cfset i = replace(i,"(","-","ALL")>
	<cfset i = replace(i,")","-","ALL")>
	<cfset id_import = ListGetAt(i,1,"§")>
	<cfset id_agente = ListGetAt(i,2,"§")>
	<cfset cognome = ListGetAt(i,3,"§")>
	<cfset indirizzo = ListGetAt(i,4,"§")>
	<cfset citta = ListGetAt(i,5,"§")>
	<cfset pv = ListGetAt(i,6,"§")>
	<cfset cap = ListGetAt(i,7,"§")>
	<cfset telefono = ListGetAT(i,8,"§")>
	<cfset email = ListGetAt(i,11,"§")>
	<cfif id_agente NEQ "null">
	<cfoutput>
		<cfquery name="addCliente" datasource="crm">
		INSERT INTO tbl_clienti_copy
		(
			id_cliente_import,
			id_agente,
			ac_cognome,
			ac_indirizzo,
			ac_citta,
			ac_pv,
			ac_cap,
			ac_telefono,
			ac_email
		)
		VALUES
		(
			#id_import#,
			#id_agente#,
			"#cognome#",
			"#indirizzo#",
			"#UCASE(citta)#",
			<cfif pv NEQ "null">"#UCASE(pv)#"<cfelse>""</cfif>,
			<cfif cap NEQ "null">"#cap#"<cfelse>""</cfif>,
			<cfif telefono NEQ "null">"#telefono#"<cfelse>''</cfif>,
			<cfif email NEQ "null">"#email#"<cfelse>''</cfif>
		)
		</cfquery>
		#id_import#. #cognome# #indirizzo#<br>
	</cfoutput>
	</cfif>
</cfloop>  --->

<!---- IMPORT AGENTI --->
 <!--- <cfloop index="i" list="#rsClienti#" delimiters="#chr(10)#">
	<cfset id_agente_import = ListGetAt(i,1,";")>
	<cfset cognome = ListGetAt(i,3,";")>
	<cfset nome = ListGetAt(i,4,";")>
	<cfset email = ListGetAt(i,12,";")>
	<cfoutput>
		<cfquery name="addAgente" datasource="crm">
		INSERT INTO tbl_persone_copy
		(
			id_agente_import,
			id_gruppo,
			ac_cognome,
			ac_nome,
			ac_email
		)
		VALUES
		(
			#id_agente_import#,
			3,
			"#cognome#",
			<cfif nome NEQ "NULL">"#nome#"<cfelse>''</cfif>,
			<cfif email NEQ "NULL">"#email#"<cfelse>''</cfif>
		)
		</cfquery>
		#id_agente_import#. #cognome# #nome# #email#<br>
	</cfoutput>
</cfloop> --->

<!--- BONIFICA NUOVI ID --->
<!--- <cfquery name="getClienti" datasource="crm">
SELECT * FROM tbl_clienti_copy WHERE id_agente <> 0 
</cfquery>

<cfoutput query="getClienti">
	<cfquery name="getNewId" datasource="crm">
		SELECT id_persona FROM tbl_persone_copy WHERE id_agente_import = #id_agente#
	</cfquery>
	#id_agente#<br>
	<cfquery name="updateIDAgente" datasource="crm">
	UPDATE tbl_clienti_copy SET id_agente = #getNewId.id_persona# WHERE id_agente = #id_agente#
	</cfquery>
</cfoutput>	
 --->
 
<cfquery name="getClienti" datasource="crm">
SELECT * FROM tbl_clienti_copy 
</cfquery>
<cfoutput query="getClienti">
	<cfset myCognome = replace(ac_cognome,"&","e","ALL")>
	<cfquery name="update" datasource="crm">
	UPDATE tbl_clienti SET ac_cognome = "#myCognome#" WHERE id_cliente = #id_cliente#
	</cfquery>
</cfoutput>

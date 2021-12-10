<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfinvoke component="setup" method="getProcessi" returnvariable="rsAll"></cfinvoke>
<!--- <cfquery name="rsAll" datasource="#application.dsn#">
Select * FROM tbl_processi
ORDER BY int_ordine
</cfquery> --->
<cfinvoke component="setup" method="getModuli" returnvariable="moduli"></cfinvoke>
<cfset listaColumn = "ac_processo,ac_sigla,int_timer_limit,int_status,ac_colore">
<cfset ColumnNames = ListToArray(listaColumn)>
<cfset listaModuli = "No,#moduli#">

<!--- <cfset ColumnNames = ListToArray(rsAll.ColumnList)> --->
<!--- Send the headers --->
<cfheader name="Content-type" value="text/xml">
<cfheader name="Pragma" value="public">
<cfheader name="Cache-control" value="private">
<cfheader name="Expires" value="-1">
<cfsetting enablecfoutputonly="no"><?xml version="1.0" encoding="ISO-8859-1"?>
<rows>
	<cfoutput query="rsAll">
	<row id="#id_processo#">
		<userdata name="id_processo">#id_processo#</userdata>
		<userdata name="int_tipo">#int_tipo#</userdata>
		<userdata name="int_ordine">#int_ordine#</userdata>
		<userdata name="ac_processo">#UCASE(ac_processo)#</userdata>
		<userdata name="ac_sigla">#UCASE(ac_sigla)#</userdata>
		<userdata name="ac_colore">#ac_colore#</userdata>
		<userdata name="int_timer_limit">#int_timer_limit#</userdata>
		<!--- <userdata name="int_reiterazione_frequency">#int_reiterazione_frequency#</userdata>
		<userdata name="int_reiterazione_event">#int_reiterazione_event#</userdata> --->
		<userdata name="int_prealert">#int_prealert#</userdata>
		<userdata name="int_prealert_event">#int_prealert_event#</userdata>
		<userdata name="int_postalert">#int_postalert#</userdata>
		<userdata name="int_postalert_event">#int_postalert_event#</userdata>
		<userdata name="int_status">#int_status#</userdata>
		<userdata name="int_gerarchia">#int_gerarchia#</userdata>	
		<userdata name="ac_permissions">#ac_permissions#</userdata>	
		<cfloop from="1" to="#ArrayLen(ColumnNames)#" index="index">
			<cfset column = LCase(ColumnNames[index])>
			<cfset value = UCASE(rsAll[column][rsAll.CurrentRow])>
			<cell style="cursor:pointer"><![CDATA[#value#]]></cell>
		</cfloop>
		<cell style="padding:2px;background:###ac_colore#"></cell>
		<cell xmlcontent="1" editable="0" title="Doppio click per selezionare il modulo da compilare" style="cursor:help">#ac_modulo#
			<cfloop index="i" list="#listaModuli#">
				<cfif ac_modulo NEQ i>
				<option value="#i#">#i#</option>
				</cfif>
			</cfloop>
		</cell>	
		<cell style="cursor:pointer"><cfif int_ordine LT 2>../include/css/icons/empty.png<cfelse>../include/css/icons/knobs/arrow_up.gif^Ordina</cfif></cell>
	</row>
    </cfoutput>
	<row id="0">
		<userdata name="id_processo">0</userdata>
		<cfloop index="i" from="0" to="#ListLen(listaColumn)-1#">
		<cell title="Doppio click su questa riga per inserire un nuovo processo" style="cursor:help"></cell>
		</cfloop>
		<cell>../include/css/icons/empty.png</cell>
	</row>
</rows>
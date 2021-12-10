<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfparam name="url.dateFrom" default="#DateFormat(now(),'dd/mm/yyyy')#">
<cfparam name="url.dateTo" default="#DateFormat(DateAdd('d',7,now()),'dd/mm/yyyy')#">
<cfparam name="url.id_gruppo_agenti" default="">
<cfparam name="url.id_agente" default="">
<cfparam name="url.id_processo" default="">

<cfinvoke component="plan" method="plan" returnvariable="rsAll">
	<cfinvokeargument name="dateFrom" value="#dateFrom#">
	<cfinvokeargument name="dateTo" value="#dateTo#">
	<cfinvokeargument name="id_agente" value="#url.id_agente#">
	<cfinvokeargument name="id_gruppo_agenti" value="#url.id_gruppo_agenti#">
	<cfinvokeargument name="id_processo" value="#url.id_processo#">
</cfinvoke>
<cfinvoke component="plan" method="ut" returnvariable="rsUT"></cfinvoke>
<cfset assegnatari_id = ValueList(rsUT.id_persona)>
<cfset assegnatari_name = ValueList(rsUT.ac_cognome)>

<!--- Send the headers --->
<cfheader name="Content-type" value="text/xml">
<cfheader name="Pragma" value="public">
<cfheader name="Cache-control" value="private">
<cfheader name="Expires" value="-1">
<cfsetting enablecfoutputonly="no"><?xml version="1.0" encoding="ISO-8859-1"?>
<rows>
	<cfoutput query="rsAll" group="int_ordine">
	<row style="background:###ac_colore#" id="#ac_processo#">
		<userdata name="id_status">#id_status#</userdata>
		<userdata name="ac_modulo_uuid">#ac_modulo_uuid#</userdata>
		<cell style="font-weight:bold;background:###ac_colore#">#ac_processo#</cell>
		<cell></cell>
		<cell></cell>
		<cell></cell>
		<cell></cell>
		<cell>../include/css/icons/empty.png</cell>
		<cell></cell>
	</row>
	<cfoutput group="data_status">
	<row>
		<userdata name="id_status">#id_status#</userdata>
		<userdata name="ac_modulo_uuid">#ac_modulo_uuid#</userdata>
		<cell></cell>
		<cell style="font-weight:bold">#data_status#</cell>
		<cell></cell>
		<cell></cell>
		<cell></cell>
		<cell>../include/css/icons/empty.png</cell>
		<cell></cell>
	</row>	
	<cfoutput>
	<cfset assegnato_a = "non assegnato">
	<row>
		<userdata name="ac_modulo_uuid">#ac_modulo_uuid#</userdata>
		<userdata name="id_status">#id_status#</userdata>
		<cell></cell>
		<cell></cell>
		<cell>#ora_status#</cell>
		<cell>#UCASE(agente)#</cell>
		<cell>#UCASE(ac_cognome)# #UCASE(ac_nome)#</cell>
		<cell style="cursor:pointer"><cfif ac_modulo_uuid NEQ "" AND ac_modulo NEQ "No"><cfif id_persona NEQ 0>
			
			<cfset pos = ListFind(assegnatari_id,id_persona)>
			<cfset assegnato_a = ListGetAt(assegnatari_name,pos)>
../include/css/icons/business-contact.png^#assegnato_a#<cfelse> ../include/css/icons/knobs/action_paste.gif^Vedi</cfif><cfelse>../include/css/icons/empty.png</cfif></cell>
		<cfif ac_modulo_uuid NEQ "" AND ac_modulo NEQ "No" AND session.livello LT 2>
		<cell xmlcontent="1" editable="0" title="Doppio click per selezionare a chi assegnare la richiesta di offerta" style="cursor:help">#UCASE(assegnato_a)#
			<cfloop query="rsUT">
				<cfif id_persona NEQ rsUT.id_persona>
				<option value="#id_persona#">#UCASE(ac_cognome)#</option>
				<cfelse>
				<option value="#id_persona#">#UCASE(ac_cognome)#</option>
				</cfif>
			</cfloop>
			<option value="0">Non assegnare</option>
		</cell>
		<cfelse>	
			<cell></cell>
		</cfif>
	</row>	
	</cfoutput>
	</cfoutput>
    </cfoutput>
</rows>

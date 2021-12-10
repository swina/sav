<cfinvoke component="clienti" method="assegnaAgente" returnvariable="done">
	<cfinvokeargument name="id_cliente" value="#form.id_da_assegnare#">
	<cfinvokeargument name="id_agente" value="#form.id_agente_assegna#">
</cfinvoke>
<cfoutput>Echo: #done# <br>#form.id_cliente# #form.id_processo# #form.calInput1# #form.ac_ora# #form.ac_note#</cfoutput>
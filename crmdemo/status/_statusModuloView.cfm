<cfinvoke component="moduli" method="getModulo" returnvariable="qryModulo">
	<cfinvokeargument name="modulo_uuid" value="#url.uuid#">
</cfinvoke>

<div class="winblue" style="height:100%;overflow:auto">
<table cellspacing="0" cellpadding="3" style="width:100%;border:1px solid black">
	<cfoutput>
	<tr>
		<td colspan="2" align="right"><a href="_statusPrintModulo.cfm?uuid=#url.uuid#" target="_blank"><img src="../include/css/icons/print.png" border="0" title="Stampa"></a></td>
	</tr>
	</cfoutput>
<cfoutput query="qryModulo">
	
	<cfset myValore = ListGetAt(ac_dati,currentrow,"|")>
	<tr>
		<td valign="top" style="border-bottom:1px solid black"><strong>#ac_label#</strong></td>
		<td valign="top" style="border-bottom:1px solid black;background:white"><cfif myValore NEQ "null" AND myValore NEQ 0><strong>#myValore#</strong></cfif></td>
	</tr>
<!--- 	<div class="winblue" style="float:left;width:150px"> </div> <div class="winblue" style="background:##fff;margin-left:5px">&nbsp;<strong><cfif myValore NEQ "null" AND myValore NEQ 0>#myValore#</cfif></strong></div> --->
</cfoutput>
</table>
<br>
<br>

</div>
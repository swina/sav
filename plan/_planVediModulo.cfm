<cfinvoke component="offerte.offerte" method="getModulo" returnvariable="qryModulo">
	<cfinvokeargument name="modulo_uuid" value="#url.uuid#">
</cfinvoke>
<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
<style>
TD { border-bottom:1px solid #eaeaea}
</style>
<script language="JavaScript" type="text/javascript">
function hideMe(){
	parent.document.getElementById("moduloPreview").style.display = "none";
	parent.document.getElementById("toDoList").style.display = "";
}
</script>
<table cellpadding="3" cellspacing="0" style="display:;border:1px solid #eaeaea" width="100%">
	<tr>
		<td colspan="2" class="winblue"><strong>MODULO</strong><input type="button" class="btn" value="Chiudi" onclick="hideMe()"></td>
	</tr>
	<cfoutput query="qryModulo">
	<cfset myValore = ListGetAt(valori,currentrow,"|")>
	<tr>
		<td>#ac_label#</td>
		<td style="font-weight:bold"><cfif myValore NEQ "null">#myValore#</cfif></td>
	</tr>
	</cfoutput>
</table>
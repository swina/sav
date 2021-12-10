<cfparam name="url.id_cliente" default=6814>
<cfinvoke component="plan" method="getClienteStatus" returnvariable="rsCliente">
	<cfinvokeargument name="id_cliente" value="#url.id_cliente#">
</cfinvoke>

<style>
TD { border-bottom:1px solid #eaeaea}
</style>
<script src="../include/js/functions.js"></script>
<script language="JavaScript" type="text/javascript">
function vediModulo(uuid){
	obj("moduloPreview").src = "_planVediModulo.cfm?uuid=" + uuid;
	showObj("moduloPreview");
	hideObj("toDoList");
}

function viewPlan(){
	parent.document.getElementById("planXMLView").style.display = "";
	parent.document.getElementById("detailCliente").style.display = "none";
}
</script>
<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
<body>
<table cellpadding="3" cellspacing="0" style="background:#fff;border:1px solid #eaeaea" width="100%">
	<tr>
		<td colspan="10" class="winblue">
		<strong>DETTAGLIO CLIENTE</strong> <input type="button" class="btn" value="&laquo; Indietro" onclick="viewPlan()">
		</td>
	</tr>
	<tr>
		<td valign="top" width="60%">
		<table cellpadding="3" cellspacing="0" style="border:1px solid #eaeaea" width="100%">
	<cfoutput query="rsCliente" group="id_cliente">
	<tr>
		<td colspan="10">
		<strong>Cliente: </strong>#ac_cognome#
		<br>
		<strong>Indirizzo: </strong><br>
		#ac_indirizzo# #ac_citta# #ac_pv#<br>
		<br>
		<strong>Tel.</strong> #ac_telefono#<br>
		<strong>Mobile:</strong> #ac_cellulare#<br>
		<strong>Email:</strong> #ac_email#<br>
		<br>
		<strong>Info:</strong><br>
		#ac_info#
		</td>
		
	</tr>
	<tr>
		<td colspan="10" class="winblue">
		<strong>ATTIVITA' SVOLTE</strong>
		</td>
	</tr>
	<cfoutput>
	<cfif dt_status LT now()>
	<tr style="background-color:###ac_colore#">
		<td valign="top">
		#data_status#	
		</td>
		<td valign="top">
		#ora_status#
		</td>
		<td valign="top">
		#ac_processo#
		</td>
		<td valign="top">
		<cfif listLen(ac_docs) GT 0>
			<cfloop index="i" list="#ac_docs#">
				<a href="../docs/status/#id_cliente#/#i#" target="_blank" alt="#i#" title="#i#"><img src="../include/css/icons/files/#ListGetAt(i,2,'.')#.png"></a>&nbsp;
			</cfloop>
		</cfif>&nbsp;
		</td>
		<td>
			<cfif ac_modulo_uuid NEQ "">
			<img src="../include/css/icons/knobs/action_paste.gif" alt="Vedi Modulo" title="Vedi Modulo" onclick="vediModulo('#ac_modulo_uuid#')" style="cursor:pointer">
			</cfif>&nbsp;
		</td>
		<td valign="top" width="30%">
		#ac_note#&nbsp;
		</td>
	</tr>
	</cfif>
	</cfoutput>
	</cfoutput>
</table>
		</td>
		<td valign="top">
		<iframe name="moduloPreview" id="moduloPreview" width="100%" height="100%" marginwidth="0" marginheight="0" frameborder="0" style="display:none"></iframe>
		<table id="toDoList" cellpadding="3" cellspacing="0" style="display:;border:1px solid #eaeaea" width="100%">
			<tr>
				<td colspan="10" class="winblue"><strong>Attività da svolgere</strong></td>
			</tr>
			<cfoutput query="rsCliente">
				<cfif dt_status GT now()>
				<tr style="background-color:###ac_colore#">
					<td valign="top">
					#data_status#	
					</td>
					<td valign="top">
					#ora_status#
					</td>
					<td valign="top">
					#ac_processo#
					</td>
					<td valign="top" width="30%">
					#ac_note#&nbsp;
					</td>
				</tr>
				</cfif>
			</cfoutput>
		</table>
		</td>
	</tr>
</table>
</body>
<!--- <cfdump var="#rsCliente#"> --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
	<script src="../include/js/functions.js"></script>
	<script language="JavaScript" type="text/javascript">
	function doAssegnaProcesso(){
ColdFusion.Ajax.submitForm("assegnaPersona","_statusAssegnaProcessoSave.cfm",callbackAssegna,errorHandler);
	}
	
	function callbackAssegna(result){
		parent.parent.GB_hide();
	}
	
	function errorHandler(code,msg){
		alert("Error !" + code + ":" + msg);
	}

	</script>	
</head>

<body>
<cfinvoke component="status" method="getUtentiGruppo" returnvariable="rsUtentiGruppo">
	<cfinvokeargument name="id_gruppo" value="#url.id_gruppo#">
</cfinvoke>

<cfoutput>
<div class="winblue" style="height:100%"><br>

<cfajaximport>
<form id="assegnaPersona">
	<input type="hidden" name="id_status_assegnazione" id="id_status_assegnazione" value="#url.id_status#">
	<input type="hidden" name="id_gruppo" id="id_gruppo" value="#url.id_gruppo#">
	Assegna a <select id="id_persona_assegnazione" name="id_persona_assegnazione">
		 <option value=0>Seleziona ...</option>
		<cfloop query="rsUtentiGruppo">
			<cfif url.id_persona EQ id_persona>
				<option value="#id_persona#" selected>#UCASE(ac_cognome)# #UCASE(ac_nome)#</option>
			<cfelse>
				<option value="#id_persona#">#UCASE(ac_cognome)# #UCASE(ac_nome)#</option>	
			</cfif>
			
		</cfloop>
	</select>&nbsp;<input type="button" class="btn" value="Assegna" onclick="doAssegnaProcesso()">
</form>
</div>
</cfoutput>
</body>
</html>
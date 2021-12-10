<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	 <link rel='stylesheet' type='text/css' href='../include/css/style.css'>
	<script src="../include/js/functions.js"></script>
	<!--- <script src="status.js"></script> ---> 
	<script src="moduli.js" type="text/javascript"></script>
	<cfoutput>
	<script type="text/javascript">
    	var GB_ROOT_DIR = "http://#http_host#/crm/include/greybox/";
	</script>
	</cfoutput>
	<script type="text/javascript" src="../include/greybox/AJS.js"></script>
	<script type="text/javascript" src="../include/greybox/AJS_fx.js"></script>
	<script type="text/javascript" src="../include/greybox/gb_scripts.js"></script>
	<link href="../include/greybox/gb_styles.css" rel="stylesheet" type="text/css" />
	<!--- ACCORDION --->
	<script src="../include/dhtmlx/dhtmlxAccordion/codebase/dhtmlxcommon.js"></script>
	<script src="../include/dhtmlx/dhtmlxAccordion/codebase/dhtmlxaccordion.js"></script>
	<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxAccordion/codebase/skins/dhtmlxaccordion_dhx_skyblue.css">
	<script src="../include/dhtmlx/dhtmlxAccordion/codebase/dhtmlxcontainer.js"></script>
	<!--- CALENDAR ---->
	<link rel="STYLESHEET" type="text/css" href="../include/dhtmlx/dhtmlxcalendar/codebase/dhtmlxcalendar.css">
	<script  src="../include/dhtmlx/dhtmlxcalendar/codebase/dhtmlxcommon.js"></script>
	<script  src="../include/dhtmlx/dhtmlxcalendar/codebase/dhtmlxcalendar.js"></script>
	
</head>

<body <cfif IsDefined("url.uuid") IS FALSE>onload="doLoadAccord()"</cfif>>
<cfif IsDefined("url.uuid") IS FALSE>
<form name="<cfoutput>#url.text#</cfoutput>" id="<cfoutput>#url.text#</cfoutput>">
<div id="accordObj" style="position: absolute; width: 600px; height: 350px;"></div>
<cfinclude template="_moduloBuilder.cfm">
</form>
<cfset myUUID = CreateUUID()>
<cfajaximport>
<form id="saveFrm" name="saveFrm">
<cfoutput>
	<input type="hidden" name="id_modulo" id="id_modulo" value="#getFields.id_modulo#">
	<textarea name="valori" id="valori" style="display:none"></textarea>
	<input type="hidden" name="modulo_uuid" id="modulo_uuid" value="#myUUID#">
</cfoutput>	
</form>
<form id="appoggio" name="appoggio">
<cfoutput>
	<input type="hidden" name="lista_labels" id="lista_labels" value="#myLabels#">
	<input type="hidden" name="lista_fields" id="lista_fields" value="#myFields#">
	<input type="hidden" name="lista_tipi" id="lista_tipi" value="#myTypes#">
	<input type="hidden" name="lista_required" id="lista_required" value="#myRequired#">
	<input type="hidden" name="lista_processi" id="lista_processi" value="#myProcessi#">
</cfoutput>
</form>
<form id="processi" name="processi">
	<cfoutput>
	<input type="text" name="id_cliente" id="id_cliente" value="#url.id_cliente#">
	<input type="hidden" name="id_processo" id="id_processo">
	<input type="hidden" name="dt_processo" id="dt_processo">
	<input type="hidden" name="processo_modulo_uuid" id="processo_modulo_uuid" value="#myUUID#">
	</cfoutput>
</form>
<script>
var dhxAccord;
function doLoadAccord(){
    dhxAccord = new dhtmlXAccordion("accordObj");
	
	<cfset n = 1>
	<cfoutput query="getFields" group="ac_sezione" maxrows="5">
		dhxAccord.addItem("a#n#", "#ac_sezione#");
		dhxAccord.cells("a#n#").attachObject("S#n#")
		<cfset n = n + 1>
	</cfoutput>
	dhxAccord.openItem("a1");
}
</script>
<cfelse>
	<cfinclude template="_statusModuloView.cfm">
</cfif>
</body>
</html>

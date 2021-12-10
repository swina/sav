<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
	<script src="../include/js/functions.js"></script>
	<script src="setup.js"></script>
	<!--- GRID --->
	<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxGrid/codebase/dhtmlxgrid.css">
    <link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxGrid/codebase/skins/dhtmlxgrid_dhx_skyblue.css">
    <script src="../include/dhtmlx/dhtmlxGrid/codebase/dhtmlxcommon.js"></script>
    <script src="../include/dhtmlx/dhtmlxGrid/codebase/dhtmlxgrid.js"></script>
    <script src="../include/dhtmlx/dhtmlxGrid/codebase/dhtmlxgridcell.js"></script>
	<script  src="../include/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_start.js"></script>
</head>

<body>
<div style="width:530px;padding:5px" class="winblue">
<div class="winhead"><strong>Qualifica Contatti</strong>&nbsp;<span id="deleteQualBtn"></span></div>
<div id="gridbox" style="width:100%;height:160px;background-color:white;"></div>
</div>
<script>

mygrid = new dhtmlXGridObject('gridbox');
mygrid.setImagePath("../include/dhtmlx/dhtmlxGrid/codebase/imgs/");
mygrid.setHeader("Qualifica,Icona");
mygrid.setInitWidths("300,*");
mygrid.setColAlign("left,center");
mygrid.setColTypes("ed,img");
mygrid.setColSorting("str,str");
mygrid.attachEvent("onEditCell", doOnCellChangedQ);
mygrid.attachEvent("onAfterUpdate" , doOnCellChangedQ);
mygrid.attachEvent("onRowSelect", doAssegnaRowId);  
mygrid.setSkin("dhx_skyblue");
mygrid.enableAutoHeight(true);
mygrid.init();
mygrid.loadXML("_qualificaXML.cfm");
</script>
<cfajaximport>
<div style="display:none">
<cfform id="updateCellQ">
	<input type="text" name="id_gruppo" id="id_gruppo">
	<input type="text" name="table_column" id="table_column">
	<input type="text" name="column_value" id="column_value">
	<input type="text" name="old_value" id="old_value">
	<input type="text" name="column_type" id="column_type">
</cfform>
<cfform id="deleteQualifica">
	<input type="text" name="id_gruppo_delete" id="id_gruppo_delete">
</cfform>
</div>
<div style="display:none;width:530px" id="icons" class="winwhite">
	<cfset myIconsTmp = "_icons.cfm">
	<cfinclude template="#myIconsTmp#">
</div>
</body>
</html>

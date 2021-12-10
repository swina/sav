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
	<script  src="../include/dhtmlx/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_acheck.js"></script>
	<script  src="../include/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_start.js"></script>
	<script src="../include/dhtmlx/dhtmlxcombo/codebase/dhtmlxcombo.js"></script>
    <link rel="STYLESHEET" type="text/css" href="../include/dhtmlx/dhtmlxcombo/codebase/dhtmlxcombo.css">

</head>

<body>
<div style="width:600px;padding:5px" class="winblue">
<div style="border:1px solid #ffeeff">
<div class="winhead"><strong>Gestione Alerting</strong></div>
<div id="gridbox" style="width:100%;height:360px;background-color:white;"></div>
</div>
</div>
<script>

mygrid = new dhtmlXGridObject('gridbox');
mygrid.setImagePath("../include/dhtmlx/dhtmlxGrid/codebase/imgs/");
mygrid.setHeader("Processo,Sigla,Pre Alert,Post Alert,Dir. Comm.,Altro,&raquo;");
mygrid.setInitWidths("200,100,60,60,60,60,*");
mygrid.setColAlign("left,left,right,right,center,center,left");
mygrid.setColTypes("ro,ro,ed,ed,acheck,acheck,img");
mygrid.setColSorting("str,str,str,str");
mygrid.attachEvent("onEditCell", doOnCellChangedA);
mygrid.attachEvent("onAfterUpdate" , doOnCellChangedA);
mygrid.attachEvent("onXLE", doSelectRow);
mygrid.setSkin("dhx_skyblue");
mygrid.enableAutoHeight(true);
mygrid.init();
mygrid.loadXML("_alertingXML.cfm");
</script>
<cfajaximport>
<div style="display:none">
<cfform id="updateCell">
	<input type="text" name="id_processo" id="id_processo">
	<input type="text" name="table_column" id="table_column">
	<input type="text" name="column_value" id="column_value">
	<input type="text" name="old_value" id="old_value">
	<input type="text" name="column_type" id="column_type">
</cfform>
</div>
</body>
</html>

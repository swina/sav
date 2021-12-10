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
	<script src="../include/dhtmlx/dhtmlxcombo/codebase/dhtmlxcombo.js"></script>
    <link rel="STYLESHEET" type="text/css" href="../include/dhtmlx/dhtmlxcombo/codebase/dhtmlxcombo.css">

</head>

<body>
<div style="width:600px;padding:5px" class="winblue">
<div style="border:1px solid #ffeeff">
<div class="winhead"><strong>Gestione Processi</strong></div>
<div id="gridbox" style="width:100%;height:360px;background-color:white;"></div>
<div id="gridboxPermission" style="width:100%;height:45px;background-color:white;"></div>
</div>
</div>
<script>

mygrid = new dhtmlXGridObject('gridbox');
mygrid.setImagePath("../include/dhtmlx/dhtmlxGrid/codebase/imgs/");
mygrid.setHeader("Processo,Sigla,Timer H,Auto,Colore,&raquo;,Modulo,&raquo;");
mygrid.setInitWidths("200,100,60,55,50,20,*,20");
mygrid.setColAlign("left,left,right,center,center,center,right,center");
mygrid.setColTypes("ed,ed,ed,ra,ro,cp,coro,img");
mygrid.setColSorting("str,str,str,str,int,str,str,str");
mygrid.attachEvent("onEditCell", doOnCellChangedP);
mygrid.attachEvent("onAfterUpdate" , doOnCellChangedP);
mygrid.attachEvent("onRowSelect" , doViewPermission);
mygrid.attachEvent("onXLE", doSelectRow);
mygrid.setSkin("dhx_skyblue");
mygrid.enableAutoHeight(true);
mygrid.init();
mygrid.loadXML("_processiXML.cfm");

//inizializza la grid della cronologia eventi di un cliente
mygrid2 = new dhtmlXGridObject('gridboxPermission');
mygrid2.setImagePath("../include/dhtmlx/dhtmlxGrid/codebase/imgs/");//path to images required by grid
mygrid2.setHeader("Direzione Commerciale.,Affiliati,Agenti,Ufficio Tecnico");//set column names
//mygrid2.setInitWidths("60,60,60,60");//set column width in px
mygrid2.setColAlign("center,center,center,center");//set column values align
mygrid2.setColTypes("img,img,img,img");//set column types
mygrid2.attachEvent("onRowSelect", setPermission);  
mygrid2.init();//initialize grid
mygrid2.setSkin("dhx_skyblue");//set grid skin
//mygrid2.attachEvent("onXLE", doSetPermission);
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
<form id="permissions">
	<input type="text" name="id_processo_perm" id="id_processo_perm">
	<input type="text" name="ac_permissions" id="ac_permissions">
</form>
<form id="ordine">
	<input type="text" name="id_processo_ordine" id="id_processo_ordine">
	<input type="text" name="int_ordine" id="int_ordine">
</form>
</div>
</body>
</html>

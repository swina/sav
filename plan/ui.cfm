<!--- LAYOUT APPLICAZIONE --->
<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxlayout.css">
<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxLayout/codebase/skins/dhtmlxlayout_dhx_skyblue.css">
<script src="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxcommon.js"></script>
<script src="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxcontainer.js"></script>
<script src="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxlayout.js"></script>
<script language="JavaScript" type="text/javascript">
function doOnLoad(){
var dhxLayout=new dhtmlXLayoutObject(document.body,"2U");
//cell a (top)
dhxLayout.items[0].setWidth(250);
dhxLayout.items[0].hideHeader();
dhxLayout.cells("a").attachObject("left");

//cell b (sidebar)
dhxLayout.items[1].hideHeader();
dhxLayout.cells("b").attachObject("right");

dhxLayout.setEffect("collapse",true);

//dhxLayout.cells("a").fixSize(true,false);
//dhxLayout.cells("b").fixSize(true,false);
dhxLayout.setAutoSize("a;b", "a;b");
}
</script>
<div id="left" class="winblue">
	<div style="height:100%">
	<cfinclude template="_plan_periodo.cfm">
	</div>
</div>
<div id="right">
	<div id="gridbox" style="width:100%;height:100%;overflow:auto;"></div>
</div>
<script>
mygrid = new dhtmlXGridObject('gridbox');
mygrid.selMultiRows = true;
mygrid.imgURL = "../include/dhtmlx/dhtmlxgrid/codebase/imgs/icons_greenfolders/";
mygrid.setHeader("Processo,Data,Ora,Agente,Cliente,Fornitore,&raquo;,&raquo;");
mygrid.setInitWidths("150,80,80,120,150,100,*,*");
mygrid.setColTypes("ro,ro,ro,ro,ro,ro,img,coro");
mygrid.setColAlign("left,left,left,left,left,left,left,left");//set column values align 	
//mygrid.setColSorting("str,str,str,str,str,str,str");
mygrid.enableResizing("false,false,false,false,false,false,false,false");
mygrid.init();
//mygrid.attachEvent("onRowSelect" , doSelectRow );
mygrid.attachEvent("onAfterUpdate" , doOnCellChanged);
mygrid.attachEvent("onEditCell", doOnCellChanged);
mygrid.setSkin("dhx_skyblue");
mygrid.load("_planXML.cfm");
</script>
<cfajaximport>
<form id="assegnaFrm">
	<input type="hidden" name="id_status_assegna" id="id_status_assegna">
	<input type="hidden" name="id_persona_assegna" id="id_persona_assegna">
</form>
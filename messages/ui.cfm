<!--- LAYOUT APPLICAZIONE --->
<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxlayout.css">
<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxLayout/codebase/skins/dhtmlxlayout_dhx_skyblue.css">
<script src="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxcommon.js"></script>
<script src="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxcontainer.js"></script>
<script src="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxlayout.js"></script>
<script language="JavaScript" type="text/javascript">
function doOnLoad(){
var dhxLayout=new dhtmlXLayoutObject(document.body,"3L");
//cell a (top)
dhxLayout.items[0].setWidth(300);
dhxLayout.items[0].hideHeader();
dhxLayout.cells("a").attachObject("left");

//cell b (sidebar)
dhxLayout.items[1].hideHeader();
dhxLayout.items[1].setHeight(200);
dhxLayout.cells("b").attachObject("right");

//cell c
dhxLayout.items[2].hideHeader();
dhxLayout.cells("c").attachObject("bottom");

dhxLayout.setEffect("collapse",true);

//dhxLayout.cells("a").fixSize(true,false);
//dhxLayout.cells("b").fixSize(true,false);
dhxLayout.setAutoSize("a;b", "a;b");
}
</script>
<div id="left" class="winblue">
	<div style="height:100%">
	<cfinclude template="_msg_periodo.cfm">
	</div>
</div>

<div id="right" style="overflow:auto">
	<div id="gridbox" style="width:100%;height:500px;overflow:auto;"></div>
</div>
<div id="bottom">
	<div id="messageDetail" style="display:none">
	<div id="msgToolbar" class="winblue" style="display:none"><input type="button" class="btn" value="Elimina" onclick="deleteMsg()"></div>
	<div id="msgDate"></div>
	<div id="msgTo"></div>
	<div id="msgSubject" style="border-bottom:1px solid #a4a4a4"></div>
	<div id="msgText"></div>
	</div>
</div>
<script>
mygrid = new dhtmlXGridObject('gridbox');
mygrid.selMultiRows = true;
mygrid.imgURL = "../include/dhtmlx/dhtmlxgrid/codebase/imgs/icons_greenfolders/";
mygrid.setHeader("Data,Ora,A,Oggetto,Messaggio");
mygrid.setInitWidths("100,100,150,150,*");
mygrid.setColTypes("ro,ro,ro,ro,ro");
mygrid.setColAlign("left,left,left,left,left");//set column values align 	
//mygrid.setColSorting("str,str,str,str,str,str,str");
mygrid.enableResizing("false,false,false,false,false");
mygrid.init();
mygrid.attachEvent("onRowSelect" , doSelectRow );
//mygrid.attachEvent("onAfterUpdate" , doOnCellChanged);
//mygrid.attachEvent("onEditCell", doOnCellChanged);
mygrid.setSkin("dhx_skyblue");
mygrid.load("_msgListXML.cfm");
</script>
<cfajaximport>
<form id="messageFrm">
	<input type="hidden" name="id_message" id="id_message">
</form>
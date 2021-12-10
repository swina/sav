<!--- LAYOUT APPLICAZIONE --->
<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxlayout.css">
<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxLayout/codebase/skins/dhtmlxlayout_dhx_skyblue.css">
<script src="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxcommon.js"></script>
<script src="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxcontainer.js"></script>
<script src="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxlayout.js"></script>
<script language="JavaScript" type="text/javascript">
function doOnLoad(){
var dhxLayout=new dhtmlXLayoutObject(document.body,"3T");
//cell a (left)
dhxLayout.items[0].setHeight(100);
dhxLayout.items[0].hideHeader();
dhxLayout.cells("a").attachObject("left");

//cell b (main)
dhxLayout.items[1].hideHeader();
dhxLayout.cells("b").attachObject("main");

//cell c (bottom)
dhxLayout.items[2].setWidth(350);
dhxLayout.items[2].hideHeader();
dhxLayout.cells("c").attachObject("rightTop");

//cell d (bottom)
//dhxLayout.items[3].setWidth(350);
//dhxLayout.items[3].hideHeader();
//dhxLayout.cells("d").attachObject("right");


dhxLayout.setEffect("collapse",true);

//dhxLayout.cells("a").fixSize(true,false);
//dhxLayout.cells("d").fixSize(true,false);
dhxLayout.setAutoSize("a;b", "a;b");

initCalendar();
}
</script>
<div id="left" class="winblue">
	<div style="height:100%">
	<cfinclude template="_offerte_periodo.cfm">
	</div>
</div>
<div id="main" style="height:100%">
	<div style="height:98%">
	<div id="gridbox" style="width:100%;height:100%;"></div>
	</div>
</div>
<div id="rightTop" class="winblue" style="height:100%">
	<div style="height:100px;">
		<div class="winhead"><strong style="font-weight:bold;font-size:11px">Richiesta Offerta <input type="button" class="btn" value="Vedi Note" onclick="vediNote()"></strong><span id="printModulo"><img src="../include/css/icons/print.png" border="0" title="Stampa" style="cursor:pointer;margin-left:10px;" onclick="printModulo()" align="absmiddle"><span id="presentazione" style="margin-left:10px;color:black;padding:3px;background:#FFBFBF"></span></div><br>
		<div><strong class="btn" onclick="uploadDocs()">Carica offerta</strong><img src="../include/css/icons/order-192.png" align="absmiddle" onclick="uploadDocs()">&nbsp;&nbsp;<span id="valore"></span></div><br>

		<div>Documenti caricati</div>
		<div id="documenti"></div>
	</div>
	<div id="gridModulo" style="width:100%;height:90%;overflow:auto;"></div>
</div>
<div id="w1" class="wiblue" style="position: relative; height: 100%; border: #cecece 1px solid; margin: 10px;display:none"><cfinclude template="_offerteDocUpload.cfm"></div>
<script>
mygrid = new dhtmlXGridObject('gridbox');
mygrid.selMultiRows = true;
mygrid.imgURL = "../include/dhtmlx/dhtmlxgrid/codebase/imgs/icons_greenfolders/";
mygrid.setHeader("Processo,Data/Ora,Agente,Cliente,&raquo,Ufficio Tecnico");
mygrid.setInitWidths("150,80,120,150,30,*");
mygrid.setColTypes("ro,ro,ro,ro,img,coro");
mygrid.setColAlign("left,left,left,left,left,left");//set column values align 	
//mygrid.setColSorting("str,str,str,str,str,str,str");
mygrid.enableResizing("false,false,false,false,false,false");
mygrid.init();
mygrid.attachEvent("onRowSelect" , doSelectRow );
mygrid.attachEvent("onAfterUpdate" , doOnCellChanged);
mygrid.attachEvent("onEditCell", doOnCellChanged);
mygrid.setSkin("dhx_skyblue");
mygrid.load("_offerteXML.cfm");

mygrid2 = new dhtmlXGridObject('gridModulo');
mygrid2.imgURL = "../include/dhtmlx/dhtmlxgrid/codebase/imgs/icons_greenfolders/";
mygrid2.setHeader("Campo,Valore");
mygrid2.setInitWidths("150,*");
mygrid2.setColTypes("ro,ro");
mygrid2.setColAlign("left,left");//set column values align 	
mygrid2.enableResizing("false,false");
mygrid2.setSkin("dhx_skyblue");
mygrid2.init();
//mygrid2.load("_offertaModuloXML.cfm");

var dhxWins , w1;
dhxWins = new dhtmlXWindows();
	dhxWins.enableAutoViewport(true);
    dhxWins.attachViewportTo("w1");
    dhxWins.setImagePath("../include/dhtmlx/dhtmlxwindows/codebase/imgs/");
</script>
<cfajaximport>
<form id="assegnaFrm">
	<input type="hidden" name="id_status_assegna" id="id_status_assegna">
	<input type="hidden" name="id_persona_assegna" id="id_persona_assegna">
</form>
<form id="processoFrm">
	<input type="hidden" name="id_status" id="id_status">
	<input type="hidden" name="id_cliente" id="id_cliente">
	<input type="hidden" name="id_agente" id="id_agente">
	<input type="hidden" name="lista_docs" id="lista_docs">
	<input type="hidden" name="ac_modulo_uuid_2" id="ac_modulo_uuid_2">
	<input type="hidden" name="add_status" id="add_status" value="1">
	<input type="hidden" name="ac_valore" id="ac_valore">
</form>

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
	<cfinclude template="_statistiche_periodo.cfm">
	</div>
</div>
<div id="right">
	<div id="gridbox" style="width:100%;height:500px;overflow:auto;">
	<iframe name="statistica" id="statistica" width="100%" height="400" marginwidth="0" marginheight="0" align="left" scrolling="yes" frameborder="0" style="background:white;overflow:auto"></iframe>
	</div>
</div>
<div id="bottom">
	<iframe name="detailFrame" id="detailFrame" width="100%" height="800" marginwidth="0" marginheight="0" align="left" scrolling="yes" frameborder="0" style="display:none;overflow:auto;"></iframe>
</div>
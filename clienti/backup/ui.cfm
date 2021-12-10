<cfajaximport>
<cfinvoke component="clienti" method="getAgenti" returnvariable="agentiQry"></cfinvoke>
<cfinvoke component="clienti" method="getImportati" returnvariable="nrNuoviContatti"></cfinvoke>
<!--- LAYOUT APPLICAZIONE --->
<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxlayout.css">
<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxLayout/codebase/skins/dhtmlxlayout_dhx_skyblue.css">
<script src="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxcommon.js"></script>
<script src="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxcontainer.js"></script>
<script src="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxlayout.js"></script>
<script language="JavaScript" type="text/javascript">
function doOnLoad(){
var dhxLayout=new dhtmlXLayoutObject(document.body,"3E");
//cell a (top)
dhxLayout.items[0].setHeight(30);
dhxLayout.items[0].hideHeader();
dhxLayout.cells("a").attachObject("top");

//cell b (sidebar)
dhxLayout.items[1].hideHeader();
dhxLayout.cells("b").attachObject("center");

dhxLayout.items[2].setHeight(20);
dhxLayout.items[2].hideHeader();
dhxLayout.cells("c").attachObject("bottom");

dhxLayout.setEffect("collapse",true);

dhxLayout.cells("a").fixSize(false,true);
dhxLayout.cells("c").fixSize(false,true);
dhxLayout.setAutoSize("b;a;c", "b;a;c");
}
</script>
<div id="top">
	<div class="winhead" style="height:100%"><strong>Contatti</strong>&nbsp;<img src="../include/css/icons/altre/001_01.png" align="absmiddle" style="cursor:pointer" alt="Aggiungi Contatto" title="Aggiungi Contatto" onclick="addAnagrafica()"><cfif session.livello LT 3>&nbsp;<img src="../include/css/icons/altre/001_02.png" align="absmiddle" style="cursor:pointer" alt="Elimina Contatto" title="Elmina Contatto" onclick="deleteAnagrafica()"></cfif><cfif session.livello LT 2><cfif nrNuoviContatti GT 0>[<strong><cfoutput>#nrNuoviContatti# nuovi contatti importati</cfoutput></strong>] <input type="button" class="btn" value="Vedi Importati" onclick="vediNuoviContatti()"> <input type="button" class="btn" value="Vedi Contatti" onclick="reloadClienti()"></cfif></cfif><input type="button" class="btn" value="Excel" onclick="printClienti()" title="Esporta in Excel"></div>
<div id="center" style="height:100%">
	<div id="gridbox" style="width:100%;height:100%;margin:0px"></div>
</div>
<div id="bottom" style="height:100%">
	<div class="winblue" style="width:100%;height:100%">
	<cfinclude template="_clientiGridPaging.cfm">
	</div>
</div>
<div id="w1" class="winblue" style="position: relative; width:100%; height: 100%; border: #cecece 1px solid; margin: 10px;display:none"><cfinclude template="_clientiForm.cfm"></div>
<div style="display:none">
<form id="deleteFrm">
	<input type="hidden" name="id_cliente_delete" id="id_cliente_delete">
</form>
</div>
<!--- <iframe id="hiddenFrame" name="hiddenFrame"></iframe> --->
<cfoutput>
<script>
mygrid = new dhtmlXGridObject('gridbox');
mygrid.setImagePath("../include/dhtmlx/dhtmlxgrid/codebase/imgs/");//path to images required by grid
mygrid.setHeader("Rag.Sociale , Fornitore, Indirizzo, Citt�,Prov,&raquo;,Q");//set column names
mygrid.setInitWidths("150,100,200,150,40,30,30");//set column width in px
mygrid.setColAlign("left,left,left,left,left,center,left");//set column values align 	
mygrid.setColTypes("ro,ro,ro,ro,ro,img,img");//set column types
mygrid.setColSorting("str,str,str,str,str,str,str");//set sorting
//mygrid.setDateFormat("%d/%m/%Y")
mygrid.init();//initialize grid
mygrid.setSkin("dhx_skyblue");//set grid skin
//mygrid.load("_clientiXML.cfm?startpage=0&search=");
startPage();
mygrid.enableMultiselect(true);
mygrid.attachEvent("onRowSelect" , doOnCellSelect);
mygrid.attachEvent("onRowDblClicked" , doOnRowSelect);
mygrid.attachEvent("onEnter", doOnRowSelect);
mygrid.attachEvent("onXLE", doSelectFirstRow);
mygrid.attachEvent("onKeyPress" , doKeyPress );

var dhxWins , w1;
dhxWins = new dhtmlXWindows();
	dhxWins.enableAutoViewport(true);
    dhxWins.attachViewportTo("w1");
    dhxWins.setImagePath("../include/dhtmlx/dhtmlxwindows/codebase/imgs/");
</script>
</cfoutput>

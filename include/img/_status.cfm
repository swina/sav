
<!--- GRID --->
	<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxgrid/codebase/dhtmlxgrid.css">
    <link rel="stylesheet" type="text/css" href="../../include/dhtmlx/dhtmlxgrid/codebase/skins/dhtmlxgrid_dhx_skyblue.css">
    <script src="../include/dhtmlx/dhtmlxgrid/codebase/dhtmlxcommon.js"></script>
    <script src="../include/dhtmlx/dhtmlxgrid/codebase/dhtmlxgrid.js"></script>
    <script src="../include/dhtmlx/dhtmlxgrid/codebase/dhtmlxgridcell.js"></script>
	<script  src="../include/dhtmlx/dhtmlxgrid/codebase/ext/dhtmlxgrid_start.js"></script>
	<!--- 
	<!--- WINDOW --->
	<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxwindows/codebase/dhtmlxwindows.css">
	<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxwindows/codebase/skins/dhtmlxwindows_dhx_skyblue.css">
	<script src="../include/dhtmlx/dhtmlxwindows/codebase/dhtmlxcommon.js"></script>
	<script src="../include/dhtmlx/dhtmlxwindows/codebase/dhtmlxwindows.js"></script>
	<!--- TOOLBAR --->
	<!-- dhtmlxToolbar -->
	<script src="../include/dhtmlx/htmlxToolbar/codebase/dhtmlxtoolbar.js"></script>
	<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxToolbar/codebase/skins/dhtmlxtoolbar_dhx_skyblue.css">
	<script src="../include/dhtmlx/dhtmlxToolbar/codebase/dhtmlxcontainer.js"></script>
	 --->
	<script>
	dhtmlx.skin="dhx_skyblue";
	function doOnRowSelect(idc){
		alert(idc);
	}
	
	function statusCliente(){
		var selectedId = mygrid.getSelectedRowId();
		var idcliente = mygrid.cellById(selectedId,2).getValue();
		mygrid2.load("_statusClienteXML.cfm?cliente=" + idcliente);
		document.getElementById("subHeader").innerHTML = idcliente;
		document.getElementById("subView").style.display = "";
	}
	
	function hideStatusCliente(){
		document.getElementById("subView").style.display = "none";
	}
	
	function doSearch(){
		var search = document.getElementById("searchValue").value;
		mygrid.clearAndLoad("_statusXML.cfm?cliente=" + search);
		document.getElementById("subView").style.display = "none";

	}
	</script>
<style>
	.subHeader { 
		font-family:Tahoma;
		font-size:11px;
		color:black ; 
		padding:4px;  	background-image:url('../include/dhtmlx/dhtmlxgrid/codebase/imgs/sky_blue_grid.gif');
		border : 1px #96c6d3 solid;
	}
	
	.overRow { background:orange; }
</style>
<body>
<div id="headGrid" style="float:left;width:520px;margin-right:50px">
	<div id="searchHeader" class="subheader"><input type="text" id="searchValue" value=""><img src="../include/css/icons/consulting.png" onclick="doSearch()"></div>
	<div id="gridboxSTATUS" style="width:520px;height:90%;float:left;"></div>
</div>
<div id="subView" style="display:none;float:left">
	<div id="subHeader" class="subHeader"></div>
	<div id="gridboxCLIENTE" style="width:300px;height:50%;"></div>
</div>
</body>
<script>
mygrid = new dhtmlXGridObject('gridboxSTATUS');
mygrid.setImagePath("../include/dhtmlx/dhtmlxgrid/codebase/imgs/");//path to images required by grid
mygrid.setHeader("ID,Ag,Cliente,Citta,Data,Azione,!");//set column names
mygrid.setInitWidths("30,30,100,100,70,150,30");//set column width in px
mygrid.setColAlign("left,left,left,left,left,left,left");//set column values align
mygrid.setColTypes("ro,ro,ro,ro,ro,ro,img");//set column types
mygrid.setColSorting("int,str,str,str,str,str");//set sorting
mygrid.init();//initialize grid
mygrid.setSkin("dhx_skyblue");//set grid skin
mygrid.load("_statusXML.cfm");

mygrid2 = new dhtmlXGridObject('gridboxCLIENTE');
mygrid2.setImagePath("../include/dhtmlx/dhtmlxgrid/codebase/imgs/");//path to images required by grid
mygrid2.setHeader("Data,Azione");//set column names
mygrid2.setInitWidths("70,*");//set column width in px
mygrid2.setColAlign("left,left");//set column values align
mygrid2.setColTypes("ro,ro");//set column types
mygrid2.setColSorting("str,str");//set sorting
mygrid2.init();//initialize grid
mygrid.setSkin("dhx_skyblue");//set grid skin
</script>
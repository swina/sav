<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
	<!--- LAYOUT APPLICAZIONE --->
	<link rel="stylesheet" type="text/css" href="include/dhtmlx/dhtmlxLayout/codebase/dhtmlxlayout.css">
    <link rel="stylesheet" type="text/css" href="include/dhtmlx/dhtmlxLayout/codebase/skins/dhtmlxlayout_dhx_skyblue.css">
    <script src="include/dhtmlx/dhtmlxLayout/codebase/dhtmlxcommon.js"></script>
    <script src="include/dhtmlx/dhtmlxLayout/codebase/dhtmlxcontainer.js"></script>
    <script src="include/dhtmlx/dhtmlxLayout/codebase/dhtmlxlayout.js"></script>
<!--- 	<style>
	body { margin:0 auto ; font-family:"Tahoma" ; font-size:12px }
	
	.top_container { 
		position: relative;
		height:100%;
		width:100%;
		margin: 0px;
		padding: 0px;
		background:#ddeeff;
		border : 1px #8899cc solid;
	}
	.inside {
		position: relative;
		margin:0px;
		padding:0px;
		height: 98%;
		width: 100%;
		float:left;
	}
	.inside div {
		float:left;
		width:200px;
	}
	.inside .wrapper {
		position: relative;
		overflow:auto;
		background:#ffffff;
		width:100%;
		height:98%;
		padding:5px;
	}
	.topbar {
		position: relative;
		height:22px;
		background:#e3e3e3;
		border : 1px #c3c3c3 solid;
		padding:5px;
		vertical-align:center;
		width:100%;
		top:0px;
		color:black;
	}
	
	</style> --->
	<script language="JavaScript" type="text/javascript">
function doOnLoad(){
var dhxLayout=new dhtmlXLayoutObject(document.body,"2U");
//cell a (top)
dhxLayout.items[0].setWidth(600);
dhxLayout.items[0].hideHeader();
dhxLayout.cells("a").setText("Status Operativo");
dhxLayout.cells("a").attachObject("status");

//cell b (sidebar)
dhxLayout.items[1].setWidth(250);
dhxLayout.items[1].hideHeader();
dhxLayout.cells("b").attachObject("cliente");
dhxLayout.cells("b").setText("Cliente");
dhxLayout.setEffect("collapse",false);

dhxLayout.setAutoSize("a;b","a;b");
}
</script>
</head>

<body onload="doOnLoad()">
<div id="status"></div>
<div id="cliente"><cfinclude template="status/_statusCliente.cfm"></div>
</body>

</html>

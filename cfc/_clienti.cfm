<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<cfoutput>
	<cfset mydhtmlx = application.dhtmlxurl>
	<link rel='stylesheet' type='text/css' href='../css/screen.css'>
	<!--- GRID --->
	
	<link rel="stylesheet" type="text/css" href="#mydhtmlx#/dhtmlxgrid/codebase/dhtmlxgrid.css">
    <link rel="stylesheet" type="text/css" href="#mydhtmlx#/dhtmlxgrid/codebase/skins/dhtmlxgrid_dhx_skyblue.css">
    <script src="#mydhtmlx#/dhtmlxgrid/codebase/dhtmlxcommon.js"></script>
    <script src="#mydhtmlx#/dhtmlxgrid/codebase/dhtmlxgrid.js"></script>
    <script src="#mydhtmlx#/dhtmlxgrid/codebase/dhtmlxgridcell.js"></script>
	<script  src="#mydhtmlx#/dhtmlxgrid/codebase/ext/dhtmlxgrid_start.js"></script>
	 
	<!--- WINDOW --->
	<link rel="stylesheet" type="text/css" href="#mydhtmlx#/dhtmlxwindows/codebase/dhtmlxwindows.css">
	<link rel="stylesheet" type="text/css" href="#mydhtmlx#/dhtmlxwindows/codebase/skins/dhtmlxwindows_dhx_skyblue.css">
	<script src="#mydhtmlx#/dhtmlxwindows/codebase/dhtmlxcommon.js"></script>
	<script src="#mydhtmlx#/dhtmlxwindows/codebase/dhtmlxwindows.js"></script>
	<script src="#mydhtmlx#/dhtmlxwindows/codebase/dhtmlxcontainer.js"></script>
	<!---<!--- TOOLBAR --->
	<!-- dhtmlxToolbar -->
	<script src="include/dhtmlx/htmlxToolbar/codebase/dhtmlxtoolbar.js"></script>
	<link rel="stylesheet" type="text/css" href="include/dhtmlx/dhtmlxToolbar/codebase/skins/dhtmlxtoolbar_dhx_skyblue.css">
	<script src="include/dhtmlx/dhtmlxToolbar/codebase/dhtmlxcontainer.js"></script>
	 --->
	</cfoutput> 
	<script>
	dhtmlx.skin="dhx_skyblue";
	var nwin = 1;
	function doOnRowSelect(id,cella){
	
		var idc = mygrid.cellById(id,2).getValue();
		var cognome = mygrid.cellById(id,2).getValue();
		var nome = mygrid.cellById(id,3).getValue();
		document.getElementById("id_cliente").value = idc;
		document.getElementById("ac_cognome").value = cognome;
		document.getElementById("ac_nome").value = nome;
		
		//crea la windows per l'editing
		if ( nwin == 1 ){
			w1 = dhxWins.createWindow("w1", 710, 0, 200, 400);
			
			//w1.center();
			w1.attachObject("formEdit");
			nwin = nwin + 1;
		}
		w1.setText("Anagrafica " + cognome + " " + nome);
	}
	
	/* var dhxWins,w1,toolbar;
	
	function doOnLoad() {
    	dhxWins = new dhtmlXWindows();
	    dhxWins.enableAutoViewport(false);
    	dhxWins.attachViewportTo("winVP");
	    dhxWins.setImagePath("../../codebase/imgs/");
    	w1 = dhxWins.createWindow("w1", 20, 30, 400, 350);
	    w1.setText("Attaching dhtmlxToolbar");
	    w1.attachURL("../common/attach_url_ajax_inner.html", true);
    	toolbar = w1.attachToolbar();
	    toolbar.setIconsPath("../../../dhtmlxToolbar/samples/common/imgs/");
    	toolbar.loadXML("../../../dhtmlxToolbar/samples/common/dhxtoolbar_button.xml?" + new Date().getTime());
} */
	
	</script>
<body>
<!--- <cfset clienti = EntityLoad("tbl_clienti")> --->
<!--- <cfdump var="#clienti#"> --->
<div id="gridbox" style="width:700px;height:90%"></div>
<div id="w1" style="position: relative; height: 500px; border: #cecece 1px solid; margin: 10px;display:none"></div>
<cfinclude template="_clientiForm.cfm">
</body>
<!--- <cfdump var="#xmlString#">--->
<script>
mygrid = new dhtmlXGridObject('gridbox');
mygrid.setImagePath("../include/dhtmlx/dhtmlxgrid/codebase/imgs/");//path to images required by grid
mygrid.setHeader("ID, Cliente , Cognome, Nome,M,P");//set column names
mygrid.setInitWidths("50,200,150,150,50,50");//set column width in px
mygrid.setColAlign("right,left,left,left,center,center");//set column values align 	
mygrid.setColTypes("ro,ed,ed,ed,img,img");//set column types
mygrid.setColSorting("int,str,str,str,str,str");//set sorting
mygrid.init();//initialize grid
mygrid.setSkin("dhx_skyblue");//set grid skin
mygrid.load("_clientiXML.cfm");
mygrid.enableMultiselect(true);
mygrid.attachEvent("onRowDblClicked" , doOnRowSelect);

var dhxWins , w1;
dhxWins = new dhtmlXWindows();
	dhxWins.enableAutoViewport(true);
    dhxWins.attachViewportTo("w1");
    dhxWins.setImagePath("../include/dhtmlx/dhtmlxwindows/codebase/imgs/");
</script>
</body>
</html>	 

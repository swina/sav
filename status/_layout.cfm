<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<cfset mydhtml = application.dhtmlxurl>
	<link rel="stylesheet" type="text/css" href="../include/css/style.css">
	<script src="../include/js/functions.js"></script>
	<script src="status.js"></script>
	
	<cfoutput>
	<script type="text/javascript">
    	var GB_ROOT_DIR = "http://#http_host#/crm/include/greybox/";
	</script>
	
	<script type="text/javascript" src="../include/greybox/AJS.js"></script>
	<script type="text/javascript" src="../include/greybox/AJS_fx.js"></script>
	<script type="text/javascript" src="../include/greybox/gb_scripts.js"></script>
	<link href="../include/greybox/gb_styles.css" rel="stylesheet" type="text/css" />
	<!--- GRID --->
	<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxGrid/codebase/dhtmlxgrid.css">
    <link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxGrid/codebase/skins/dhtmlxgrid_dhx_skyblue.css">
    <script src="../include/dhtmlx/dhtmlxGrid/codebase/dhtmlxcommon.js"></script>
    <script src="../include/dhtmlx/dhtmlxGrid/codebase/dhtmlxgrid.js"></script>
    <script src="../include/dhtmlx/dhtmlxGrid/codebase/dhtmlxgridcell.js"></script>
	<script  src="../include/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_start.js"></script>
	<!--- CALENDAR --->	
	<link rel="STYLESHEET" type="text/css" href="../include/dhtmlx/dhtmlxCalendar/codebase/dhtmlxcalendar.css">
<!--- 	<script>
	window.dhx_globalImgPath = "../include/dhtmlx/dhtmlxCalendar/codebase/imgs/";
	</script> --->
	<script  src="../include/dhtmlx/dhtmlxCalendar/codebase/dhtmlxcommon.js"></script>
	<script  src="../include/dhtmlx/dhtmlxCalendar/codebase/dhtmlxcalendar.js"></script>
	
	<!--- WINDOW --->
	<link rel="stylesheet" type="text/css" href="#mydhtml#/dhtmlxwindows/codebase/dhtmlxwindows.css">
	<link rel="stylesheet" type="text/css" href="#mydhtml#/dhtmlxwindows/codebase/skins/dhtmlxwindows_dhx_skyblue.css">
	<script src="#mydhtml#/dhtmlxwindows/codebase/dhtmlxcommon.js"></script>
	<script src="#mydhtml#/dhtmlxwindows/codebase/dhtmlxwindows.js"></script>
	<script src="#mydhtml#/dhtmlxwindows/codebase/dhtmlxcontainer.js"></script>
	</cfoutput>
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
dhxLayout.items[0].setWidth(400);
dhxLayout.setEffect("collapse",false);
dhxLayout.cells("a").setText("Status Operativo");
dhxLayout.cells("a").attachObject("status");

//cell b (sidebar)
dhxLayout.items[1].setWidth(300);
dhxLayout.setEffect("collapse",false);
dhxLayout.cells("b").setText("Dettaglio Cliente");
dhxLayout.cells("b").attachObject("sidebar");
}
</script>
</head>

<body onload="doOnLoad()">
<div>
	<div id="status" class="winblue" style="height:90%">
		<cfinclude template="_statusList.cfm">
	</div>
	<div id="sidebar" class="winblue">
	 	<cfinclude template="_statusDetail.cfm">
	</div>
</div>
<div id="w1" class="wiblue" style="position: relative; height: 100%; border: #cecece 1px solid; margin: 10px;display:none"><cfinclude template="_statusDocsUpload.cfm"></div>
<cfinclude template="_statusQualifica.cfm">

<cfwindow width="600" height="450" 
        name="moduloWin" title="Modulo" 
		center="true"
        initshow="false" 
		draggable="true" 
		resizable="true" 
		closable="false" 
        source="_statusModulo.cfm?text={processoFrm:ac_modulo}"/>
</body>
<cfoutput>
<script>
function date_custom(a,b,order){ 
		alert (a);
            a=a.split("/")
            b=b.split("/")
            if (a[2]==b[2]){
                if (a[1]==b[1])
                    return (a[0]>b[0]?1:-1)*(order=="asc"?1:-1);
                else
                    return (a[1]>b[1]?1:-1)*(order=="asc"?1:-1);
            } else
                 return (a[2]>b[2]?1:-1)*(order=="asc"?1:-1);
        }

//inizializza la grid status
mygrid = new dhtmlXGridObject('gridboxSTATUS');
mygrid.setImagePath("../include/dhtmlx/dhtmlxGrid/codebase/imgs/");//path to images required by grid
<cfif session.livello LT 3 OR StructFind(session.userlogin,"gruppi_controllo") NEQ "">
	mygrid.setHeader("&raquo;,Cliente,Agente,Citt�,Data,Azione,&raquo;");//set column names
<cfelse>
	mygrid.setHeader("&raquo;,Cliente,Indirizzo,Citt�,Data,Azione,&raquo;");//set column names	
</cfif>
mygrid.setInitWidths("25,150,100,100,70,150,*");//set column width in px
mygrid.setColAlign("left,left,left,left,left,left,left");//set column values align
mygrid.setColTypes("img,ro,ro,ro,ro,ro,img");//set column types
mygrid.setColSorting("img,str,str,str,date_custom,str,str,str");//set sorting
//mygrid.attachEvent("onSelectStateChanged", statusCliente);
mygrid.attachEvent("onRowSelect" , statusCliente );
mygrid.init();//initialize grid
mygrid.setSkin("dhx_skyblue");//set grid skin
<cfif IsDefined("url.idcliente") IS FALSE>
	mygrid.load("_statusXML.cfm");
<cfelse>
	mygrid.load("_statusXML.cfm?idcliente=#url.idcliente#");
	//setValore("searchValue","#url.cognome#");
</cfif>
mygrid.attachEvent("onXLE", doOnRebuild);

//inizializza la grid della cronologia eventi di un cliente
mygrid2 = new dhtmlXGridObject('gridboxCLIENTE');
mygrid2.setImagePath("../include/dhtmlx/dhtmlxGrid/codebase/imgs/");//path to images required by grid
mygrid2.setHeader("Data,Ora,Azione");//set column names
mygrid2.setInitWidths("80,45,*");//set column width in px
mygrid2.setColAlign("left,left,left");//set column values align
mygrid2.setColTypes("ro,ro,ro");//set column types
mygrid2.setColSorting("str,str,str");//set sorting
mygrid2.attachEvent("onSelectStateChanged", getDataStatus);
mygrid2.attachEvent("onRowDblClicked", getDataStatus);  
mygrid2.init();//initialize grid
mygrid2.setSkin("dhx_skyblue");//set grid skin


var dhxWins , w1;
dhxWins = new dhtmlXWindows();
	dhxWins.enableAutoViewport(true);
    dhxWins.attachViewportTo("w1");
    dhxWins.setImagePath("../include/dhtmlx/dhtmlxwindows/codebase/imgs/");

	
var aProcesso_Gerarchia = new Array();	
<cfset np = 0>
<cfloop query="myProcessi">
	<cfif StructFind(session.userlogin,"livello") GT 0>
		<cfset permission = ListGetAt(ac_permissions,livello)>
		<cfif permission EQ 1>
			aProcesso_Gerarchia[#np#] = "#int_gerarchia#";
			<cfset np = np + 1>
		</cfif>
	<cfelse>	
		aProcesso_Gerarchia[#np#] = "#int_gerarchia#";
		<cfset np = np + 1>
	</cfif>
</cfloop>	
	
var aProcesso_Tipo = new Array();	
<cfset np = 0>
<cfloop query="myProcessi">
	<cfif StructFind(session.userlogin,"livello") GT 0>
		<cfset permission = ListGetAt(ac_permissions,livello)>
		<cfif permission EQ 1>
			aProcesso_Tipo[#np#] = "#int_tipo#";
			<cfset np = np + 1>
		</cfif>
	<cfelse>	
		aProcesso_Tipo[#np#] = "#int_tipo#";
		<cfset np = np + 1>
	</cfif>
</cfloop>


var aProcesso_Timer = new Array();	
<cfset np = 0>
<cfloop query="myProcessi">
	<cfif StructFind(session.userlogin,"livello") GT 0>
		<cfset permission = ListGetAt(ac_permissions,livello)>
		<cfif permission EQ 1>
			aProcesso_Timer[#np#] = "#int_timer_limit#";
			<cfset np = np + 1>
		</cfif>
	<cfelse>	
		aProcesso_Timer[#np#] = "#int_timer_limit#";
		<cfset np = np + 1>
	</cfif>
</cfloop>

	
var aModuli = new Array();
<cfset np = 0>
<cfloop query="myProcessi">
	<cfif StructFind(session.userlogin,"livello") GT 0>
		<cfset permission = ListGetAt(ac_permissions,livello)>
		<cfif permission EQ 1>
			aModuli[#np#] = "#ac_modulo#";
			<cfset np = np + 1>
		</cfif>
	<cfelse>	
		aModuli[#np#] = "#ac_modulo#";
		<cfset np = np + 1>
	</cfif>
</cfloop>

var aValore = new Array();
<cfset np = 0>
<cfloop query="myProcessi">
	<cfif StructFind(session.userlogin,"livello") GT 0>
		<cfset permission = ListGetAt(ac_permissions,livello)>
		<cfif permission EQ 1>
			aValore[#np#] = #int_tipo#;
			<cfset np = np + 1>
		</cfif>
	<cfelse>	
		aValore[#np#] = #int_tipo#;
		<cfset np = np + 1>
	</cfif>
</cfloop>


var aDocumenti = new Array();
<cfset np = 0>
<cfloop query="myProcessi">
	<cfif StructFind(session.userlogin,"livello") GT 0>
		<cfset permission = ListGetAt(ac_permissions,livello)>
		<cfif permission EQ 1>
			aDocumenti[#np#] = #bl_documento#;
			<cfset np = np + 1>
		</cfif>
	<cfelse>	
		aDocumenti[#np#] = #bl_documento#;
		<cfset np = np + 1>
	</cfif>
</cfloop>

</script>
</cfoutput>
</html>

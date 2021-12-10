<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>SAVSales @ SAV Energy</title>
	<link rel="stylesheet" type="text/css" href="include/css/style.css">
	
	<!--- LAYOUT APPLICAZIONE --->
	<link rel="stylesheet" type="text/css" href="include/dhtmlx/dhtmlxLayout/codebase/dhtmlxlayout.css">
    <link rel="stylesheet" type="text/css" href="include/dhtmlx/dhtmlxLayout/codebase/skins/dhtmlxlayout_dhx_skyblue.css">
    <script src="include/dhtmlx/dhtmlxLayout/codebase/dhtmlxcommon.js"></script>
    <script src="include/dhtmlx/dhtmlxLayout/codebase/dhtmlxcontainer.js"></script>
    <script src="include/dhtmlx/dhtmlxLayout/codebase/dhtmlxlayout.js"></script>
	
	<!--- JS di funzioni generali e per l'autosuggest --->
 	<script language="JavaScript" src="include/js/functions.js" type="text/javascript"></script>
	<script language="JavaScript" src="service.js" type="text/javascript"></script>
 
<!--- inizialiazzazione layout --->
<script language="JavaScript" type="text/javascript">
function doOnLoad(){
var dhxLayout=new dhtmlXLayoutObject(document.body,"4I");
//cell a (top)
dhxLayout.items[0].setHeight(50);
dhxLayout.items[0].hideHeader();
dhxLayout.cells("a").setText("xSales");
dhxLayout.cells("a").attachObject("topbar");

//cell b (sidebar)
dhxLayout.items[1].setWidth(190);
dhxLayout.cells("b").attachObject("sidebar");
dhxLayout.setEffect("collapse",false);
dhxLayout.items[1].setText("Strumenti");

//cell c (main content)
dhxLayout.items[2].setText("Desktop");
dhxLayout.cells("c").attachObject("desktop");

//cell d (bottom bar)
dhxLayout.items[3].setHeight(20);
dhxLayout.items[3].hideHeader();
var statusBar = dhxLayout.cells("d").attachStatusBar();
statusBar.setText("<cfoutput>SAVSales @ SAV Energy - #DateFormat(now(),'dd.mm.yyyy')#</cfoutput>");
dhxLayout.setAutoSize("a;b;c;d","a;b;c;d");
}
</script>
</head>

<body onload="doOnLoad()">
<cfif IsDefined("application.dsn") IS FALSE>
	<cfset application.dsn = "savenergy">
</cfif>
<cfset session.debug = false>
<cfif IsDefined("url.debug")>
	<cfset session.debug = true>
</cfif>
<cfajaxproxy cfc="service" jsclassname="service" />
<cfif session.login>
	<div id="topbar">
		<cfinclude template="_header.cfm">
	</div>
	<div id="sidebar">
	 	<cfinclude template="_sidebar.cfm">
	</div>
	<div id="desktop">
		<cfinclude template="_tabbar.cfm">
	</div>
<cfelse>
	<div id="topbar">
		<cfinclude template="_header.cfm">
	</div>
	<div id="sidebar">
	 	<cfinclude template="_loginHelp.cfm">
	</div>
	<div id="desktop">
		<cfinclude template="_login.cfm">
	</div>
</cfif>
<cfform name="logoutFrm">
	<input type="hidden" id="logout" name="logout">
</cfform>
</body>
</html>

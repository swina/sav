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
	dhtmlx.image_path='./codebase/imgs/';

	var main_layout = new dhtmlXLayoutObject(document.body, '2E');

	var a = main_layout.cells('a');
	a.setHeight('50');
	a.hideHeader();
	a.fixSize(0,1);


	var b = main_layout.cells('b');
	b.hideHeader();

	
	dhxLayout.cells("a").setText("xSales");
	dhxLayout.cells("a").attachObject("topbar");
	
	//cell c (main content)
	dhxLayout.cells("b").setText("xSales");
	dhxLayout.cells("b").attachObject("desktop");
</script>
</head>

<body>
<!--- <div style="position:fixed; top:0px ; left:0px; width:100%; height:45px; border-bottom:5px solid #99cccc;" id="topbar">
	<cfinclude template="_header.cfm">
</div>
<!--- <div style="position:fixed; top:50px; left:0px; width:190px; z-index:10">
	<cfinclude template="_sidebar.cfm">
</div>
 --->
<div style="position:fixed; top:50px; left:0px; width:100%; height:100%; display:inline-block; background:#eaeaea; overflow:auto; z-index:11" id="main">
	<div style="float:left;display:inline-block;width:100%;background:#fff">
		<cfinclude template="tabs.cfm">
	</div>
</div> --->

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
	<!--- <div id="sidebar">
	 	<cfinclude template="_sidebar.cfm">
	</div> --->
	<div id="desktop">
		<cfinclude template="tabs.cfm">
	</div>
<cfelse>
	<div id="topbar">
		<cfinclude template="_header.cfm">
	</div>
	<!--- <div id="sidebar">
	 	<cfinclude template="_loginHelp.cfm">
	</div> --->
	<div id="desktop">
		<cfinclude template="_login.cfm">
	</div>
</cfif>
<cfform name="logoutFrm">
	<input type="hidden" id="logout" name="logout">
</cfform>
</body>
</html>

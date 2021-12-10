
<html>
<head>
	<cfset mydhtml = application.dhtmlxurl>
	<cfoutput>
	<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
	<script src="../include/js/functions.js"></script>
	<script src="status.js"></script>
	
	<cfoutput>
	<script type="text/javascript">
    	var GB_ROOT_DIR = "http://#http_host#/sav/include/greybox/";
	</script>
	</cfoutput>
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
	<style>
	body, html { height:95% }
	</style>

<body onload="doOnLoad()" class="winblue">
<cfset livello = StructFind(session.userlogin,"livello")>
<cfinclude template="ui2.cfm">
</body>
</html>	 
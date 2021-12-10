<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<cfset mydhtml = application.dhtmlxurl>
	<cfoutput>
	<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
	<script src="../include/js/functions.js"></script>
	<script src="status.js"></script>
	
	<cfoutput>
	<script type="text/javascript">
    	var GB_ROOT_DIR = "https://#application.hostname#/sav/include/greybox/";
	</script>
	</cfoutput>
	<script type="text/javascript" src="../include/greybox/AJS.js"></script>
	<script type="text/javascript" src="../include/greybox/AJS_fx.js"></script>
	<script type="text/javascript" src="../include/greybox/gb_scripts.js"></script>
	<link href="../include/greybox/gb_styles.css" rel="stylesheet" type="text/css" />
	<!--- GRID --->
	<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxgrid/codebase/dhtmlxgrid.css">
    <link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxgrid/codebase/skins/dhtmlxgrid_dhx_skyblue.css">
    <script src="../include/dhtmlx/dhtmlxgrid/codebase/dhtmlxcommon.js"></script>
    <script src="../include/dhtmlx/dhtmlxgrid/codebase/dhtmlxgrid.js"></script>
    <script src="../include/dhtmlx/dhtmlxgrid/codebase/dhtmlxgridcell.js"></script>
	<script  src="../include/dhtmlx/dhtmlxgrid/codebase/ext/dhtmlxgrid_start.js"></script>
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
	body, html { height:100% ; background:#dfdfff; }
	</style>

<body style="background:#eeeeee" class="winblue">
<cfset livello = StructFind(session.userlogin,"livello")>
<cfinclude template="ui3.cfm">
</body>
</html>	 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
	<cfoutput>
	<script type="text/javascript">
    	var GB_ROOT_DIR = "https://#application.hostname#/crmdemo/include/greybox/";
	</script>
	</cfoutput>
	<script type="text/javascript" src="../include/greybox/AJS.js"></script>
	<script type="text/javascript" src="../include/greybox/AJS_fx.js"></script>
	<script type="text/javascript" src="../include/greybox/gb_scripts.js"></script>
	<link href="../include/greybox/gb_styles.css" rel="stylesheet" type="text/css" />
	<!--- GRID --->
	 <cfoutput>
	<cfset mydhtml = application.dhtmlxurl>
	<link rel="stylesheet" type="text/css" href="#mydhtml#/dhtmlxgrid/codebase/dhtmlxgrid.css">
    <link rel="stylesheet" type="text/css" href="#mydhtml#/dhtmlxgrid/codebase/skins/dhtmlxgrid_dhx_skyblue.css">
    <script src="#mydhtml#/dhtmlxgrid/codebase/dhtmlxcommon.js"></script>
    <script src="#mydhtml#/dhtmlxgrid/codebase/dhtmlxgrid.js"></script>
    <script src="#mydhtml#/dhtmlxgrid/codebase/dhtmlxgridcell.js"></script>
	<script  src="#mydhtml#/dhtmlxgrid/codebase/ext/dhtmlxgrid_start.js"></script>
	
	<!--- CALENDAR --->	
	<link rel="STYLESHEET" type="text/css" href="../include/dhtmlx/dhtmlxCalendar/codebase/dhtmlxcalendar.css">
	<script  src="../include/dhtmlx/dhtmlxCalendar/codebase/dhtmlxcommon.js"></script>
	<script  src="../include/dhtmlx/dhtmlxCalendar/codebase/dhtmlxcalendar.js"></script>
	<!--- WINDOW --->
	<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxwindows/codebase/dhtmlxwindows.css">
	<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxwindows/codebase/skins/dhtmlxwindows_dhx_skyblue.css">
	<script src="../include/dhtmlx/dhtmlxwindows/codebase/dhtmlxcommon.js"></script>
	<script src="../include/dhtmlx/dhtmlxwindows/codebase/dhtmlxwindows.js"></script>
	<script src="../include/dhtmlx/dhtmlxwindows/codebase/dhtmlxcontainer.js"></script>
	
	</cfoutput> 
	
	<script src="../include/js/functions.js"></script>
	<script src="offerte.js"></script>
	<cfif IsDefined("session.debug") IS FALSE>
		<cfset session.debug = false>
	</cfif>
	<input type="hidden" name="debug" id="debug" value="<cfoutput>#session.debug#</cfoutput>">
<body onLoad="doOnLoad()" style="width:100%;height:100%;margin:0;paddin:0;background-color:#cbe2fe">
<cfinclude template="ui.cfm">


</body>
</html>

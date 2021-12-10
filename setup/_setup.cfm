<!--- <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<link rel="stylesheet" type="text/css" href="../include/css/style.css"></link>
	<!--- TAB Pagina principale --->
	<script  src="../include/dhtmlx/dhtmlxTabbar/codebase/dhtmlxcommon.js"></script>
	<script  src="../include/dhtmlx/dhtmlxTabbar/codebase/dhtmlxtabbar.js"></script>
	<script  src="../include/dhtmlx/dhtmlxTabbar/codebase/dhtmlxtabbar_start.js"></script>
	<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxTabbar/codebase/dhtmlxtabbar.css">

</head>

<body> --->
<cfif session.login>
	<cfset livello = StructFind(session.userlogin,"livello")>
<div id="setup_tabbar" class="dhtmlxTabBar" imgpath="../include/dhtmlx/dhtmlxTabbar/codebase/imgs/" style="width:100%; height:100%;"  skinColors="#FCFBFC,#F4F3EE" hrefmode="iframe">
	<!--- gestione tab --->
	<!--- Config --->
	<cfif livello EQ 0>
	    <div id="a1" name="Generale" href="_setup_Config.cfm">Generale</div>
		<!--- Azioni ---->
	    <div id="a2" name="Processi" href="_setup_Processi.cfm">Azioni</div>
		<!--- Alerting --->
		<div id="a3" name="Alerting" href="_setup_Alert.cfm">Alerting</div>
		<!--- Tipologie Contatti --->
		<div id="a4" name="Qualifica Contatti" href="_setup_Qualifica.cfm">Qualifica Contatti</div>
	</cfif>
	<div id="a5" name="Profilo" href="_setup_Profilo.cfm">Profilo</div>
</div>
<script>
dhtmlx.skin = "dhx_skyblue";
</script>
</cfif>
<!--- </body>
<script>
dhtmlx.skin = "dhx_skyblue";
</script>

 </html> --->

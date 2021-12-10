<!--- TAB Pagina principale --->
<script  src="include/dhtmlx/dhtmlxTabbar/codebase/dhtmlxcommon.js"></script>
<script  src="include/dhtmlx/dhtmlxTabbar/codebase/dhtmlxtabbar.js"></script>
<script  src="include/dhtmlx/dhtmlxTabbar/codebase/dhtmlxtabbar_start.js"></script>
<link rel="stylesheet" type="text/css" href="include/dhtmlx/dhtmlxTabbar/codebase/dhtmlxtabbar.css">
<div id="a_tabbar" class="dhtmlxTabBar" imgpath="include/dhtmlx/dhtmlxTabbar/codebase/imgs/" style="width:100%; height:100%;" skinColors="#FCFBFC,#F4F3EE" hrefmode="iframes">

	<!--- gestione tab --->
	<!--- DASHBOARD > STATUS --->
    <div id="a0" name="Status" href="status/" style="overflow:auto">Dashboard</div>
	<!--- AGENDA --->
	<div id="a1" name="Agenda" href="agenda/">Agenda</div>
	<!--- CONTATTI ---->
    <div id="a2" name="Contatti" href="clienti/">Contatti</div>
	<cfif session.livello LT 3>
 	<div id="a3" name="Utenti" href="gruppi/">Utenti</div>
	</cfif>
    <div id="a4" name="Analisi" href="analisi/">Analisi</div>
	<div id="a5" name="Documenti" href="docs/">Documenti</div>
    <div id="a6" name="Setup" href="setup/">Setup</div>
	<div id="a7" name="Chat" href="chat/">Chat</div>
</div>
<br>
<script>
dhtmlx.skin = "dhx_skyblue";
a_tabbar.attachEvent("onSelect" , function(id,last_id){
	alert ( id );
	if ( id == "a2" ){
		alert ( "Reloading ...");
		tabbar.setContent(id,"agenda/");
	}
}); 


</script>

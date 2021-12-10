<!--- TAB Pagina principale --->
<script  src="include/dhtmlx/dhtmlxTabbar/codebase/dhtmlxcommon.js"></script>
<script  src="include/dhtmlx/dhtmlxTabbar/codebase/dhtmlxtabbar.js"></script>
<!--- <script  src="include/dhtmlx/dhtmlxTabbar/codebase/dhtmlxtabbar_start.js"></script> --->
<link rel="stylesheet" type="text/css" href="include/dhtmlx/dhtmlxTabbar/codebase/dhtmlxtabbar.css">
<body>
<div id="a_tabbar" style="width:100%; height:100%;overflow:auto"/>


<script>
tabbar = new dhtmlXTabBar("a_tabbar", "top");
tabbar.setSkin('dhx_skyblue');
tabbar.setImagePath("include/dhtmlx/dhtmlxTabbar/codebase/imgs/");
tabbar.setHrefMode("iframes");
var statusOpened = false;
var contattiOpened = false;
var planOpened = false;
var utentiOpened = false;
var analisiOpened = false;
var docsOpened = false;
var setupOpened = false;
var alertsOpened = false;
var offerteOpened = false;
var messagesOpened = false;

<cfif session.livello LT 2>
	tabbar.addTab("a0", "Home", "80px");
	tabbar.addTab("a1", "Status", "80px");
	tabbar.addTab("a2", "Agenda", "80px");
	tabbar.addTab("a3", "Contatti", "80px");
	tabbar.addTab("a4", "Utenti", "80px");
	tabbar.addTab("a5", "Analisi", "80px");
	tabbar.addTab("a6", "Documenti", "80px");
	tabbar.addTab("a7", "Setup", "80px");
	//tabbar.addTab("a8", "Chat", "80px");
	tabbar.addTab("a9", "Help", "80px");
	tabbar.addTab("a10", "Plan", "80px");
	tabbar.addTab("a11", "Alerts", "80px");
	tabbar.addTab("a12", "Offerte", "80px");
	tabbar.addTab("a13", "Messaggi", "80px");
	//tabbar.setContentHref("a1", "status/");
	tabbar.setContentHref("a0","_home.cfm");
	//tabbar.setContentHref("a3", "clienti/index2.cfm");
	//tabbar.setContentHref("a4", "gruppi/");
	//tabbar.setContentHref("a5", "analisi/");
	//tabbar.setContentHref("a6", "docs/");
	//tabbar.setContentHref("a7", "setup/");
	//tabbar.setContentHref("a8", "chat/");
	//tabbar.setContentHref("a10", "plan/index2.cfm");
	tabbar.setTabActive("a0");

<cfelse>
	tabbar.addTab("a0", "Home", "80px");
	tabbar.addTab("a1", "Status", "80px");
	tabbar.addTab("a2", "Agenda", "80px");
	tabbar.addTab("a3", "Contatti", "80px");
	tabbar.addTab("a5", "Analisi", "80px");
	tabbar.addTab("a6", "Documenti", "80px");
	tabbar.addTab("a7", "Setup", "80px");
	//tabbar.addTab("a8", "Chat", "80px");
	tabbar.addTab("a9", "Help", "80px");
	tabbar.addTab("a10", "Plan", "80px");
	tabbar.addTab("a11", "Alerts", "80px");
	<cfif session.livello EQ 4>
	tabbar.addTab("a12", "Offerte", "80px");
	</cfif>
	tabbar.addTab("a13", "Messaggi", "80px");
	tabbar.setContentHref("a0","_home.cfm");
	//tabbar.setContentHref("a1", "status/");
	//tabbar.setContentHref("a3", "clienti/");
	//tabbar.setContentHref("a5", "analisi/");
	//tabbar.setContentHref("a6", "docs/");
	//tabbar.setContentHref("a7", "setup/");
	//tabbar.setContentHref("a8", "chat/");
	//tabbar.setContentHref("a10", "plan/");
	tabbar.setTabActive("a0");

</cfif>


tabbar.attachEvent("onSelect", function(id,last_id) {
	if ( id == "a2" ){
		//l'agenda viene ricaricata sempre
		tabbar.setContentHref(id,"agenda/");
		return true;
	}	else {
		if ( id == "a1" ){
			if ( statusOpened == false ){
				tabbar.setContentHref(id,"status/");
				statusOpened = true;
			}
			return true;
		}
		if ( id == "a3" ){
			if ( contattiOpened == false ){
				tabbar.setContentHref(id, "clienti/index2.cfm");
				contattiOpened = true;
			}
			return true;
		}
		if ( id == "a4" ){
			if ( utentiOpened == false ){
				tabbar.setContentHref(id, "gruppi/");
				utentiOpened = true;
			}
			return true;
		}
		if ( id == "a5" ){
			if ( analisiOpened == false ){
				tabbar.setContentHref(id, "analisi/");
				analisiOpened = true;
			}
			return true;
		}
		if ( id == "a6" ){
			if ( docsOpened == false ){
				tabbar.setContentHref(id, "docs/");
				docsOpened = true;
			}
			return true;
		}
		if ( id == "a7" ){
			if ( setupOpened == false ){
				tabbar.setContentHref(id, "setup/");
				setupOpened = true;
			}
			return true;
		}
		if ( id == "a10" ){
			if ( planOpened == false ){
				tabbar.setContentHref(id, "plan/");
				planOpened = true;
			}
			return true;
		}
		if ( id == "a11" ){
			if ( alertsOpened == false ){
				tabbar.setContentHref(id, "alerting/");
				alertsOpened = true;
			}
			return true;
		}
		if ( id == "a12" ){
			if ( offerteOpened == false ){
				tabbar.setContentHref(id, "offerte/");
				offerteOpened = true;
			}
			return true;
		}
		if ( id == "a13" ){
			if ( messagesOpened == false ){
				tabbar.setContentHref(id, "messages/");
				messagesOpened = true;
			}
			return true;
		}
		if ( id == "a9" ){
			if ( last_id == "a1" ){
				tabbar.setContentHref(id,"help/status/");
			} 
			if ( last_id == "a2" ) {
				tabbar.setContentHref(id,"help/agenda/");
			}
			if ( last_id == "a3" ){
				tabbar.setContentHref(id,"help/clienti/");
			}
			if ( last_id == "a4" ){
				tabbar.setContentHref(id,"help/gruppi/");
			}
			if ( last_id == "a5" ){
				tabbar.setContentHref(id,"help/analisi/");
			}
			if ( last_id == "a6" ){
				tabbar.setContentHref(id,"help/docs/");
			}
			if ( last_id == "a7" ){
				tabbar.setContentHref(id,"help/setup/");
			}
			//if ( last_id == "a8" ){
			//	tabbar.setContentHref(id,"help/chat/");
			//}
			if ( last_id == "a10" ){
				tabbar.setContentHref(id,"help/plan/");
			}
		}
		
		return true;
	}
});
</script>



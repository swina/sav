var currentRow = -1;

var aTitolo = ["ANALISI PROCESSI","ANALISI ASSEGNAZIONI"];
var aMetodo = ["contaProcessi"];
var aCFML	= ["_stat_processi.cfm?","_stat_assegnazioni.cfm?","_1app-contratto_dettaglio.cfm?","_richiesta-contratto_dettaglio.cfm?","_stat_riepilogo_generale.cfm?","_1telefo-contratto_dettaglio.cfm?","appuntamenti-contratto_dettaglio.cfm?","_appuntamenti2.cfm?","_assegnazioni.cfm?","_richieste-contratti.cfm?"];
//CALENDARIO -------------------------------------------------------------	
	var cal1,
	cal2,
	mCal,
	mDCal,
	newStyleSheet;
	var dateFrom = null;
	var dateTo = null;
	window.dhx_globalImgPath = "../include/dhtmlx/dhtmlxCalendar/codebase/imgs/";
	window.onload = function() {
	    cal1 = new dhtmlxCalendarObject('dateFrom');
		cal1.attachEvent("onClick", function(date) {
        	calDeptDate(date,"dateFrom");
	    });
		cal2 = new dhtmlxCalendarObject('dateTo');
		cal2.attachEvent("onClick", function(date) {
        	calDeptDate(date,"dateTo");
	    });
		cal3 = new dhtmlxCalendarObject('dateFrom2');
		cal3.attachEvent("onClick", function(date) {
        	calDeptDate(date,"dateFrom2");
	    });
		cal4 = new dhtmlxCalendarObject('dateTo2');
		cal4.attachEvent("onClick", function(date) {
        	calDeptDate(date,"dateTo2");
	    });
	}

	function calDeptDate(d,obj) {
		var  myDate = d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear();
	    setValore(obj,myDate);
	}
//FINE CALENDARIO ----------------------------------------------------------

function setStatistiche(tipo){
	//alert(tipo);
	setHTML("stat","<strong>" + aTitolo[tipo] + "</strong>");
	var id_gruppo_agenti = comboGet("id_gruppo_agenti");
	
	var id_agente = comboGet("id_agente")[0];
	
	var combo = document.getElementById("id_agente");
	var multiple_agente = "";
	for ( var i = 0; i < combo.options.length; i++ ){
		if ( combo.options[i].selected ){
			
			multiple_agente = multiple_agente + combo.options[i].value + ",";
		}
	}
	if ( multiple_agente != ","){
		id_agente = multiple_agente;
	}
	//alert(id_agente);
	var checkGruppiControllo = getValore("gruppi_controllo");
	if ( checkGruppiControllo != "" ){
		id_agente[0] = "";
	}
	
	var startProcesso = comboGet("id_processo_start");
	var endProcesso = comboGet("id_processo_end");

	var periodo2 = document.getElementById("periodo2").checked;

	var myXML = aCFML[tipo] + "metodo=" + aMetodo[tipo] + "&dateFrom=" + getValore("dateFrom") + "&dateTo=" + getValore("dateTo") + "&id_agente=" + id_agente + "&id_gruppo_agenti=" + id_gruppo_agenti[0] + "&start_processo=" + startProcesso[0] + "&end_processo=" + endProcesso[0] + "&dateFrom2=" + getValore("dateFrom2") + "&dateTo2=" + getValore("dateTo2") + "&periodo2=" + periodo2;
	
	//alert(myXML);
	obj("statistica").src = myXML;
	parent.obj("detailFrame").style.display = "none";
	//ColdFusion.Ajax.submit("periodoFrm","_stat_processi.cfm",callbackStatistiche,errorHandler);
	
	//mygrid.clearAndLoad(myXML);
	//var CFMLDetail = "_analisi_processi_detailXML.cfm?";
	//var metodoDetail = "processiInCorsoDetail";
	
	//var myXML = CFMLDetail + "metodo=" + metodoDetail + "&dateFrom=" + getValore("dateFrom") + "&dateTo=" + getValore("dateTo") + "&id_agente=" + id_agente[0] + "&id_gruppo_agenti=" + id_gruppo_agenti[0] + "&start_processo=" + startProcesso[0] + "&end_processo=" + endProcesso[0];
	//mygrid2.clearAndLoad(myXML);
}

function callbackStatistiche ( result ){
	return true;
}

function errorHandler ( err , msg ){
	alert ( err + "\n" + msg );
}

function setStandard(tipo){
	
}
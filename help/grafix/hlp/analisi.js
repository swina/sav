var currentRow = -1;

var aTitolo = ["INDICI OPERATIVI"];
var aMetodo = ["processiInCorso"];
var aCFML	= ["_analisi_processiXML.cfm?"];

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
	}

	function calDeptDate(d,obj) {
		var  myDate = d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear();
	    setValore(obj,myDate);
	}
//FINE CALENDARIO ----------------------------------------------------------

function setAnalisi(tipo){
	setHTML("stat","<strong>" + aTitolo[tipo] + "</strong>");
	var id_gruppo_agenti = comboGet("id_gruppo_agenti");
	var id_agente = comboGet("id_agente");
	alert (id_agente);
	var checkGruppiControllo = getValore("gruppi_controllo");
	if ( checkGruppiControllo != "" ){
		id_agente[0] = "";
	}
	var myXML = aCFML[tipo] + "metodo=" + aMetodo[tipo] + "&dateFrom=" + getValore("dateFrom") + "&dateTo=" + getValore("dateTo") + "&id_agente=" + id_agente[0] + "&id_gruppo_agenti=" + id_gruppo_agenti[0];
	//alert(myXML);
	mygrid.clearAndLoad(myXML);
	var CFMLDetail = "_analisi_processi_detailXML.cfm?";
	var metodoDetail = "processiInCorsoDetail";
	
	var myXML = CFMLDetail + "metodo=" + metodoDetail + "&dateFrom=" + getValore("dateFrom") + "&dateTo=" + getValore("dateTo") + "&id_agente=" + id_agente[0] + "&id_gruppo_agenti=" + id_gruppo_agenti[0];
	mygrid2.clearAndLoad(myXML);
}


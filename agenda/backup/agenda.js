function reloadAgenda(obj){
	
	var soloagente = 0;
	if ( obj.checked ){
		soloagente = 1;
	}
	scheduler.clearAll();
	scheduler.load("_agendaXML.cfm?soloagente=" + soloagente);
}

function setAgenda(){
	var id_gruppo_agenti = comboGet("id_gruppo_agenti");
	var id_agente = comboGet("id_agente");
	var checkGruppiControllo = getValore("gruppi_controllo");
	//alert("dateFrom=" + getValore("dateFrom") + "&dateTo=" + getValore("dateTo") + "&id_agente=" + id_agente[0] + "&id_gruppo_agenti=" + id_gruppo_agenti[0] + "&id_processo=" + id_processo[0]);
	var myXML = "_agendaXML.cfm?dateFrom=" + getValore("dateFrom") + "&dateTo=" + getValore("dateTo") + "&id_agente=" + id_agente[0] + "&id_gruppo_agenti=" + id_gruppo_agenti[0];
	scheduler.clearAll();
	showObj("warning");
	scheduler.load(myXML);
}

function doAgendaLoaded(){
	hideObj("warning");
}
function exportToiCal(){
	var str = scheduler.toICal();
	setValore("iCal",str);
}

function doOpenStatus(){
	
	//alert(scheduler.getEvent());
}
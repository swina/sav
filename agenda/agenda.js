var hrs;
var mins;
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

function doAgendaAddEvent(id,data,is_new_event){
	var myText = scheduler.getEventText(id);

	var startDate = scheduler.getEventStartDate(id);
	startDate = dateParser(startDate);
	oraParser(scheduler.getEventStartDate(id),id);
	
	var endDate = scheduler.getEventEndDate(id);
	endDate = dateParser(endDate);
	oraEndParser(scheduler.getEventEndDate(id),id);
	$("#agenda_id").val(id);
	$("#agenda_action").val(myText);
	$("#ac_evento").val(myText);

	//alert(startDate);
	//alert(giorno + "/" + mese + "/" + anno + " " + ora + ":" + minuti);

	if ( myText == "Nuovo evento" ){
		$("#btn-delete-event").hide();
		var myTitle = "Nuovo evento";
	} else {
		$("#btn-delete-event").show();
		var myTitle = "Evento del ";
	}
	$("#dialog").dialog("option","title", myTitle +  " " + startDate);
	$("#dialog").dialog("open");
}


function dateParser(myDate){
	var giorno = myDate.getUTCDate();
	var mese = myDate.getUTCMonth()+1;
	var anno = myDate.getUTCFullYear();
	var ora = myDate.getHours();
	var minuti = myDate.getMinutes();
	if ( minuti < 10 ){
		minuti = "0" + minuti;
	}
	//$("#ora").val(eval(ora));
	//$("#minuti").val(minuti);
	$("#dt_start").val(giorno + "/" + mese + "/" + anno);
	var strDate = giorno + "/" + mese + "/" + anno + "-" + ora + ":" + minuti;
	return strDate;
}

function oraParser(data,id){
		$.ajax({
			url: "http://" + $('#url_host').val() + "/savmarket/agenda/agenda.cfc",
			type: 'GET',
			data: {method: 'getTimeEvent', returnFormat: 'plain', id: id, tipo: 'start'}, 
	    	dataType: 'html',
   			cache: false,
   			success: function (txt){ 
				if (txt.length != 0) {
					var aOre = txt.split(":");
					$("#ora").val(aOre[0]);
					$("#minuti").val(aOre[1]);
				} else {
					$("#ora").val(data.getHours());
					$("#minuti").val(data.getMinutes());
				}				
			}
		});

	//$("#ora").val(data.getHours());
	//$("#minuti").val(data.getMinutes());
}

function oraEndParser(data,id){
	$.ajax({
			url: "http://" + $('#url_host').val() + "/savmarket/agenda/agenda.cfc",
			type: 'GET',
			data: {method: 'getTimeEvent', returnFormat: 'plain', id: id, tipo: 'end'}, 
	    	dataType: 'html',
   			cache: false,
   			success: function (txt){ 
				if (txt.length != 0) {
					var aOre = txt.split(":");
					$("#ora_end").val(aOre[0]);
					$("#minuti_end").val(aOre[1]);
				} else {
					$("#ora_end").val(data.getHours());
					$("#minuti_end").val(data.getMinutes());
				}				
			}
		});
}

function doNewEvent(){
	scheduler.addEvent({
          start_date: new Date(),
          end_date: new Date(),
          text: "Nuovo evento"
   });
}

var currentRow = -1;


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

function doSelectRow(rId,cIn){
	showObj("messageDetail");
	setHTML("msgDate","Data: <strong>" + mygrid.getUserData(rId,"msgDate") + "</strong>");
	setHTML("msgTo","A: <strong>" + mygrid.getUserData(rId,"msgTo") + "</strong>");
	setHTML("msgSubject","Oggetto: <strong>" + mygrid.getUserData(rId,"msgSubject") + "</strong>");
	setHTML("msgText",mygrid.getUserData(rId,"msgText"));
	showObj("msgToolbar");
	setValore("id_message",mygrid.getUserData(rId,"id_message"));
}

function doOnCellChanged(stage, rId, cIn, nValue,oValue) {
	currentRow = rId;
	if ( stage == 2 ){
		if (  cIn == 6 ){
			setValore("id_status_assegna",mygrid.getUserData(rId,"id_status"));
			setValore("id_persona_assegna",nValue);
			ColdFusion.Ajax.submitForm("assegnaFrm","_planAssegna.cfm",callbackAssegna,errorHandler)		;
			
		}
	}
}

function callbackAssegna ( result ){
	mygrid.cells(currentRow,6).setValue(result);
}

function errorHandler (code,msg){
	alert(code);
}

function createMsg(){
	showObj("newMsg");
}

function sendMsg(){
	
	var id_gruppo = comboGet("id_gruppo_agenti");
	var id_agente = comboGet("id_agente");
	if ( id_gruppo[0] == 0 && id_agente[0] == 0 ){
		
		if ( obj("id_to").checked ){
			setValore("invio_generale",-1);
			ColdFusion.Ajax.submitForm("periodoFrm","_msgSend.cfm",callbackSendMsg,errorHandler);
		} else {
			alert("Attenzione! Selezionare almeno un destinatario!");
		}
	} else {
		//alert(id_gruppo[0]);
		//alert(id_agente[0]);
		ColdFusion.Ajax.submitForm("periodoFrm","_msgSend.cfm",callbackSendMsg,errorHandler);
	}
}

function deleteMsg(){
	var conferma = confirm ( "Confermi la cancellazione di questo messaggio ?");
	if ( conferma ){
		hideObj("messageDetail");
		ColdFusion.Ajax.submitForm("messageFrm","_msgDelete.cfm",callbackSendMsg,errorHandler);
	}
}

function callbackSendMsg(result){
	mygrid.clearAndLoad("_msgListXML.cfm");
}

function viewMsg(){
	var dFrom = getValore("dateFrom");
	var dTo = getValore("dateTo");
	var gruppo = comboGet("id_gruppo_agenti");
	var agente = comboGet("id_agente");
	var tutti = document.getElementById("id_to").checked;
	mygrid.clearAndLoad("_msgListXML.cfm?dateFrom=" + dFrom + "&dateTo=" + dTo + "&id_gruppo_agenti=" + gruppo[0] + "&id_agente=" + agente[0] + "&tutti=" + tutti);
}
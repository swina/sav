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

function setAlert(){
	var id_gruppo_agenti = comboGet("id_gruppo_agenti");
	var id_agente = comboGet("id_agente");
	var checkGruppiControllo = getValore("gruppi_controllo");
	
	var id_processo = comboGet("id_processo");
	//alert("dateFrom=" + getValore("dateFrom") + "&dateTo=" + getValore("dateTo") + "&id_agente=" + id_agente[0] + "&id_gruppo_agenti=" + id_gruppo_agenti[0] + "&id_processo=" + id_processo[0]);
	var myXML = "_alertBlackListXML.cfm?dateFrom=" + getValore("dateFrom") + "&dateTo=" + getValore("dateTo") + "&id_agente=" + id_agente[0] + "&id_gruppo_agenti=" + id_gruppo_agenti[0] + "&id_processo=" + id_processo[0];
	
	mygrid.clearAndLoad(myXML);
}

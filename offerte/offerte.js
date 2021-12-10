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
	var nwin = 1;
	function initCalendar(){
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
	var uuid = mygrid.getUserData(rId,"ac_modulo_uuid");
	setValore("ac_modulo_uuid",uuid);
	setValore("id_cliente",mygrid.getUserData(rId,"id_cliente"));
	setValore("id_agente",mygrid.getUserData(rId,"id_agente"));
	setValore("id_status",mygrid.getUserData(rId,"id_status"));
	setValore("ac_modulo_uuid_2",mygrid.getUserData(rId,"ac_modulo_uuid"));
	setValore("ac_valore",mygrid.getUserData(rId,"ac_valore"));
	if ( getValore("ac_valore") != 0 ){
		setHTML("valore","Valore &euro; <strong>" + getValore("ac_valore") + "</strong>");
	} else {
		setHTML("valore","");
	}
	//alert(mygrid.getUserData(rId,"id_cliente"));
	var docs = mygrid.getUserData(rId,"ac_docs");
	if ( uuid != "" ){
		ColdFusion.Ajax.submitForm("moduloFrm","_offertaModulo.cfm",callbackModuloOfferta,errorHandler);
	} else {
		mygrid2.clearAll();
	}	
	
	if ( docs != "" ){
		var myDocs = listToArray(docs,",");
		var myURLS = "";
		for ( var i = 0 ; i < myDocs.length ; i++){
			if ( myDocs[i].length > 3 ){
				var pos = myDocs[i].indexOf(".");
				var icona = myDocs[i].substring(pos+1);
				
				var myURLS = myURLS + "<img src='../include/css/icons/files/" + icona + ".png' align='absmiddle'><a href='../docs/status/" + getValore("id_cliente") + "/" + myDocs[i] + "' style='color:blue' target='_blank'>" + myDocs[i] + "</a> &nbsp;&nbsp;";
			}
		}
		setHTML("documenti", myURLS); 
	} else {
		setHTML("documenti", "");
	}
	
	//recupero la data di presentazione offerta
	doVediPresentazione();
}

function callbackModuloOfferta(result){
	//alert("Loading modulo " + getValore("ac_modulo_uuid"));
	mygrid2.clearAll();
	mygrid2.load("_offertaModuloXML.cfm?uuid=" + getValore("ac_modulo_uuid"));
	//var data = listToArray(result,"|");
	//for ( var i = 0 ; i < data.length ; i++ ){
	//	alert ( data[i] );
	//}
}


function doVediPresentazione(){
	ColdFusion.Ajax.submitForm("processoFrm","_offertePresentazione.cfm",callbackPresentazione,errorHandler);
}

function callbackPresentazione(result){
	setHTML("presentazione","<strong>Pres. Off. " + result + "</strong>")
}

function doOnCellChanged(stage, rId, cIn, nValue,oValue) {
	currentRow = rId;
	if ( stage == 2 ){
		if (  cIn == 5 ){
			setValore("id_status_assegna",mygrid.getUserData(rId,"id_status"));
			setValore("id_persona_assegna",nValue);
			ColdFusion.Ajax.submitForm("assegnaFrm","_offerteAssegna.cfm",callbackAssegna,errorHandler)		;
			
		}
	}
}

function callbackAssegna ( result ){
	mygrid.cells(currentRow,6).setValue(result);
}

function errorHandler (code,msg){
	alert(code);
}

function setPlan(){
	var id_gruppo_agenti = comboGet("id_gruppo_agenti");
	var id_agente = comboGet("id_agente_filter");
	var checkGruppiControllo = getValore("gruppi_controllo");
	var id_processo = comboGet("id_processo");
	var cliente = getValore("ac_cliente");
	var id_persona = comboGet("id_ut");
	var noOfferte = false;
	if ( obj("noOfferte").checked ){
		noOfferte = true;
	}
	//alert("dateFrom=" + getValore("dateFrom") + "&dateTo=" + getValore("dateTo") + "&id_agente=" + id_agente[0] + "&id_gruppo_agenti=" + id_gruppo_agenti[0] + "&id_processo=" + id_processo[0]);
	var myXML = "_offerteXML.cfm?dateFrom=" + getValore("dateFrom") + "&dateTo=" + getValore("dateTo") + "&id_agente=" + id_agente[0] + "&id_gruppo_agenti=" + id_gruppo_agenti[0] + "&id_processo=" + id_processo[0] + "&cliente=" + cliente + "&id_persona=" + id_persona[0] + "&noOfferte=" + noOfferte;
	mygrid.clearAndLoad(myXML);
}


//inizializza/visualizza finestra per l'upload dei documenti
	function uploadDocs(){
		if ( nwin == 1 ){
			w1 = dhxWins.createWindow("w1", 150, 50, 450, 250);
			w1.button("close").hide();
			w1.button("minmax1").hide();
			w1.button("park").hide();
			w1.setText("Carica Documenti");
			w1.center();
			w1.attachObject("uploadWin");
			nwin = nwin + 1;
			w1.addUserButton("close", 0, "Dock Window", "close");
    		w1.button("close").attachEvent("onClick", function() {
        		w1.hide();
    		});
		} else {
			w1.show();
		}
	}

	function hideWin(){
		if ( nwin == 1){
			w1.hide();
		}
	}	

function getFileNameUploaded(obj){
	  	//verifica se caricati pi� file contemporaneamente
		setValore("lista_docs","");
		if (obj.constructor.toString().indexOf("Array") == -1){
			//caricato 1 file
			alert(obj.FILENAME);
      		setValore("lista_docs",obj.FILENAME);
  	  	} else
			{
			//caricati + file;
          	for (i = 0 ; i < obj.length ; i++ ){
		  		setValore("lista_docs", getValore("lista_docs") + obj[i].FILENAME + ",");
			}
		}	
		alert(getValore("lista_docs"));
		//setValore("id_cliente",getValore("id_cliente"));
		//setValore("id_status",getValore("id_status"));
		w1.hide();		
		//effettua l'aggiornamento dello status con i documenti caricati e sposta i documenti nella cartella del cliente
		var valore = prompt("Inserisci il valore commerciale dell'offerta");
		setValore("ac_valore",valore);
		var processo = comboGet("id_processo");
		if ( processo[0] == 9 ){
			setValore("add_status",0);
		} else {
			setValore("add_status",1);
		}
ColdFusion.Ajax.submitForm("processoFrm","_offerteDocsMove.cfm",callbackDocsMove,errorHandler);
	}
	
//call back per lo spostamento dei file caricati
function callbackDocsMove(text){
	alert(text);
	alert("I documenti sono stati caricati");
}

function vediNote(){
	var id_cliente = getValore("id_cliente");
	GB_showCenter("Note Cliente", "../../offerte/_offerteNoteCliente.cfm?id_cliente=" + id_cliente, 350, 350)
	//alert(id_cliente);
}

function printModulo(){
	window.open("_offertePrintModulo.cfm?uuid=" + getValore("ac_modulo_uuid"));
}
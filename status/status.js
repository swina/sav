//----------------------------------------------------------------
//  IMPOSTAZIONI GENERALI 
//----------------------------------------------------------------

var idcliente,cliente,status_id_processo,status_data,status_processo,status_ora,status_note,status_indirizzo,status_citta,status_telefono,status_cellulare,status_email,processi,agenti;
	var lastRowSelected = -1;
	var lastRowSelected2 = -1;
	var nwin = 1; //dhtlmxwindows init number
	var cliente = document.getElementById("gridboxCLIENTE");
	var processo=document.getElementById("addProcesso");

	
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
	    cal1 = new dhtmlxCalendarObject('calInput1');
		cal1.attachEvent("onClick", function(date) {
        	calDeptDate(date,"calInput1");
	    });
		cal2 = new dhtmlxCalendarObject('dateFrom');
		cal2.attachEvent("onClick", function(date) {
        	calDeptDate(date,"dateFrom");
	    });	
		cal3 = new dhtmlxCalendarObject('dateTo');
		cal3.attachEvent("onClick", function(date) {
        	calDeptDate(date,"dateTo");
	    });
	}

	function calDeptDate(d,obj) {
		var  myDate = d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear();
	    setValore(obj,myDate);
	}
//FINE CALENDARIO ----------------------------------------------------------

//----------------------------------------------------------------
//  GESTIONE DELLA PAGINAZIONE
//----------------------------------------------------------------
function statusNextPage(){
	setValore("start",eval(getValore("start")) + 30);
	if ( eval(getValore("start")) > 0 ){
		document.getElementById("prevPage").style.display = "";
	} else {
		document.getElementById("prevPage").style.display = "none";
	}
	
	filterProcess(-1);
}

function statusPrevPage(){
	setValore("start",eval(getValore("start")) - 30);
	if ( eval(getValore("start")) > 0 ){
		document.getElementById("prevPage").style.display = "";
	} else {
		document.getElementById("prevPage").style.display = "none";
	}
	filterProcess(-1);
}

//----------------------------------------------------------------
//  GESTIONE DELLA GRID PRINCIPALE
//----------------------------------------------------------------

	//viene richiamata ogni volta vengono caricati i dati nella grid	
	function doOnRebuild(){
		if ( lastRowSelected != -1 ){
			mygrid.selectRowById(lastRowSelected);
		} else {
			lastRowSelected = -1;
		}
		lastRowSelected2 = -1;
		var recFrom = eval(getValore("start")) + 1;
		var recTo = eval(recFrom) + eval(mygrid.getRowsNum());
		setHTML("statusINFO","Records : " + recFrom + "-" + recTo);
	}
	
	//viene richiamato quando viene selezionata una riga
	function doOnRowSelect(rId,cId){
		status_modulo_uuid = mygrid.getUserData(rId,"modulo_uuid");
		
		if ( status_modulo_uuid != "" && cId == 6){
			checkModulo();
		}
	}
	
	//recupera tutta la cronologia degli eventi dello status di un cliente specifico
	function statusCliente(rId , cId){
		//prelevo i dati dalla grid per popolare il modulo di modifica
		var selectedId = rId;//mygrid.getSelectedRowId();
		idcliente = mygrid.getUserData(selectedId,"id_cliente");
		cliente = mygrid.getUserData(selectedId,"cliente");
		status_id_processo = mygrid.getUserData(selectedId,"id_processo");
		status_data = mygrid.getUserData(selectedId,"status_data");
		status_id = mygrid.getUserData(selectedId,"id_status");
		status_processo = mygrid.getUserData(selectedId,"status_processo");
		status_ora = mygrid.getUserData(selectedId,"status_ora");
		status_note = mygrid.getUserData(selectedId,"status_note");
		status_indirizzo = mygrid.getUserData(selectedId,"status_indirizzo");
		status_citta = mygrid.getUserData(selectedId,"status_citta");
		status_telefono = mygrid.getUserData(selectedId,"status_telefono");
		status_cellulare = mygrid.getUserData(selectedId,"status_cellulare");
		status_email = mygrid.getUserData(selectedId,"status_email");
		status_docs = mygrid.getUserData(selectedId,"ac_docs");
		status_modulo = mygrid.getUserData(selectedId,"ac_modulo");
		status_modulo_uuid = mygrid.getUserData(selectedId,"modulo_uuid");
		status_assegnazione = mygrid.getUserData(selectedId,"bl_assegnazione");
		status_assegnazione_persona = mygrid.getUserData(selectedId,"id_persona");
		//aggiorno scheda dettaglio azione
		setValore("id_status",status_id);
		setValore("id_cliente",idcliente);
		setValore("calInput1",status_data);
		setValore("ac_note",status_note);
		comboSelect("id_processo",status_id_processo);
		comboSelect("ac_ora",status_ora);
		setValore("submitButton","Salva");
		setValore("action","save");
		setValore("modulo_uuid",status_modulo_uuid);
		setValore("lista_docs",status_docs);
		
		hideObj("valore_field");
		
		$.ajax({
              url: "status.note.cfm",
			  type: 'GET',
              data: "id=" + status_id,
		      dataType: 'html',
        	  cache: false,
              success: function (txt){ 
			  	setValore("ac_note",txt);
			  }
		});
		
		//verifico se esistono documenti per il processo selezionato
		//inserita nuova gestione documenti
		/*if ( status_docs != "" ){
			//var myListaDocs = status_docs.substring(0,status_docs.length-1);
			var myListaDocs = status_docs;
			var docToDownload = listToArray(myListaDocs,",");
			setHTML("docs", downloadList(docToDownload,getValore("id_cliente")));
		} else {
			setHTML("docs"," ");
		}
		*/
		//� stato compilato un modulo per l'azione selezionata
		if ( status_modulo_uuid != "" && status_modulo != "No" ){
			if ( cId == 6 ){
				isModulo(status_modulo_uuid);
			}
		} else {
			if ( status_modulo_uuid == "" && status_modulo != "No" ){
				checkModulo();
			} else {
				setHTML("moduloIcon","");
			}
		}
		
		if ( status_assegnazione != 0 ){
			var title_assegnata = "Assegna";
			setHTML("assegnazioneIcon","&nbsp;<img src='../include/css/icons/hire-me.png' align='absmiddle' onclick='assegnaAzione(" + status_id + ","  + status_assegnazione + "," + status_assegnazione_persona + ")' title='" + title_assegnata + "' style='cursor:pointer'>");
		} else {
			setHTML("assegnazioneIcon","");
		}
		
		//aggiorno lista azioni del cliente selezionato		
		mygrid2.clearAndLoad("_statusClienteXML.cfm?cliente=" + idcliente);
		document.getElementById("subHeader").innerHTML = "Cliente : <strong>" + cliente +"</strong>";
		
		//alert(idcliente);

		//visualizzo finestra dettaglio azione
		document.getElementById("subView").style.display = "";
		document.getElementById("gridboxCLIENTE").style.display = "";
		
		infoCliente();
		
		mygrid.setRowTextBold(selectedId);
		mygrid.setRowTextNormal(lastRowSelected);
		
		lastRowSelected = selectedId;
		lastRowSelected2 = -1;
		mygrid2.selectRowById(0);
		obj("id_processo").disabled = true;
		
		if ( cId == 0 ){
			switchQualifica(rId,cId);
		}
		
		//inserisco tasto di stampa dettaglio cliente
		setHTML("printDetail","&nbsp;<img src='../include/css/icons/print.png' align='absmiddle' onclick='printStatus(" + idcliente + ")' style='cursor:pointer'>");
	}
	
	//visualizza i dati anagrafici
	function infoCliente(){
		document.getElementById("infoCliente").innerHTML = status_indirizzo + " - " + status_citta + "<br>" + status_telefono + " / " + status_cellulare + "<br>" + status_email;
		
	}
	
	//filtra lo status sul processo selezionato
	function filterProcess(mode){
		var id_processo = document.getElementById("id_processo_filter");
		var indice = id_processo.selectedIndex;
		var valore = id_processo.options[indice].value;
		var processo = comboGet("id_processo_filter");
		var nome = getValore("searchValue");
		var agente = comboGet("id_agente_filter");
		var gruppo = comboGet("id_gruppo_filtro");
		var dFrom = getValore("dateFrom");
		var dTo = getValore("dateTo");
		if ( mode == 0 ){
			setValore("start",0);
		}
		var startRecord = getValore("start");
		//filtra solo i contatti agente se selezionato
		//solo i miei agenti
		var soloagente = 0;
		if ( obj("bl_soloagente").checked ){
			soloagente = 1;
		} else {
			soloagente = 0;
		}
		if ( nome == "cerca cliente ..." ){
			nome = "";
		}
		if ( processo[0] != "" || nome != "" || agente[0] != "" || gruppo[0] != "" || dFrom != "" || dTo != "" || soloagente == 0 || startRecord != 0){
			mygrid.clearAndLoad("_statusXML.cfm?processo=" + processo[0] + "&clientesearch=" + nome + "&agente=" + agente[0] + "&gruppo=" + gruppo[0] +  "&from=" + dFrom + "&todate=" + dTo + "&soloagente=" + soloagente + "&start=" + startRecord);
		} else {
			mygrid.clearAndLoad("_statusXML.cfm");
		}
	}
	
	//reinizializza lo status
	function resetFilter(){
		mygrid.clearAndLoad("_statusXML.cfm");
	}
	
	
	
	
	//aggiunge processo
	function addProcess(){
		//processo.style.display = "";
		//setValore("calInput1","");
		mygrid2.setRowTextNormal(lastRowSelected2);
		setValore("id_status","0");
		setValore("ac_note","");
		setValore("submitButton","Aggiungi");
		setValore("action","add");
		setValore("modulo_uuid","");
		comboSelect("id_processo","");
		comboSelect("ac_ora","09:00");
		obj("id_processo").disabled = false;
		var d = new Date();
		var  myDate = d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear();
		setValore("calInput1", myDate);
		
		//setValore("ac_modulo","");
	}
	
	//visualizza elenco agenti
	function selectAgente(){
		document.getElementById("subView").style.display = "";
		document.getElementById("subHeader").innerHTML = "<strong>Assegna Agente</strong>";
	}
	
	//Ricerca cliente nello status
	function doSearch(){
		var mysearch = getValore("searchValue");
		mygrid.clearAndLoad("_statusXML.cfm?clientesearch=" + mysearch);
	}
	
	//assegna un'azione ad un utente specifico (il flag bl_assegnazione definisce a quale gruppo di 
	//utenti pu� essere assegnata un'azione specifica. In questo caso l'azione sar� visibile solo 
	//all'utente assegnato
	function assegnaAzione(stato,gruppo,persona){
		GB_showCenter("Assegna", "../../status/_statusAssegnaProcesso.cfm?id_status=" + stato + "&id_gruppo=" + gruppo + "&id_persona=" + persona, 80, 300, callBackAssegnazione);		
	}
	
	function callBackAssegnazione(){
		mygrid2.clearAndLoad("_statusClienteXML.cfm?cliente=" + idcliente);
		//setHTML("assegnazioneIcon","")
		mygrid2.selectRowById(lastRowSelected2);
	}
	
	//recupera dati dell'evento selezionato 
	function getDataStatus(){
		//processo.style.display = "";
		var livello = getValore("livello");
		var selectedId = mygrid2.getSelectedRowId();
		var id_status = mygrid2.getUserData(selectedId,"id_status");
		var giorno = mygrid2.getUserData(selectedId,"ac_data");
		var ora = mygrid2.getUserData(selectedId,"ac_ora");
		//var status_note = mygrid2.getUserData(selectedId,"ac_note");
		var status_id_processo = mygrid2.getUserData(selectedId,"id_processo");
		var status_processo_tipo = mygrid2.getUserData(selectedId,"int_tipo");
		var status_processo_valore = mygrid2.getUserData(selectedId,"ac_valore");
		var status_ac_processo = mygrid2.getUserData(selectedId,"ac_processo");
		var status_docs =  mygrid2.getUserData(selectedId,"ac_docs");
		status_modulo =  mygrid2.getUserData(selectedId,"ac_modulo");
		var status_modulo_uuid =  mygrid2.getUserData(selectedId,"modulo_uuid");
		var status_assegnazione_cliente = mygrid2.getUserData(selectedId,"bl_assegnazione");
		var status_assegnazione_persona = mygrid2.getUserData(selectedId,"id_assegnazione");
		var status_assegnata = mygrid2.getUserData(selectedId,"assegnata");
		if ( status_note == "" ){
			status_note =  mygrid.getUserData(lastRowSelected,"ac_comunicazioni");
			if ( status_note == "NULL") {
				status_note = "";
			}
		}
		
		$.ajax({
              url: "status.note.cfm",
			  type: 'GET',
              data: "id=" + id_status,
		      dataType: 'html',
        	  cache: false,
              success: function (txt){ 
			  	status_note = txt;
			  	setValore("ac_note",txt);
			  }
		});
		
		setValore("id_status",id_status);
		setValore("ac_note",status_note);
		comboSelect("id_processo",status_id_processo);
		comboSelect("ac_ora",ora);
		setValore("calInput1",giorno);
		setValore("submitButton","Salva");
		setValore("action","save");
		setValore("ac_modulo",status_modulo);
		setValore("modulo_uuid",status_modulo_uuid);
		setValore("ac_valore",status_processo_valore);
		setValore("lista_docs",status_docs);
		//verifico se esistono documenti per il processo selezionato
		//funzione disattivata
		/*
		if ( status_docs != "" ){
			//var myListaDocs = status_docs.substring(0,status_docs.length-1);
			var myListaDocs = status_docs;
			var docToDownload = listToArray(myListaDocs,",");
			setHTML("docs",downloadList(docToDownload,getValore("id_cliente")));
		} else {
			setHTML("docs"," ");
		}
		*/
		
		//verifico se l'azione � collegata ad un modulo 	
		if ( status_modulo_uuid != "" && status_modulo != "No" ){
			//esiste gi� un modulo compilato
			setHTML("moduloIcon","<img src='../include/css/icons/knobs/action_paste.gif' onclick='isModulo(\"" + status_modulo_uuid + "\")' align='absmiddle' title='Apri modulo' style='cursor:pointer'>");
			//checkModulo();
		} else {
			if ( status_modulo_uuid == "" && status_modulo != "No" ){
				//richiede la compilazione del modulo collegato
				checkModulo();
			} else {
				setHTML("moduloIcon","");
			}
		}
		
		if ( status_assegnazione_cliente != 0 ){
			var title_assegnata = "Assegna";
			if ( status_assegnata != "" ){
				var title_assegnata = "Assegnata a " + status_assegnata;
			}
			setHTML("assegnazioneIcon","&nbsp;<img src='../include/css/icons/hire-me.png' align='absmiddle' onclick='assegnaAzione(" + id_status + ","  + status_assegnazione_cliente + "," + status_assegnazione_persona + ")' title='" + title_assegnata + "' style='cursor:pointer'>");
		} else {
			setHTML("assegnazioneIcon","");
		}

		
		if ( status_processo_tipo == 1 ){
			showObj("valore_field");
		} else {
			hideObj("valore_field");
		}
		
		if ( livello > 2 ) {
			if ( status_id_processo == 6 || status_id_processo == 9 ){
				obj("calInput1").disabled = true;
			} else {
				obj("calInput1").disabled = false;
			}
		}
		
		//obj("id_processo").enabled = false;
		showObj("submitButton");
		showObj("deleteButton");

		//if ( lastRowSelected2 != -1 ){
		//	mygrid2.cellById(lastRowSelected2,0).setValue("");
		//} 
		mygrid2.setRowTextBold(selectedId);
		mygrid2.setRowTextNormal(lastRowSelected2);
		lastRowSelected2 = selectedId;
		//mygrid2.cellById(selectedId,0).setValue("<img src='../include/css/icons/knobs/Knob_Upload.png'>");		
	}
	
	//verifica se il processo selezionato richiede l'inserimento di un valore commerciale
	//campo int_tipo della tabella processi = 1
	function checkValore(){
		if ( aValore[comboGetIndex("id_processo")] == 1){
			showObj("valore_field");
		} else {
			hideObj("valore_field");
		}
	}

	//verifica se il processo selezionato richiede l'inserimento di un documento
	function checkDocumento(){
		if ( aDocumenti[comboGetIndex("id_processo")] == 1){
			if (  mygrid2.getUserData(lastRowSelected2,"ac_docs") == "" ){
				setValore("documento_flag",0);
				alert("L'azione richiede un documento che deve essere caricato");
				uploadDocs();
			} else {
				setValore("documento_flag",1);
			}
		}	
	}	
	
	//se il valore nella colonna int_tipo della tabella processi � = 2 
	//blocca il campo data. L'utente non pu� immettere una data diversa
	//da quella odierna
	function checkFixedDate(){
		if ( aProcesso_Tipo[comboGetIndex("id_processo")] == "2" ){
			obj("calInput1").disabled = false;
		} else {
			obj("calInput1").disabled = false;
		}
	}
	
	
	//verifica se la colonna int_gerarchia di tbl_processi ha un valore != 0
	//nel caso deve verificare che esista un processo con l'id della colonna
	//questa funzione blocca l'inserimento di un processo vincolato all'esistenza
	//di un altro processo. Se il processo selezionato ha un int_timer_limit verifica
	//che la data sia inferiore di int_timer_limit/24 (giorni) al processo da cui � vincolato
	//dopo tale verifica viene eseguito il controllo se il processo selezionato richiede
	//la compilazione di un modulo
	function checkDipendenza(){
		var dipende_da = aProcesso_Gerarchia[comboGetIndex("id_processo")];
		var controllo = false;
		var controlloThis = true;
		var checkDate;
		if ( eval(dipende_da) != 0 ){
			var righe = mygrid2.getRowsNum();
			//if ( eval(dipende_da) != eval(status_id_processo) ){
				for ( var i = 0 ; i < righe ; i++){
					var id_proc = mygrid2.cells(i,3).getValue();
					if ( eval(id_proc) == eval(dipende_da) ){
						//alert ( mygrid2.cells(i,0).getValue() );
						//var checkDate = mygrid2.getUserData(i,"ac_data");
						var checkDate = mygrid2.cells(i,0).getValue();
						//alert(checkDate);
						var controlloThis = checkDays(checkDate,dipende_da);
						if ( !controlloThis ) {
							controllo = false;
							break;
						} else {
							controllo = true;
							break;
						}
						//alert(controllo);
					}
					
				}
			//} else {
			//	var myData = mygrid.getUserData(lastRowSelected,"status_data");
			//	controllo = checkDays(myData,dipende_da);
			//}
		} else {
			controllo = true;
		}
		if ( controllo ){
			showObj("submitButton");
			showObj("deleteButton");
			checkModulo();
		} 
		else {
			if ( controlloThis ){
				hideObj("submitButton");
				hideObj("deleteButton");
				var azione_richiesta = comboGetText("id_processo",dipende_da);
				alert("Non e' possibile inserire questa nuova azione.\nE' necessario prima inserire " + azione_richiesta); 
				obj("id_processo").enabled = false;
			}
		}
		
	}
	
	//verifica che la data del processo da cui dipende quello attuale sia => della data odierna
	//diversamente restituisce un valore false e impedisce l'inserimento del processo selezionato
	function checkDays (data,dipendenza){
		var aDate = listToArray(data,"/");
		var today = new Date();
		var dateToCheck = new Date ( aDate[2] , aDate[1]-1 , aDate[0] );
		var difference = dateToCheck - today;
		difference = Math.round(difference/(1000*60*60*24));
		var azione_richiesta = comboGetText("id_processo",dipendenza);
		var giorni_minimi = aProcesso_Timer[comboGetIndex("id_processo")];
		giorni_minimi = Math.round(giorni_minimi/24);
		if ( giorni_minimi < 1 ){
			return true;
		} else {
			if ( difference < giorni_minimi ){
				hideObj("submitButton");
				hideObj("deleteButton");
				if ( giorni_minimi < 1 ){
					alert("Non e' possibile inserire questa nuova azione.\nE' necessario prima inserire " + azione_richiesta); 
					obj("id_processo").enabled = false;
				} else {
					if ( difference < giorni_minimi ){
						alert("Non e' possibile inserire questa nuova azione.\nE' necessario prima inserire " + azione_richiesta + "\ncon una data superiore di " + giorni_minimi + " giorni a quella corrente\nLa data inserita per " + azione_richiesta + " al momento e' " + data);
					}
				}
				return false;
			} else {
				return true;
			}
		}
	}
	
	function addNewProcess(){
		hideObj("submitButton");
		hideObj("deleteButton");
		//alert(getValore("modulo_uuid"));
		var noError = checkFormProcesso();
		if ( noError ){
			if ( getValore("modulo_flag") == "1" && getValore("documento_flag") == "1" ){
				if ( getValore("action") == "add" ){
ColdFusion.Ajax.submitForm("processoFrm","_statusAddProcesso.cfm",callback,errorHandler);
				} else {
ColdFusion.Ajax.submitForm("processoFrm","_statusSaveProcesso.cfm",callback,errorHandler);
				}
			} else {
				if ( getValore("modulo_flag") == "0" ){
					alert ( "Attenzione !!!\nL'azione richiede la compilazione di un modulo !\nE' necessario compilare il relativo modulo per procedere"); 
					checkModulo();
				}
				if ( getValore("documento_flag") == "0" ){
					alert ( "Attenzione !!!\nL'azione richiede un documento !\nE' necessario caricare  il relativo documento per procedere"); 
				}
				
			}
		}		
		showObj("submitButton");
		showObj("deleteButton");	
	}	
	
	function deleteProcess(){
		if (getValore("id_status") != 0){
			hideObj("submitButton");
			hideObj("deleteButton");
			setValore("action","delete");
			if ( getValore("debug") == "true" ){
				alert(getValore("id_status"));
			}
ColdFusion.Ajax.submitForm("processoFrm","_statusDeleteProcesso.cfm",callback,errorHandler);
		}
	}
	
	function callback(text){
		//alert(text);
		if ( getValore("debug") == "true" ){
			alert(text);
		}
		showObj("submitButton");
		showObj("deleteButton");
		//mygrid.clearAndLoad("_statusXML.cfm");
		filterProcess(0);
		mygrid2.clearAndLoad("_statusClienteXML.cfm?cliente=" + getValore("id_cliente"));
		//obj("id_processo").disabled = true;
		resetForm("processoFrm");
	}

	function resetForm(myform){
		if ( myform == "processoFrm") {
			setValore("id_status","0");
			setValore("calInput1","");
			setValore("action","add");
			setValore("ac_note","");
			setValore("lista_docs","");
			setValore("ac_modulo","");
			setValore("lista_docs","");
			setValore("modulo_flag","1");
			comboReset("id_processo");
			comboReset("ac_ora");
			setValore("ac_valore","0");
			setHTML("docs","");
			hideObj("valore_field");
		}
	}
	
	
	function checkFormProcesso(){
		re = /^\d{1,2}\/\d{1,2}\/\d{4}$/;
		var err = false;
		var errMsg = "Attenzione!!!";
		if ( getValore("calInput1") == "" || getValore("calInput1").match(re) == null ){
			errMsg = errMsg + "\nLa data non e' valida";
			alert ( errMsg );
			return false;
		} else {
			return true;
		}
	}
	
	function errorHandler(code,msg){
		alert("Error !" + code + ":" + msg);
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
	//ottieni il nome dei file caricati per lo spostamento nella cartella del cliente
	//docs\status\id_cliente
	function getFileNameUploaded(obj){
	  	//verifica se caricati pi� file contemporaneamente
		if (obj.constructor.toString().indexOf("Array") == -1)
			//caricato 1 file
      		setValore("lista_docs",obj.FILENAME);
  	  	else
			//caricati + file;
          	for (i = 0 ; i < obj.length ; i++ ){
				if ( getValore("lista_docs") == "" ){
			  		setValore("lista_docs", getValore("lista_docs") + obj[i].FILENAME + ",");
				} else {
					setValore("lista_docs", getValore("lista_docs") + obj[i].FILENAME + ",");
				}
		}
		if ( getValore("remote_addr") == "89.118.53.254" ){
			alert("DEBUG MODE");
			alert(getValore("lista_docs"));
			alert(getValore("id_cliente"));
			alert(getValore("id_status"));
		}

		setValore("id_cliente",getValore("id_cliente"));
		setValore("id_status",getValore("id_status"));
		
		w1.hide();		
		//effettua l'aggiornamento dello status con i documenti caricati e sposta i documenti nella cartella del cliente
ColdFusion.Ajax.submitForm("processoFrm","_statusDocsMove.cfm",callbackDocsMove,errorHandler);
	}
	
	//call back per lo spostamento dei file caricati
	function callbackDocsMove(text){
		alert("I documenti sono stati caricati");
		
		if ( getValore("documento_flag") == "1" ){
			setValore("lista_docs","");
			mygrid2.clearAndLoad("_statusClienteXML.cfm?cliente=" + getValore("id_cliente"));
			var status_docs =  mygrid2.getUserData(lastRowSelected2,"ac_docs");
			if ( status_docs != "" ){
				//var myListaDocs = status_docs.substring(0,status_docs.length-1);
				var myListaDocs = status_docs;
				var docToDownload = listToArray(myListaDocs,",");
				setHTML("docs", downloadList(docToDownload,getValore("id_cliente")));
			}
		} else {
			//var status_docs =  mygrid2.getUserData(lastRowSelected2,"ac_docs");
			var mydocs = getValore("lista_docs");
			if ( mydocs != "" ){
				//var myListaDocs = mydocs.substring(0,mydocs.length-1);
				var myListaDocs = mydocs;
				var docToDownload = listToArray(myListaDocs,",");
				setHTML("docs", downloadList(docToDownload,getValore("id_cliente")));
				setValore("documento_flag","1");
			}
			
		}
	}
	
	//crea la lista dei documenti con link per essere scaricati
	function downloadList(a,id){
		var retValue = "";
		var myurl = getValore("docs_url");
		for ( i = 0 ; i < a.length ; i ++){
			if ( a[i].length > 3 ){
			retValue = retValue + "<span id='" + a[i] + "'><img src='../include/css/icons/page_cross.gif' align='absmiddle' title='Cancella documento' style='cursor:pointer' onclick='deleteDoc(\"" + a[i] + "\"," + getValore("id_cliente") +")'>[<a href='" + myurl + "/" + id + "/" + a[i] + "' target='_blank'>" + a[i] + "</a>]&nbsp;</span>";
			}
		}
		return retValue;
	}
	
	//verifica che il processo selezionato abbia un modulo associato
	function checkModulo(){
		var indice = comboGetIndex("id_processo");
		var myModuli = aModuli;
		if ( myModuli[indice] != "No" ){
			setValore("ac_modulo",myModuli[indice]);
			setValore("modulo_flag",0);
			if ( getValore("modulo_uuid") == "" ){
				GB_showCenter(myModuli[indice], "http://87.248.52.100/sav/status/_statusModulo.cfm?text=" + myModuli[indice] + "&id_cliente=" + idcliente, 350, 400, callBackModulo);
				//setValore("modulo_flag","1");
			} else {
				setValore("modulo_flag","1");
				GB_showCenter(myModuli[indice], "http://87.248.52.100/sav/status/_statusModulo.cfm?text=" + myModuli[indice] + "&uuid=" + getValore("modulo_uuid"), 350, 400, callBackModulo);
				
			}
			setValore("modulo_flag","1");
			setHTML("moduloIcon","<img src='../include/css/icons/knobs/action_paste.gif' onclick='checkModulo()' align='absmiddle' title='Apri modulo'>");

		} else {
			setValore("ac_modulo","");
			setValore("modulo_flag",1);
			setHTML("moduloIcon","");
		}
	}

	//funzione per visualizzare il modulo gi� compilato
	function isModulo(codice_modulo){
		//alert(status_modulo);
		var indice = comboGetIndex("id_processo");
		var myModuli = getValore("lista_moduli");
		myModuli = listToArray(myModuli,",");
		if ( codice_modulo != "" ){
			GB_showCenter(status_modulo, "../../status/_statusModulo.cfm?text=" + getValore("ac_modulo") + "&uuid=" + codice_modulo, 350, 400, callBackModulo);
		}
	}
	
	function callBackModulo(){
		if ( getValore("modulo_flag") == 0 ){
			alert("Attenzione il modulo non e' stato compilato correttamente.\nCompilare il modulo prima di inserire l'azione");
		} else {
			return true;
		}
	}
	
	function deleteDoc(doc,idc){
		var myStatus = getValore("id_status");
		var myDocsList = getValore("lista_docs");
		var conferma = confirm("Confermi la cancellazione del documento " + doc + "?");
		if ( conferma ) {
			hideObj(doc);
			GB_showCenter("Cancella documento", "../../status/_deleteDoc.cfm?file=" + doc + "&id_cliente=" + idc + "&id_status=" + myStatus + "&docs=" + myDocsList, 250, 250, callBackDeleteDoc);
		}
	}
	
	function callBackDeleteDoc(){
		alert ("Il documento e' stato cancellato");
		filterProcess(0);
		//mygrid.clearAndLoad("_statusXML.cfm");
		mygrid2.clearAndLoad("_statusClienteXML.cfm?cliente=" + getValore("id_cliente"));
		//resetForm("processoFrm");
		//parent.parent.GB_hide();
	}
	

	function switchQualifica(rId,cId){
		//currentRow = rId;
		var indice = comboGetIndex("qualifica");
		var cLen = comboLen("qualifica")-1;
		if ( indice == cLen ){
			indice = 0;
		} else {
			indice = indice + 1;
		}
		comboSetIndex("qualifica",indice);
		var id_qualifica = comboGetAt("filtro_gruppo",indice+1);
		setValore("id_qualifica",id_qualifica);
		var icon = comboGet("qualifica");
		var setIcon = "../include/css/icons/" + icon[0] + "^" + icon[1];
		mygrid.cellById(rId,cId).setValue(setIcon);
		setValore("id_cliente_qualifica",gridUserData(mygrid,rId,"id_cliente"));
ColdFusion.Ajax.submitForm("qualificaCliente","_statusSaveQualifica.cfm",callbackSaveQualifica,errorHandler);
	}
	
	function callbackSaveQualifica(result){
		return true;
	}

	
	function printStatus(idc){
	//filtra lo status sul processo selezionato
		var id_processo = document.getElementById("id_processo_filter");
		var indice = id_processo.selectedIndex;
		var valore = id_processo.options[indice].value;
		var processo = comboGet("id_processo_filter");
		var nome = getValore("searchValue");
		var agente = comboGet("id_agente_filter");
		var gruppo = comboGet("id_gruppo_filtro");
		var dFrom = getValore("dateFrom");
		var dTo = getValore("dateTo");
		var startRecord = getValore("start");
		//filtra solo i contatti agente se selezionato
		//solo i miei agenti
		var soloagente = 0;
		if ( obj("bl_soloagente").checked ){
			soloagente = 1;
		} else {
			soloagente = 0;
		}
		if ( nome == "cerca cliente ..." ){
			nome = "";
		}
		if ( idc == 0 ){
			if ( processo[0] != "" || nome != "" || agente[0] != "" || gruppo[0] != "" || dFrom != "" || dTo != "" || soloagente == 0 || startRecord != 0){
				window.open("_statusPrint.cfm?processo=" + processo[0] + "&clientesearch=" + nome + "&agente=" + agente[0] + "&gruppo=" + gruppo[0] +  "&from=" + dFrom + "&todate=" + dTo + "&soloagente=" + soloagente + "&start=" + startRecord);
			} else {
				window.open("_statusPrint.cfm");
			}
		} else {
			window.open("_statusPrintDetail.cfm?idcliente=" + idc);
		}
	}
	
	function statusExcel(){
		var id_processo = document.getElementById("id_processo_filter");
		var indice = id_processo.selectedIndex;
		var valore = id_processo.options[indice].value;
		var processo = comboGet("id_processo_filter");
		var nome = getValore("searchValue");
		var agente = comboGet("id_agente_filter");
		var gruppo = comboGet("id_gruppo_filtro");
		var dFrom = getValore("dateFrom");
		var dTo = getValore("dateTo");
		var startRecord = getValore("start");
		//filtra solo i contatti agente se selezionato
		//solo i miei agenti
		var soloagente = 0;
		if ( obj("bl_soloagente").checked ){
			soloagente = 1;
		} else {
			soloagente = 0;
		}
		if ( nome == "cerca cliente ..." ){
			nome = "";
		}
		if ( processo[0] != "" || nome != "" || agente[0] != "" || gruppo[0] != "" || dFrom != "" || dTo != "" || soloagente == 0 || startRecord != 0){
			document.getElementById("excelFrame").src = "_statusExcel.cfm?processo=" + processo[0] + "&clientesearch=" + nome + "&agente=" + agente[0] + "&gruppo=" + gruppo[0] +  "&from=" + dFrom + "&todate=" + dTo + "&soloagente=" + soloagente + "&start=" + startRecord;

			//window.open("_statusExcel.cfm?processo=" + processo[0] + "&clientesearch=" + nome + "&agente=" + agente[0] + "&gruppo=" + gruppo[0] +  "&from=" + dFrom + "&todate=" + dTo + "&soloagente=" + soloagente + "&start=" + startRecord);
		} else {
			window.open("_statusExcel.cfm");
		}
	}
	
	
	function docManager(){
		var idc = getValore("id_cliente");
		GB_showCenter("Documenti", "../../status/_statusDocManager.cfm?folder=" + idc, 250, 350);

	}
	
	function callbackdocManager(){
		//
	}
	
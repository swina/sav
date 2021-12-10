//----------------------------------------------------------------
//  IMPOSTAZIONI GENERALI 
//----------------------------------------------------------------

var cliente,status_id_processo,status_data,status_processo,status_ora,status_note,status_indirizzo,status_citta,status_telefono,status_cellulare,status_email,processi,agenti;
	var lastRowSelected = -1;
	var lastRowSelected2 = -1;
	var nwin = 1; //dhtlmxwindows init number
	var cliente = document.getElementById("gridboxCLIENTE");
	var processo=document.getElementById("addProcesso");
	var sorting = "DESC";
	
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
        calDeptDate(date);
    });
	}

	function calDeptDate(d) {
		var  myDate = d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear();
	    document.getElementById("calInput1").value = myDate;
	}
//FINE CALENDARIO ----------------------------------------------------------


//----------------------------------------------------------------
//  GESTIONE DELLA GRID PRINCIPALE
//----------------------------------------------------------------

	//viene richiamata ogni volta vengono caricati i dati nella grid	
	function doOnRebuild(){
		mygrid.selectRow(0);
		//if ( lastRowSelected != -1 ){
		//	mygrid.selectRowById(lastRowSelected);
		//	mygrid.cellById(lastRowSelected,5).setValue('<img src="../include/css/icons/future-projects.png">');
		//} else {
		//	mygrid.selectRow(0);
			//lastRowSelected = -1;
		//}
		//if ( lastRowSelected2 != -1){
		//	mygrid2.selectRow(lastRowSelected2,true,true,true);
		//	mygrid2.cellById(lastRowSelected2,0).setValue('<img src="../include/css/icons/knobs/Knob_Upload.png">');
		//} else {
		//	lastRowSelected2 = -1;
		//}
	}
	
	//viene richiamato quando viene selezionata una riga
	function doOnRowSelect(rId,cId){
		status_modulo_uuid = mygrid.getUserData(rId,"modulo_uuid");
		if ( status_modulo_uuid != "" && cId == 6){
			checkModulo();
		}
	}
	
	
	function sortByDate(){
		alert(sorting);
		//mygrid.clearAndLoad("_statusXML.cfm?sort=" + sorting);
		
	}
	
	//recupera tutta la cronologia degli eventi dello status di un cliente specifico
	function statusCliente(rId , cId){
		//prelevo i dati dalla grid per popolare il modulo di modifica
		var selectedId = mygrid.getSelectedRowId();
		var idcliente = mygrid.getUserData(selectedId,"id_cliente");
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
		status_modulo_uuid = mygrid.getUserData(selectedId,"modulo_uuid");
	
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
		
		//verifico se esistono documenti per il processo selezionato
		if ( status_docs != "" ){
			var myListaDocs = status_docs.substring(0,status_docs.length-1);
			var docToDownload = listToArray(myListaDocs,",");
			setHTML("docs", downloadList(docToDownload,getValore("id_cliente")));
		} else {
			setHTML("docs"," ");
		}
		
		//� stato compilato un modulo per l'azione selezionata
		if ( status_modulo_uuid != "" ){
			isModulo();
		} else {	
			setHTML("moduloIcon","");
		}
		
		//aggiorno lista azioni del cliente selezionato		
		mygrid2.clearAndLoad("_statusClienteXML.cfm?cliente=" + idcliente);
		document.getElementById("subHeader").innerHTML = "Cliente : <strong>" + cliente +"</strong><img src='../include/css/icons/plus.png' height='14' align='absmiddle' hspace='5' style='cursor:pointer' alt='Aggiungi azione' title='Aggiungi azione' onclick='addProcess()'>";
		

		//visualizzo finestra dettaglio azione
		document.getElementById("subView").style.display = "";
		document.getElementById("gridboxCLIENTE").style.display = "";
		//document.getElementById("gridboxAGENTI").style.display = "none";
		//processo.style.display = "";
		infoCliente();
		if ( lastRowSelected != -1 ){
			mygrid.cellById(lastRowSelected,5).setValue("");
		} 
		lastRowSelected = selectedId;
		lastRowSelected2 = -1;
		//mygrid.setRowColor(selectedId,"orange");
		mygrid.cellById(selectedId,5).setValue("<img src='../include/css/icons/future-projects.png'>");
		mygrid2.selectRowById(0);
		
		obj("id_processo").disabled = true;
		
	}
	
	function infoCliente(){
		document.getElementById("infoCliente").innerHTML = status_indirizzo + " - " + status_citta + "<br>" + status_telefono + " / " + status_cellulare + "<br>" + status_email;
		//toggleHide("infoCliente");
	}
	
	//filtra lo status sul processo selezionato
	function filterProcess(){
		var id_processo = document.getElementById("id_processo_filter");
		var indice = id_processo.selectedIndex;
		var valore = id_processo.options[indice].value;
		var processo = comboGet("id_processo_filter");
		var nome = getValore("searchValue");
		var agente = comboGet("id_agente_filter");
		if ( nome == "cerca cliente ..." ){
			nome = "";
		}
		if ( processo[0] != "" || nome != "" || agente[0] != ""){
			
			mygrid.clearAndLoad("_statusXML.cfm?processo=" + processo[0] + "&clientesearch=" + nome + "&agente=" + agente[0]);
		} else {
			mygrid.clearAndLoad("_statusXML.cfm");
		}
	}
	
	//aggiunge processo
	function addProcess(){
		//processo.style.display = "";
		setValore("calInput1","");
		setValore("ac_note","");
		setValore("submitButton","Aggiungi");
		setValore("action","add");
		setValore("modulo_uuid","");
		comboSelect("id_processo","");
		comboSelect("ac_ora","");
		obj("id_processo").disabled = false;
		//setValore("ac_modulo","");
	}
	
	
	//visualizza elenco agenti
	function selectAgente(){
		document.getElementById("subView").style.display = "";
		document.getElementById("subHeader").innerHTML = "<strong>Assegna Agente</strong>";
		//processo.style.display = "none";
		//cliente.style.display = "none";
		//agenti.style.display = "";
		//document.getElementById("gridboxCLIENTE").style.display = "none";
		//document.getElementById("gridboxAGENTI").style.display = "";
		//mygrid2.setHeader("ID","Agente");
	}
	
	//Ricerca cliente nello status
	function doSearch(){
		var mysearch = getValore("searchValue");
		mygrid.clearAndLoad("_statusXML.cfm?clientesearch=" + mysearch);
		//document.getElementById("subView").style.display = "none";
	}
	
	
	//recupera dati dell'evento selezionato 
	function getDataStatus(){
		//processo.style.display = "";
		var selectedId = mygrid2.getSelectedRowId();
		var id_status = mygrid2.getUserData(selectedId,"id_status");
		var giorno = mygrid2.getUserData(selectedId,"ac_data");
		var ora = mygrid2.getUserData(selectedId,"ac_ora");
		var status_note = mygrid2.getUserData(selectedId,"ac_note");
		var status_id_processo = mygrid2.getUserData(selectedId,"id_processo");
		var status_ac_processo = mygrid2.getUserData(selectedId,"ac_processo");
		var status_docs =  mygrid2.getUserData(selectedId,"ac_docs");
		var status_modulo =  mygrid2.getUserData(selectedId,"ac_modulo");
		var status_modulo_uuid =  mygrid2.getUserData(selectedId,"modulo_uuid");
		setValore("id_status",id_status);
		setValore("ac_note",status_note);
		comboSelect("id_processo",status_id_processo);
		comboSelect("ac_ora",ora);
		setValore("calInput1",giorno);
		setValore("submitButton","Salva");
		setValore("action","save");
		setValore("modulo_uuid",status_modulo_uuid);
		//verifico se esistono documenti per il processo selezionato
		
		if ( status_docs != "" ){
			var myListaDocs = status_docs.substring(0,status_docs.length-1);
			var docToDownload = listToArray(myListaDocs,",");
			setHTML("docs",downloadList(docToDownload,getValore("id_cliente")));
		} else {
			setHTML("docs"," ");
		}

		if ( status_modulo_uuid != "" ){
			isModulo();
		} else {
			setHTML("moduloIcon","");
		}
		
		if ( lastRowSelected2 != -1 ){
			mygrid2.cellById(lastRowSelected2,0).setValue("");
		} 

		lastRowSelected2 = selectedId;
		mygrid2.cellById(selectedId,0).setValue("<img src='../include/css/icons/knobs/Knob_Upload.png'>");		
	}
	
	function addNewProcess(){
		hideObj("submitButton");
		hideObj("deleteButton");
		var noError = checkFormProcesso();
		if ( noError ){
			if ( getValore("modulo_flag") == "1" ){
				if ( getValore("action") == "add" ){
ColdFusion.Ajax.submitForm("processoFrm","_statusAddProcesso.cfm",callback,errorHandler);
				} else {
ColdFusion.Ajax.submitForm("processoFrm","_statusSaveProcesso.cfm",callback,errorHandler);
				}
			} else {
				alert ( "Attenzione !!!\nL'azione richiede la compilazione di un modulo !\nE' necessario compilare il relativo modulo per procedere"); 
				
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
ColdFusion.Ajax.submitForm("processoFrm","_statusDeleteProcesso.cfm",callback,errorHandler);
		}
	}
	
	function callback(text){
		showObj("submitButton");
		showObj("deleteButton");
   		//document.getElementById("submitButton").style.display = "";
		mygrid.clearAndLoad("_statusXML.cfm");
		//var idc = document.getElementById("id_cliente").value;
		mygrid2.clearAndLoad("_statusClienteXML.cfm?cliente=" + getValore("id_cliente"));
		//resetForm("processoFrm");
		obj("id_processo").disabled = true;
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
		  		setValore("lista_docs", getValore("lista_docs") + obj[i].FILENAME + ",");
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
		setValore("lista_docs","");
		mygrid2.clearAndLoad("_statusClienteXML.cfm?cliente=" + getValore("id_cliente"));
		var status_docs =  mygrid2.getUserData(lastRowSelected2,"ac_docs");
		if ( status_docs != "" ){
			var myListaDocs = status_docs.substring(0,status_docs.length-1);
			var docToDownload = listToArray(myListaDocs,",");
			setHTML("docs", downloadList(docToDownload,getValore("id_cliente")));
		}
	}
	
	//crea la lista dei documenti con link per essere scaricati
	function downloadList(a,id){
		var retValue = "";
		var myurl = getValore("docs_url");
		for ( i = 0 ; i < a.length ; i ++){
			retValue = retValue + "<span id='" + a[i] + "'><img src='../include/css/icons/page_cross.gif' align='absmiddle' title='Cancella documento' style='cursor:pointer' onclick='deleteDoc(\"" + a[i] + "\"," + getValore("id_cliente") +")'>[<a href='" + myurl + "/" + id + "/" + a[i] + "' target='_blank'>" + a[i] + "</a>] <br></span>";
		}
		return retValue;
	}
	
	//verifica che il processo selezionato abbia un modulo associato
	function checkModulo(){
		var indice = comboGetIndex("id_processo");
		var myModuli = getValore("lista_moduli");
		myModuli = listToArray(myModuli,",");
		if ( myModuli[indice] != "No" ){
			setValore("ac_modulo",myModuli[indice]);
			setValore("modulo_flag",0);
			if ( getValore("modulo_uuid") == "" ){
				GB_showCenter(myModuli[indice], "../../status/_statusModulo.cfm?text=" + myModuli[indice], 450, 400, callBackModulo);
				setValore("modulo_flag","1");
			} else {
				GB_showCenter(myModuli[indice], "../../status/_statusModulo.cfm?text=" + myModuli[indice] + "&uuid=" + getValore("modulo_uuid"), 450, 400, callBackModulo);
				setValore("modulo_flag","1");
			}
			setHTML("moduloIcon","<img src='../include/css/icons/knobs/action_paste.gif' onclick='checkModulo()' align='absmiddle' title='Apri modulo'>");

		} else {
			setValore("ac_modulo","");
			setValore("modulo_flag",1);
			setHTML("moduloIcon","");
		}
	}

	//funzione per visualizzare il modulo gi� compilato
	function isModulo(){
		setHTML("moduloIcon","<img src='../include/css/icons/knobs/action_paste.gif' onclick='checkModulo()' align='absmiddle' title='Apri modulo'>");
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
		mygrid.clearAndLoad("_statusXML.cfm");
		mygrid2.clearAndLoad("_statusClienteXML.cfm?cliente=" + getValore("id_cliente"));
		//resetForm("processoFrm");
		//parent.parent.GB_hide();
	}
	

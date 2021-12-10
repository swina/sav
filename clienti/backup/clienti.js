//selezionando una riga della grid visualizza l'anagrafica
dhtmlx.skin="dhx_skyblue";
var nwin = 1;
var lastRow = false;
var initRow = false;
var currentRow = 0;

function initWin(){
	//inizializzo window	
		if ( nwin == 1 ){
			w1 = dhxWins.createWindow("w1", 150, 50, 350, 425);
			w1.button("close").hide();
			w1.button("minmax1").hide();
			w1.button("park").show();
			w1.center();
			w1.attachObject("formEdit");
			nwin = nwin + 1;
			w1.setText("Anagrafica");
		}
}

function reloadClienti(){
	window.location = "index.cfm";
}

//------------------------------------------------------------------------------
// FUNZIONA CHE INTERCETTA I TASTI PREMUTI
// 
// [CANC] 	(46) = Elimina cliente
// [PagGiù]	(34) = Pagina avanti
// [PagSu]	(33) = Pagina indietro
//------------------------------------------------------------------------------
function doKeyPress(code,cFlag,sFlag){
	
	//pagina avanti
	if ( code == 34 ){
		if ( eval(getValore("currentPage")) < eval(getValore("totalPages")) ) {
			nextPage();
			mygrid.selectRow(0);
		}
	}
	
	//pagina indietro
	if ( code == 33 ){
		if ( eval(getValore("currentPage") ) > 1 ){
			prevPage();
			mygrid.selectRow(0);
		}
	}
	//cancella cliente tasto delete
	if ( code == 46 ){
		deleteAnagrafica();
	}
}
//------------------------------------------------------------------------------
//FUNZIONI RELATIVE ALLA GESTIONE DELLA TABELLA 
//------------------------------------------------------------------------------
	
	//seleziona la prima riga dopo aver ricostruito la grid
	function doSelectFirstRow(){
		//seleziona la prima riga quando la grid è renderizzata
		if ( currentRow == 0 ){
			mygrid.selectRow(0);
		} else {
			mygrid.selectRowById(currentRow);
		}
		//imposta il numero totale di pagine
		setValore("totalPages", eval(mygrid.getUserData("","pagine"))+1);
		if ( getValore("currentPage") == getValore("totalPages") ){
			hideObj("btnNextPage");
			hideObj("btnEndPage");
		}
		if ( nwin > 1 ){
			w1.hide();
		}
	}
	//selezione riga grid
	function doOnRowSelect(id,cella){
		//alert(id);
		//popolo i campi del form prelevando le userdata definiti nella grid
		currentRow = id;
		setValore("id_cliente",gridUserData(mygrid,id,"id_cliente"));
		setValore("ac_cognome",gridUserData(mygrid,id,"ac_cognome"));
		setValore("ac_nome",gridUserData(mygrid,id,"ac_nome"));
		setValore("ac_azienda",gridUserData(mygrid,id,"ac_azienda"));
		setValore("ac_indirizzo",gridUserData(mygrid,id,"ac_indirizzo"));
		setValore("ac_citta",gridUserData(mygrid,id,"ac_citta"));
		setValore("ac_pv",gridUserData(mygrid,id,"ac_pv"));
		setValore("ac_cap",gridUserData(mygrid,id,"ac_cap"));
		setValore("ac_telefono",gridUserData(mygrid,id,"ac_telefono"));
		setValore("ac_cellulare",gridUserData(mygrid,id,"ac_cellulare"));
		setValore("ac_email",gridUserData(mygrid,id,"ac_email"));
		setValore("ac_segnalatore",gridUserData(mygrid,id,"ac_segnalatore"));
		comboSelect("id_agente",gridUserData(mygrid,id,"id_agente"));
		setValore("id_agente_old",gridUserData(mygrid,id,"id_agente"));
		
		//apro il form nella window	
		if ( nwin == 1 ){
			initWin();
		}

		//imposto il titolo della window ocn il nome cliente
		w1.setText(gridUserData(mygrid,id,"ac_cognome") + " " + gridUserData(mygrid,id,"ac_nome"));
		w1.show();
		document.getElementById("closeThis").focus();
	}
	
	function doOnCellSelect(rId,cId){
		currentRow = rId;
		if ( cId != null ){
			if ( cId == 6 ){
				switchQualifica(rId,cId);
			}
		}
	}
	
	function closeForm(){
		if ( nwin > 1 ){
			w1.hide();
		}
	}

	
//------------------------------------------------------------------------------
//FUNZIONI DI RICERCA
//------------------------------------------------------------------------------

	//Ricerca cliente nelle anagrafiche
	function doSearch(){
		var search = document.getElementById("searchValue").value;
		//mygrid.clearAndLoad("_clientiXML.cfm?startpage=0&search=" + search);
		document.getElementById("btnNextPage").style.display = "";
		document.getElementById("btnEndPage").style.display = "";
		document.getElementById("btnPrevPage").style.display = "none";
		document.getElementById("btnStartPage").style.display = "none";
		document.getElementById("currentPage").value = 1;
		doGetData();
		//document.getElementById("subView").style.display = "none";
	}
	
	//Recupera i dati secondo i filtri impostati
	function doGetData(){
		if ( nwin > 1){
			w1.hide();
		}
		//getRecordsNum();
		var page = eval(getValore("currentPage"))-1;
		var pagesize = 27;
		var search = getValore("searchValue");
		if (search == "cerca cliente ..."){
			search = "null";
		}
		var assegnati = comboGet("filtro_posizione");
		var tipologia = comboGet("filtro_gruppo");
		var pv = comboGet("filtro_pv");
		var attivo = getValore("bl_attivo");
		setValore("currentFilter","startpage=" + page + "&pagesize=" + pagesize + "&search=" + search + "&id_agente=" + assegnati[0] + "&id_gruppo=" + tipologia[0] + "&pv=" + pv[0] + "&import=" + attivo);
		mygrid.clearAndLoad("_clientiFilterXML.cfm?startpage=" + page + "&pagesize=" + pagesize + "&search=" + search + "&id_agente=" + assegnati[0] + "&id_gruppo=" + tipologia[0] + "&pv=" + pv[0] + "&import=" + attivo);
		//alert(attivo);
	}

	function vediNuoviContatti(){
		setValore("bl_attivo",-1);
		doGetData();
	}

//------------------------------------------------------------------------------
//FUNZIONI DI STAMPA
//------------------------------------------------------------------------------
	function printClienti(){
		var myPrintQry = getValore("currentFilter") + "&scopo=1";
		window.open("_clientiToExcel.cfm?" + myPrintQry);
	}
	
//------------------------------------------------------------------------------
//FUNZIONI DI INSERIMENTO NUOVA ANAGRAFICA
//------------------------------------------------------------------------------
	function addAnagrafica(){
		if ( nwin > 1){
			w1.show();
		} else {
			initWin();
			w1.show();
		}
		w1.setText("Nuova Anagrafica");
		clearAnagrafica();		
		
	}	
	
	function clearAnagrafica(){
		setValore("id_cliente","0");
		setValore("ac_cognome","");
		setValore("ac_nome","");
		setValore("ac_azienda","");
		setValore("ac_indirizzo","");
		setValore("ac_citta","");
		setValore("ac_pv","");
		setValore("ac_cap","");
		setValore("ac_telefono","");
		setValore("ac_cellulare","");
		setValore("ac_email","");
		setValore("ac_segnalatore","");
	}
//------------------------------------------------------------------------------
//FUNZIONI DI AGGIORNAMENTO DEI DATI ANAGRAFICI
//------------------------------------------------------------------------------
	
	function saveAnagrafica(){
		var aFields = new Array();
		aFields[0] = "COGNOME";
		aFields[1] = "NOME";
		aFields[2] = "Indirizzo";
		aFields[3] = "Citta'";
		aFields[4] = "Provincia";
		aFields[5] = "Telefono";
		
		var aValidation = new Array();
		aValidation[0] = "ac_cognome";
		aValidation[1] = "ac_nome";
		aValidation[2] = "ac_indirizzo";
		aValidation[3] = "ac_citta";
		aValidation[4] = "ac_pv";
		aValidation[5] = "ac_telefono";
		
		var aFieldType = new Array();
		aFieldType[0] = "txt";
		aFieldType[1] = "txt";
		aFieldType[2] = "txt";
		aFieldType[3] = "txt";
		aFieldType[4] = "txt";
		aFieldType[5] = "num";
		
		var error = false;
		//var error = validateForm(aFields,aValidation,aFieldType);	
		//alert(getValore("id_cliente"));
		//w1.hide();
		
		if ( !error ){
			var conferma = true; 
			if ( comboGet("id_agente")[0] != getValore("id_agente_old") ){
				conferma = confirm("Confermi l'assegnazione all'agente " + comboGet("id_agente")[1] + "?");		
			}
			if ( conferma ) {
ColdFusion.Ajax.submitForm("clienteFrm","_clientiSave.cfm",callbackSaveCliente,errorHandler);
			}
		} else {
			alert("Dati errati o mancanti");
		}
	}
	
	function callbackSaveCliente(result){
		alert(result);
		if ( nwin > 1 ){
			w1.show();
			doGetData();
		}
	}
	
	function switchQualifica(rId,cId){
		currentRow = rId;
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
ColdFusion.Ajax.submitForm("assegnaFrm","_clientiQualifica.cfm",callbackSaveQualifica,errorHandler);
	}
	
	function callbackSaveQualifica(result){
		if ( currentRow != 0){
			mygrid.selectRowById(currentRow,true,true,true);
		} else {
			mygrid.selectRow(0);
		}
		return true;
	}

//------------------------------------------------------------------------------
//FUNZIONI DI CANCELLAZIONE ANAGRAFICA
//------------------------------------------------------------------------------
	function deleteAnagrafica(){
		setValore("id_cliente_delete",currentRow);
ColdFusion.Ajax.submitForm("deleteFrm","_clientiElimina.cfm",callbackEliminaCliente,errorHandler);
	}
	
	function callbackEliminaCliente(result){
		if ( result == "false" ){
			alert("Non e' possibile eliminare il contatto in quanto esiste al momento uno status operativo attivo");
		} else {
			mygrid.deleteRow(currentRow);
		}
	}
	
//--------------------------------------------------------------------------
//FUNZIONI DI ASSEGNAZIONE AGENTE (anche multipla)
//--------------------------------------------------------------------------

	//recupera gli id clienti relativi ad una selezione multipla
	//attiva la procedura per l'assegnazione dell'agente alle righe selezionate
	function doAssegnaMultiple(){
		//verifica che non sia già stato cliccato 
		if ( obj("filterDIV").style.display != "none"){
			//verifica che ci siano righe selezionate
			setValore("id_da_assegnare",mygrid.getSelectedRowId());
			if ( getValore("id_da_assegnare") != "" ){
				showObj("id_agente_assegna");
				hideObj("filterDIV");
				if ( nwin > 1 ){
					w1.hide();
				}
			} else {
				//non è stata selezionata nessuna riga
				alert("Devi selezionare almeno un cliente");
			}
		} else {
			hideObj("id_agente_assegna");
			//ripristina il filtro di ricerca
			showObj("filterDIV");
		}	
	}
	
	
	//Assegna
	function assegnaAgente(obj){
		var indice = obj.selectedIndex;
		if ( indice != 0 ){
			var id_agente_da_assegnare = obj.options[indice].value;
			var conferma = confirm ( "Assegno i clienti selezionati all'agente " + obj.options[indice].text + "?");
			if ( conferma ){
				setValore("id_da_assegnare",mygrid.getSelectedRowId());
				hideObj("btnAssegna");
				hideObj("id_agente_assegna");
			ColdFusion.Ajax.submitForm("assegnaFrm","_assegnaAgente.cfm",callbackAssegna,errorHandler);
			}
		}
		
	}
	
	//CALLBACK dell'assegnazione agente
	function callbackAssegna(text){
   		showObj("btnAssegna");
		//ricarico i dati
		doGetData();
		//mygrid.clearAndLoad("_clientiXML.cfm?search=&startpage=" + (getValore("currentPage")-1));
		//nascondo il form
		showObj("filterDIV");
		setValore("id_da_assegnare","");
		if ( nwin > 1 ){
			w1.hide();
		}
	}

	//gestione generale dell'errore coldfusion-ajax
	function errorHandler(code,msg){
		alert("Error !" + code + ":" + msg);
		document.write(msg);
	}


//------------------------------------------------------------------------------
// GRID Gestione paginazione 
//------------------------------------------------------------------------------
	
	//Pagina avanti
	function nextPage(){
		var paginaLast = document.getElementById("totalPages");
		var pagina = document.getElementById("currentPage");
		var isLastPage = false;
		pagina.value = eval(pagina.value) + 1;
		
		if ( eval(pagina.value) > 1 ){
			document.getElementById("btnPrevPage").style.display = "";
			document.getElementById("btnStartPage").style.display = "";
		} else {
			document.getElementById("btnPrevPage").style.display = "none";
			document.getElementById("btnStartPage").style.display = "none";
		}
		
		if ( eval(pagina.value) < eval(paginaLast.value) ){
			document.getElementById("btnNextPage").style.display = "";
			document.getElementById("btnEndPage").style.display = "";
		} else {
			document.getElementById("btnNextPage").style.display = "none";
			document.getElementById("btnEndPage").style.display = "none";
			isLastPage = true;
		}
		
		//ricarico i dati
		//mygrid.clearAndLoad("_clientiXML.cfm?search=&startpage=" + (pagina.value-1));
		doGetData();
		//nascondo il form
		if ( nwin > 1 ){
			w1.hide();
		}
	}
	
	//pagina indietro
	function prevPage(){
		var paginaLast = document.getElementById("totalPages");
		var pagina = document.getElementById("currentPage");
		pagina.value = eval(pagina.value) - 1;
		if ( eval(pagina.value) > 1 ){
			document.getElementById("btnPrevPage").style.display = "";
			document.getElementById("btnStartPage").style.display = "";
		} else {
			document.getElementById("btnPrevPage").style.display = "none";
			document.getElementById("btnStartPage").style.display = "none";
		}
		
		if ( eval(pagina.value) < eval(paginaLast.value) ){
			document.getElementById("btnNextPage").style.display = "";
			document.getElementById("btnEndPage").style.display = "";
		} else {
			document.getElementById("btnNextPage").style.display = "none";
			document.getElementById("btnEndPage").style.display = "none";
		}
		//ricarico i dati
		//mygrid.clearAndLoad("_clientiXML.cfm?search=&startpage=" + (pagina.value-1));
		doGetData();
		//nascondo il form
		if ( nwin > 1 ){
			w1.hide();
		}
	}
	
	//vai all'ultima pagina
	function endPage(){
		var paginaLast = document.getElementById("totalPages");
		var pagina = document.getElementById("currentPage");
		pagina.value = paginaLast.value;
		//mygrid.clearAndLoad("_clientiXML.cfm?search=&startpage=" + (pagina.value-1));
		document.getElementById("btnNextPage").style.display = "none";
		document.getElementById("btnEndPage").style.display = "none";
		document.getElementById("btnPrevPage").style.display = "";
		document.getElementById("btnStartPage").style.display = "";
		if ( nwin > 1 ){
			w1.hide();
		}
		doGetData();
	}
	
	//vai alla prima pagina
	function startPage(){
		var pagina = document.getElementById("currentPage");
		pagina.value = 1;
		//mygrid.clearAndLoad("_clientiXML.cfm?search=&startpage=0");
		document.getElementById("btnNextPage").style.display = "";
		document.getElementById("btnEndPage").style.display = "";
		document.getElementById("btnPrevPage").style.display = "none";
		document.getElementById("btnStartPage").style.display = "none";
		if ( nwin > 1 ){
			w1.hide();
		}
		doGetData();
	}
		
//************************	FUNZIONI DISATTIVATE *************************************
//	
	//funzione attivata con doppio click sulla prima o sull'ultima riga
	//permette il pagina avanti/indietro 
	//doppio click sulla prima riga = pagina indietro (se non prima pagina)
	//doppio click sull'ultima riga = pagina avanti (se non ultima pagina)
	function doPageNavigation(id,cella){
		//avanzamento pagina
		//controllo se prima riga
		if ( mygrid.getRowIndex(id) == 0 ){
			//controllo se pagina > 1
			if ( document.getElementById("currentPage").value != "1" ){
				if ( nwin > 1 ){
					w1.hide();
				}
				prevPage();
			}
		}
		//pagina precedente
		//controllo se ultima riga
		if ( mygrid.getRowIndex(id) == (mygrid.getRowsNum()-1) ){
			//controllo se pagina < ultima pagina
			if ( document.getElementById("currentPage").value != document.getElementById("totalPages").value ){
				if ( nwin > 1 ){
					w1.hide();
				}
				nextPage();
			} 
		}
		
	}
// *************************** FINE FUNZIONI DISATTIVATE ****************************		
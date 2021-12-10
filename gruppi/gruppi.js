dhtmlx.skin="dhx_skyblue";
var nwin = 1;
var lastRow = false;
var initRow = false;
var currentRowGruppo = 0;
var currentRow = 0;

function initWin1(){
		
			w1 = dhxWins.createWindow("u1", 150, 50, 250, 250);
			w1.button("close").hide();
			w1.button("minmax1").hide();
			w1.button("park").show();
			w1.center();
			w1.attachObject("gruppiFrm");
			nwin = nwin + 1;
			w1.setText("Gruppo");
}

function initWin2(){
		
			w2 = dhxWins.createWindow("u2", 150, 50, 350,550);
			w2.button("close").hide();
			w2.button("minmax1").hide();
			w2.button("park").show();
			w2.center();
			w2.attachObject("utenteFrm");
			nwin = nwin + 1;
			w2.setText("Utente");
}
//----------------------------------------------------------------------------------
// FUNZIONI GESTIONE GRUPPI
//----------------------------------------------------------------------------------
	function selectGruppo( rId , cIn ){
		
	}

	function getUtenti(){
		//prelevo i dati dalla grid per popolare il modulo di modifica
		var selectedId = mygrid.getSelectedRowId();
		var id_gruppo = mygrid.getUserData(selectedId,"id_gruppo");
		var gruppo = mygrid.getUserData(selectedId,"ac_gruppo");
		var int_livello = mygrid.getUserData(selectedId,"int_livello");
		var id_gruppo_padre = mygrid.getUserData(selectedId,"id_gruppo_padre");
		setValore("id_gruppo",id_gruppo);
		setValore("ac_gruppo",gruppo);
		//setValore("int_livello",int_livello);
		comboSelect("id_gruppo_padre",id_gruppo_padre);
		showObj("userTools");
		//aggiorno lista azioni del cliente selezionato		
		mygrid2.clearAndLoad("_gruppiUtentiXML.cfm?id_gruppo=" + id_gruppo);
		mygrid.setRowTextBold(selectedId);
		mygrid.setRowTextNormal(currentRowGruppo);
		currentRowGruppo = selectedId;
	}
	
	function getGruppo(rId){
		var level = mygrid.getUserData(rId,"int_livello");
		comboSelect("int_livello",level);
		if ( w1 == null ){
			initWin1();
		}
		w1.show();
		w1.setText("Gruppo");
	}
	
	function addGruppo(){
		setValore("id_gruppo","0");
		setValore("ac_gruppo","");
		comboSelect("id_gruppo_padre",2);
		comboSelect("int_livello","3");
		if ( w1 == null ){
			initWin1();
		}
		w1.show();
		w1.setText("Aggiungi Gruppo");
	}
	
	function saveGruppo(){
		ColdFusion.Ajax.submitForm("gruppiFrm","_gruppiSave.cfm",callbackSaveGruppi,errorHandler);
	}
	
	function deleteGruppo(){
		//alert(mygrid2.getRowsNum());
		var numUtenti = mygrid2.getRowsNum();
		if ( eval(numUtenti) == 0 ){
			setValore("action",-1);
			ColdFusion.Ajax.submitForm("gruppiFrm","_gruppiSave.cfm",callbackSaveGruppi,errorHandler);
		} else {
			alert ( "Non e' possibile eliminare un gruppo a cui sono gia' stati assegnati utenti" );
		}
	}
	
	function closeGruppiFrm(){
		w1.hide();
	}
	
	
//----------------------------------------------------------------------------------
// FUNZIONI GESTIONE UTENTI
//----------------------------------------------------------------------------------
	function selectUtente ( rId , cIn ){
		mygrid2.setRowTextBold(rId);
		mygrid2.setRowTextNormal(currentRow);
		currentRow = rId;
	}
	function getUtente(rId,cIn){
		//prelevo i dati dalla grid per popolare il modulo di modifica
		var id = mygrid2.getSelectedRowId();
		setValore("id_persona",gridUserData(mygrid2,id,"id_persona"));
		setValore("ac_cognome",gridUserData(mygrid2,id,"ac_cognome"));
		setValore("ac_nome",gridUserData(mygrid2,id,"ac_nome"));
		setValore("ac_indirizzo",gridUserData(mygrid2,id,"ac_indirizzo"));
		setValore("ac_citta",gridUserData(mygrid2,id,"ac_citta"));
		setValore("ac_pv",gridUserData(mygrid2,id,"ac_pv"));
		setValore("ac_cap",gridUserData(mygrid2,id,"ac_cap"));
		setValore("ac_telefono",gridUserData(mygrid2,id,"ac_telefono"));
		setValore("ac_cellulare",gridUserData(mygrid2,id,"ac_cellulare"));
		setValore("ac_email",gridUserData(mygrid2,id,"ac_email"));
		setValore("ac_utente",gridUserData(mygrid2,id,"ac_utente"));				
		setValore("ac_password",gridUserData(mygrid2,id,"ac_password"));
		setValore("nrclienti",gridUserData(mygrid2,id,"nrclienti"));
		setValore("ac_sconto_riservato",gridUserData(mygrid2,id,"ac_sconto_riservato"));
		setHTML("lista_gruppi",getGruppi("id_gruppi_controllo",gridUserData(mygrid2,id,"ac_gruppi")));
		//setComboSelected("id_gruppi_controllo",gridUserData(mygrid2,id,"ac_gruppi"));
		comboSelect("id_gruppo_agente",gridUserData(mygrid2,id,"id_gruppo"));
		currentRow = mygrid2.getSelectedRowId();
		if ( w2 == null ){
			initWin2();
		} 
		w2.show();
		w2.setText("Utente");
	}	
	
	
	function getGruppi(obj,valore){
		if ( valore != "" ){
		var aValori = listToArray(valore,",");
		var n = aValori.length;
		var testo = "";
		for ( s = 0 ; s < n ; s++){
			var myGruppo = comboGetText(obj,aValori[s]);
			testo = testo + myGruppo + ",";
		}
		return testo;
		}
	}
	
	function addUtente(){
		setValore("id_persona",0);
		var id =  mygrid.getSelectedRowId();
		setValore("id_gruppo_agente",gridUserData(mygrid,id,"id_gruppo"));
		if (gridUserData(mygrid,id,"id_gruppo") == ""){
			alert("Selezionare un gruppo !!!");
			return ;
		}
		setValore("ac_cognome","");
		setValore("ac_nome","");
		setValore("ac_indirizzo","");
		setValore("ac_citta","");
		setValore("ac_pv","");
		setValore("ac_cap","");
		setValore("ac_telefono","");
		setValore("ac_cellulare","");
		setValore("ac_email","");
		setValore("ac_utente","");				
		setValore("ac_password","");
		if ( w2 == null ){
			initWin2();
		} 
		w2.show();
		w2.setText("Nuovo Utente");
	}	
	
	
	function validateFormUtente(){
		var aFields = new Array();
		aFields[0] = "COGNOME";
		aFields[1] = "NOME";
		aFields[2] = "Telefono";
		aFields[3] = "Email";
		aFields[4] = "Nome Utente";
		aFields[5] = "Password";
		
		var aValidation = new Array();
		aValidation[0] = "ac_cognome";
		aValidation[1] = "ac_nome";
		aValidation[2] = "ac_telefono";
		aValidation[3] = "ac_email";
		aValidation[4] = "ac_utente";
		aValidation[5] = "ac_password";
		var aFieldType = new Array();
		aFieldType[0] = "txt";
		aFieldType[1] = "txt";
		aFieldType[2] = "num";
		aFieldType[3] = "mail";
		aFieldType[4] = "txt";
		aFieldType[5] = "txt";
		
		var error = false;
		for ( var i = 0; i<aValidation.length ; i++){
			var isValid = validate( aFieldType[i] , obj(aValidation[i]) , true );
			if ( !isValid ){
				alert ( "Il campo >>> " + aFields[i] + "<<< e' errato o obbligatorio");
				error = true;
			}
		}
		return error;
	}
	
	function saveUtente(){
		var error = validateFormUtente();
		if ( !error ){
ColdFusion.Ajax.submitForm("utenteFrm","_gruppiUtenteSave.cfm",callbackSaveUtente,errorHandler);
		} else {
			alert("Dati errati o mancanti");
		}
	}
	
	function deleteUtente(){
		var clienti = gridUserData(mygrid2,currentRow,"nrclienti");
		var nome = gridUserData(mygrid2,currentRow,"ac_cognome") + " " + gridUserData(mygrid2,currentRow,"ac_nome");
		if ( clienti != 0 ){
			alert ( "Al momento " + clienti + " clienti sono assegnati a questo utente!\nNon e' possibile eliminare un'utente con clienti assegnati");
		} else {
			var conferma = confirm ( "Elimino utente " + nome + " ?");
			if ( conferma ){
				setValore("id_utente_enable",gridUserData(mygrid2,currentRow,"id_persona"));
				setValore("bl_cancellato",3);
ColdFusion.Ajax.submitForm("enableUtente","_gruppiUtenteEnable.cfm",callbackEnableUtente,errorHandler);	
			}
		}
		
	}
	function closeUtenteFrm(){
		w2.hide();
	}
	

	function getEnabled (rId , cId , stato){
		setValore("id_utente_enable",gridUserData(mygrid2,rId,"id_persona"));
		setValore("bl_cancellato",stato);
		ColdFusion.Ajax.submitForm("enableUtente","_gruppiUtenteEnable.cfm",callbackEnableUtente,errorHandler);
	}
	
	function callbackEnableUtente(result){
		if ( result == "Deleted" ){
			mygrid2.clearAndLoad("_gruppiUtentiXML.cfm?id_gruppo=" + getValore("id_gruppo"));
		} else {
			return true;
		}
		//return true;
	}
//----------------------------------------------------------------------------------
// FUNZIONI COMUNI
//----------------------------------------------------------------------------------	
//Gestisce il risulatato dell'aggiornamento gruppi
function callbackSaveGruppi(result){
	alert(result);
	if ( result == "Gruppo Eliminato" ){
		mygrid.clearAndLoad("_gruppiXML.cfm");
		mygrid2.clearAll();
	} else {
		mygrid.clearAndLoad("_gruppiXML.cfm");
		
	}
	w1.hide();
}

//Gestisce il risulatato dell'aggiornamento utente
function callbackSaveUtente(result){
	if ( result != "false" ){
		alert(result);
		var selectedId = mygrid.getSelectedRowId();
		var id_gruppo = mygrid.getUserData(selectedId,"id_gruppo");
		mygrid2.clearAndLoad("_gruppiUtentiXML.cfm?id_gruppo=" +id_gruppo);
		w2.hide();
	} else {
		alert ( "Attenzione il nome utente e la password per l'accesso sono gia' in uso.\nScegliere un altro nome utente o un'altra password");
	}
}

function doSelectRow(stato,rId,cIn){
	if ( currentRow != 0 ){
		mygrid2.selectRowById(currentRow,true,true,true);
	} else {
		mygrid2.selectRow(0);
	}	
	
	if ( currentRowGruppo != 0 ){
		mygrid.selectRowById(currentRowGruppo,true,true,true);
	} else {
		mygrid.selectRow(0);
	}
}
	
//gestione generale dell'errore coldfusion-ajax
function errorHandler(code,msg){
	//alert("Error !" + code + ":" + msg);
	obj("error").innerHTML = msg;
}	
//--------------------------- FUNZIONI PER AUTOSUGGEST ----------------------------------//
//verifica che sia stata premuta la barra dopo aver selezionato
//il cognome suggerito ed avvia il recupero dei dati per
//la visualizzazione 
//modalità AJAX : accessibile se nel template viene utilizzato
//cfajaximport 
function checkKey(obj,e){
		if ( e.keyCode == 32 ){
			if ( obj.value != " " ){
				//creo un oggetto riferito al componente clienti.cfc
				var instance = new service();
				//definisco la funzione di callback
    			instance.setCallbackHandler(getCustomerDataSuccess);
				//chiamo la funzione cfc:clienti.getCustomerData
	    		instance.getCustomerData(obj.value);
			}
		} else {
			return false
		}
	}

//questa funzione ha le stesse proprietà di checkKey
//viene attivata cliccando sull'icona search	
function fastSearch(){
	var mySearch = document.getElementById("search");
	if (mySearch.value != " "){
		//creo un oggetto riferitto al componente clienti.cfc
		var instance = new service();
		//definisco funzione di callback
 		instance.setCallbackHandler(getCustomerDataSuccess);
		//chiamo la funzione cfc:clienti.getCustomerData
	    instance.getCustomerData(mySearch.value);
	}	
}	
//funzione per accedere al componente ed al metodo
function getCustomerData(obj){
	if ( obj.value != "" ){
		var instance = new service();
    	instance.setCallbackHandler(getCustomerDataSuccess);
	    instance.getCustomerData(obj.value);
	}
}

//funzione di callback
function getCustomerDataSuccess(result){
	
	//visualizzo i dati del cliente
	if ( result.DATA.length > 0 ){
		var azienda = result.DATA[0][0];
		var indirizzo = result.DATA[0][2];
		var citta = result.DATA[0][3];
		var provincia = result.DATA[0][5];
		var cap = result.DATA[0][4];
		var telefono = result.DATA[0][6];
		var cellulare = result.DATA[0][7];
		var email = result.DATA[0][8];
		document.getElementById("searchInfo").innerHTML = "<strong style='font-weight:bold'><img src='include/css/icons/my-account.png' align='right' onclick='hideObj(\"searchInfo\")'></strong><br>" + azienda + "<br>" + indirizzo + "<br>" + cap + " " + citta + " " + provincia + "<br><img src='include/css/icons/contact.png' align='absmiddle' hspace='3'>" + telefono + "<br><img src='include/css/icons/phone.png' align='absmiddle' hspace='3'>" + cellulare + "<br><img src='include/css/icons/email.png' align='absmiddle' hspace='3'>" + email;
		document.getElementById("searchInfo").style.display = "";
	}
}

function submitLogin(){
	setHTML("errorLogin","");
	ColdFusion.Ajax.submitForm("loginFrm","_loginAuthenticate.cfm",callbackLogin,errorHandler);
}

function callbackLogin(result){
	var check =	result.substring(0,2);
	if ( check != "KO"){
		alert("Benvenuto " + result + " !");
		parent.location = "index.cfm";
	} else {
		alert("Nome utente o password errati!\nRiprovare o contattare l'amministratore");
	}
}

function errorHandler(code,msg){
		alert("Error !" + code + ":" + msg);
	}
	
function logout(){
	ColdFusion.Ajax.submitForm("logoutFrm","_logout.cfm",callbackLogout,errorHandler);
}

function callbackLogout(result){
	alert("Arrivederci "+ result + " !");
	window.location = "index.cfm";
}
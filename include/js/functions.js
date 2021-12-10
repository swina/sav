//---------------------------------- FUNZIONI GENERALI --------------------------------//
//nasconde un oggetto con id obj
function hideObj(obj){
	document.getElementById(obj).style.display = "none";
}

//nasconde un oggetto con id obj
function showObj(obj){
	document.getElementById(obj).style.display = "";
}


//azzera il valore di un oggetto con proprietà .value (es. input)
function clearValue(obj){
	obj.value = "";
}

//assegna ad un elemento (parametro elemento) con proprietà value (es. input)
//il valore passato (paramentro valore)
function setValore(elemento,valore){
	var obj = document.getElementById(elemento);
	obj.value = valore;
}

//recupero il valore da un elemento (parametro elemento) con proprietà value (es. input)
//
function getValore(elemento){
	var obj = document.getElementById(elemento);
	return obj.value;
}

//assegna il valore (parametro valore) innerHTML ad un elemento (parametro elemento)
function setHTML(elemento,valore){
	var obj = document.getElementById(elemento);
	obj.innerHTML = valore;
}

//imposta il selectedIndex di una select (parametro elemento) 
//secondo il valore fornito (parametro valore)
function comboSelect(elemento,valore){
	var obj = document.getElementById(elemento);
	obj.selectedIndex = 0;
	for ( i = 0 ; i < obj.options.length ; i++){
		if ( obj.options[i].value == valore ){
			obj.selectedIndex = i;
		}
	}
}

//imposta il selectedIndex di una select (parametro elemento) 
//secondo il valore fornito (parametro valore)
function comboGetText(elemento,valore){
	var obj = document.getElementById(elemento);
	for ( i = 0 ; i < obj.options.length ; i++){
		if ( obj.options[i].value == valore ){
			return obj.options[i].text;
		}
	}
}

//imposta una select all'indice indicato
function comboSetIndex(elemento,indice){
	obj(elemento).selectedIndex = indice;
}

//ritorna l'indice attuale di una select
function comboGetIndex(elemento){
	var obj = document.getElementById(elemento);
	return obj.selectedIndex;
}

//ritorna l'indice di una select passato un determinato valore
function comboGetIndexByValue(elemento,valore){
	var obj = document.getElementById(elemento);
	for ( var i = 0 ; i < obj.options.length ; i++){
		if ( obj.options[i].value == valore ){
			return i;
		}
	}

}

//ritorna il numero di opzioni di una select
function comboLen(elemento){
	return obj(elemento).options.length;
}

//ritorna il valore di una select ad un determinato indice
function comboGetAt(elemento,indice){
	//var lastIndex = obj(elemento).selectedIndex;
	//obj(elemento).selectedIndex = indice;
	//var retValue = obj(elemento).options[indice].value;
	return obj(elemento).options[indice].value;
}

//imposta il selectedIndex di una select (parametro elemento) a 0
function comboReset(elemento){
	var obj = document.getElementById(elemento);
	obj.selectedIndex = 0;
}

//recupera il valore ed il testo corrente di una select (parametro obj)  
function comboGet(elemento){
	var obj = document.getElementById(elemento);
	var indice = obj.selectedIndex;
	var myArray = new Array(1);
	myArray[0] = obj.options[indice].value;
	myArray[1] = obj.options[indice].text;
	return myArray; 
}

//ritorna il valore userdata della grid 
//grid = oggetto grid;
//id = riga della grid
//userdata = userdata definito nella grid
//Es: gridUserData(mygrid,0,"cognome");
function gridUserData(grid,id,userdata){
	return grid.getUserData(id,userdata);
}

//restituisce l'oggetto id_oggetto
function obj(id_oggetto){
	return document.getElementById(id_oggetto);
}

//ritorna un array da una lista (parametro lista) con separatore (parametro sep)
function listToArray(lista,sep){
	var aArray = lista.split(sep);
	return aArray;
}


//---------------------------------- VALIDAZIONE CAMPI --------------------------------//
//
function validate ( tipo , field , richiesto){
		
		//TESTO RICHIESTO
		if ( tipo == "txt" ){
			if ( richiesto ) {
				if ( field.value.length > 1 ){
					return true;
				} else {
					alert ( "Il campo e' obbligatorio" );
					field.focus();
				}
			} else {
				return true;
			}
		}
		
		//EMAIL
		if ( tipo == "mail" ){
			if ( richiesto ){
				var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
				var address = field.value;
				if(reg.test(address) == false) {
		      		alert('Indirizzo mail non valido');
					field.value = "";
				  	field.focus();
    	  		  	return false;
   				} else {
					return true;
				}
			} else {
				var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
				var address = field.value;
				if(reg.test(address) == false) {
					alert("Indirizzo mail non valido");
					field.value = "";
					field.focus();
					return false;
				} else {
					return true;
				}
			}
		}
		
		//CAMPO NUMERICO
		if ( tipo == "num" ){
		
			if ( isNaN(field.value) ){
				alert("Il valore deve essere numerico");
				field.value = "";
				field.focus();
				return false;
			} else {
				if ( richiesto ){
				
					if ( field.value.length > 0 ){
						return true;
					} else {
						field.focus();
						alert("Il campo e' obbligatorio");
						return false;
					}
				
				} else {
					return true;
				}
			}
		}
	}
	
	
	
	function validateForm(aFields , aValidation , aFieldType){
		
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


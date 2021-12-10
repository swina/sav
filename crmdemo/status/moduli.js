function checkVincoli(vincoli,obj,conta){
	var allVincoli = listToArray(vincoli,"|");
	for ( v = 0 ; v < allVincoli.length ; v++ ){
		myVincoli = listToArray(allVincoli[v],",");
		if ( myVincoli[0] == comboGet(obj)[0] ){
			doRequired ( myVincoli , 1 );
		} else {
			doRequired ( myVincoli , 0 );
		}
	}
	/*	
		if ( comboGet(obj)[0] == myVincoli[0] ){
			for ( n = 1; n<myVincoli.length ; n++ ){
				document.getElementById(myVincoli[n]).className = "required";
				var myRequired = rebuildList(myVincoli[n],1);
				setValore("lista_required",myRequired);
			}
		} else {
			for ( n = 1; n<conta ; n++ ){
				document.getElementById(myVincoli[n]).className = "";
				var myRequired = rebuildList(myVincoli[n],0);
			}
		}		
	}*/
	//var myVincoli = listToArray(vincoli,",");

}
function uploadFrmFiles(){
	GB_showCenter(myModuli[indice], "../../status/_statusDocsUpload.cfm", 350, 300, callBackModulo);
}
function doRequired ( vincoli , stato ){
	var richiesto = "";
	if ( stato == 1 ){
		richiesto = "required";
	}
	for ( var n = 1 ; n < vincoli.length ; n++ ){
			document.getElementById(vincoli[n]).className = richiesto;
			var myRequired = rebuildList(myVincoli[n],stato);
			setValore("lista_required",myRequired);
	}
}

function checkDate ( data , giorni, newdate ){
	var myDate = listToArray(newdate,"/");
	if ( myDate[0].length == 1 ){
		myDate[0] = "0" + myDate[0];
	}
	if ( myDate[1].length == 1 ){
		myDate[1].length = "0" + myDate[2];
	}
	
	var checkDate = myDate[2]+myDate[1]+myDate[0];
	if ( (eval(checkDate) - eval(data)) < eval(giorni)){
		alert ( "La data inserita non e' valida.\nDeve essere almeno " + giorni + " giorni successiva a quella odierna");
		hideObj("submitFrm");
	} else {
		showObj("submitFrm");
	}
}

function rebuildList (campo,valore){
	var aR = listToArray(getValore("lista_required"),",");
	var aF = listToArray(getValore("lista_fields"),",");
	for ( x=0 ; x < aF.length ; x++ ){
		if ( aF[x] == campo ){
			aR[x] = valore;
		}
	}
	newList = "";
	for ( s=0 ; s < aF.length ; s++ ){
		newList = newList + aR[s] + ",";
	}
	newList = newList.substring(0,newList.length-1);
	return newList;
	//return;
	//alert ( newList );
}

function saveThisModulo(){
	var listaLabels = getValore("lista_labels");
	var listaCampi = getValore("lista_fields");
	var listaRequired = getValore("lista_required");
	var listaTipi = getValore("lista_tipi");
	var listaProcessi = getValore("lista_processi");
	
	var aCampi = listToArray(listaCampi,",");
	var aRequired = listToArray(listaRequired,",");
	var aLabels = listToArray(listaLabels,",");
	var aTipi = listToArray(listaTipi,",");
	var aProcessi = listToArray(listaProcessi,",");
	
	var myValues = "";
	var errMsg = "Attenzione !!! Modulo incompleto";
	var err = false;
	
	for ( i = 0 ; i < aCampi.length ; i++ ){
		var valore = getValue(aCampi[i],aTipi[i],aRequired[i]);
		var tipo = aTipi[i];
		var label = aLabels[i];
		var required = aRequired[i];
		var processo = aProcessi[i];
		if ( !valore  && aRequired[i] == "1"){
			err = true;
			errMsg = errMsg + "\n- " + aLabels[i];
		} else {  
			if ( valore == '' ){
				currValue = "null";
			} else {
				currValue = valore;
			}
			myValues = myValues + currValue + "|";
		}
		
	}
	if ( err != true ){
		setValore("valori",myValues);
		for ( i = 0 ; i < aCampi.length ; i++ ){
			var processo = aProcessi[i];
			if ( processo != 0 ){
				var valore = getValue(aCampi[i],aTipi[i],aRequired[i]);
				setValore("id_processo",aProcessi[i]);
				setValore("dt_processo",valore);
ColdFusion.Ajax.submitForm("processi","_statusModuloProcessoSave.cfm",callbackProcessoModuloSave,errorhandler);
			}
		}				ColdFusion.Ajax.submitForm("saveFrm","_statusModuloSave.cfm",callbackModuloSave,errorhandler);
	} else {
		alert ( errMsg );
	}
}

function callbackProcessoModuloSave ( result ){
	//alert(result);
	var idcliente = parent.parent.document.getElementById("id_cliente").value;
	parent.parent.mygrid2.clearAndLoad("_statusClienteXML.cfm?cliente=" + idcliente);
	parent.parent.GB_hide();
	//parent.parent.document.getElementById("modulo_uuid").value = result;
	//parent.parent.document.getElementById("modulo_flag").value = "1";
	//ColdFusion.Ajax.submitForm("processi","_statusModuloProcessoSave.cfm",callbackProcessoModuloSave,errorhandler);
	//alert(result);
}

function getValue(campo,tipo,richiesto){
	var noError = true;
	if ( tipo == "co" ){
		if ( richiesto == "1" ){
			if ( comboGet(campo)[0] == "" ){
				noError = false ;
			} else {
				return comboGet(campo)[0];
			}
		} else {
			return comboGet(campo)[0];
		}
		
	}
	if ( tipo == "ch" ){
		
		var myField = document.getElementsByName(campo);
		var counter = myField.length ;
		var myValue = "";
		
		if ( richiesto == "1" ){
			for ( i = 0; i < counter ; i++ ){
				if ( myField[i].checked ){
					myValue = myValue + myField[i].value + ",";
				}
			}
			if ( myValue == "" ){
				noError = false;
			} else {
				return myValue;
			}
		} else {
			return true;
		}

	}
	if ( tipo == "str" || tipo == "mem" || tipo == "dt" ){
		if ( richiesto == 1 ){
			if ( getValore(campo) == "" ){
				noError = false;
			} else {
				return getValore(campo);
			}
		} else {
			return getValore(campo);
		}	
	}
	return noError;
	
}

function callbackModuloSave(result){
	parent.parent.document.getElementById("modulo_uuid").value = result;
	parent.parent.document.getElementById("modulo_flag").value = "1";
	parent.parent.addNewProcess();
	parent.parent.GB_hide();
}

function errorhandler(code,msg){
		alert("Error !" + code + ":" + msg);
}
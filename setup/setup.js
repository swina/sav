var currentRow = -1;
//----------------------------------------------------------------------------
//FUNZIONI GESTIONE PROFILO 
//----------------------------------------------------------------------------
function saveProfilo(){
	alert(getValore("ac_nome"));
	if (getValore("ac_password") == getValore("password_confirm")){
		ColdFusion.Ajax.submitForm("profiloFrm","_profiloSave.cfm",callbackSaveConfig,errorHandler);
	} else {
		alert("Le password non coincidono !");
	}	
}

//----------------------------------------------------------------------------
//FUNZIONI GESTIONE CONFIGURAZIONE 
//----------------------------------------------------------------------------
function saveConfig(){
	if (getValore("ac_admin_password") == getValore("password_confirm")){
		ColdFusion.Ajax.submitForm("configFrm","_configSave.cfm",callbackSaveConfig,errorHandler);
	} else {
		alert("Le password non coincidono !");
	}	
}

function callbackSaveConfig(result){
	alert("Configurazione salvata!");
	return true;
}
//----------------------------------------------------------------------------
//FUNZIONI GESTIONE PROCESSI 
//----------------------------------------------------------------------------
var myColumnsP = new Array();
myColumnsP[0] = "id_processo";
myColumnsP[1] = "ac_processo";
myColumnsP[2] = "ac_sigla";
myColumnsP[3] = "int_timer_limit";
myColumnsP[4] = "int_status";
myColumnsP[5] = "ac_colore";
myColumnsP[6] = "ac_modulo";
myColumnsP[7] = "int_ordine";


var myColTypeP = new Array();
myColTypeP[0] = "int";
myColTypeP[1] = "str";
myColTypeP[2] = "str";
myColTypeP[3] = "int";
myColTypeP[4] = "int";
myColTypeP[5] = "str";
myColTypeP[6] = "str";
myColTypeP[7] = "int";

function doSelectRow(rId,cIn){
	if ( currentRow != -1 ){
		mygrid.selectRowById(currentRow,true,true,true);
	}
}

function doOnCellChangedP(stage, rId, cIn, nValue,oValue) {
	//controllo se cella modificata
	
	if ( stage == 1 && cIn == 3 ){
		var myAuto = mygrid.cells(rId,cIn).getValue();
		
		if ( myAuto == 1 ){
			setValore("id_processo",gridUserData(mygrid,rId,"id_processo"));
			setValore("table_column",myColumnsP[cIn+1]);
			setValore("column_type",myColTypeP[cIn+1]);
			setValore("column_value",1);
			setValore("old_value",0);
			ColdFusion.Ajax.submitForm("updateCell","_processoColumnSave.cfm",callbackSaveColProcesso,errorHandler);
		}
	}
	if (stage == 2) {
		
        if (cIn == 5) {
			//cella color picker
			//cambio colore
			var newColor = mygrid.cells(rId, 5).getValue();
			newColor = newColor.substring(1);
            mygrid.cells(rId, 4).setValue(newColor.toUpperCase());
			setValore("id_processo",gridUserData(mygrid,rId,"id_processo"));		
			setValore("table_column","ac_colore");
			setValore("column_value",newColor.toUpperCase());
			setValore("old_value",gridUserData(mygrid,rId,"ac_colore"));
			setValore("column_type","str");
        } else {

				//gestione modifica altre celle
				//imposto i valori per il form
				setValore("id_processo",gridUserData(mygrid,rId,"id_processo"));
				if ( cIn < 7 ){			
					setValore("table_column",myColumnsP[cIn+1]);
					setValore("column_type",myColTypeP[cIn+1]);
				}	
				setValore("column_value",mygrid.cells(rId,cIn).getValue());
				setValore("old_value",oValue);
			
			//mygrid.cells(rId,cIn).setValue(nValue);
		}
		//alert( getValore("table_column") );
		//alert( getValore("column_type") );
		//alert( getValore("column_value") );	
		//alert( getValore("old_value") );	
		if ( getValore("column_value") != getValore("old_value") ){
			//alert( getValore("table_column") );
			//alert( getValore("column_type") );
			//alert( getValore("column_value") );	
			//alert( getValore("old_value") );
		//avvio salvataggio dati
ColdFusion.Ajax.submitForm("updateCell","_processoColumnSave.cfm",callbackSaveColProcesso,errorHandler)		;
    return true }
	} else {
    	return true;
	}
}

//callback di salvataggio processo
function callbackSaveColProcesso(result){
	if ( result == 0 ){
		mygrid.clearAndLoad("_processiXML.cfm");
	}
	return true;
}

function doViewPermission ( rId , cId ){
	currentRow = rId;
	var id_processo = gridUserData(mygrid,rId,"id_processo");
	var perm = gridUserData(mygrid,rId,"ac_permissions");
	var ordine = gridUserData(mygrid,rId,"int_ordine");
	mygrid2.clearAndLoad("_processiPermissionXML.cfm?id_processo=" + id_processo + "&ac_permission=" + perm);
	//riordina (colonna 7)
	if ( cId == 7 ){
		setValore("int_ordine",ordine);
		setValore("id_processo_ordine",id_processo);
ColdFusion.Ajax.submitForm("ordine","_processiSetOrdine.cfm",callbackOrdinaProcessi,errorHandler)		;	}
}

function callbackOrdinaProcessi(result){
	mygrid.clearAndLoad("_processiXML.cfm");
}

function setPermission ( rId , cId ){
	var id_processo = gridUserData(mygrid2,rId,"id_processo");
	var myStatus = mygrid2.cells(rId,cId).getValue();
	if ( myStatus.indexOf("check") == -1 ){
		mygrid2.cells(rId,cId).setValue("../include/css/icons/check.png^Abilitato");
	} else {
		mygrid2.cells(rId,cId).setValue("../include/css/icons/busy.png^Non abilitato");
	}
	var myNewPermissions = "";
	for ( i = 0 ; i < 4 ; i++ ){
		myStatus = mygrid2.cells(rId,i).getValue();
		if ( myStatus.indexOf("check") == -1 ){
			myNewPermissions = myNewPermissions + "0,";
		} else {
			myNewPermissions = myNewPermissions + "1,";
		}
	}
	setValore("id_processo_perm",id_processo);
	setValore("ac_permissions",myNewPermissions);
	ColdFusion.Ajax.submitForm("permissions","_processiPermissionSave.cfm",callbackPermission,errorHandler);
}

function callbackPermission(result){
	mygrid.setUserData(currentRow,"ac_permissions",result);
}

//----------------------------------------------------------------------------
//FUNZIONI GESTIONE ALERTING 
//----------------------------------------------------------------------------
var myColumnsA = new Array();
myColumnsA[0] = "ac_processo";
myColumnsA[1] = "ac_sigla";
myColumnsA[2] = "int_prealert";
myColumnsA[3] = "int_postalert";
myColumnsA[4] = "bl_alert_admin";
myColumnsA[5] = "bl_alert_assegnato";
myColumnsA[6] = "bl_assegnato";


var myColTypeA = new Array();
myColTypeA[0] = "str";
myColTypeA[1] = "str";
myColTypeA[2] = "int";
myColTypeA[3] = "int";
myColTypeA[4] = "int";
myColTypeA[5] = "int";
myColTypeA[6] = "int";

function doOnCellChangedA(stage, rId, cIn, nValue,oValue) {
	//controllo se cella modificata
	currentRow = rId;
	if ( stage == 1 && ( cIn == 4  || cIn == 5 )){
		setValore("id_processo",gridUserData(mygrid,rId,"id_processo"));
		setValore("table_column",myColumnsA[cIn]);
		setValore("column_type",myColTypeA[cIn]);
		var myAuto = mygrid.cells(rId,cIn).getValue();
		if ( myAuto == 1 ){
			setValore("column_value",1);
			setValore("old_value",0);
		} else {
			setValore("column_value",0);
			setValore("old_value",1);
		}	ColdFusion.Ajax.submitForm("updateCell","_processoColumnSave.cfm",callbackSaveColProcesso,errorHandler);
	}
	if ( stage == 2 && ( cIn == 2 || cIn == 3 ) ){
		//alert(nValue);
		setValore("id_processo",gridUserData(mygrid,rId,"id_processo"));
		setValore("table_column",myColumnsA[cIn]);
		setValore("column_type",myColTypeA[cIn]);
		setValore("column_value",nValue);
		setValore("old_value",oValue);
ColdFusion.Ajax.submitForm("updateCell","_processoColumnSave.cfm",callbackSaveAlert,errorHandler);
		//mygrid.cells(rId,cIn).setValue(nValue);
	} 
}

function callbackSaveAlert(result){
	mygrid.clearAndLoad("_alertingXML.cfm");
}
//----------------------------------------------------------------------------
//FUNZIONI GESTIONE QUALIFICAZIONE CLIENTI 
//----------------------------------------------------------------------------
var myColumnsQ = new Array();
myColumnsQ[0] = "id_gruppo";
myColumnsQ[1] = "ac_gruppo";
myColumnsQ[2] = "ac_colore";
myColumnsQ[3] = "ac_icona";

var myColTypeQ = new Array();
myColTypeQ[0] = "int";
myColTypeQ[1] = "str";
myColTypeQ[2] = "str";
myColTypeQ[3] = "str";

function doOnCellChangedQ(stage, rId, cIn, nValue,oValue) {
	//controllo se cella modificata
    if (stage == 2) {
	
        /*if (cIn == 2) {
			//cella color picker
			//cambio colore
			var newColor = mygrid.cells(rId, 2).getValue();
			newColor = newColor.substring(1);
            mygrid.cells(rId, 1).setValue(newColor.toUpperCase());
			setValore("id_gruppo",gridUserData(mygrid,rId,"id_gruppo"));		
			setValore("table_column","ac_colore");
			setValore("column_value",newColor.toUpperCase());
			setValore("old_value",gridUserData(mygrid,rId,"ac_colore"));
			setValore("column_type","str");
        } else {
		*/	
			if ( cIn != 3 ){
				//gestione modifica altre celle
				//imposto i valori per il form
				setValore("id_gruppo",gridUserData(mygrid,rId,"id_gruppo"));		
				setValore("table_column",myColumnsQ[cIn+1]);
				setValore("column_value",mygrid.cells(rId,cIn).getValue());
				setValore("old_value",oValue);
				setValore("column_type",myColTypeQ[cIn+1]);
				mygrid.cells(rId,cIn).setValue(nValue);
			}
		//}
		if ( getValore("column_value") != getValore("old_value") ){
		//avvio salvataggio dati
			//alert(getValore("id_gruppo"));
ColdFusion.Ajax.submitForm("updateCellQ","_qualificaColumnSave.cfm",callbackSaveColQualifica,errorHandler);
    return true }
	} else {
    	return true;
	}
}

//callback di salvataggio processo
function callbackSaveColQualifica(result){
	//alert(result);
	if ( result == 0 ){
		mygrid.clearAndLoad("_qualificaXML.cfm");
	}
	return true;
}

//assegna la row id alla variabile globale currentRow
function doAssegnaRowId(rId,cId){
	
	setHTML("deleteQualBtn",'<img src="../include/css/icons/knobs/page_cross.gif" onclick="deleteQualifica()" align="absmiddle" style="cursor:pointer;" title="Elimina">');
	currentRow = rId;
	//se colonna è l'icona visualizza le icone per la qualifica
	if ( cId == 1 ){
		showObj("icons");
	}
}

//assegna l'icona alla qualifica del contatto
function doAssegnaIcona(icona){
	setValore("id_gruppo",gridUserData(mygrid,currentRow,"id_gruppo"));		
	setValore("table_column",myColumnsQ[3]);
	setValore("column_value",icona);
	setValore("old_value","");
	setValore("column_type",myColTypeQ[3]);
	ColdFusion.Ajax.submitForm("updateCellQ","_qualificaColumnSave.cfm",callbackSaveIcona,errorHandler);
	hideObj("icons");
}

//callback di salvataggio icona
function callbackSaveIcona(result){
	//aggiorna grid
	mygrid.clearAndLoad("_qualificaXML.cfm");
}

function deleteQualifica(){
	setValore("id_gruppo_delete",gridUserData(mygrid,currentRow,"id_gruppo"));
	alert ( getValore("id_gruppo_delete"));
	ColdFusion.Ajax.submitForm("deleteQualifica","_qualificaDelete.cfm",callbackDeleteQ,errorHandler);
}

function callbackDeleteQ(result){
	if ( !result ){
		alert ( "Non e' possibile eliminare questa qualifica perchè attualmente utilizzata nel sistema" );
	} else {
		mygrid.deleteRow(currentRow);
		setHTML("deleteQualBtn","");
	}
}
//error handler
//gestione generale dell'errore coldfusion-ajax
	function errorHandler(code,msg){
		alert("Error !" + code + ":" + msg);
	}
	
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

	<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
	<script src="../include/js/functions.js"></script>
	<script src="status.js"></script>
	
	<!--- GRID --->
	<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxgrid/codebase/dhtmlxgrid.css">
    <link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxgrid/codebase/skins/dhtmlxgrid_dhx_skyblue.css">
    <script src="../include/dhtmlx/dhtmlxgrid/codebase/dhtmlxcommon.js"></script>
    <script src="../include/dhtmlx/dhtmlxgrid/codebase/dhtmlxgrid.js"></script>
    <script src="../include/dhtmlx/dhtmlxgrid/codebase/dhtmlxgridcell.js"></script>
	<script  src="../include/dhtmlx/dhtmlxgrid/codebase/ext/dhtmlxgrid_start.js"></script>
	<!--- 
	<!--- WINDOW --->
	<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxwindows/codebase/dhtmlxwindows.css">
	<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxwindows/codebase/skins/dhtmlxwindows_dhx_skyblue.css">
	<script src="../include/dhtmlx/dhtmlxwindows/codebase/dhtmlxcommon.js"></script>
	<script src="../include/dhtmlx/dhtmlxwindows/codebase/dhtmlxwindows.js"></script>
	<!--- TOOLBAR --->
	<!-- dhtmlxToolbar -->
	<script src="../include/dhtmlx/htmlxToolbar/codebase/dhtmlxtoolbar.js"></script>
	<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxToolbar/codebase/skins/dhtmlxtoolbar_dhx_skyblue.css">
	<script src="../include/dhtmlx/dhtmlxToolbar/codebase/dhtmlxcontainer.js"></script>
	 --->
	<!--- <script>
	var cliente,status_id_processo,status_data,status_processo,status_ora,status_note,status_indirizzo,status_citta,status_telefono,status_cellulare,status_email,processi,agenti;
	var lastRowSelected = -1;
	dhtmlx.skin="dhx_skyblue";
	
	var cliente = document.getElementById("gridboxCLIENTE");
	//agenti= document.getElementById("gridboxAGENTI");
	var processo=document.getElementById("addProcesso");
	
	function doOnRowSelect(idc){
		//statusCliente();
	}
	
	//recupera tutta la cronologia degli eventi dello status di un cliente specifico
	function statusCliente(){
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
		
		//aggiorno scheda dettaglio azione
		setValore("id_status",status_id);
		setValore("id_cliente",idcliente);
		setValore("calInput1",status_data);
		setValore("ac_note",status_note);
		comboSelect("id_processo",status_id_processo);
		comboSelect("ac_ora",status_ora);
		setValore("submitButton","Salva");
		setValore("action","save");
		
		//aggiorno lista azioni del cliente selezionato		
		mygrid2.clearAndLoad("_statusClienteXML.cfm?cliente=" + idcliente);
		document.getElementById("subHeader").innerHTML = "Cliente : <strong>" + cliente +"</strong><img src='../include/css/icons/plus.png' align='absmiddle' hspace='5' style='cursor:pointer' alt='Aggiungi azione' title='Aggiungi azione' onclick='addProcess()'>";

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
		mygrid.cellById(selectedId,5).setValue("<img src='../include/css/icons/future-projects.png'>");
		
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
		mygrid.clearAndLoad("_statusXML.cfm?processo=" + valore);
	}
	
	//aggiunge processo
	function addProcess(){
		//processo.style.display = "";
		setValore("calInput1","");
		setValore("ac_note","");
		setValore("submitButton","Aggiungi");
		setValore("action","add");
		comboSelect("id_processo","");
		comboSelect("ac_ora","");
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
		var search = document.getElementById("searchValue").value;
		mygrid.clearAndLoad("_statusXML.cfm?cliente=" + search);
		document.getElementById("subView").style.display = "none";
	}
	
	
	//recupera dati dell'evento selezionato 
	function getDataStatus(){
		//processo.style.display = "";
		var selectedId = mygrid2.getSelectedRowId();
		var giorno = mygrid2.cellById(selectedId,0).getValue();
		var ora = mygrid2.cellById(selectedId,1).getValue();
		var status_note = mygrid2.getUserData(selectedId,"note");
		var status_id_processo = mygrid2.getUserData(selectedId,"id_processo");
		var status_ac_processo = mygrid2.getUserData(selectedId,"ac_processo");
		setValore("ac_note",status_note);
		comboSelect("id_processo",status_id_processo);
		comboSelect("ac_ora",ora);
		setValore("calInput1",giorno);
		setValore("submitButton","Salva");
		setValore("action","save");
	}
	
	//assegna ad un elemento (parametro elemento) con propriet� value (es. input)
	//il valore passato (paramentro valore)
	function setValore(elemento,valore){
		var obj = document.getElementById(elemento);
		obj.value = valore;
	}
	
	//imposta il selectedIndex di una select (parametro obj) 
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
	
	function toggleHide(elemento){
		var obj = document.getElementById(elemento);
		if ( obj.style.display == "none" ){
			obj.style.display = "";
		} else {
			obj.style.display = "none";
		}
	}
	
	//azzera il valore di un oggetto con propriet� .value (es. input)
	function clearValue(obj){
		obj.value = "";
	}
	</script>
<style>
	input, select, textarea { font-size:11px ; font-family:Tahoma }
	.subHeader { 
		font-family:Tahoma;
		font-size:11px;
		color:black ; 
		padding:4px;  	background-image:url('../include/dhtmlx/dhtmlxgrid/codebase/imgs/sky_blue_grid.gif');
		border : 1px #96c6d3 solid;
	}
	
	html, body {
        width: 100%;
        height: 100%;
        margin: 0px;
		padding:0px;
        overflow: hidden;
		font-size:10px;
    }
	
	.overRow { background:orange; }
	.container { width:100%; height:100%; overflow:hidden; top:0; left:0 ; align:left}
</style> --->

<cfinvoke component="status" method="getProcessi" returnvariable="myProcessi"></cfinvoke>

<body>
<!--- COLONNA SX --->
<table  style="height:100%;margin:0;">
<tr>
	<td valign="top">
	<div class="container">
<!--- 	<div id="headGrid" style="float:left;margin-right:2px"> --->
	<!--- intestazione status --->
	<div id="titleBar" class="panel"><strong>STATUS OPERATIVO</strong></div>
	<!--- ricerca cliente --->
	<div id="searchHeader" class="panel"><cfinclude template="_statusFilter.cfm"></div>

	<!--- grid status --->
	<div id="gridboxSTATUS" style="width:600px;height:90%;float:left;"></div>
	<!------------------->

</div>
<!------------------->
</td>
<!--- COLONNA DX --->
<td valign="top">
<div id="subView" style="position:absolute;display:none;float:left;height:90%;left:615px;width:240px"  class="subHeader">
	<!--- intestazione grid CLIENTI e AGENTI --->
	<div id="subHeader" class="panel"></div>
	<div id="infoCliente" style="height:50px;" class="panel"></div>
	<!--- intestazione Form di aggiornamento / modifica evento --->
	<div id="addProcesso" style="" class="panel">
	<!--- form per l'aggiornamento/inserimento di un nuovo evento nello status --->
	<cfinclude template="_statusAddRow.cfm"></div>
	<!--- grid della cronologia eventi dello status per cliente specifico --->
	<div id="gridboxCLIENTE" style="width:100%;height:50%;display:none"></div>
<!--- 	<!--- grid della lista agenti --->
	<div id="gridboxAGENTI" style="width:240px;height:50%;display:none"></div> --->

</div>
</td>
</tr>
</table>
<!------------------->
</body>
<script>
//inizializza la grid status
mygrid = new dhtmlXGridObject('gridboxSTATUS');
mygrid.setImagePath("../include/dhtmlx/dhtmlxgrid/codebase/imgs/");//path to images required by grid
mygrid.setHeader("Cliente,Ag,Citta,Data,Azione,&raquo;");//set column names
mygrid.setInitWidths("100,100,100,70,*,25");//set column width in px
mygrid.setColAlign("left,left,left,left,left,right");//set column values align
mygrid.setColTypes("ro,ro,ro,ro,ro,ro");//set column types
mygrid.setColSorting("str,str,date,str,str");//set sorting
mygrid.attachEvent("onSelectStateChanged", statusCliente);
mygrid.init();//initialize grid
mygrid.setSkin("dhx_skyblue");//set grid skin
mygrid.load("_statusXML.cfm");

//inizializza la grid della cronologia eventi di un cliente
mygrid2 = new dhtmlXGridObject('gridboxCLIENTE');
mygrid2.setImagePath("../include/dhtmlx/dhtmlxgrid/codebase/imgs/");//path to images required by grid
mygrid2.setHeader("Data,Ora,Azione");//set column names
mygrid2.setInitWidths("70,50,*");//set column width in px
mygrid2.setColAlign("left,left,left");//set column values align
mygrid2.setColTypes("ro,ro,ro");//set column types
mygrid2.setColSorting("str,str,str");//set sorting
mygrid2.attachEvent("onRowDblClicked", getDataStatus);  
mygrid2.init();//initialize grid
mygrid2.setSkin("dhx_skyblue");//set grid skin


//inizializza la grid dell'elenco agenti
/*mygrid3 = new dhtmlXGridObject('gridboxAGENTI');
mygrid3.setImagePath("../include/dhtmlx/dhtmlxgrid/codebase/imgs/");//path to images required by grid
mygrid3.setHeader("ID,Agente");//set column names
mygrid3.setInitWidths("70,*");//set column width in px
mygrid3.setColAlign("left,left");//set column values align
mygrid3.setColTypes("ro,ro");//set column types
mygrid3.setColSorting("int,str");//set sorting
mygrid3.init();//initialize grid
mygrid3.setSkin("dhx_skyblue");//set grid skin
mygrid3.load("_loadAgentiXML.cfm");
*/

</script>
</body>
</html>	 

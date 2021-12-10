<cfinvoke component="status" method="getProcessi" returnvariable="myProcessi"></cfinvoke>
<cfinvoke component="status" method="getModuli" returnvariable="moduli"></cfinvoke>
<!--- COLONNA SX --->
<div class="container" style="height:95%">
<table style="height:100%;margin:0;" border="0">
<tr>
	<td valign="top" class="winblue">
	<!--- <div class="container"> --->
	<!--- intestazione status --->
	<div id="titleBar" class="panel" style="height:20px"><strong>STATUS OPERATIVO</strong></div>
	<!--- ricerca cliente --->
	<div id="searchHeader" class="panel"><cfinclude template="_statusFilter.cfm"></div>
	<!--- grid status --->
	<div id="gridboxSTATUS" style="width:550px;height:90%;float:left;"></div>
	<!------------------->
	<!--- </div> --->
</td>
<!--- COLONNA DX --->
<td valign="top" class="winblue" style="width:250px">
	<div id="subView" class="container" style="height:100%;display:none">
<!--- <div id="subView" style="position:absolute;display:none;float:left;height:400px;left:605px;width:240px"  class="subHeader"> --->
	<!--- intestazione grid CLIENTR  --->
	<div id="subHeader" class="panel" style="height:20px"></div>
	<div id="infoCliente" style="height:65px;" class="winblue"></div>
	<!--- intestazione Form di aggiornamento / modifica evento --->
	<!--- form per l'aggiornamento/inserimento di un nuovo evento --->
	<div id="addProcesso" style="height:200px" class="winblue">
	<cfinclude template="_statusCliente.cfm"></div>
	<!--- grid della cronologia eventi dello status per cliente specifico --->
	<div id="gridboxCLIENTE" style="width:250px;height:250px;display:"></div>
	</div>
</td>
</tr>
</table> 
</div>
<!------------------->
<div id="w1" class="panel" style="position: relative; height: 100%; border: #cecece 1px solid; margin: 10px;display:none"><cfinclude template="_statusDocsUpload.cfm"></div>

<cfwindow width="600" height="450" 
        name="moduloWin" title="Modulo" 
		center="true"
        initshow="false" 
		draggable="true" 
		resizable="true" 
		closable="false" 
        source="_statusModulo.cfm?text={processoFrm:ac_modulo}"/>

<!--- </body> --->

<cfoutput>
<script>
//inizializza la grid status
mygrid = new dhtmlXGridObject('gridboxSTATUS');
mygrid.setImagePath("../include/dhtmlx/dhtmlxgrid/codebase/imgs/");//path to images required by grid
mygrid.setHeader("Cliente,Citta,Indirizzo,Data,Azione,&raquo;");//set column names
mygrid.setInitWidths("100,100,100,70,*,25");//set column width in px
mygrid.setColAlign("left,left,left,left,left,right");//set column values align
mygrid.setColTypes("ro,ro,ro,ro,ro,ro");//set column types
mygrid.setColSorting("str,str,str,date,str,str");//set sorting
mygrid.attachEvent("onSelectStateChanged", statusCliente);
mygrid.init();//initialize grid
mygrid.setSkin("dhx_skyblue");//set grid skin
<cfif IsDefined("url.idcliente") IS FALSE>
	mygrid.load("_statusAgenteXML.cfm");
<cfelse>
	mygrid.load("_statusAgenteXML.cfm?id_cliente=#url.idcliente#");
	setValore("searchValue","#url.cognome#");
</cfif>
mygrid.attachEvent("onXLE", doOnRebuild);

//inizializza la grid della cronologia eventi di un cliente
mygrid2 = new dhtmlXGridObject('gridboxCLIENTE');
mygrid2.setImagePath("../include/dhtmlx/dhtmlxgrid/codebase/imgs/");//path to images required by grid
mygrid2.setHeader("&raquo;,Data,Ora,Azione");//set column names
mygrid2.setInitWidths("*,60,45,120");//set column width in px
mygrid2.setColAlign("left,left,left,left");//set column values align
mygrid2.setColTypes("ro,ro,ro,ro");//set column types
mygrid2.setColSorting("str,str,str,str");//set sorting
mygrid2.attachEvent("onSelectStateChanged", getDataStatus);
mygrid2.attachEvent("onRowDblClicked", getDataStatus);  
mygrid2.init();//initialize grid
mygrid2.setSkin("dhx_skyblue");//set grid skin

var dhxWins , w1;
dhxWins = new dhtmlXWindows();
	dhxWins.enableAutoViewport(true);
    dhxWins.attachViewportTo("w1");
    dhxWins.setImagePath("../include/dhtmlx/dhtmlxwindows/codebase/imgs/");
</script>
</cfoutput>
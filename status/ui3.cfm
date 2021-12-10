<cfinvoke component="status" method="getProcessi" returnvariable="myProcessi"></cfinvoke>
<cfinvoke component="status" method="getModuli" returnvariable="moduli"></cfinvoke>
<cfinvoke component="status" method="getAgenti" returnvariable="qryAgenti"></cfinvoke>
<cfinvoke component="status" method="getGruppiAgenti" returnvariable="qryGruppi"></cfinvoke>
<cfparam name="url.start" default=0>
	<!--- LAYOUT APPLICAZIONE --->
	<link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxlayout.css">
    <link rel="stylesheet" type="text/css" href="../include/dhtmlx/dhtmlxLayout/codebase/skins/dhtmlxlayout_dhx_skyblue.css">
	<title>SAVSales @ SAVEnergy - Status</title>
    <script src="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxcommon.js"></script>
    <script src="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxcontainer.js"></script>
    <script src="../include/dhtmlx/dhtmlxLayout/codebase/dhtmlxlayout.js"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js" type="text/javascript"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js" type="text/javascript"></script>
	<script language="JavaScript" type="text/javascript">
function doOnLoad(){
var dhxLayout=new dhtmlXLayoutObject(document.body,"3L");
//cell a (top)
dhxLayout.items[0].setWidth(600);
dhxLayout.items[0].hideHeader();
dhxLayout.cells("a").setText("Status Operativo");
dhxLayout.cells("a").attachObject("leftPanel");

//cell b (sidebar)
dhxLayout.items[1].setWidth(280);
dhxLayout.items[1].hideHeader();
dhxLayout.cells("b").attachObject("rightPanel");
dhxLayout.cells("b").setText("right");

dhxLayout.items[2].setWidth(280);
dhxLayout.items[2].hideHeader();
dhxLayout.cells("c").attachObject("rightBottom");
dhxLayout.cells("c").setText("right");

dhxLayout.setEffect("collapse",true);

//dhxLayout.cells("a").fixSize(true, true);
//dhxLayout.cells("b").fixSize(true, true);


dhxLayout.setAutoSize("a;b;c","b;c;a");
}
</script>
<style>
	.blu { background:#dfdfff; }
</style>
<div id="leftPanel" class="blu" style="height:100%;margin:0px;padding:5px">
	<div id="filtroView"><cfinclude template="_statusFilter.cfm"></div>
	<div id="status" style="display:;margin-bottom:5px;width:99%;border:0px solid #0099cc;"></div>
	<div id="dummy" style="height:100%;">SAVEnergy Status</div>
</div>
<div id="rightPanel" class="blu" style="height:100%;border:0px solid black">
	<div id="subView" class="blu" style="overflow:auto">
		<div class="winhead"><strong>Dettaglio Cliente</strong> <span id="printDetail"></span></div>
		<div id="subHeader" style="height:15px"></div>
		<div id="infoCliente" style="height:60px;"></div>
		<!--- intestazione Form di aggiornamento / modifica evento --->
		<!--- form per l'aggiornamento/inserimento di un nuovo evento --->
		<div id="addProcesso" style="overflow:auto" class="blu">
		<cfinclude template="_statusCliente.cfm">
		</div>
	</div>
</div>
<div id="rightBottom" class="blu">
	<div id="gridboxCLIENTE" style="height:100%;display:;"></div>
</div>
<div id="w1" class="wiblue" style="position: relative; height: 100%; border: #cecece 1px solid; margin: 10px;display:none"><cfinclude template="_statusDocsUpload.cfm"></div>
<cfinclude template="_statusQualifica.cfm">

<cfwindow width="600" height="450" 
        name="moduloWin" title="Modulo" 
		center="true"
        initshow="false" 
		draggable="true" 
		resizable="true" 
		closable="false" 
        source="_statusModulo.cfm?text={processoFrm:ac_modulo}"/>


<cfoutput>
<script>
function date_custom(a,b,order){ 
		alert (a);
            a=a.split("/")
            b=b.split("/")
            if (a[2]==b[2]){
                if (a[1]==b[1])
                    return (a[0]>b[0]?1:-1)*(order=="asc"?1:-1);
                else
                    return (a[1]>b[1]?1:-1)*(order=="asc"?1:-1);
            } else
                 return (a[2]>b[2]?1:-1)*(order=="asc"?1:-1);
        }

//inizializza la grid status
mygrid = new dhtmlXGridObject('status');
mygrid.setImagePath("../include/dhtmlx/dhtmlxGrid/codebase/imgs/");//path to images required by grid
<cfif session.livello NEQ 3 OR StructFind(session.userlogin,"gruppi_controllo") NEQ "">
	mygrid.setHeader("&raquo;,Cliente,Agente,Citt�,Data,Azione,&raquo;");//set column names
<cfelse>
	mygrid.setHeader("&raquo;,Cliente,Indirizzo,Citt�,Data,Azione,&raquo;");//set column names	
</cfif>
mygrid.enableAutoHeight(true);
mygrid.enableAutoWidth(false);
mygrid.setInitWidths("25,150,100,100,70,*,5");//set column width in px
mygrid.setColAlign("left,left,left,left,left,left,left");//set column values align
mygrid.setColTypes("img,ro,ro,ro,ro,ro,img");//set column types
//mygrid.setColSorting("img,str,str,str,date_custom,str,str,str");//set sorting
//mygrid.attachEvent("onSelectStateChanged", statusCliente);
mygrid.enableResizing("false,false,false,false,false,false,false");
mygrid.attachEvent("onRowSelect" , statusCliente );
mygrid.init();//initialize grid
mygrid.setSkin("dhx_skyblue");//set grid skin
<cfif IsDefined("url.idcliente") IS FALSE>
	mygrid.load("_statusXML.cfm");
<cfelse>
	mygrid.load("_statusXML.cfm?idcliente=#url.idcliente#");
	//setValore("searchValue","#url.cognome#");
</cfif>
mygrid.attachEvent("onXLE", doOnRebuild);

//inizializza la grid della cronologia eventi di un cliente
mygrid2 = new dhtmlXGridObject('gridboxCLIENTE');
mygrid2.setImagePath("../include/dhtmlx/dhtmlxGrid/codebase/imgs/");//path to images required by grid
mygrid2.setHeader("Data,Ora,Azione,id");//set column names
mygrid2.setInitWidths("80,45,*,1");//set column width in px
mygrid2.setColAlign("left,left,left,left");//set column values align
mygrid2.setColTypes("ro,ro,ro,ro");//set column types
mygrid2.setColSorting("str,str,str,str");//set sorting
mygrid2.attachEvent("onSelectStateChanged", getDataStatus);
mygrid2.attachEvent("onRowDblClicked", getDataStatus);  
mygrid2.init();//initialize grid
mygrid2.setSkin("dhx_skyblue");//set grid skin
mygrid2.enableAutoHeight(true);
mygrid2.enableAutoWidth(false);

var dhxWins , w1;
dhxWins = new dhtmlXWindows();
	dhxWins.enableAutoViewport(true);
    dhxWins.attachViewportTo("w1");
    dhxWins.setImagePath("../include/dhtmlx/dhtmlxwindows/codebase/imgs/");

	
var aProcesso_Gerarchia = new Array();	
<cfset np = 0>
<cfloop query="myProcessi">
	<cfif StructFind(session.userlogin,"livello") GT 0>
		<cfset permission = ListGetAt(ac_permissions,livello)>
		<cfif permission EQ 1>
			aProcesso_Gerarchia[#np#] = "#int_gerarchia#";
			<cfset np = np + 1>
		</cfif>
	<cfelse>	
		aProcesso_Gerarchia[#np#] = "#int_gerarchia#";
		<cfset np = np + 1>
	</cfif>
</cfloop>	
	
var aProcesso_Tipo = new Array();	
<cfset np = 0>
<cfloop query="myProcessi">
	<cfif StructFind(session.userlogin,"livello") GT 0>
		<cfset permission = ListGetAt(ac_permissions,livello)>
		<cfif permission EQ 1>
			aProcesso_Tipo[#np#] = "#int_tipo#";
			<cfset np = np + 1>
		</cfif>
	<cfelse>	
		aProcesso_Tipo[#np#] = "#int_tipo#";
		<cfset np = np + 1>
	</cfif>
</cfloop>


var aProcesso_Timer = new Array();	
<cfset np = 0>
<cfloop query="myProcessi">
	<cfif StructFind(session.userlogin,"livello") GT 0>
		<cfset permission = ListGetAt(ac_permissions,livello)>
		<cfif permission EQ 1>
			aProcesso_Timer[#np#] = "#int_timer_limit#";
			<cfset np = np + 1>
		</cfif>
	<cfelse>	
		aProcesso_Timer[#np#] = "#int_timer_limit#";
		<cfset np = np + 1>
	</cfif>
</cfloop>

	
var aModuli = new Array();
<cfset np = 0>
<cfloop query="myProcessi">
	<cfif StructFind(session.userlogin,"livello") GT 0>
		<cfset permission = ListGetAt(ac_permissions,livello)>
		<cfif permission EQ 1>
			aModuli[#np#] = "#ac_modulo#";
			<cfset np = np + 1>
		</cfif>
	<cfelse>	
		aModuli[#np#] = "#ac_modulo#";
		<cfset np = np + 1>
	</cfif>
</cfloop>

var aValore = new Array();
<cfset np = 0>
<cfloop query="myProcessi">
	<cfif StructFind(session.userlogin,"livello") GT 0>
		<cfset permission = ListGetAt(ac_permissions,livello)>
		<cfif permission EQ 1>
			aValore[#np#] = #int_tipo#;
			<cfset np = np + 1>
		</cfif>
	<cfelse>	
		aValore[#np#] = #int_tipo#;
		<cfset np = np + 1>
	</cfif>
</cfloop>


var aDocumenti = new Array();
<cfset np = 0>
<cfloop query="myProcessi">
	<cfif StructFind(session.userlogin,"livello") GT 0>
		<cfset permission = ListGetAt(ac_permissions,livello)>
		<cfif permission EQ 1>
			aDocumenti[#np#] = #bl_documento#;
			<cfset np = np + 1>
		</cfif>
	<cfelse>	
		aDocumenti[#np#] = #bl_documento#;
		<cfset np = np + 1>
	</cfif>
</cfloop>

doOnLoad();
</script>
</cfoutput>

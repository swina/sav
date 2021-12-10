<cfinvoke component="status" method="getProcessi" returnvariable="myProcessi"></cfinvoke>
<cfinvoke component="status" method="getModuli" returnvariable="moduli"></cfinvoke>
<cfinvoke component="status" method="getAgenti" returnvariable="qryAgenti"></cfinvoke>
<cfinvoke component="status" method="getGruppiAgenti" returnvariable="qryGruppi"></cfinvoke>
<cfif IsDefined("session.debug") IS FALSE>
	<cfset session.debug = false>
</cfif>
<input type="hidden" name="debug" id="debug" value="<cfoutput>#session.debug#</cfoutput>">
<cfparam name="url.start" default=0>
 <!--- COLONNA SX --->
<div class="container" style="height:98%;width:98%;border:0 solid red; overflow:auto">
<table style="width:900px;height:99%;margin-bottom:10px;overflow:auto" border="0">
<tr>
	<td valign="top" style="height:100%;width:600px;" class="winblue">
	<!--- <div class="container"> --->
	<!--- intestazione status --->
	<!--- <div id="titleBar" class="panel" style="height:20px"><strong>STATUS OPERATIVO</strong></div> --->
	<!--- ricerca cliente --->
	<div id="searchHeader" class="winblue" style="height:85%;width:600px;margin:0;padding:0"><cfinclude template="_statusFilter.cfm">
	<!--- grid status --->
	<div id="gridboxSTATUS" style="width:100%;height:89%;overflow:auto"></div>
	
	</div>
	<!------------------->
	<!--- </div> --->
</td>
<!--- COLONNA DX --->
<td valign="top" style="height:300px;width:250px;padding-right:10px" class="winblue">
		<div id="subView" class="container" style="padding-right:10px;width:250px;height:99%;display:;overflow:auto">
		<!--- intestazione grid CLIENTR  --->
		<div style="height:55%">
		<div class="winhead"><strong>Dettaglio Cliente</strong><span id="printDetail"></span></div>
		<div id="subHeader" style="height:15px"></div>
		<div id="infoCliente" style="height:40px;"></div>
		<!--- intestazione Form di aggiornamento / modifica evento --->
		<!--- form per l'aggiornamento/inserimento di un nuovo evento --->
		<div id="addProcesso" style="overflow:auto" class="winblue">
		<cfinclude template="_statusCliente.cfm">
		</div>
		</div>
		<!--- grid della cronologia eventi dello status per cliente specifico --->
		<div id="gridboxCLIENTE" style="height:200px;display:;"></div>
	 </div>
	
</td>
</tr>
</table>
<input type="hidden" id="remote_addr" value="<cfoutput>#remote_addr#</cfoutput>">
</div>
<!------------------->
<div id="w1" class="wiblue" style="position: relative; height: 100%; border: #cecece 1px solid; margin: 10px;display:none"><cfinclude template="_statusDocsUpload.cfm"></div>
<cfinclude template="_statusQualifica.cfm">

<cfwindow width="600" height="550" 
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
mygrid = new dhtmlXGridObject('gridboxSTATUS');
mygrid.setImagePath("../include/dhtmlx/dhtmlxgrid/codebase/imgs/");//path to images required by grid
<cfif session.livello NEQ 3 OR StructFind(session.userlogin,"gruppi_controllo") NEQ "">
	mygrid.setHeader("&raquo;,Cliente,Agente,Citt�,Data,Azione,&raquo;");//set column names
<cfelse>
	mygrid.setHeader("&raquo;,Cliente,Indirizzo,Citt�,Data,Azione,&raquo;");//set column names	
</cfif>
mygrid.setInitWidths("25,150,100,100,70,*,25");//set column width in px
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
mygrid2.setImagePath("../include/dhtmlx/dhtmlxgrid/codebase/imgs/");//path to images required by grid
mygrid2.setHeader("Data,Ora,Azione,id");//set column names
mygrid2.setInitWidths("80,45,*,1");//set column width in px
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

</script>
</cfoutput>
<!--- </body>
</html>	 
 --->
<cfajaximport>
<cfinvoke component="clienti" method="getAgenti" returnvariable="agentiQry"></cfinvoke>
<cfinvoke component="clienti" method="getImportati" returnvariable="nrNuoviContatti"></cfinvoke>
<table style="width:100%;height:94%;margin:0;">
	<tr>
		<td valign="top">
		<div class="container">
		<div id="statusBar" class="winblue" style="width:100%;height:25px"><div class="winhead"><strong>Contatti</strong>&nbsp;<img src="../include/css/icons/altre/001_01.png" align="absmiddle" style="cursor:pointer" alt="Aggiungi Contatto" title="Aggiungi Contatto" onclick="addAnagrafica()"><cfif session.livello LT 2>&nbsp;<img src="../include/css/icons/altre/001_02.png" align="absmiddle" style="cursor:pointer" alt="Elimina Contatto" title="Elmina Contatto" onclick="deleteAnagrafica()"></cfif><cfif session.livello LT 2><cfif nrNuoviContatti GT 0>[<strong><cfoutput>#nrNuoviContatti# nuovi contatti importati</cfoutput></strong>] <input type="button" class="btn" value="Vedi Importati" onclick="vediNuoviContatti()"> <input type="button" class="btn" value="Vedi Contatti" onclick="reloadClienti()"></cfif></cfif><input type="button" class="btn" value="Excel" onclick="printClienti()" title="Esporta in Excel"></div></div>
<div id="gridbox" style="width:100%;height:83%;margin:0px"></div>
<div id="statusBar" class="panel" style="width:100%;height:25px"><cfinclude template="_clientiGridPaging.cfm"></div>
		</div>
	</td>
	</tr>
</table>
<div id="w1" class="winblue" style="position: relative; width:100%; height: 100%; border: #cecece 1px solid; margin: 10px;display:none"><cfinclude template="_clientiForm.cfm"></div>
<div style="display:none">
<form id="deleteFrm">
	<input type="hidden" name="id_cliente_delete" id="id_cliente_delete">
</form>
</div>
<!--- <iframe id="hiddenFrame" name="hiddenFrame"></iframe> --->
<cfoutput>
<script>
mygrid = new dhtmlXGridObject('gridbox');
mygrid.setImagePath("../include/dhtmlx/dhtmlxgrid/codebase/imgs/");//path to images required by grid
mygrid.setHeader("Rag.Sociale , Fornitore, Indirizzo, Citt�,Prov,&raquo;,Q");//set column names
mygrid.setInitWidths("150,100,200,150,40,30,30");//set column width in px
mygrid.setColAlign("left,left,left,left,left,center,left");//set column values align 	
mygrid.setColTypes("ro,ro,ro,ro,ro,img,img");//set column types
mygrid.setColSorting("str,str,str,str,str,str,str");//set sorting
//mygrid.setDateFormat("%d/%m/%Y")
mygrid.init();//initialize grid
mygrid.setSkin("dhx_skyblue");//set grid skin
//mygrid.load("_clientiXML.cfm?startpage=0&search=");
startPage();
mygrid.enableMultiselect(true);
mygrid.attachEvent("onRowSelect" , doOnCellSelect);
mygrid.attachEvent("onRowDblClicked" , doOnRowSelect);
mygrid.attachEvent("onEnter", doOnRowSelect);
mygrid.attachEvent("onXLE", doSelectFirstRow);
mygrid.attachEvent("onKeyPress" , doKeyPress );

var dhxWins , w1;
dhxWins = new dhtmlXWindows();
	dhxWins.enableAutoViewport(true);
    dhxWins.attachViewportTo("w1");
    dhxWins.setImagePath("../include/dhtmlx/dhtmlxwindows/codebase/imgs/");
</script>
</cfoutput>

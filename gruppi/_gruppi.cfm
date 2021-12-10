<div class="container" style="width:100%;height:95%">
<table style="width:100%;height:95%;margin:0;" border="0">
	<tr>
		<td valign="top">
		<div class="winblue" style="width:100%;overflow:auto"><div class="winhead"><strong>Gruppi</strong> <img src="../include/css/icons/altre/001_01.png" align="absmiddle" onclick="addGruppo()" style="cursor:pointer;" title="Aggiungi Gruppo"><img src="../include/css/icons/altre/001_02.png" align="absmiddle" onclick="deleteGruppo()" style="cursor:pointer;" title="Elimina Gruppo"></div></div>
		<div id="gridbox" style="width:100%;height:150px"></div>
		<div class="winblue" style="width:100%;overflow:auto"><div class="winhead"><strong>Utenti</strong><span id="userTools" style="display:none"> <img src="../include/css/icons/altre/001_01.png" align="absmiddle" onclick="addUtente()" title="Aggiungi utente" style="cursor:pointer"><img src="../include/css/icons/altre/001_02.png" align="absmiddle" onclick="deleteUtente()" title="Elimina Utente" style="cursor:pointer"></span></div></div>
		<div id="gridboxUTENTI" style="width:100%;height:65%"></div>
		</td>
		<td><div id="error"></div></td>
	</tr>
</table>
<div id="u1" class="winblue" style="display:none"><cfinclude template="_gruppiFrm.cfm"></div>
<div id="u2" class="winblue" style="display:none"><cfinclude template="_gruppiUtenteFrm.cfm"></div>
<cfform id="enableUtente">
	<input type="hidden" name="id_utente_enable" id="id_utente_enable">
	<input type="hidden" name="bl_cancellato" id="bl_cancellato">
</cfform>
</div>
<script>
mygrid = new dhtmlXGridObject('gridbox');
mygrid.selMultiRows = true;
mygrid.imgURL = "../include/dhtmlx/dhtmlxGrid/codebase/imgs/icons_greenfolders/";
mygrid.setHeader("Gruppo");
mygrid.setColTypes("ro");
mygrid.setColAlign("left");//set column values align 	
mygrid.setColSorting("str");
mygrid.init();
mygrid.setSkin("dhx_skyblue");
mygrid.load("_gruppiXML.cfm");
mygrid.attachEvent("onSelectStateChanged", getUtenti);
mygrid.attachEvent("onRowDblClicked", getGruppo);
//mygrid.attachEvent("onRowSelect" , getUtenti );
mygrid.attachEvent("onXLE", doSelectRow);


//inizializza la grid della cronologia eventi di un cliente
mygrid2 = new dhtmlXGridObject('gridboxUTENTI');
mygrid2.setImagePath("../include/dhtmlx/dhtmlxGrid/codebase/imgs/");//path to images required by grid
mygrid2.setHeader("Cognome,Nome,Email,Clienti,LOGIN,Password,Sospeso,Assegnazione");//set column names
mygrid2.setInitWidths("100,100,250,50,80,80,80,*");//set column width in px
mygrid2.setColAlign("left,left,left,right,left,left,left,left");//set column values align
mygrid2.setColTypes("ro,ro,ro,ro,ro,ro,ch,ed");//set column types
mygrid2.setColSorting("str,str,str,int,str,str,str,str");//set sorting
mygrid2.attachEvent("onRowDblClicked", getUtente);
mygrid2.attachEvent("onCheck", getEnabled);
mygrid2.attachEvent("onRowSelect" , selectUtente );
//mygrid2.attachEvent("onRowDblClicked", getDataStatus);  
mygrid2.init();//initialize grid
mygrid2.setSkin("dhx_skyblue");//set grid skin
mygrid2.attachEvent("onXLE", doSelectRow);

var dhxWins , w1, w2;
dhxWins = new dhtmlXWindows();
	dhxWins.enableAutoViewport(true);
    dhxWins.attachViewportTo("w1");
    dhxWins.setImagePath("../include/dhtmlx/dhtmlxwindows/codebase/imgs/");
</script>

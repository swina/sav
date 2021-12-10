
	
<!--- <div class="container" style="width:100%;height:95%"> --->
<table style="width:100%;height:95%;margin:0;" border="0" cellpadding="2" cellspacing="0">
	<tr>
		<td style="width:250px" valign="top" class="winblue" width="250">
		<cfinclude template="_analisi_periodo.cfm">
		</td>
		<td valign="top">
		<div class="winhead"><strong>Riepilogo</strong></div>
		<div id="gridbox" style="width:100%;height:210px"></div>
		<div class="winhead"><strong>Dettaglio</strong></div>
		<div id="gridboxDetail" style="height:310px;width:100%;"></div>
		</td>
	</tr>
<!--- 	<tr>
		<td></td>
		<td valign="top">
		<div id="gridboxDetail" style="height:300px;width:100%;"></div>
		</td>
	</tr> --->
</table>
<!--- </div> --->

<script>
mygrid = new dhtmlXGridObject('gridbox');
mygrid.selMultiRows = true;
mygrid.imgURL = "../include/dhtmlx/dhtmlxGrid/codebase/imgs/icons_greenfolders/";
mygrid.setHeader("Processo,Nr.,GG,IPA,IPMG");
mygrid.setInitWidths("150,60,60,60,*");
mygrid.setColTypes("ro,ro,ro,ro,ro");
mygrid.setColAlign("left,center,center,left,left");//set column values align 	
mygrid.setColSorting("str,int,int,int,int");
mygrid.init();
mygrid.setSkin("dhx_skyblue");
mygrid.load("_analisi_processiXML.cfm");
//mygrid.attachEvent("onXLE", doAnalisiDetail);
//mygrid.attachEvent("onSelectStateChanged", getUtenti);
//mygrid.attachEvent("onRowDblClicked", getGruppo);

mygrid2 = new dhtmlXGridObject('gridboxDetail');
mygrid2.imgURL = "../include/dhtmlx/dhtmlxGrid/codebase/imgs/icons_greenfolders/";
mygrid2.setHeader("Agente,Processo,Nr.,GG,IPA,IPMG");
mygrid2.setInitWidths("150,150,60,60,60,*");
mygrid2.setColTypes("ro,ro,ro,ro,ro,ro");
mygrid2.setColAlign("left,left,center,center,left,left");//set column values align 	
mygrid2.setColSorting("str,str,int,int,int,int");
mygrid2.init();
mygrid2.setSkin("dhx_skyblue");
mygrid2.load("_analisi_processi_detailXML.cfm");


</script>

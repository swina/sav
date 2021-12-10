
<table width="100%">
	<tr>
		<td width="250" valign="top">
		<div class="winblue">
			<cfinclude template="_statistiche_periodo.cfm">
		</div>
		</td>
		<td>
			<table width="100%">
				<tr>
				<td>
				<iframe name="statistica" id="statistica" width="100%" height="400" marginwidth="0" marginheight="0" align="left" scrolling="yes" frameborder="0" style="background:white;overflow:auto"></iframe>
				</td>
				</tr>
				<tr>
				<td>
				<iframe name="detailFrame" id="detailFrame" width="100%" height="800" marginwidth="0" marginheight="0" align="left" scrolling="yes" frameborder="0" style="display:none;overflow:auto;background-color:white"></iframe>
				</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<!--- <div style="float:left;width:20%">
	<div class="winblue">
	<cfinclude template="_statistiche_periodo.cfm">
	</div>
</div>
<div style="float:left;width:80%">
	<div style="width:100%;overflow:auto;">
	<div class="winhead"><strong>Riepilogo</strong></div>
	<iframe name="statistica" id="statistica" width="100%" height="400" marginwidth="0" marginheight="0" align="left" scrolling="yes" frameborder="0" style="background:white;overflow:auto"></iframe>
	</div>
	<div style="width:100%;overflow:auto;">
	<div class="winhead"><strong>Dettaglio</strong></div>
	<iframe name="detailFrame" id="detailFrame" width="100%" height="800" marginwidth="0" marginheight="0" align="left" scrolling="yes" frameborder="0" style="display:none;overflow:auto;"></iframe>
	</div>
</div>
</div> --->
	<!--- 
<!--- <div class="container" style="width:100%;height:95%"> --->
<table style="width:95%;margin:0;overflow:auto" border="0" cellpadding="2" cellspacing="0">
	<tr>
		<td style="width:250px" valign="top" width="250">
		<cfinclude template="_statistiche_periodo.cfm">
		</td>
		<td valign="top" style="overflow:auto">
		
		<div class="winhead"><strong>Riepilogo</strong></div>
		<iframe name="statistica" id="statistica" width="100%" height="400" marginwidth="0" marginheight="0" align="left" frameborder="0" style="background:white;overflow:auto"></iframe>
		</div>
		<div class="winhead"><strong>Dettaglio</strong></div>
		<div style="overflow:auto">
		<iframe name="detailFrame" id="detailFrame" width="100%" height="800" marginwidth="0" marginheight="0" align="left" scrolling="yes" frameborder="0" style="display:none;overflow:auto;"></iframe>
		</div>
		<!--- <div id="gridboxDetail" style="height:310px;width:100%;"></div> --->
		</td>
	</tr>
<!--- 	<tr>
		<td></td>
		<td valign="top">
		<div id="gridboxDetail" style="height:300px;width:100%;"></div>
		</td>
	</tr> --->
</table> --->
<!--- <script>
mygrid = new dhtmlXGridObject('gridbox');
mygrid.selMultiRows = true;
mygrid.imgURL = "../include/dhtmlx/dhtmlxGrid/codebase/imgs/icons_greenfolders/";
mygrid.setHeader("&raquo;,Processo,Totale,%amp;,&raquo;,Clienti SAV,Clienti Fornitori,Totale Clienti,&raquo;");
mygrid.setInitWidths("20,150,60,60,120,60,60,60,*");
mygrid.setColTypes("img,ro,ro,ro,img,ro,ro,ro,img");
mygrid.setColAlign("left,left,right,right,left,left,left,left");//set column values align 	
mygrid.init();
mygrid.setSkin("dhx_skyblue");
mygrid.load("_statisticheXML.cfm");
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
//mygrid2.load("_analisi_processi_detailXML.cfm");


</script> --->
<div class="winblue" style="height:100%;width:100%;overflow:auto">
<table style="width:100%;height:95%;margin:0;" border="0">
	<tr id="planXMLView" style="display:">
		<td style="width:250px" valign="top" class="winblue" width="250">
		<cfinclude template="_plan_periodo.cfm">
		</td>
		<td valign="top">
		<div id="gridbox" style="width:100%;height:100%;overflow:auto;"></div>
		</td>
		
	</tr>
	<tr id="detailCliente" style="display:none">
		<td colspan="2" valign="top">
		<iframe name="detail" id="detail" width="100%" height="100%" marginwidth="0" marginheight="0" frameborder="0" style="display:"></iframe>
		</td>
	</tr>
</table>
</div>
<script>
mygrid = new dhtmlXGridObject('gridbox');
mygrid.selMultiRows = true;
mygrid.imgURL = "../include/dhtmlx/dhtmlxgrid/codebase/imgs/icons_greenfolders/";
mygrid.setHeader("Processo,Data,Ora,Agente,Cliente,Fornitore,&raquo;,&raquo;");
mygrid.setInitWidths("150,80,80,120,150,100,*,*");
mygrid.setColTypes("ro,ro,ro,ro,ro,ro,img,coro");
mygrid.setColAlign("left,left,left,left,left,left,left,left");//set column values align 	
//mygrid.setColSorting("str,str,str,str,str,str,str");
mygrid.enableResizing("false,false,false,false,false,false,false,false");
mygrid.init();
//mygrid.attachEvent("onRowSelect" , doSelectRow );
mygrid.attachEvent("onAfterUpdate" , doOnCellChanged);
mygrid.attachEvent("onEditCell", doOnCellChanged);
mygrid.attachEvent("onRowDblClicked", doDettaglioCliente);  
mygrid.setSkin("dhx_skyblue");
mygrid.load("_planXML.cfm");
</script>
<cfajaximport>
<form id="assegnaFrm">
	<input type="hidden" name="id_status_assegna" id="id_status_assegna">
	<input type="hidden" name="id_persona_assegna" id="id_persona_assegna">
</form>
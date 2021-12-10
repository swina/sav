<cfinvoke component="status" method="getProcessi" returnvariable="myProcessi"></cfinvoke>
<cfinvoke component="status" method="getModuli" returnvariable="moduli"></cfinvoke>
<cfinvoke component="status" method="getAgenti" returnvariable="qryAgenti"></cfinvoke>
<cfinvoke component="status" method="getGruppiAgenti" returnvariable="qryGruppi"></cfinvoke>
 <!--- COLONNA SX --->
<div style="height:95%;">
	<div id="searchHeader" class="winblue" style="height:95%;width:100%;margin:0;padding:0"><cfinclude template="_statusFilter.cfm">
	<!--- grid status --->
	<div id="gridboxSTATUS" style="width:100%;height:95%;"></div></div>
</div>
<!------------------->


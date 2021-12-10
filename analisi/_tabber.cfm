<cfset livello = StructFind(session.userlogin,"livello")>
<div id="analisi_tabbar" class="dhtmlxTabBar" imgpath="../include/dhtmlx/dhtmlxTabbar/codebase/imgs/" style="width:100%; height:100%;"  skinColors="#FCFBFC,#F4F3EE" hrefmode="iframe">

	<div id="a1" name="INDICI OPERATIVI" href="_analisi.cfm">Indici Operativi</div>
	<div id="a2" name="PLAN" href="../tools/_plan.cfm">Plan</div>
	
</div>
<script>
dhtmlx.skin = "dhx_skyblue";
</script>
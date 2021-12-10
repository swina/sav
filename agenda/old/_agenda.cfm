<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<script src="../include/js/functions.js" type="text/javascript"></script>
	<link rel="stylesheet" href="../include/css/style.css" type="text/css">
	<script src="../include/dhtmlx/dhtmlxScheduler/codebase/dhtmlxscheduler.js" type="text/javascript" charset="utf-8"></script>
	<script src="../include/dhtmlx/dhtmlxScheduler/sources/locale_it.js" type="text/javascript" charset="utf-8"></script>
	<link href="../include/dhtmlx/dhtmlxScheduler/codebase/dhtmlxscheduler.css" rel="stylesheet" type="text/css" charset="ISO-8859-1">
	<script src="../include/dhtmlx/dhtmlxScheduler/codebase/ext/dhtmlxscheduler_agenda_view.js"></script>
   <link rel="stylesheet" href="../include/dhtmlx/dhtmlxScheduler/codebase/ext/dhtmlxscheduler_ext.css" type="text/css">
	<script src="../include/dhtmlx/dhtmlxScheduler/codebase/ext/dhtmlxscheduler_serialize.js"></script>
	<title>Agenda</title>
</head>
<cfinvoke component="agenda" method="events" returnvariable="rsEvents"></cfinvoke>
<body>
<div class="winhead"><strong>Agenda</strong> &nbsp; 
<input type="checkbox" id="bl_soloagente" name="bl_soloagente" onclick="reloadAgenda(this)"> solo i miei contatti <!--- | <input type="button" class="btn" value="Esporta in Outlook" onclick="exportToiCal()"><textarea id="iCal" style="width:500px;height:300px;display:none"></textarea> ---></div>
<div id="calendar" class="dhx_cal_container" style='width:100%; height:80%;overflow:auto'>
		<div class="dhx_cal_navline">
			<div class="dhx_cal_prev_button">&nbsp;</div>
			<div class="dhx_cal_next_button">&nbsp;</div>
			<div class="dhx_cal_today_button"></div>
			<div class="dhx_cal_date"></div>
		  	<div class="dhx_cal_tab" id="agenda_tab" name="agenda_tab" style="right:280px;"></div>
			<div class="dhx_cal_tab" name="day_tab" style="right:204px;"></div>
			<div class="dhx_cal_tab" name="week_tab" style="right:140px;"></div>
			<div class="dhx_cal_tab" name="month_tab" style="right:76px;"></div>
		</div>
		<div class="dhx_cal_header">
		</div>
		<div class="dhx_cal_data">
		</div>		
	</div>
</div>

</body>
<script>
scheduler.init('calendar',null,"agenda");
//scheduler.config.xml_date="%Y-%m-%d %H:%i";
//scheduler.config.default_date="%d-%m-%Y";

//var loader = new dtmlXMLLoaderObject();
//loader.xmlDoc = "_agendaXML.cfm";
//scheduler.on_load(loader);
scheduler.config.readonly = false;
scheduler.locale.labels.agenda_tab = "To Do";
scheduler.templates.event_text=function(start,end,event){
   return "<b> "+event.text+"</b><br>"+event.details;
  }
  
scheduler.load("_agendaXML.cfm");

function reloadAgenda(obj){
	
	var soloagente = 0;
	if ( obj.checked ){
		soloagente = 1;
	}
	scheduler.clearAll();
	scheduler.load("_agendaXML.cfm?soloagente=" + soloagente);
}

function exportToiCal(){
	var str = scheduler.toICal();
	setValore("iCal",str);
}
setHTML("agenda_tab","Agenda");
//scheduler.config.agenda_start = scheduler.date.add(new Date(), -7, "day"); //1 month from a current date
//scheduler.config.labels.agenda_tab = "Agenda";
/*<cfoutput query="rsEvents">
	<cfset endDate = DateAdd("H",1,dt_status)>
scheduler.addEvent({
		id: "#id_status#",
		start_date: "#DateFormat(dt_status,"mm-dd-yyyy")# #TimeFormat(dt_status,"HH:MM")#",
		end_date: "#DateFormat(endDate,"mm-dd-yyyy")# #TimeFormat(endDate,"HH:MM")#",
		text: "#ac_processo#"
	});
</cfoutput>	
*/
</script>
</html>

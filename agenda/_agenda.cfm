<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<script src="../include/js/functions.js" type="text/javascript"></script>
	<script src="agenda.js" type="text/javascript"></script>
	<link rel="stylesheet" href="../include/css/style.css" type="text/css">
	<script src="../include/dhtmlx/dhtmlxScheduler/codebase/dhtmlxscheduler.js" type="text/javascript" charset="utf-8"></script>
	<script src="../include/dhtmlx/dhtmlxScheduler/sources/locale_it.js" type="text/javascript" charset="utf-8"></script>
	<link href="../include/dhtmlx/dhtmlxScheduler/codebase/dhtmlxscheduler.css" rel="stylesheet" type="text/css" charset="ISO-8859-1">
	<script src="../include/dhtmlx/dhtmlxScheduler/codebase/ext/dhtmlxscheduler_agenda_view.js"></script>
   <link rel="stylesheet" href="../include/dhtmlx/dhtmlxScheduler/codebase/ext/dhtmlxscheduler_ext.css" type="text/css">
	<script src="../include/dhtmlx/dhtmlxScheduler/codebase/ext/dhtmlxscheduler_serialize.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js" type="text/javascript"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js" type="text/javascript"></script>
	<script src="jquery.ui.datepicker-it.js" type="text/javascript"></script>
	<link type="text/css" href="../include/css/jquery.ui/css/overcast/jquery-ui-overcast.css" rel="stylesheet" />	
	<title>Agenda</title>
</head>
<cfinvoke component="agenda" method="events" returnvariable="rsEvents"></cfinvoke>
<cfset session.agenda_test = rsEvents>
<body>
<div id="working" style="position:fixed;width:100%;height:100%;top:0px;left:0px;display:none;text-align:center;background:url(https://vm4.indual.it/sav/loading_2.gif) no-repeat center center;z-index:9999999999"></div>
<div class="winhead" style="height:35px"> 
<div style="float:left"><strong>Agenda</strong> &nbsp;</div><cfinclude template="_agendaFilter.cfm"></div>

<!--- | <input type="button" class="btn" value="Esporta in Outlook" onclick="exportToiCal()"><textarea id="iCal" style="width:500px;height:300px;display:none"></textarea> ---></div>
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
<div id="dialog" style="display:none">
	<cfoutput>
	<input type="hidden" name="id_persona" id="id_persona" value="#session.userlogin.id#">
	</cfoutput>
	<input type="hidden" name="agenda_id" id="agenda_id">
	<input type="hidden" name="agenda_action" id="agenda_action">
	<label>Data </label> <input type="text" name="dt_start" id="dt_start" class="datepicker"><br>
	
	<label>Ore</label> <input type="text" name="ora" id="ora" size="3"><input type="text" name="minuti" id="minuti" size="3"> 
	 Alle <input type="text" name="ora_end" id="ora_end" size="3"><input type="text" name="minuti_end" id="minuti_end" size="3">  
<!--- 		<select name="ora" id="ora" style="width:70px">
		<cfloop index="ore" from="0" to="24">
			<cfoutput>
			<option value="#numberformat(ore,'00')#">#numberformat(ore,'00')#</option>
			</cfoutput>
		</cfloop>
		</select>
		<select name="minuti" id="minuti" style="width:70px">
		<cfloop index="min" from="0" to="60" step="15">
			<cfoutput>
			<option value="#numberformat(min,'00')#">#numberformat(min,'00')#</option>
			</cfoutput>
		</cfloop>
		</select>
 --->	<br>
	<label>Evento</label>
	<div style="clear:both"></div>
	<textarea id="ac_evento" name="ac_evento" style="width:380px;height:100px"></textarea>
	<br><br>
	<input type="button" class="btn btn-delete-event" value="Delete"><input type="button" class="btn btn-add-event" value="Salva">
	<cfoutput>
	<input type="hidden" name="url_host" id="url_host" value="#application.hostname#">
	</cfoutput>
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
scheduler.attachEvent("onXLE", doAgendaLoaded);
scheduler.attachEvent("onBeforeLightbox", doAgendaAddEvent);
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

$(document).ready(function(){
	$.datepicker.setDefaults( $.datepicker.regional[ "it" ] );
	
	$('#dialog').dialog({
			autoOpen: false,
			width: 400,
			height:500,
			modal:false,
			resizable:true,
			show: "fade",
			hide: "scale", 
			close: function(event, ui) { verifyAction() }
	});
	
	$(function() {
		$( ".datepicker" ).datepicker();
		$( ".datepicker" ).datepicker( "option",$.datepicker.regional[ "it" ] );
	});
	
	$(".btn-add-event").click(function(){
		//modifica evento action = 1
		var action = $("#agenda_id").val();
		//nuovo evento action = 0
		if ( $("#agenda_action").val() == "Nuovo evento" ){
			action = 0;
		}
		var id = $("#agenda_id").val();
		scheduler.setEventText(id,$("#ac_evento").val());
		var myDate = $("#dt_start").datepicker("getDate");
		
		myDate.setHours(eval($("#ora_end").val()));
		myDate.setMinutes(eval($("#minuti_end").val()));
		scheduler.setEventEndDate(id,myDate);
		
		
		myDate.setHours(eval($("#ora").val()));
		myDate.setMinutes(eval($("#minuti").val()));
		scheduler.setEventStartDate(id,myDate);
		
		
		scheduler.updateEvent(id);
		var user = $('#id_persona').val();
		var dstart = $('#dt_start').val();
		var ostart = $('#ora').val() + ':' + $('#minuti').val();
		var evento = $('#ac_evento').val();
		var oend = $('#ora_end').val() + ':' + $('#minuti_end').val();
		/*	
		var stringa = "dt_start=" + $("#dt_start").val();
		stringa = stringa + "&ora=" + $("#ora").val() + ":" + $("#minuti").val();
		stringa = stringa + "&ac_evento=" + $("#ac_evento").val();
		stringa = stringa + "&action=" + action;
		stringa = stringa + "&ora_end=" + $("#ora_end").val() + ":" + $("#minuti_end").val();
		*/
		$.ajax({
			
			url: "https://" + $('#url_host').val() + "/sav/agenda/agenda.cfc",
			type: 'GET',
			data: {method: 'addAgendaEvent', returnFormat: 'plain', id_persona: user, dt_start: dstart, ora: ostart, ac_evento: evento, action: action, ora_end: oend},
			//data:stringa,
	    	dataType: 'html',
   			cache: false,
   			success: function (txt){ 
				if ( action == 0){
					scheduler.changeEventId(id,txt);
					
				}
				scheduler.updateEvent(id);
				$("#dialog").dialog("close");
				$("#agenda_action").val("Inserted");
				setAgenda();
			}
		});
		
	});

	
	$(".btn-delete-event").click(function(){
		var id = $("#agenda_id").val();
		scheduler.deleteEvent(id);
		scheduler.updateEvent(id);
		$.ajax({
			url: "https://"  + $('#url_host').val() + "/sav/agenda/agenda.cfc?method=deleteAgendaEvent",
			type: 'GET',
			data:"id=" + id,
	    	dataType: 'html',
   			cache: false,
   			success: function (txt){ 
				$("#dialog").dialog("close");
			}
		});
		
	});
	
	function verifyAction(){
		if ( $("#agenda_action").val() == "Nuovo evento" ){
			var id = $("#agenda_id").val();
			scheduler.deleteEvent(id);
		}
	}
	
});
	
</script>
</html>

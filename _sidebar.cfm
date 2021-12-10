<div class="winblue">
<strong>Cerca Cliente</strong>
<cfform format="HTML">
	<cfinput type="Text"
       name="search"
       height="20"
       label="Search"
       autosuggest="cfc:service.lookupCustomer({cfautosuggestvalue})"
       autosuggestminlength="1"
       maxresultsdisplayed="20"
       required="yes"
       visible="Yes"
       enabled="Yes"
       showautosuggestloadingicon="False"
       typeahead="No"
       onkeydown="checkKey(this,event)"
       id="search"
       onKeyPress="checkKey(this,event)"
       maxresultdisplay="10"
	   style="margin-left:5px; margin-bottom:10px;font-size:11px;font-family:Tahoma"><img src="include/css/icons/search.png" onclick="fastSearch()" align="absmiddle"><br>
		<br>
		<!--- pannello di informazioni in relazione alla ricerca effettuata --->
		<div class="winwhite" id="searchInfo" style="width:98%;display:none;margin-left:5px"></div>
</cfform>

<!--- Tools della sidebar --->
<cfif session.livello GT 1>
<cfset myTools = "tools/_tools.cfm">
<cfinclude template="#myTools#">
</cfif>
</div>
<!--- <div id="calendarObj" style="position:absolute;top:260px;margin-left:5px"></div>
<script>
      
	  
	  dhtmlxCalendarLangModules = new Array();//create array if it doesn't exist  
            //define settings for the new language (Russian)
      dhtmlxCalendarLangModules['it'] = {
            langname: 'ru', // id of the new language
            dateformat: '%d.%m.%Y', // date format
            monthesFNames: ["Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"], 
// full names of months
            monthesSNames: ["Gen", "Feb", "Mar", "Apr", "Mag", "Giu", "Lug", "Ago", "Set", "Ott", "Nov", "Dec"], 
// short names of months
            daysFNames: ["Domenica", "Lunedi", "Martedi", "Mercoledi", "Giovedi", "Venerdi", "Sabato"], 
// full names of days
            daysSNames: ["Do", "Lu", "Ma", "Me", "Gi", "Ve", "Sa"], // short names of days
            weekend: [0, 6], // weekend days
            weekstart: 1, // week start day
            msgClose: "Chiudi", // close button tooltip
            msgMinimize: "Minimizza", // minimize button tooltip
            msgToday: "Oggi" // today button tooltip
        }
	 
	 
	 mCal = new dhtmlxCalendarObject("calendarObj",true);
	 mCal.loadUserLanguage("it");	
     mCal.setSkin();
  </script>
<div id="calendar"></div> --->

<cfset initDate = CreateDate(2008,3,21)>
<cfset myDate = CreateDate(2008,3,21)>
<cfset ore = 24>
<cfset myFestivita = "01/01,06/01,01/05,02/06,15/08,01/11,08/11,25/12,26/12">
<cfset checkFestivita = DateFormat(now(),"dd/mm")>


<cfset anno = year(myDate)>
<cfset a = anno mod 19>
<cfset b = anno mod 4>
<cfset c = anno mod 7>

<cfset d = ((19 * a)+24) mod 30>
<cfset e = ((2*b) + (4*c) + (6*d) + 5) mod 7>

<cfset calcolo = d + e>
<cfif calcolo GT 10>
	<cfset calcolo = calcolo - 9>
	<cfif calcolo EQ 26 OR calcolo EQ 25>
		<cfset calcolo = calcolo-7>
	</cfif>
	<cfset pasqua = "#calcolo#/04">
	<cfset pasquetta = "#calcolo+1#/04">
<cfelse>
	<cfset calcolo = calcolo + 22>
	<cfset pasqua = "#calcolo#/03">
	<cfset pasquetta = "#calcolo+1#/03">
</cfif>
<cfset myFestivita = "01/01,06/01,#pasqua#,#pasquetta#,01/05,02/06,15/08,01/11,08/11,25/12,26/12">


CALCOLO PROSSIMO GIORNO LAVORATIVO ALLA DATA<br>
<cfoutput>#DayOfWeek(myDate)# #dateFormat(myDate,"ddd dd.mm.yy")#</cfoutput><br>








<cfset newTrigger = DateAdd("H",ore,myDate)>
<!--- <cfoutput>#DayOfWeek(newTrigger)# #dateFormat(newTrigger,"ddd dd.mm.yy")#</cfoutput><br> --->
<cfif DayOfWeek(newTrigger) EQ 7>
	<cfset newTrigger = DateAdd("H",24,newTrigger)>
</cfif>
<cfloop index="i" list="#myFestivita#">
	<cfoutput>
	#i# > #DateFormat(newTrigger,"dd/mm")#<br>
	<cfif i EQ DateFormat(newTrigger,"dd/mm")>
		<cfset newTrigger = DateAdd("H",24,newTrigger)>
		<cfset myDate = newTrigger>
	</cfif>
	</cfoutput>
</cfloop>

<!--- <cfoutput>#DayOfWeek(newTrigger)# #dateFormat(newTrigger,"ddd dd.mm.yy")#</cfoutput><br>
<cfoutput>#DayOfWeek(newTrigger)# #dateFormat(myDate,"ddd dd.mm.yy")#</cfoutput><br> --->

<cfif DayOfWeek(newTrigger) EQ "1">
	<cfset newTrigger = DateAdd("H",24,newTrigger)>
</cfif>
<cfif DayOfWeek(newTrigger) EQ 7>
	<cfset newTrigger = DateAdd("H",48,newTrigger)>
</cfif>
Prossimo giorno lavorativo<br>

<cfoutput>#DayOfWeek(newTrigger)# #dateFormat(newTrigger,"ddd dd.mm.yy")#</cfoutput>

<br>
<br>
CALCOLO DELLA PASQUA
<br>
<br>
<cfoutput>
#pasqua#/#year(myDate)#
</cfoutput>
<br>
<br>



<cfinvoke component="status.status" method="nextWorkDate" returnvariable="nextWorkDay">
	<cfinvokeargument name="data" value="#initDate#">
</cfinvoke>
<cfoutput>
Oggi è #DateFormat(initDate,"ddd dd.mm.yyyy")#<br>
Prossimo giorno lavorativo: #DateFormat(nextWorkDay,"ddd dd.mm.yyyy")#</cfoutput>


<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="yes">
<cfset thisDay = DateAdd("d",-3,now())>

<cfinvoke component="agenda.agenda" method="events" returnvariable="rsAll">
</cfinvoke> 
		
		
		
		<cfquery name="qry" datasource="crm">
			SELECT 
				tbl_status.*,
				tbl_processi.ac_processo,
				tbl_clienti.ac_cognome,
				tbl_clienti.ac_nome,
				tbl_clienti.ac_azienda
			 FROM tbl_status
			 INNER JOIN tbl_processi ON tbl_status.id_processo = tbl_processi.id_processo
			 INNER JOIN tbl_clienti ON tbl_status.id_cliente = tbl_clienti.id_cliente
			 WHERE
			 	(
					tbl_status.dt_status >= #thisDay# AND
					tbl_status.dt_status <= #DateAdd("d",7,thisDay)#
				)
		</cfquery>
		
		<cfoutput>
		#Week(thisDay)#
		<br>
		<br>
		#rsAll.recordcount#</cfoutput>
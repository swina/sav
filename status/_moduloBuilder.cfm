<cfparam name="url.text" default="Fotovoltaico">
<cfinvoke component="status" method="getProcessi" returnvariable="rsProcessi"></cfinvoke>
<cfinvoke component="status" method="getCampiModulo" returnvariable="getFields">
	<cfinvokeargument name="ac_modulo" value="#url.text#">
</cfinvoke>
<!--- <cfquery name="getFields" datasource="#application.dsn#">
	SELECT 
		tbl_moduli_fields.* ,
		tbl_moduli.ac_modulo,
		tbl_processi.ac_processo,
		tbl_processi.ac_sigla
	FROM tbl_moduli_fields 
	INNER JOIN tbl_moduli ON tbl_moduli_fields.id_modulo = tbl_moduli.id_modulo
	LEFT JOIN tbl_processi ON tbl_moduli_fields.id_processo = tbl_processi.id_processo
	WHERE tbl_moduli.ac_modulo = '#url.text#'
	ORDER BY ac_sezione, tbl_moduli_fields.int_ordine
</cfquery> --->
<cfset myFields = ValueList(getFields.ac_field)>
<cfset myRequired = ValueList(getFields.bl_required)>
<cfset myLabels = ValueList(getFields.ac_label)>
<cfset myTypes = ValueList(getFields.ac_tipo)>
<cfset myProcessi = ValueList(getFields.id_processo)>

	<cfset n = 1>
	<cfoutput query="getFields" group="ac_sezione">
		
		<input type="text" id="lista_sezioni" value="#ac_sezione#">
		<div style="float:left;font-family:'Tahoma';font-size:12px" id="S#n#">
		<div style="margin-left:20px">
		
		<cfoutput>
		<cfset myDisplay = "">
 		<cfif bl_visible IS 0>
			<cfset myDisplay = "none">
		<cfelse>
			<cfset myDisplay = "">
		</cfif> 
		<div>
		<span style="width:200px;display:#myDisplay#"><strong <cfif bl_required EQ 1>style="color:red"</cfif>>
		<cfif bl_processo EQ 1>
			#ac_processo#
		<cfelse>
			#ac_label#	
		</cfif>
		
		</strong><br></span>
		</div>
		<input type="hidden" name="#ac_field#_vincoli" id="#ac_field#_vincoli" style="display:#myDisplay#">
		<cfswitch expression="#ac_tipo#">
			
			<cfcase value="str">
				<input type="text" name="#ac_field#" id="#ac_field#" value="" <cfif bl_required EQ 1>class="required"</cfif>>				
			</cfcase>
		
			<cfcase value="dt">
				<cfset oggi = DateFormat(now(),"yyyymmdd")>
				<cfif ac_vincoli NEQ "">
					<cfset myDate = DateAdd("d",ac_vincoli,now())>
				<cfelse>
					<cfset myDate = now()>
				</cfif>
				<input type="text" name="#ac_field#" id="#ac_field#" value="#dateFormat(myDate,'dd/mm/yyyy')#" <cfif bl_required EQ 1>class="required"</cfif> size="10" <cfif ac_vincoli NEQ "">onChange="checkDate('#oggi#',#ac_vincoli#,this)"</cfif>  style="display:#myDisplay#">
				<cfif ac_vincoli NEQ "">
					<br>
					<span id="#ac_field#_msg" style="display:;font-size:9px">La data deve essere almeno #ac_vincoli# giorni successiva a quella odierna</span>
				</cfif>
			</cfcase>
						
			<cfcase value="co">
				
				<select id="#ac_field#"  name="#ac_field#" <cfif ac_vincoli NEQ "">onchange="checkVincoli('#ac_vincoli#','#ac_field#',#ListLen(ac_vincoli)#)"</cfif> style="display:#myDisplay#">
					<option value="">...
					<cfloop index="i" list="#ac_values#" delimiters="|">
						<option value="#i#">#i#</option>
					</cfloop>
				</select>
			</cfcase>
			
			
			<cfcase value="ch">
				<cfloop index="i" list="#ac_values#" delimiters="|">
					<!--- <cfif i EQ "medio">
						<span style="display:none"><input type="checkbox" name="#ac_field#" value="#i#" id="#ac_field#"  style="display:#myDisplay#">#i#&nbsp;</span>
					<cfelse> --->
						<span style="display:"><input type="checkbox" name="#ac_field#" value="#i#" id="#ac_field#"  style="display:#myDisplay#">#i#&nbsp;</span>	
					<!--- </cfif> --->


				</cfloop>
			</cfcase>
			
			
			<cfcase value="ra">
				<cfset x = 1>
				<cfloop index="i" list="#ac_values#" delimiters="|">
					<input type="radio" name="#ac_field#" value="#i#" id="#ac_field#" <cfif x EQ 1>checked</cfif>  style="display:#myDisplay#"> #i#&nbsp;
					<cfset x = x + 1>
				</cfloop>
			</cfcase>
			
			<cfcase value="mem">
				<textarea name="#ac_field#" id="#ac_field#" style="width:200px;height:60px"  style="display:#myDisplay#"></textarea>
			</cfcase>
			
			<cfcase value="fi">
				 <img src="../include/css/icons/upcoming-work.png" onclick="uploadDocs()" style="cursor:pointer;" title="Carica Documento" align="absmiddle"> Carica File
			</cfcase>
		</cfswitch>
		<br>
		<cfif currentrow EQ getFields.recordcount>
		<br>
		
		<input type="button" value=" Salva " name="submitFrm" id="submitFrm" class="btn" onclick="saveThisModulo()" style="display:">
		</cfif>
		</cfoutput>
		</div>
		</div>
		<cfset n = n + 1>
	</cfoutput>
	
	<script>
	window.dhx_globalImgPath = "../include/dhtmlx/dhtmlxCalendar/codebase/imgs/";
	function calDeptDate(d,obj) {
		var  myDate = d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear();
	    setValore(obj,myDate);
	}
	</script>
	<script>
	<cfloop query="getFields">
		
		<cfoutput>
		<cfif ac_tipo EQ "dt">
		var cal_#currentrow# = new dhtmlxCalendarObject('#ac_field#');
			cal_#currentrow#.attachEvent("onClick", function(date) {
	        	calDeptDate(date,"#ac_field#");
				
				<cfif ac_vincoli NEQ "">
				var nDate = date.getDate() + "/" + (date.getMonth() + 1) + "/" + date.getFullYear();
				checkDate("#oggi#",#ac_vincoli#,nDate);
				</cfif>
		    });
		</cfif>
		</cfoutput>
		
	</cfloop>
	</script>
	<!--- </div> --->


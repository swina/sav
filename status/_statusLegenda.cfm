<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
	<link rel='stylesheet' type='text/css' href='../include/css/style.css'>
</head>
<cfinvoke component="status" method="getProcessi" returnvariable="rsLegenda"></cfinvoke>
<!--- <cfquery name="rsLegenda" datasource="crm">
Select 
	tbl_processi.*,
	tbl_processi_permission.*
FROM tbl_processi
INNER JOIN tbl_processi_permission ON tbl_processi.id_processo = tbl_processi_permission.id_processo 
WHERE 
	tbl_processi_permission.int_livello = #StructFind(session.userlogin,"livello")#
	AND 
	tbl_processi.int_ordine > 0
ORDER BY int_ordine
</cfquery> --->
<body>

<div class="winblue" style="height:100%;overflow:auto">
<table style="width:100%;" cellspacing="1" cellpadding="5">
	<tr>
		<td class="winblue" colspan="2"><strong>Azione</strong></td>
	</tr>
<cfoutput query="rsLegenda">
	<tr style="background:white">
		<td>#ac_processo#</td>
		<td style="background:###ac_colore#;width:20px;border:1px solid black"></td>
	</tr>
</cfoutput>
</table>
</div>
</body>
</html>

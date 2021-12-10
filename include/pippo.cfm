<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>
<cfquery name="getProcessi" datasource="crm">
SELECT * FROM tbl_processi
</cfquery>
<cfoutput query="getProcessi">
#ac_processo# > #ListGetAt(ac_permissions,StructFind(session.userlogin,"livello"))#<br>
</cfoutput>

</body>
</html>

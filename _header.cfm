<div style="width:100% ; height:50px ; margin:0 auto">
<img src="include/css/logo.png"><br>

<cfif IsDefined("session.userlogin") AND session.login>
	<cfoutput>
	<span style="margin-left:10px;color:##9a9a9a">#StructFind(session.userlogin,"utente")# [#StructFind(session.userlogin,"gruppo")#] <img src="include/css/icons/logout.png"  onclick="logout()" align="absmiddle" title="Fine Lavoro" style="cursor:pointer"><a href="index.cfm?reloadApp" target="_self"><img src="include/css/icons/knobs/action_refresh_blue.gif" align="absmiddle" style="cursor:pointer" title="Ricarica l'applicazione" border="0"></a></span>
	</cfoutput>
</cfif>
</div>


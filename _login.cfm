<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>:::LOGIN:::</title>
<!--- 	<script src="service.js"></script>
	<script src="include/js/functions.js"></script> --->
</head>

<body>
<cfajaximport>
<cfform id="loginFrm" name="loginFrm">
<div align="center">
<div class="winblue" style="margin:40px auto;width:240px;">
	<div class="winwhite"><img src="include/css/icons/login.png" align="absmiddle"><strong>LOGIN</strong></div><br>
	<br>
	
	Nome Utente<br>
	<img src="include/css/icons/user.png" align="absmiddle" hspace="10"><input type="text" name="ac_utente" id="ac_utente"><br>
	Password<br>
	<img src="include/css/icons/lock.png" align="absmiddle" hspace="10"><input type="password" name="ac_password" id="ac_password"><br>
	<br>
	
	<input type="button" class="btn" value="LOGIN" onclick="submitLogin()">
	<br>
	
</div>
	<div id="errorLogin">
	Per lavorare nella migliore condizione si suggerisce la modalità full-screen.<br>
	Premere <strong>F11</strong> e quindi <strong>F5</strong>
	</div>
</div>
</cfform>

</body>
</html>

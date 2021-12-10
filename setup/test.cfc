<cfcomponent>
	<cffunction name="test" access="remote" returntype="any">
		<cfscript>
		var a = 100;
		var b = divide(a);
		</cfscript>
		<cfreturn b>
	</cffunction>
	
	<cffunction name="divide" access="private" returntype="any">
		<cfargument name="numero" required="yes" type="numeric">
		
		<cfreturn arguments.numero/10>
		
	</cffunction>
</cfcomponent>
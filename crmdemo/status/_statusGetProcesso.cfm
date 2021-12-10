<input type="text" id="test">
<cfset form.id_status = 2>
<cfinvoke component="status" method="getStatus" returnvariable="myArray">
	<cfinvokeargument name="id_status" value="#form.id_status#">
</cfinvoke>


<cfoutput>
<script>
document.getElementById("ac_note").value = "CIAOOOOO";
</script>
</cfoutput>

<!--- cfquery name="qry" datasource="#THIS.dsn#">
		SELECT 
			tbl_status.* 
			
		FROM tbl_status 
		WHERE id_status = 2
		</cfquery>
		<cfscript>

// Define the local scope.
var LOCAL = StructNew();

// Get the column names as an array.
LOCAL.Columns = ListToArray( qry.ColumnList );

// Create an array that will hold the query equivalent.
LOCAL.QueryArray = ArrayNew( 1 );

// Loop over the query.
for (LOCAL.RowIndex = 1 ; LOCAL.RowIndex LTE qry.RecordCount ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){

// Create a row structure.
LOCAL.Row = StructNew();

// Loop over the columns in this row.
for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE ArrayLen( LOCAL.Columns ) ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){

// Get a reference to the query column.
LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];

// Store the query cell value into the struct by key.
LOCAL.Row[ LOCAL.ColumnName ] = qry[ LOCAL.ColumnName ][ LOCAL.RowIndex ];

}

// Add the structure to the query array.
ArrayAppend( LOCAL.QueryArray, LOCAL.Row );

}
</cfscript>
<cfdump var="#LOCAL.QueryArray#">
 --->

<cfinvoke component="status" method="deleteDoc" returnvariable="done">
	<cfinvokeargument name="file" value="#url.file#">
	<cfinvokeargument name="folder" value="#url.id_cliente#">
	<cfinvokeargument name="id_status" value="#url.id_status#">
</cfinvoke>
<script>
parent.parent.GB_hide();
</script>
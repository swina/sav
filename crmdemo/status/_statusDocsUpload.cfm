<div id="uploadWin" class="winblue">
<cffileupload  
	    url="_statusDoUpload.cfm" 
	    progressbar="true" 
	    addButtonLabel = "Aggiungi" 
	    clearButtonlabel = "Reset" 
		deleteButtonlabel = "Elimina"
		hideUploadButton = "false" 
	    width=420 
	    height=200 
	    title = "Carica Documenti" 
	    maxuploadsize="50" 
	    extensionfilter="*.doc, *.pdf , *.xls, *.txt, *.rtf" 
	    BGCOLOR="##FFFFFF" 
	    UPLOADBUTTONLABEL="Carica"
		onUploadComplete = "getFileNameUploaded"/>
</div>

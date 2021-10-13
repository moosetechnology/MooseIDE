Class {
	#name : #MooseImportFromJSONForm,
	#superclass : #MooseImportFromMSEForm,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #action }
MooseImportFromJSONForm >> privateImportModel [

	^ mooseModelDroplist selectedItem new importFromJSON
]

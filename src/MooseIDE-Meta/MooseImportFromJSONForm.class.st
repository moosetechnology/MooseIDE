"
Dialog used to import JSON models
"
Class {
	#name : #MooseImportFromJSONForm,
	#superclass : #MooseImportFromMSEForm,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #specs }
MooseImportFromJSONForm class >> title [

	^ 'Import model from JSON file'
]

{ #category : #action }
MooseImportFromJSONForm >> privateImportModel [

	^ mooseModelDroplist selectedItem new importFromJSON
]

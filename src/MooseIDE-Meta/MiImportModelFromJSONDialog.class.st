"
Dialog used to import JSON models
"
Class {
	#name : #MiImportModelFromJSONDialog,
	#superclass : #MiImportModelFromMSEDialog,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #specs }
MiImportModelFromJSONDialog class >> title [

	^ 'Import model from JSON file'
]

{ #category : #action }
MiImportModelFromJSONDialog >> privateImportModel [

	^ mooseModelDroplist selectedItem new importFromJSON
]

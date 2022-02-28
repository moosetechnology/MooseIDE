Class {
	#name : #MiImportFromJSONCommand,
	#superclass : #MiImportCommand,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #default }
MiImportFromJSONCommand class >> defaultDescription [

	^ 'Import model from JSON file'
]

{ #category : #default }
MiImportFromJSONCommand class >> defaultIcon [

	^ MooseIcons mooseImportJson
]

{ #category : #default }
MiImportFromJSONCommand class >> defaultIconName [

	^ #mooseImportJson
]

{ #category : #default }
MiImportFromJSONCommand class >> defaultName [

	^ 'Import from JSON'
]

{ #category : #accessing }
MiImportFromJSONCommand class >> importForm [

	^ MiImportModelFromJSONDialog
]

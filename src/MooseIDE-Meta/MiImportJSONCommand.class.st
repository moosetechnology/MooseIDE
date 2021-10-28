Class {
	#name : #MiImportJSONCommand,
	#superclass : #MiImportCommand,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #default }
MiImportJSONCommand class >> defaultDescription [

	^ 'Import model from JSON file'
]

{ #category : #default }
MiImportJSONCommand class >> defaultIcon [

	^ MooseIcons mooseImportJson
]

{ #category : #default }
MiImportJSONCommand class >> defaultIconName [

	^ #mooseImportJson
]

{ #category : #default }
MiImportJSONCommand class >> defaultName [

	^ 'Import from JSON'
]

{ #category : #accessing }
MiImportJSONCommand class >> importForm [

	^ MooseImportFromJSONForm
]

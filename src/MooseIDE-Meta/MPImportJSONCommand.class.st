Class {
	#name : #MPImportJSONCommand,
	#superclass : #MPImportCommand,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #default }
MPImportJSONCommand class >> defaultDescription [

	^ 'Import model from JSON file'
]

{ #category : #default }
MPImportJSONCommand class >> defaultIcon [

	^ MooseIcons mooseImportJson
]

{ #category : #default }
MPImportJSONCommand class >> defaultIconName [

	^ #mooseImportJson
]

{ #category : #default }
MPImportJSONCommand class >> defaultName [

	^ 'Import from JSON'
]

{ #category : #accessing }
MPImportJSONCommand class >> importForm [

	^ MooseImportFromJSONForm
]

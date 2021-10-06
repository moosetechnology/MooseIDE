Class {
	#name : #MPImportJSONCommand,
	#superclass : #MPImportCommand,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #'accessing - defaults' }
MPImportJSONCommand class >> defaultDescription [

	^ 'Import model from JSON file'
]

{ #category : #accessing }
MPImportJSONCommand class >> defaultIcon [

	^ MooseIcons mooseImportJson
]

{ #category : #initialization }
MPImportJSONCommand class >> defaultIconName [

	^ #mooseImportJson
]

{ #category : #'accessing - defaults' }
MPImportJSONCommand class >> defaultName [

	^ 'Import from JSON'
]

{ #category : #accessing }
MPImportJSONCommand class >> importForm [

	^ MooseImportFromJSONForm
]

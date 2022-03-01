Class {
	#name : #MiImportFromMSECommand,
	#superclass : #MiImportCommand,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #hooks }
MiImportFromMSECommand class >> defaultDescription [

	^ 'Import model from MSE file'
]

{ #category : #hooks }
MiImportFromMSECommand class >> defaultIcon [

	^ MooseIcons mooseImportMse
]

{ #category : #default }
MiImportFromMSECommand class >> defaultIconName [

	^ #mooseImportMse
]

{ #category : #hooks }
MiImportFromMSECommand class >> defaultName [

	^ 'Import from MSE'
]

{ #category : #accessing }
MiImportFromMSECommand class >> importForm [

	^ MiImportModelFromMSEDialog
]

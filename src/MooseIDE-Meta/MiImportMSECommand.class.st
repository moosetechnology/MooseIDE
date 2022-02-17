Class {
	#name : #MiImportMSECommand,
	#superclass : #MiImportCommand,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #hooks }
MiImportMSECommand class >> defaultDescription [

	^ 'Import model from MSE file'
]

{ #category : #hooks }
MiImportMSECommand class >> defaultIcon [

	^ MooseIcons mooseImportMse
]

{ #category : #default }
MiImportMSECommand class >> defaultIconName [

	^ #mooseImportMse
]

{ #category : #hooks }
MiImportMSECommand class >> defaultName [

	^ 'Import from MSE'
]

{ #category : #accessing }
MiImportMSECommand class >> importForm [

	^ MiImportModelFromMSEDialog
]

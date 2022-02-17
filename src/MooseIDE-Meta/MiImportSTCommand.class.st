Class {
	#name : #MiImportSTCommand,
	#superclass : #MiImportCommand,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #hooks }
MiImportSTCommand class >> defaultDescription [

	^ 'Import Famix Smalltalk model from the current image'
]

{ #category : #hooks }
MiImportSTCommand class >> defaultIcon [

	^ MooseIcons mooseImportSmalltalk
]

{ #category : #default }
MiImportSTCommand class >> defaultIconName [
	
	^ #mooseImportSmalltalk
]

{ #category : #hooks }
MiImportSTCommand class >> defaultName [

	^ 'Import from Smalltalk'
]

{ #category : #accessing }
MiImportSTCommand class >> importForm [

	^ MiImportModelFromSmalltalkDialog
]

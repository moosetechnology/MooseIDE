Class {
	#name : #MiImportFromSTCommand,
	#superclass : #MiImportCommand,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #hooks }
MiImportFromSTCommand class >> defaultDescription [

	^ 'Import Famix Smalltalk model from the current image'
]

{ #category : #hooks }
MiImportFromSTCommand class >> defaultIcon [

	^ MooseIcons mooseImportSmalltalk
]

{ #category : #default }
MiImportFromSTCommand class >> defaultIconName [
	
	^ #mooseImportSmalltalk
]

{ #category : #hooks }
MiImportFromSTCommand class >> defaultName [

	^ 'Import from Smalltalk'
]

{ #category : #accessing }
MiImportFromSTCommand class >> importForm [

	^ MiImportModelFromSmalltalkDialog
]

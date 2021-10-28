Class {
	#name : #MPImportSTCommand,
	#superclass : #MPImportCommand,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #hooks }
MPImportSTCommand class >> defaultDescription [

	^ 'Import Famix Smalltalk model from the current image'
]

{ #category : #hooks }
MPImportSTCommand class >> defaultIcon [

	^ MooseIcons mooseImportSmalltalk
]

{ #category : #default }
MPImportSTCommand class >> defaultIconName [
	
	^ #mooseImportSmalltalk
]

{ #category : #hooks }
MPImportSTCommand class >> defaultName [

	^ 'Import from Smalltalk'
]

{ #category : #accessing }
MPImportSTCommand class >> importForm [

	^ MooseImportFromSmalltalkForm
]

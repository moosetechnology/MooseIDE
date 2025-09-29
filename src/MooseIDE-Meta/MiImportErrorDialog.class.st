Class {
	#name : #MiImportErrorDialog,
	#superclass : #SpConfirmDialog,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #accessing }
MiImportErrorDialog class >> defaultAcceptLabel [

	^ 'Ok'
]

{ #category : #accessing }
MiImportErrorDialog class >> defaultCancelLabel [

	^ 'Debug'
]

{ #category : #private }
MiImportErrorDialog >> defaultIcon [

	^ self application iconNamed: #info
]

{ #category : #accessing }
MiImportErrorDialog >> defaultTitle [

	^ 'Import error'
]

Class {
	#name : #MiAddQueryToLibraryCommand,
	#superclass : #CmCommand,
	#category : #'Midas-FamixQueries-Tools'
}

{ #category : #default }
MiAddQueryToLibraryCommand class >> defaultName [
	^ 'Save this query'
]

{ #category : #executing }
MiAddQueryToLibraryCommand >> execute [
	| name |
	name := self getName.
	name ifNil: [ ^ self ].
	FQLibrary current addNewQuery: (self queryNamed: name)
]

{ #category : #executing }
MiAddQueryToLibraryCommand >> getName [
	| name |
	name := UIManager default request: self requestText.
	name ifNil: [ ^ nil ].
	name ifEmpty: [ ^ self getName ].
	^ name
]

{ #category : #executing }
MiAddQueryToLibraryCommand >> queryNamed: name [
	^ self context selectedQuery name: name
]

{ #category : #executing }
MiAddQueryToLibraryCommand >> requestText [
	^ 'Please name this query'
]

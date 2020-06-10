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
	FQQueriesLibrary current addNewQuery: (self queryNamed: name)
]

{ #category : #executing }
MiAddQueryToLibraryCommand >> getName [
	| name |
	name := UIManager default request: 'Please name this query'.
	name ifNil: [ ^ nil ].
	name ifEmpty: [ ^ self getName ].
	^ name
]

{ #category : #executing }
MiAddQueryToLibraryCommand >> queryNamed: name [
	^ self context selectedQuery name: name
]

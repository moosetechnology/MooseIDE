Class {
	#name : #MiExportQueryColumnModel,
	#superclass : #MiExportAbstractColumnModel,
	#instVars : [
		'query'
	],
	#category : #'MooseIDE-Export-Browser'
}

{ #category : #comparing }
MiExportQueryColumnModel >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ name = anObject name1 and: [ query = anObject query ]
]

{ #category : #comparing }
MiExportQueryColumnModel >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ name hash bitXor: query hash
]

{ #category : #testing }
MiExportQueryColumnModel >> isQueryColumn [

	^ true
]

{ #category : #accessing }
MiExportQueryColumnModel >> name1 [

	^ name
]

{ #category : #accessing }
MiExportQueryColumnModel >> privatePrintValueFor: anEntity [
	^ query value: anEntity
]

{ #category : #accessing }
MiExportQueryColumnModel >> query [

	^ query
]

{ #category : #accessing }
MiExportQueryColumnModel >> query: anObject [

	query := anObject
]

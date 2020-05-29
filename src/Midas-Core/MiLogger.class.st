"
Keeps a log of all selected entities in the application
"
Class {
	#name : #MiLogger,
	#superclass : #SpApplication,
	#instVars : [
		'logs',
		'application'
	],
	#category : #'Midas-Core-Logger'
}

{ #category : #accessing }
MiLogger >> application [
	^ application
]

{ #category : #accessing }
MiLogger >> application: anObject [
	application := anObject
]

{ #category : #api }
MiLogger >> clean [
	logs removeAll
]

{ #category : #accessing }
MiLogger >> globallySelect: anEntity [
	logs
		add:
			(MiSelectedEntityLog new
				logger: self;
				entity: anEntity)
]

{ #category : #accessing }
MiLogger >> initialize [
	super initialize.
	logs := OrderedCollection new
]

{ #category : #accessing }
MiLogger >> lastEntity [
	^ self logs
		ifEmpty: [ nil ]
		ifNotEmpty: [ self logs last entity ]
]

{ #category : #accessing }
MiLogger >> logs [
	^ logs
]

{ #category : #accessing }
MiLogger >> logs: anObject [
	logs := anObject
]

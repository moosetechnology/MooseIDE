Class {
	#name : #MiLogger,
	#superclass : #SpApplication,
	#instVars : [
		'logs',
		'application'
	],
	#category : #'Midas-Logger'
}

{ #category : #accessing }
MiLogger >> application [
	^ application
]

{ #category : #accessing }
MiLogger >> application: anObject [
	application := anObject
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
MiLogger >> logs [
	^ logs
]

{ #category : #accessing }
MiLogger >> logs: anObject [
	logs := anObject
]

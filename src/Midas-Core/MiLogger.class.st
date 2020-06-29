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
	anEntity ifNil: [ ^ self ].
	self mostRecentEntity == anEntity
		ifTrue: [ self mostRecentLog activate ]
		ifFalse: [ logs
				addFirst:
					(MiSelectedEntityLog new
						logger: self;
						entity: anEntity) ]
]

{ #category : #accessing }
MiLogger >> initialize [
	super initialize.
	logs := OrderedCollection new
]

{ #category : #accessing }
MiLogger >> lastEntity [
	self
		deprecated: 'Use #mostRecentEntity instead'
		transformWith: '`@receiver lastEntity' -> '`@receiver mostRecentEntity'.
	^ self mostRecentEntity
]

{ #category : #accessing }
MiLogger >> logs [
	^ logs
]

{ #category : #accessing }
MiLogger >> logs: anObject [
	logs := anObject
]

{ #category : #accessing }
MiLogger >> mostRecentEntity [
	^ self mostRecentLog ifNotNil: [ :log | log entity ]
]

{ #category : #accessing }
MiLogger >> mostRecentLog [
	^ self logs ifEmpty: [ nil ] ifNotEmpty: [ self logs first ]
]

{ #category : #accessing }
MiLogger >> removeLog: aLog [
	self logs remove: aLog
]

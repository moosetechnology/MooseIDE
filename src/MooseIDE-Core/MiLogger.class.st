"
Keeps a log of all selected entities in the application
"
Class {
	#name : #MiLogger,
	#superclass : #Object,
	#instVars : [
		'logs'
	],
	#category : #'MooseIDE-Core-Logger'
}

{ #category : #api }
MiLogger >> clean [
	logs removeAll
]

{ #category : #initialization }
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

{ #category : #api }
MiLogger >> newLogFor: anEntity [
	^ self mostRecentEntity == anEntity
		ifTrue: [ self mostRecentLog ]
		ifFalse: [ logs addFirst: (MiSelectedEntityLog new entity: anEntity) ]
]

{ #category : #api }
MiLogger >> removeLog: aLog [
	self logs remove: aLog
]

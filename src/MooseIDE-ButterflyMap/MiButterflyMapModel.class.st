Class {
	#name : #MiButterflyMapModel,
	#superclass : #Object,
	#instVars : [
		'currentEntity',
		'browser',
		'childrenBlock',
		'childrenQuery',
		'leftEntitiesQuery',
		'leftEntitiesBlock',
		'rightEntitiesQuery',
		'rightEntitiesBlock'
	],
	#category : #'MooseIDE-ButterflyMap-Model'
}

{ #category : #accessing }
MiButterflyMapModel >> browser [

	^ browser
]

{ #category : #accessing }
MiButterflyMapModel >> browser: anObject [

	browser := anObject
]

{ #category : #accessing }
MiButterflyMapModel >> childrenBlock [

	^ childrenBlock
]

{ #category : #accessing }
MiButterflyMapModel >> childrenBlock: anObject [

	childrenBlock := anObject
]

{ #category : #accessing }
MiButterflyMapModel >> childrenFor: anEntity [

	^ anEntity children
]

{ #category : #accessing }
MiButterflyMapModel >> childrenQuery [

	^ childrenQuery
]

{ #category : #accessing }
MiButterflyMapModel >> childrenQuery: anObject [

	childrenQuery := anObject
]

{ #category : #accessing }
MiButterflyMapModel >> currentEntity [

	^ currentEntity
]

{ #category : #accessing }
MiButterflyMapModel >> currentEntity: anObject [

	currentEntity := anObject.
	browser run
]

{ #category : #accessing }
MiButterflyMapModel >> leftEntitiesBlock [

	^ leftEntitiesBlock
]

{ #category : #accessing }
MiButterflyMapModel >> leftEntitiesBlock: anObject [

	leftEntitiesBlock := anObject
]

{ #category : #accessing }
MiButterflyMapModel >> leftEntitiesQuery [

	^ leftEntitiesQuery
]

{ #category : #accessing }
MiButterflyMapModel >> leftEntitiesQuery: anObject [

	leftEntitiesQuery := anObject
]

{ #category : #accessing }
MiButterflyMapModel >> rightEntitiesBlock [

	^ rightEntitiesBlock
]

{ #category : #accessing }
MiButterflyMapModel >> rightEntitiesBlock: anObject [

	rightEntitiesBlock := anObject
]

{ #category : #accessing }
MiButterflyMapModel >> rightEntitiesQuery [

	^ rightEntitiesQuery
]

{ #category : #accessing }
MiButterflyMapModel >> rightEntitiesQuery: anObject [

	rightEntitiesQuery := anObject
]

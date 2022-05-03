Class {
	#name : #MiButterflyMapModel,
	#superclass : #Object,
	#instVars : [
		'currentEntity',
		'level'
	],
	#category : #'MooseIDE-ButterflyMap-Model'
}

{ #category : #accessing }
MiButterflyMapModel >> childrenFor: anEntity [

	^ anEntity children
]

{ #category : #accessing }
MiButterflyMapModel >> currentEntity [

	^ currentEntity
]

{ #category : #accessing }
MiButterflyMapModel >> currentEntity: anObject [

	currentEntity := anObject
]

{ #category : #initialization }
MiButterflyMapModel >> initialize [

	super initialize.
	level := 1
]

{ #category : #accessing }
MiButterflyMapModel >> level [

	^ level
]

{ #category : #accessing }
MiButterflyMapModel >> level: anObject [

	level := anObject
]

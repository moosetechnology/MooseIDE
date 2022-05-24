"
A model for the MiDSMBrowser, contains the entities to display, computes the dependencies and the colors to show the cells of the DSM matrix
"
Class {
	#name : #MiDSMBrowserModel,
	#superclass : #Object,
	#instVars : [
		'browser',
		'entities',
		'relationsForX'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #accessing }
MiDSMBrowserModel >> browser [

	^ browser
]

{ #category : #accessing }
MiDSMBrowserModel >> browser: anObject [

	browser := anObject
]

{ #category : #utilities }
MiDSMBrowserModel >> cacheDependencies: aCollection [
	"RSDSM conventions: X entities are at the top of the matricx, Y entities at the left
	We choose to say that there is a relation from X to Y if Y depends on X"
	relationsForX := Dictionary new.
	aCollection do: [ :each | 
		relationsForX
			at: each
			put: ((each queryAllIncoming withoutSelfLoops atScope: each class) intersection: entities) ]
]

{ #category : #testing }
MiDSMBrowserModel >> canFollowEntity: anObject [

	^ anObject isCollection and: [ 
		  anObject allSatisfy: [ :a | 
			  a usesFamixTrait: TEntityMetaLevelDependency ] ].
]

{ #category : #accessing }
MiDSMBrowserModel >> colorForX: xEntity y: yEntity [
	(self isDiagonalX: xEntity y: yEntity)
	ifTrue: [ ^Color veryLightGray ].
	(self isDependantX: xEntity onY: yEntity)
	ifTrue: [ ^Color colorFrom: '#4d79ff' ].
	^Color r: 0.9 g: 0.9 b: 0.9 "extremely light gray"
]

{ #category : #accessing }
MiDSMBrowserModel >> entities [
	^ entities
]

{ #category : #actions }
MiDSMBrowserModel >> followEntity: anEntity [
	entities := anEntity asMooseGroup select: [ :e | 
		e usesFamixTrait: TEntityMetaLevelDependency ].
	self cacheDependencies: entities.
	entities := self orderEntities: entities.
	entities ifNotEmpty: [
		browser showDSM]
]

{ #category : #actions }
MiDSMBrowserModel >> highlightEntity: anEntity [

	"browser highlightEntities: anEntity asCollection"
]

{ #category : #initialization }
MiDSMBrowserModel >> initialize [
	super initialize.
	entities := #()
]

{ #category : #testing }
MiDSMBrowserModel >> isDependantX: xEntity onY: yEntity [
	^(relationsForX at: xEntity) includes: yEntity
]

{ #category : #testing }
MiDSMBrowserModel >> isDiagonalX: xEntity y: yEntity [
	^xEntity = yEntity

]

{ #category : #utilities }
MiDSMBrowserModel >> orderEntities: aCollection [
	^aCollection sorted: [ :a :b || dependenciesA dependenciesB |
		dependenciesA := (relationsForX at: a) size.
		dependenciesB := (relationsForX at: b) size.
		(dependenciesA < dependenciesB)
		ifTrue: [ true ]
		ifFalse: [ (dependenciesA = dependenciesB)
			ifTrue: [ a name < b name ]
			ifFalse: [ false ] ]
	]
]

{ #category : #accessing }
MiDSMBrowserModel >> relationsForX: anEntity [
	^relationsForX at: anEntity
]

{ #category : #accessing }
MiDSMBrowserModel >> selectedEntities [
	^#()
]

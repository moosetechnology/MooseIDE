"
The spec model for the MiDeadCodeBrowser

Responsible for handling all interactions as well as computing the dead entities
"
Class {
	#name : 'MiDeadCodeBrowserModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'deadEntities',
		'candidateEntities',
		'chosenHeuristics',
		'availableHeuristics',
		'selectedDeadEntities'
	],
	#category : 'MooseIDE-DeadCode-Model',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Model'
}

{ #category : 'accessing' }
MiDeadCodeBrowserModel >> availableHeuristics [

	^availableHeuristics ifNil: [
		availableHeuristics := MiDeadCodeAbstractHeuristic withAllSubclasses
			select: [ :class | class isAbstract not ]
			thenCollect: [ :class | class new ]
	]
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> chooseHeuristics: heuristicCollection [
	"add all of heuristicCollection  to the internal list of chosenHeuristics"

	chosenHeuristics := (chosenHeuristics union: heuristicCollection)
		sort: self heuristicSortBlock.
	browser updateChosenHeuristics
]

{ #category : 'accessing' }
MiDeadCodeBrowserModel >> chosenHeuristics [

	^chosenHeuristics 
]

{ #category : 'accessing - private tests' }
MiDeadCodeBrowserModel >> clearChosenHeuristics [

	chosenHeuristics removeAll
]

{ #category : 'settings management' }
MiDeadCodeBrowserModel >> currentConfiguration [
	"no settings"
]

{ #category : 'accessing' }
MiDeadCodeBrowserModel >> deadEntities [

	^deadEntities 
]

{ #category : 'settings management' }
MiDeadCodeBrowserModel >> defaultConfiguration [
	"no settings"
]

{ #category : 'accessing' }
MiDeadCodeBrowserModel >> entities [

	^candidateEntities
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> firstRoundComputation [

	deadEntities removeAll.
	self entities do: [ :entity | self firstRoundOn: entity ].
	browser updateToolbar.
	browser updateDeadEntities
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> firstRoundOn: entity [
	"search for a heuristic that could deal with the entity
	 when found, go to next entity"

	chosenHeuristics do: [ :heuristic |
		(self heuristic: heuristic handle: entity)
			ifTrue: [ ^self ]
		]
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> followEntity: aCollection [

	candidateEntities := aCollection.
	browser candidateEntities: aCollection.
	browser updateChosenHeuristics
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> heuristic: heuristic handle: entity [
	"returns whether a decision was reached or not.
	 A decision is reached for _refuting_ heuristics if the entity is not dead
	   and there is nothing to do (but we do not need to check other heuristics)
	 A decision is reached for _asserting_ heuristic, if the entity is dead
	   and it must be added to the list of dead entities"

	heuristic refuteDead 
		ifTrue: [ (heuristic isDead: entity) ifFalse: [ ^true ] ]
		ifFalse: [
			(heuristic isDead: entity)
				ifTrue: [ deadEntities add: entity. ^true ]
		].
	
	^false
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> heuristicSortBlock [
	"sorts refuting heuristics before asserting ones.
	 inside these two categories, sort on their names"

	^[ :a :b |
		(a refuteDead = b refuteDead)
			ifTrue: [ a name < b name ]
			ifFalse: [ a refuteDead ]
		]
]

{ #category : 'initialization' }
MiDeadCodeBrowserModel >> initialize [ 

	super initialize.

	self initializeHeuristics.
	deadEntities := OrderedCollection new.
	selectedDeadEntities := #()
]

{ #category : 'initialization' }
MiDeadCodeBrowserModel >> initializeHeuristics [

	chosenHeuristics := OrderedCollection new:
		                    self availableHeuristics size.
	chosenHeuristics addAll:
		(self availableHeuristics select: [ :heuristic |
			 heuristic selectedByDefault ])
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> isNewDead: anEntity [

	(deadEntities includes: anEntity) ifTrue: [ ^ false ].

	^(anEntity queryIncoming: FamixTInvocation) opposites
		allSatisfy: [ :invoker | deadEntities includes: invoker ]
]

{ #category : 'accessing' }
MiDeadCodeBrowserModel >> miSelectedItem [

	^selectedDeadEntities ifEmpty: [ deadEntities ] 
]

{ #category : 'accessing' }
MiDeadCodeBrowserModel >> miSelectedItems: aCollection [

	selectedDeadEntities := aCollection 
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> oneRoundRecursion [

	| addNewDead |
	addNewDead := false.

	self deadEntities clone do: [ :dead |
		(dead queryOutgoing: FamixTInvocation) opposites do: [ :invoked |
			(self isNewDead: invoked) ifTrue: [
				deadEntities add: invoked.
				addNewDead := true
			]
		]
	].

	^ addNewDead
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> recursionComputation [

	[ self oneRoundRecursion ]
		whileTrue.

	browser updateDeadEntities
]

{ #category : 'settings management' }
MiDeadCodeBrowserModel >> settings [
	"no settings"

]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> unchooseHeuristics: heuristicCollection [
	"remove all of heuristicCollection from the internal list of chosenHeuristics"

	chosenHeuristics removeAll: heuristicCollection.
	browser updateChosenHeuristics
]

{ #category : 'settings management' }
MiDeadCodeBrowserModel >> updateFromConfiguration: aConfiguration [
	"no settings"
]

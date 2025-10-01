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
		'allHeuristics',
		'selectedHeuristics'
	],
	#category : 'MooseIDE-Dependency-DeadCode',
	#package : 'MooseIDE-Dependency',
	#tag : 'DeadCode'
}

{ #category : 'accessing' }
MiDeadCodeBrowserModel >> availableHeuristics [

	^allHeuristics
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> clearDeads [

	deadEntities := OrderedCollection new.
	browser updateDeadEntities
]

{ #category : 'accessing - private tests' }
MiDeadCodeBrowserModel >> clearSelectedHeuristics [

	selectedHeuristics removeAll
]

{ #category : 'accessing' }
MiDeadCodeBrowserModel >> deadEntities [

	^deadEntities 
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

	selectedHeuristics do: [ :heuristic |
		(self heuristic: heuristic handle: entity)
			ifTrue: [ ^self ]
		]
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> followEntity: aCollection [

	candidateEntities := aCollection.
	browser candidateEntities: aCollection.
	browser updateHeuristicSelection
]

{ #category : 'accessing' }
MiDeadCodeBrowserModel >> gatherHeuristics [

	^MiDeadCodeAbstractHeuristic withAllSubclasses
		select: [ :class | class isAbstract not ]
		thenCollect: [ :class | class new ]
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> heuristic: heuristic handle: entity [
	"returns whether a decision was reach or not.
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

{ #category : 'initialization' }
MiDeadCodeBrowserModel >> initialize [ 

	super initialize.

	self initializeHeuristics.
	deadEntities := OrderedCollection new
]

{ #category : 'initialization' }
MiDeadCodeBrowserModel >> initializeHeuristics [

	allHeuristics := self gatherHeuristics.

	selectedHeuristics := OrderedCollection new: allHeuristics size.
	allHeuristics do: [ :heuristic |
		heuristic selectedByDefault
			ifTrue: [ selectedHeuristics add: heuristic ] ].

]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> isNewDead: anEntity [

	(deadEntities includes: anEntity) ifTrue: [ ^false ].

	^anEntity queryAllIncomingInvocations opposites allSatisfy: [ :invoker |
		deadEntities includes: invoker
	] 
]

{ #category : 'accessing' }
MiDeadCodeBrowserModel >> miSelectedItem [

	^deadEntities 
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> oneRoundRecursion [

	| addNewDead |
	addNewDead := false.

	self deadEntities clone do: [ :dead |
		dead queryAllOutgoingInvocations opposites do: [ :invoked |
			(self isNewDead: invoked) ifTrue: [
				deadEntities add: invoked.
				addNewDead := true
			]
		]
	].

	^addNewDead
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> recursionComputation [

	[ self oneRoundRecursion ]
		whileTrue
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> rejectHeuristics [
	"remove all heuristics selected by the user in listHeuristicsSelected from
	 the internal list of selectedHeuristics"

	| reject |
	reject := browser heuristicColumn listHeuristicsSelected selectedItems clone.

	selectedHeuristics removeAll: reject.
	browser updateHeuristicSelection
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> selectHeuristics [
	"add all heuristics selected by the user in listHeuristicsOffered to
	 the internal list of selectedHeuristics"

	selectedHeuristics := (selectedHeuristics union:
		browser heuristicColumn listHeuristicsOffered selectedItems).
	self sortHeuristics.
	browser updateHeuristicSelection
]

{ #category : 'accessing' }
MiDeadCodeBrowserModel >> selectedHeuristics [

	^selectedHeuristics 
]

{ #category : 'settings' }
MiDeadCodeBrowserModel >> settings [

]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> sortHeuristics [
	"sorts refuting heuristics before asserting ones.
	 if of the samecategory, sort on their names"

	selectedHeuristics sort: [ :a :b |
		(a refuteDead = b refuteDead)
			ifTrue: [ a name < b name ]
			ifFalse: [ a refuteDead ]
		]
]

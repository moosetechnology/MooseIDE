"
The spec model for the MiDeadCodeBrowser

Responsible for handling all interactions as well as computing the dead entities
"
Class {
	#name : 'MiDeadCodeBrowserModelWithCallGraph',
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
MiDeadCodeBrowserModelWithCallGraph >> availableHeuristics [

	^availableHeuristics ifNil: [
		availableHeuristics := MiDeadCodeAbstractHeuristic withAllSubclasses
			select: [ :class | class isAbstract not ]
			thenCollect: [ :class | class new ]
	]
]

{ #category : 'actions' }
MiDeadCodeBrowserModelWithCallGraph >> chooseHeuristics: heuristicCollection [
	"add all of heuristicCollection  to the internal list of chosenHeuristics"

	chosenHeuristics := (chosenHeuristics union: heuristicCollection)
		sort: self heuristicSortBlock.
	browser updateChosenHeuristics
]

{ #category : 'accessing' }
MiDeadCodeBrowserModelWithCallGraph >> chosenHeuristics [

	^chosenHeuristics 
]

{ #category : 'actions' }
MiDeadCodeBrowserModelWithCallGraph >> clearChosenHeuristics [

	chosenHeuristics removeAll
]

{ #category : 'private' }
MiDeadCodeBrowserModelWithCallGraph >> computeCallGraph [

	^(FamixJavaCHABuilder
		entryPoints: (self entities select: [ :entity | self isEntryPoint: entity ]))
		build.

]

{ #category : 'actions' }
MiDeadCodeBrowserModelWithCallGraph >> computeDeadEntitiesFrom: calledEntities [

	deadEntities := (OrderedCollection withAll: self entities) \ calledEntities
]

{ #category : 'settings management' }
MiDeadCodeBrowserModelWithCallGraph >> currentConfiguration [
	"no settings"
]

{ #category : 'accessing' }
MiDeadCodeBrowserModelWithCallGraph >> deadEntities [

	^deadEntities 
]

{ #category : 'settings management' }
MiDeadCodeBrowserModelWithCallGraph >> defaultConfiguration [
	"no settings"
]

{ #category : 'accessing' }
MiDeadCodeBrowserModelWithCallGraph >> entities [

	^candidateEntities
]

{ #category : 'actions' }
MiDeadCodeBrowserModelWithCallGraph >> firstRoundComputation [

	| graph |
	deadEntities removeAll.

	graph := self computeCallGraph.
	self computeDeadEntitiesFrom: (graph allNodes collect: #realMethod).

	browser updateToolbar.
	browser updateDeadEntities
]

{ #category : 'actions' }
MiDeadCodeBrowserModelWithCallGraph >> firstRoundOn: entity [
	"search for a heuristic that could deal with the entity
	 when found, go to next entity"

	chosenHeuristics do: [ :heuristic |
		(self heuristic: heuristic handle: entity)
			ifTrue: [ ^self ]
		]
]

{ #category : 'actions' }
MiDeadCodeBrowserModelWithCallGraph >> followEntity: aCollection [

	candidateEntities := aCollection.
	browser candidateEntities: aCollection.
	browser updateChosenHeuristics
]

{ #category : 'actions' }
MiDeadCodeBrowserModelWithCallGraph >> graph: graph contains: mth [

	^graph allNodes anySatisfy: [ :node | node realMethod = mth]
]

{ #category : 'actions' }
MiDeadCodeBrowserModelWithCallGraph >> heuristic: heuristic handle: entity [
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
MiDeadCodeBrowserModelWithCallGraph >> heuristicSortBlock [
	"sorts refuting heuristics before asserting ones.
	 inside these two categories, sort on their names"

	^[ :a :b |
		(a refuteDead = b refuteDead)
			ifTrue: [ a name < b name ]
			ifFalse: [ a refuteDead ]
		]
]

{ #category : 'initialization' }
MiDeadCodeBrowserModelWithCallGraph >> initialize [ 

	super initialize.

	self initializeHeuristics.
	deadEntities := OrderedCollection new.
	selectedDeadEntities := #()
]

{ #category : 'initialization' }
MiDeadCodeBrowserModelWithCallGraph >> initializeHeuristics [

	chosenHeuristics := OrderedCollection new:
		                    self availableHeuristics size.
	chosenHeuristics addAll:
		(self availableHeuristics select: [ :heuristic |
			 heuristic selectedByDefault ])
]

{ #category : 'actions' }
MiDeadCodeBrowserModelWithCallGraph >> isEntryPoint: entity [

	chosenHeuristics do: [ :heuristic |
		(self heuristic: heuristic handle: entity)
			ifTrue: [ heuristic isForEntryPoint 
				ifTrue: [ (heuristic accept: entity) ifTrue: [ ^true ] ]
			]
		].
	^false
]

{ #category : 'accessing' }
MiDeadCodeBrowserModelWithCallGraph >> miSelectedItem [

	^selectedDeadEntities ifEmpty: [ deadEntities ] 
]

{ #category : 'accessing' }
MiDeadCodeBrowserModelWithCallGraph >> miSelectedItems: aCollection [

	selectedDeadEntities := aCollection 
]

{ #category : 'actions' }
MiDeadCodeBrowserModelWithCallGraph >> recursionComputation [

	UIManager default inform: 'No recursion done'
]

{ #category : 'settings management' }
MiDeadCodeBrowserModelWithCallGraph >> settings [
	"no settings"

]

{ #category : 'actions' }
MiDeadCodeBrowserModelWithCallGraph >> unchooseHeuristics: heuristicCollection [
	"remove all of heuristicCollection from the internal list of chosenHeuristics"

	chosenHeuristics removeAll: heuristicCollection.
	browser updateChosenHeuristics
]

{ #category : 'settings management' }
MiDeadCodeBrowserModelWithCallGraph >> updateFromConfiguration: aConfiguration [
	"no settings"
]

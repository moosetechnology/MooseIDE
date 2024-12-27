"
The spec model for the MiDeadCodeBrowser

Responsible for handling all interactions as well as computing the dead entities
"
Class {
	#name : #MiDeadCodeBrowserModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'deadEntities',
		'candidateEntities',
		'allHeuristics',
		'selectedHeuristics'
	],
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #accessing }
MiDeadCodeBrowserModel >> availableHeuristics [

	^allHeuristics
]

{ #category : #'accessing - private tests' }
MiDeadCodeBrowserModel >> clearSelectedHeuristics [

	selectedHeuristics removeAll
]

{ #category : #accessing }
MiDeadCodeBrowserModel >> deadEntities [

	^deadEntities 
]

{ #category : #accessing }
MiDeadCodeBrowserModel >> entities [

	^candidateEntities
]

{ #category : #actions }
MiDeadCodeBrowserModel >> firstRoundComputation [

	deadEntities removeAll.
	self entities do: [ :entity | self firstRoundOn: entity ].
	browser updateDeadEntities
]

{ #category : #actions }
MiDeadCodeBrowserModel >> firstRoundOn: entity [
	"search for a heuristic that could deal with the entity
	 when found, go to next entity"

	selectedHeuristics do: [ :heuristic |
		(self heuristic: heuristic handle: entity)
			ifTrue: [ ^self ]
		]
]

{ #category : #actions }
MiDeadCodeBrowserModel >> followEntity: aCollection [

	candidateEntities := aCollection.
	browser candidateEntities: aCollection 
]

{ #category : #accessing }
MiDeadCodeBrowserModel >> gatherHeuristics [

	^MiDeadCodeAbstractHeuristic withAllSubclasses
		select: [ :class | class isAbstract not ]
		thenCollect: [ :class | class new ]
]

{ #category : #actions }
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

{ #category : #initialization }
MiDeadCodeBrowserModel >> initialize [ 

	super initialize.

	self initializeHeuristics.
	deadEntities := OrderedCollection new
]

{ #category : #initialization }
MiDeadCodeBrowserModel >> initializeHeuristics [

	allHeuristics := self gatherHeuristics.

	selectedHeuristics := Set new: allHeuristics size.
	allHeuristics do: [ :heuristic |
		heuristic selectedByDefault
			ifTrue: [ selectedHeuristics add: heuristic ] ]
]

{ #category : #accessing }
MiDeadCodeBrowserModel >> miSelectedItem [

	^#()
]

{ #category : #actions }
MiDeadCodeBrowserModel >> rejectHeuristics [
	"remove all heuristics selected by the user in listHeuristicsSelected from
	 the internal list of selectedHeuristics"

	| reject |
	reject := browser heuristicColumn listHeuristicsSelected selectedItems clone.

	selectedHeuristics removeAll: reject.
	browser updateHeuristicSelection
]

{ #category : #actions }
MiDeadCodeBrowserModel >> selectHeuristics [
	"add all heuristics selected by the user in listHeuristicsOffered to
	 the internal list of selectedHeuristics"

	selectedHeuristics addAll: browser heuristicColumn listHeuristicsOffered selectedItems.
	browser updateHeuristicSelection
]

{ #category : #accessing }
MiDeadCodeBrowserModel >> selectedHeuristics [

	^selectedHeuristics 
]

{ #category : #settings }
MiDeadCodeBrowserModel >> settings [

]

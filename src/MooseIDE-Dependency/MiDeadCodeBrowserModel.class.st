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

{ #category : #'accessing - private tests' }
MiDeadCodeBrowserModel >> availableHeuristics [

	^allHeuristics
]

{ #category : #'accessing - private tests' }
MiDeadCodeBrowserModel >> clearSelectedHeuristics [

	selectedHeuristics removeAll.
	browser updateHeuristicSelection
]

{ #category : #accessing }
MiDeadCodeBrowserModel >> entities [

	^candidateEntities
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

	| reject |
	reject := browser heuristicColumn listHeuristicsSelected selectedItems clone.

	selectedHeuristics removeAll: reject.
	browser updateHeuristicSelection
]

{ #category : #actions }
MiDeadCodeBrowserModel >> selectHeuristics [

	selectedHeuristics addAll: browser heuristicColumn listHeuristicsOffered selectedItems.
	browser updateHeuristicSelection
]

{ #category : #accessing }
MiDeadCodeBrowserModel >> selectedHeuristics [

	^selectedHeuristics 
]

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
		'allHeuristics'
	],
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #'accessing - private tests' }
MiDeadCodeBrowserModel >> availableHeuristics [

	^allHeuristics
]

{ #category : #accessing }
MiDeadCodeBrowserModel >> entities [

	^candidateEntities
]

{ #category : #actions }
MiDeadCodeBrowserModel >> followEntity: aCollection [

	candidateEntities := aCollection 
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

	allHeuristics := self gatherHeuristics.
	deadEntities := OrderedCollection new
]

{ #category : #accessing }
MiDeadCodeBrowserModel >> miSelectedItem [

	^#()
]

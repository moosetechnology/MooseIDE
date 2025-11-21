Class {
	#name : 'MiDeadCodeHeuristicListPresenter',
	#superclass : 'SpComponentListPresenter',
	#category : 'MooseIDE-DeadCode-Browser',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Browser'
}

{ #category : 'api' }
MiDeadCodeHeuristicListPresenter >> chosenHeuristics [

	^self selectedItems collect: #heuristic	
]

{ #category : 'initialization' }
MiDeadCodeHeuristicListPresenter >> initialize [

	super initialize.

	self beMultipleSelection 
]

{ #category : 'api' }
MiDeadCodeHeuristicListPresenter >> items: heuristicsCollection [

	| sortedHeuristics |
	sortedHeuristics := heuristicsCollection sorted: [ :o1 :o2 | o1 name < o2 name ].
	^super items: (sortedHeuristics collect: [:heuristic | MiDeadCodeHeuristicPresenter withHeuristic: heuristic])
]

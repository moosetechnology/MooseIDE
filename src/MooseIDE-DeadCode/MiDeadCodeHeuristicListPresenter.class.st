Class {
	#name : 'MiDeadCodeHeuristicListPresenter',
	#superclass : 'SpTreeListViewPresenter',
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
	
"
	contentView := self newTreeListView
		setup: [ :aPresenter | 
			(aPresenter instantiate: self rowPresenterClass)
				listView: self;
				yourself ];
		bind: [ :aPresenter :anObject | 
			aPresenter model: anObject ];
		yourself.

"
]

{ #category : 'api' }
MiDeadCodeHeuristicListPresenter >> items: heuristicsCollection [

	| sortedHeuristics |

	sortedHeuristics := "heuristicsCollection sorted: [ :o1 :o2 | o1 name < o2 name ]."
		heuristicsCollection groupedBy: [ :heuristic | heuristic heuristicGroup ].

	self roots: (sortedHeuristics associations 
		collect: [ :heuristicGroup |
			heuristicGroup key isString
				ifTrue: [
					MiDeadCodeHeuristicGroup new
						name: heuristicGroup key ;
						heuristics: heuristicGroup value
				]
				ifFalse: [ heuristicGroup key ]
		]).
	
	self children: [ :item | item heuristics ].	
	self bind: [ :aPresenter :anObject | aPresenter label: anObject name ]

	"^super items: (sortedHeuristics collect: [:heuristic | MiDeadCodeHeuristicPresenter withHeuristic: heuristic])"
]

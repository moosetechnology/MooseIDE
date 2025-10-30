Class {
	#name : 'MiDeadCodeBrowserHeuristicColum',
	#superclass : 'SpPresenter',
	#instVars : [
		'lstHeuristicsOffered',
		'btnSelectHeuristic',
		'btnRejectHeuristic',
		'lstHeuristicsChosen'
	],
	#category : 'MooseIDE-DeadCode',
	#package : 'MooseIDE-DeadCode'
}

{ #category : 'accessing - private tests' }
MiDeadCodeBrowserHeuristicColum >> buttonRejectHeuristics [

	^btnRejectHeuristic 
]

{ #category : 'accessing - private tests' }
MiDeadCodeBrowserHeuristicColum >> buttonSelectHeuristics [

	^btnSelectHeuristic 
]

{ #category : 'accessing' }
MiDeadCodeBrowserHeuristicColum >> chosenHeuristics [

	^self specModel chosenHeuristics
]

{ #category : 'layout' }
MiDeadCodeBrowserHeuristicColum >> defaultLayout [

	^SpBoxLayout newTopToBottom
		add: 'Available heuristics' expand: false ;
		add: lstHeuristicsOffered expand: true ;
		add: (SpBoxLayout newLeftToRight
			add: btnSelectHeuristic ;
			add: btnRejectHeuristic ;
			yourself)
		height: self toolbarHeight ;
		add: 'Selected heuristics' expand: false ;
		add: lstHeuristicsChosen expand: true ;
		yourself
]

{ #category : 'layout' }
MiDeadCodeBrowserHeuristicColum >> heuristicColumnLayout [

	^SpBoxLayout newTopToBottom
		add: lstHeuristicsOffered expand: true ;
		add: (SpBoxLayout newLeftToRight
			add: btnSelectHeuristic ;
			add: btnRejectHeuristic ;
			yourself)
		height: self toolbarHeight ;
		add: lstHeuristicsChosen expand: true ;
		yourself
]

{ #category : 'initialization' }
MiDeadCodeBrowserHeuristicColum >> initializePresenters [

	lstHeuristicsOffered := self newTable
		hideColumnHeaders ;
		addColumn: (MiDeadCodeMorphicStringTableColumn evaluated: #name) ;
		items: (self specModel availableHeuristics sorted: [ :o1 :o2 | o1 name < o2 name ]) ;
		beMultipleSelection.

	lstHeuristicsChosen := self newList
		beMultipleSelection ;
		display: [:item | item name].
	self selectedHeuristics: self specModel selectedHeuristics.

	btnSelectHeuristic := self newButton
		label: 'v' ;
		action: [ self specModel selectHeuristics].

	btnRejectHeuristic := self newButton
		label: '^' ;
		action: [ self specModel rejectHeuristics].

]

{ #category : 'accessing' }
MiDeadCodeBrowserHeuristicColum >> listHeuristicsOffered [ 

	^lstHeuristicsOffered 
]

{ #category : 'accessing' }
MiDeadCodeBrowserHeuristicColum >> listHeuristicsSelected [ 

	^lstHeuristicsChosen
]

{ #category : 'actions' }
MiDeadCodeBrowserHeuristicColum >> selectedHeuristics: aCollection [

	lstHeuristicsChosen items: aCollection
]

{ #category : 'accessing' }
MiDeadCodeBrowserHeuristicColum >> specModel [ 

	^owner specModel
]

{ #category : 'TOREMOVE' }
MiDeadCodeBrowserHeuristicColum >> toolbarHeight [

	^self class toolbarHeight
]

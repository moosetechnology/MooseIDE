Class {
	#name : 'MiDeadCodeBrowserHeuristicColum',
	#superclass : 'SpPresenter',
	#instVars : [
		'lstHeuristicsOffered',
		'btnRejectHeuristic',
		'btnChooseHeuristics',
		'lstChosenHeuristics'
	],
	#category : 'MooseIDE-DeadCode',
	#package : 'MooseIDE-DeadCode'
}

{ #category : 'accessing - private tests' }
MiDeadCodeBrowserHeuristicColum >> buttonChooseHeuristics [

	^btnChooseHeuristics 
]

{ #category : 'accessing - private tests' }
MiDeadCodeBrowserHeuristicColum >> buttonUnchooseHeuristics [

	^btnRejectHeuristic 
]

{ #category : 'accessing' }
MiDeadCodeBrowserHeuristicColum >> chosenHeuristics: aCollection [

	lstChosenHeuristics items: aCollection
]

{ #category : 'initialization' }
MiDeadCodeBrowserHeuristicColum >> connectPresenters [

	btnChooseHeuristics action: [
		self specModel chooseHeuristics: lstHeuristicsOffered chosenHeuristics.
		self resetSelection
	].

	btnRejectHeuristic action: [
		self specModel unchooseHeuristics: lstChosenHeuristics chosenHeuristics.
		self resetSelection
	].

]

{ #category : 'layout' }
MiDeadCodeBrowserHeuristicColum >> defaultLayout [

	^SpBoxLayout newTopToBottom
		add: 'Available heuristics' expand: false ;
		add: lstHeuristicsOffered expand: true ;
		add: (SpBoxLayout newLeftToRight
			add: btnChooseHeuristics ;
			add: btnRejectHeuristic ;
			yourself)
		height: self toolbarHeight ;
		add: 'Selected heuristics' expand: false ;
		add: lstChosenHeuristics expand: true ;
		yourself
]

{ #category : 'initialization' }
MiDeadCodeBrowserHeuristicColum >> initializePresenters [

	lstHeuristicsOffered := self newHeuristicList
		items: self specModel availableHeuristics.

	lstChosenHeuristics := self newHeuristicList
		items: self specModel chosenHeuristics.

	btnChooseHeuristics := self newButton
		label: 'v' ;
		action: [ self specModel chooseHeuristics: lstHeuristicsOffered chosenHeuristics ].

	btnRejectHeuristic := self newButton
		label: '^' ;
		action: [ self specModel unchooseHeuristics: lstChosenHeuristics chosenHeuristics ].

]

{ #category : 'accessing - private tests' }
MiDeadCodeBrowserHeuristicColum >> listHeuristicsOffered [ 

	^lstHeuristicsOffered 
]

{ #category : 'initialization' }
MiDeadCodeBrowserHeuristicColum >> newHeuristicList [

	^self instantiate: MiDeadCodeHeuristicListPresenter
]

{ #category : 'actions' }
MiDeadCodeBrowserHeuristicColum >> resetSelection [

	lstHeuristicsOffered unselectAll.
	lstChosenHeuristics unselectAll 
]

{ #category : 'accessing' }
MiDeadCodeBrowserHeuristicColum >> specModel [ 

	^owner specModel
]

{ #category : 'TOREMOVE' }
MiDeadCodeBrowserHeuristicColum >> toolbarHeight [

	^self class toolbarHeight
]

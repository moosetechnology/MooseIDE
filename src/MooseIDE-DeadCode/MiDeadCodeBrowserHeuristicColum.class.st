Class {
	#name : 'MiDeadCodeBrowserHeuristicColum',
	#superclass : 'SpPresenter',
	#instVars : [
		'btnRejectHeuristic',
		'btnChooseHeuristics',
		'lstChosenHeuristics',
		'lstOfferedHeuristics'
	],
	#category : 'MooseIDE-DeadCode-Browser',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Browser'
}

{ #category : 'accessing' }
MiDeadCodeBrowserHeuristicColum >> chosenHeuristics: aCollection [

	lstChosenHeuristics items: aCollection
]

{ #category : 'initialization' }
MiDeadCodeBrowserHeuristicColum >> connectPresenters [

	btnChooseHeuristics action: [
		self specModel chooseHeuristics: lstOfferedHeuristics chosenHeuristics.
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
		add: lstOfferedHeuristics expand: true ;
		add: (SpBoxLayout newLeftToRight
			add: btnChooseHeuristics ;
			add: btnRejectHeuristic ;
			yourself)
		height: self toolbarHeight ;
		add: 'Selected heuristics' expand: false ;
		add: lstChosenHeuristics expand: true ;
		yourself
]

{ #category : 'accessing' }
MiDeadCodeBrowserHeuristicColum >> heuristicGroupChildrenFor: heuristicGroup [

	heuristicGroup key isString
		ifTrue: [ heuristicGroup value ]
		ifFalse: [ {  heuristicGroup key } ]
]

{ #category : 'initialization' }
MiDeadCodeBrowserHeuristicColum >> initializeOfferedHeuristicsList: availableHeuristics [

	| treeList groupedHeuristics |

	groupedHeuristics := availableHeuristics groupedBy: [ :heuristic | heuristic heuristicGroup ].

	treeList := self newTreeListView.
	treeList setup: [ :aPresenter | aPresenter instantiate: MiDeadCodeHeuristicPresenter ].
	treeList bind: [ :aPresenter :anObject | aPresenter heuristicGroup: anObject ].
	treeList children: [ :association | self childrenFor: association ].

	treeList roots: groupedHeuristics associations.

	^treeList 

]

{ #category : 'initialization' }
MiDeadCodeBrowserHeuristicColum >> initializePresenters [

	lstOfferedHeuristics := self initializeOfferedHeuristicsList: self specModel availableHeuristics.

	lstChosenHeuristics := self newHeuristicList
		items: self specModel chosenHeuristics.

	btnChooseHeuristics := self newButton
		label: 'v' ;
		action: [ self specModel chooseHeuristics: lstOfferedHeuristics chosenHeuristics ].

	btnRejectHeuristic := self newButton
		label: '^' ;
		action: [ self specModel unchooseHeuristics: lstChosenHeuristics chosenHeuristics ].

]

{ #category : 'initialization' }
MiDeadCodeBrowserHeuristicColum >> newHeuristicList [

	^self instantiate: MiDeadCodeHeuristicListPresenter
]

{ #category : 'actions' }
MiDeadCodeBrowserHeuristicColum >> resetSelection [

	lstOfferedHeuristics unselectAll.
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

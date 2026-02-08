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

	lstChosenHeuristics items: (aCollection collect: [:heuristic | MiDeadCodeHeuristicPresenter withHeuristic: heuristic])
]

{ #category : 'initialization' }
MiDeadCodeBrowserHeuristicColum >> connectPresenters [

	btnChooseHeuristics action: [
		self specModel chooseHeuristics: self selectedHeuristicsOffered.
		self resetSelection
	].

	btnRejectHeuristic action: [
		self specModel unchooseHeuristics: self selectedHeuristicsChosen.
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

	^heuristicGroup key isString
		ifTrue: [ heuristicGroup value collect: [ :heuristic | heuristic -> heuristic ] ]
		ifFalse: [ #() ]
]

{ #category : 'initialization' }
MiDeadCodeBrowserHeuristicColum >> initializeOfferedHeuristicsList: availableHeuristics [

	| groupedHeuristics |

	groupedHeuristics := availableHeuristics groupedBy: [ :heuristic | heuristic heuristicGroup ].

	^self newTreeListView
		beMultipleSelection ;
		setup: [ :aPresenter | aPresenter instantiate: MiDeadCodeHeuristicPresenter ] ;
		bind: [ :aPresenter :anObject | aPresenter heuristicGroup: anObject ] ;
		children: [ :association | self heuristicGroupChildrenFor: association ] ;
		roots: groupedHeuristics associations ;
		yourself
]

{ #category : 'initialization' }
MiDeadCodeBrowserHeuristicColum >> initializePresenters [

	lstOfferedHeuristics := self initializeOfferedHeuristicsList: self specModel availableHeuristics.

	lstChosenHeuristics := self newList
		beMultipleSelection ;
		display: #label ;
		sortingBlock: [ :a :b |a label < b label ] ;
		items: (self specModel chosenHeuristics
			collect: [:heuristic | MiDeadCodeHeuristicPresenter withHeuristic: heuristic]).

	btnChooseHeuristics := self newButton
		icon: (self iconNamed: #mooseDown) ;
		help: 'Select' ;
		action: [ self specModel chooseHeuristics: lstOfferedHeuristics chosenHeuristics ].

	btnRejectHeuristic := self newButton
		icon: (self iconNamed: #mooseTrash) ;
		help: 'De-select' ;
		action: [ self specModel unchooseHeuristics: lstChosenHeuristics chosenHeuristics ].

]

{ #category : 'actions' }
MiDeadCodeBrowserHeuristicColum >> resetSelection [

	lstOfferedHeuristics unselectAll.
	lstChosenHeuristics unselectAll 
]

{ #category : 'as yet unclassified' }
MiDeadCodeBrowserHeuristicColum >> selectedHeuristicsChosen [

	^lstChosenHeuristics selectedItems
		collect: #heuristic

]

{ #category : 'actions' }
MiDeadCodeBrowserHeuristicColum >> selectedHeuristicsOffered [

	^lstOfferedHeuristics selectedItems
		flatCollectAsSet: [  :item |
			item key isString
				ifTrue: [ item value ]
				ifFalse: [ {  item key } ] ]
]

{ #category : 'accessing' }
MiDeadCodeBrowserHeuristicColum >> specModel [ 

	^owner specModel
]

{ #category : 'TOREMOVE' }
MiDeadCodeBrowserHeuristicColum >> toolbarHeight [

	^self class toolbarHeight
]

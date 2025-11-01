"
A class to implement the right column (results) of the DeadCodeBrowser
"
Class {
	#name : 'MiDeadCodeBrowserResultColum',
	#superclass : 'SpPresenter',
	#instVars : [
		'lstDeadMethods',
		'btnFirstRound',
		'btnRecursive',
		'lblDeadMethods'
	],
	#category : 'MooseIDE-DeadCode',
	#package : 'MooseIDE-DeadCode'
}

{ #category : 'accessing - private tests' }
MiDeadCodeBrowserResultColum >> buttonFirstRound [

	^btnFirstRound 
]

{ #category : 'accessing - private tests' }
MiDeadCodeBrowserResultColum >> buttonRecursiveRound [

	^btnRecursive 
]

{ #category : 'layout' }
MiDeadCodeBrowserResultColum >> defaultLayout [

	^SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
			add: btnFirstRound ;
			add: btnRecursive ;
			yourself)
		height: self toolbarHeight ;
		add: lblDeadMethods height: self toolbarHeight ;
		add: lstDeadMethods expand: true ;
		yourself
]

{ #category : 'initialization' }
MiDeadCodeBrowserResultColum >> initializePresenters [

	lstDeadMethods := self newList
		display: #mooseName ;
		sortingBlock: #mooseName ascending.

	btnFirstRound := self newButton
		label: '1st round' ;
		enabled: false ;
		action: [ self specModel firstRoundComputation].

	btnRecursive := self newButton
		label: 'recursion' ;
		enabled: false ;
		action: [ self specModel recursionComputation].

	lblDeadMethods := self newLabel
		label: '0 dead entities'
]

{ #category : 'accessing - private tests' }
MiDeadCodeBrowserResultColum >> labelDeadEntities [

	^lblDeadMethods 
]

{ #category : 'accessing - private tests' }
MiDeadCodeBrowserResultColum >> listDeadEntities [

	^lstDeadMethods 
]

{ #category : 'accessing' }
MiDeadCodeBrowserResultColum >> specModel [ 

	^owner specModel
]

{ #category : 'TOREMOVE' }
MiDeadCodeBrowserResultColum >> toolbarHeight [

	^self class toolbarHeight
]

{ #category : 'actions' }
MiDeadCodeBrowserResultColum >> update [

	| deads |
	deads := self specModel deadEntities.
	lstDeadMethods items: deads.
	lblDeadMethods label: deads size asString , ' dead entities'.

	btnFirstRound enabled: (self specModel chosenHeuristics isNotEmpty).
	btnRecursive enabled: (deads isNotEmpty)
]

{ #category : 'actions' }
MiDeadCodeBrowserResultColum >> updateChosenHeuristics [

	btnFirstRound enabled: (self specModel chosenHeuristics isNotEmpty)
]

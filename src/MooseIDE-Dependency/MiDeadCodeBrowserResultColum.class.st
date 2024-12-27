"
A class to implement the right column (results) of the DeadCodeBrowser
"
Class {
	#name : #MiDeadCodeBrowserResultColum,
	#superclass : #SpPresenter,
	#instVars : [
		'lstDeadMethods',
		'btnFirstRound',
		'btnRecursive',
		'lblDeadMethods'
	],
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #'accessing - private tests' }
MiDeadCodeBrowserResultColum >> buttonFirstRound [

	^btnFirstRound 
]

{ #category : #layout }
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

{ #category : #initialization }
MiDeadCodeBrowserResultColum >> initializePresenters [

	lstDeadMethods := self newList.

	btnFirstRound := self newButton
		label: '1st round' ;
		action: [ self specModel firstRoundComputation].

	btnRecursive := self newButton
		label: 'recursion' ;
		action: [ self specModel recursiveComputation].

	lblDeadMethods := self newLabel
		label: '0 dead entities'
]

{ #category : #accessing }
MiDeadCodeBrowserResultColum >> specModel [ 

	^owner specModel
]

{ #category : #TOREMOVE }
MiDeadCodeBrowserResultColum >> toolbarHeight [

	^self class toolbarHeight
]

{ #category : #actions }
MiDeadCodeBrowserResultColum >> update [

	| deads |
	deads := self specModel deadEntities.
	lstDeadMethods items: deads.
	lblDeadMethods label: deads asString , ' dead entities'.

	btnRecursive enabled: deads isNotEmpty
]

{ #category : #actions }
MiDeadCodeBrowserResultColum >> updateHeuristicSelection [

	btnFirstRound enabled: (self specModel selectedHeuristics isNotEmpty)
]

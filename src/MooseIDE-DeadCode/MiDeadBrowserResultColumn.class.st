"
A class to implement the right column (results) of the DeadCodeBrowser
"
Class {
	#name : 'MiDeadBrowserResultColumn',
	#superclass : 'SpPresenter',
	#instVars : [
		'lstDeadMethods',
		'lblDeadMethods',
		'btnRun',
		'btnClear',
		'btnRefactor'
	],
	#category : 'MooseIDE-DeadCode-Browser',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Browser'
}

{ #category : 'initialization' }
MiDeadBrowserResultColumn >> connectPresenters [

	lstDeadMethods
		whenModelChangedDo: [ :new :old :evt | lstDeadMethods unselectAll ] ;
		whenSelectionChangedDo: [ self specModel miSelectedItems: lstDeadMethods selectedItems ].

	btnRun action: [ self specModel runComputation].

	btnClear action: [ self specModel clearDeads].

	btnRefactor action: [ self specModel refactorCode]
]

{ #category : 'layout' }
MiDeadBrowserResultColumn >> defaultLayout [

	^SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
			add: btnRun ;
			add: btnClear ;
			add: btnRefactor ;
			yourself)
		height: self toolbarHeight ;
		add: lblDeadMethods height: self toolbarHeight ;
		add: lstDeadMethods expand: true ;
		yourself
]

{ #category : 'initialization' }
MiDeadBrowserResultColumn >> initializePresenters [

	lstDeadMethods := self newList
		beMultipleSelection ;
		display: #mooseName ;
		sortingBlock: #mooseName ascending.

	btnRun := self newButton
		label: 'Run' ;
		enabled: false.

	btnClear := self newButton
		label: 'Clear'.

	btnRefactor := self newButton
		label: 'Refactor' ;
		enabled: false.

	lblDeadMethods := self newLabel
		label: '0 dead entities'
]

{ #category : 'actions' }
MiDeadBrowserResultColumn >> refactorDone [

	lblDeadMethods label: (lblDeadMethods label , ' -- removed from code').

	btnRun enabled: false.
	btnRefactor enabled: false
]

{ #category : 'accessing' }
MiDeadBrowserResultColumn >> specModel [ 

	^owner specModel
]

{ #category : 'TOREMOVE' }
MiDeadBrowserResultColumn >> toolbarHeight [

	^self class toolbarHeight
]

{ #category : 'actions' }
MiDeadBrowserResultColumn >> update [

	| deads |
	deads := self specModel deadEntities.
	lstDeadMethods items: deads.
	lblDeadMethods label: deads size asString , ' dead entities'.

	btnRun enabled: (self specModel chosenRules isNotEmpty).
	btnRefactor enabled: (self specModel deadEntities isNotEmpty)
]

{ #category : 'actions' }
MiDeadBrowserResultColumn >> updateChosenRules [

	btnRun enabled: (self specModel chosenRules isNotEmpty)
]

Class {
	#name : 'MiDeadCodeBrowserRuleColum',
	#superclass : 'SpPresenter',
	#instVars : [
		'lstChosenRules',
		'lstOfferedRules',
		'btnChooseRules',
		'btnRejectRules'
	],
	#category : 'MooseIDE-DeadCode-Browser',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Browser'
}

{ #category : 'private' }
MiDeadCodeBrowserRuleColum >> childrenInOfferedRuleTree: item [

	^item isAssociation
		ifTrue: [ item value ]
		ifFalse: [ #() ]
]

{ #category : 'accessing' }
MiDeadCodeBrowserRuleColum >> chosenRules: aCollection [

	lstChosenRules items: (aCollection
		collect: [:rule | MiDeadCodeRulePresenter withRule: rule])
]

{ #category : 'initialization' }
MiDeadCodeBrowserRuleColum >> connectPresenters [

	btnChooseRules action: [
		self specModel chooseRules: self selectedHeuristicsOffered.
		self resetSelection
	].

	btnRejectRules action: [
		self specModel unchooseHeuristics: self selectedHeuristicsChosen.
		self resetSelection
	].

]

{ #category : 'layout' }
MiDeadCodeBrowserRuleColum >> defaultLayout [

	^SpBoxLayout newTopToBottom
		add: 'Available heuristics' expand: false ;
		add: lstOfferedRules expand: true ;
		add: (SpBoxLayout newLeftToRight
			add: btnChooseRules ;
			add: btnRejectRules ;
			yourself)
		height: self toolbarHeight ;
		add: 'Selected heuristics' expand: false ;
		add: lstChosenRules expand: true ;
		yourself
]

{ #category : 'initialization' }
MiDeadCodeBrowserRuleColum >> initializeOfferedRuleTree: availableRules [

	^self newTreeListView
		beMultipleSelection ;
		setup: [ :aPresenter | aPresenter instantiate: MiDeadCodeRulePresenter ] ;
		bind: [ :aPresenter :anObject | aPresenter rule: anObject ] ;
		children: [ :item | self childrenInOfferedRuleTree: item ] ;
		roots: (self itemsForOfferedRuleTree: availableRules) ;
		yourself
]

{ #category : 'initialization' }
MiDeadCodeBrowserRuleColum >> initializePresenters [

	lstOfferedRules := self initializeOfferedRuleTree: self specModel availableRules.

	lstChosenRules := self newList
		beMultipleSelection ;
		display: #label ;
		sortingBlock: [ :a :b |a label < b label ] ;
		items: (self specModel chosenRules
			collect: [:heuristic | MiDeadCodeRulePresenter withRule: heuristic]).

	btnChooseRules := self newButton
		icon: (self iconNamed: #mooseDown) ;
		help: 'Select' ;
		action: [ self specModel chooseRules: lstOfferedRules chosenRules ].

	btnRejectRules := self newButton
		icon: (self iconNamed: #mooseTrash) ;
		help: 'De-select' ;
		action: [ self specModel unchooseHeuristics: lstChosenRules chosenRules ].

]

{ #category : 'as yet unclassified' }
MiDeadCodeBrowserRuleColum >> itemsForOfferedRuleTree: rules [
	"returns a list of items for the tree of rules.
	 An item is either an association (group->rules) or a single rule"

	^(rules groupedBy: #ruleGroup)
		collect: [ :association |
			association key isString
				ifTrue: [ association ]
				ifFalse: [ association key ]
		]
]

{ #category : 'actions' }
MiDeadCodeBrowserRuleColum >> resetSelection [

	lstOfferedRules unselectAll.
	lstChosenRules unselectAll 
]

{ #category : 'as yet unclassified' }
MiDeadCodeBrowserRuleColum >> selectedHeuristicsChosen [

	^lstChosenRules selectedItems
		collect: #rule

]

{ #category : 'actions' }
MiDeadCodeBrowserRuleColum >> selectedHeuristicsOffered [

	^lstOfferedRules selectedItems
		flatCollectAsSet: [  :item |
			item key isString
				ifTrue: [ item value ]
				ifFalse: [ {  item key } ] ]
]

{ #category : 'accessing' }
MiDeadCodeBrowserRuleColum >> specModel [ 

	^owner specModel
]

{ #category : 'TOREMOVE' }
MiDeadCodeBrowserRuleColum >> toolbarHeight [

	^self class toolbarHeight
]

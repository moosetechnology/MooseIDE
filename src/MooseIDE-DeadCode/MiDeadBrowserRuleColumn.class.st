Class {
	#name : 'MiDeadBrowserRuleColumn',
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
MiDeadBrowserRuleColumn >> childrenInOfferedRuleTree: item [

	^item isAssociation
		ifTrue: [ item value ]
		ifFalse: [ #() ]
]

{ #category : 'private' }
MiDeadBrowserRuleColumn >> chosenRuleItems: aCollection [

	lstChosenRules items: (aCollection
		collect: [:rule | MiDeadRulePresenter withRule: rule])
]

{ #category : 'as yet unclassified' }
MiDeadBrowserRuleColumn >> chosenRulesSelected [

	^lstChosenRules selectedItems
		collect: #rule

]

{ #category : 'initialization' }
MiDeadBrowserRuleColumn >> connectPresenters [

	btnChooseRules action: [
		self specModel chooseRules: self offeredRulesSelected.
		self resetSelection
	].

	btnRejectRules action: [
		self specModel unchooseRules: self chosenRulesSelected.
		self resetSelection
	].

]

{ #category : 'layout' }
MiDeadBrowserRuleColumn >> defaultLayout [

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
MiDeadBrowserRuleColumn >> initializeChosenRuleList [

	lstChosenRules := self newList
		beMultipleSelection ;
		display: #label ;
		sortingBlock: [ :a :b |a label < b label ] ;
		items: self itemsForChosenRuleList 
]

{ #category : 'initialization' }
MiDeadBrowserRuleColumn >> initializeOfferedRuleTree [

	lstOfferedRules := self newTreeListView
		beMultipleSelection ;
		setup: [ :aPresenter | aPresenter instantiate: MiDeadRulePresenter ] ;
		bind: [ :aPresenter :anObject | aPresenter rule: anObject ] ;
		children: [ :item | self childrenInOfferedRuleTree: item ] ;
		roots: self itemsForOfferedRuleTree ;
		yourself
]

{ #category : 'initialization' }
MiDeadBrowserRuleColumn >> initializePresenters [

	self initializeOfferedRuleTree.
	self initializeChosenRuleList.

	btnChooseRules := self newButton
		icon: (self iconNamed: #mooseDown) ;
		help: 'Select heuristics'.

	btnRejectRules := self newButton
		icon: (self iconNamed: #mooseTrash) ;
		help: 'De-select heuristics'.

]

{ #category : 'private' }
MiDeadBrowserRuleColumn >> itemsForChosenRuleList [

	^self specModel chosenRules
			collect: [:heuristic | MiDeadRulePresenter withRule: heuristic]
]

{ #category : 'private' }
MiDeadBrowserRuleColumn >> itemsForOfferedRuleTree [
	"returns a list of items for the tree of rules.
	 An item is either an association (group->rules) or a single rule"

	^(self specModel availableRules groupedBy: #ruleGroup)
		associations collect: [ :association |
			 association key isString
				ifTrue: [ association ]
				ifFalse: [ association key ]
		]
]

{ #category : 'private' }
MiDeadBrowserRuleColumn >> offeredRulesSelected [

	^lstOfferedRules selectedItems
		flatCollectAsSet: [  :item |
			item key isString
				ifTrue: [ item value ]
				ifFalse: [ {  item key } ] ]
]

{ #category : 'actions' }
MiDeadBrowserRuleColumn >> resetSelection [

	lstOfferedRules unselectAll.
	lstChosenRules unselectAll 
]

{ #category : 'accessing' }
MiDeadBrowserRuleColumn >> specModel [ 

	^owner specModel
]

{ #category : 'TOREMOVE' }
MiDeadBrowserRuleColumn >> toolbarHeight [

	^self class toolbarHeight
]

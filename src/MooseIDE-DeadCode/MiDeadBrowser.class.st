"
Computes dead methods/functions from an initial list of methods/functions
There are several heurisitcs to find out what are dead entities
The user must:
- first select some heuristics to apply
- then do a ""first run"" (apply the chosen heurisitcs to the list of entities
- this gives a firs tlist of dead entities
- this list can be expanded by running a ""recursion"": any entity only called by a dead entity is also dead

Accepted entities: A list of methods/functions (behavioural entities)
"
Class {
	#name : 'MiDeadBrowser',
	#superclass : 'MiAbstractBrowser',
	#instVars : [
		'lstMethod',
		'lblAllMethods',
		'resultColumn',
		'ruleColumn'
	],
	#category : 'MooseIDE-DeadCode-Browser',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Browser'
}

{ #category : 'world menu' }
MiDeadBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : 'world menu' }
MiDeadBrowser class >> menuItem [

	^#mooseCancel
]

{ #category : 'world menu' }
MiDeadBrowser class >> menuPriority [

	^ self menuMetaToolsPriority + 1
]

{ #category : 'world menu' }
MiDeadBrowser class >> newModel [

	^MiDeadCodeBrowserModel new
	 "MiDeadCodeBrowserModelWithCallGraph new"
]

{ #category : 'world menu' }
MiDeadBrowser class >> open [
	<script>
	^ super open
]

{ #category : 'world menu' }
MiDeadBrowser class >> preferredExtent [

	^ 900 @ 700
]

{ #category : 'world menu' }
MiDeadBrowser class >> title [
	^'Dead code browser'
]

{ #category : 'testing' }
MiDeadBrowser >> canFollowEntity: anObject [

	^anObject isCollection and:
	[ anObject anySatisfy: [ :entity | entity usesFamixTrait: FamixTWithInvocations ] ]
]

{ #category : 'layout' }
MiDeadBrowser >> candidateEntiesColumnLayout [

	^SpBoxLayout newTopToBottom
		add: lblAllMethods expand: false;
		add: lstMethod ;
		yourself
]

{ #category : 'accessing' }
MiDeadBrowser >> candidateEntities: aCollection [

	lstMethod items: aCollection.
	lblAllMethods label: aCollection size asString , ' entities'
]

{ #category : 'heuristic column' }
MiDeadBrowser >> chosenRules [

	^specModel chosenRules
]

{ #category : 'layout' }
MiDeadBrowser >> defaultLayout [

	^SpPanedLayout newLeftToRight 
		add: self candidateEntiesColumnLayout;
		add: (SpPanedLayout newLeftToRight 
			add: ruleColumn ;
			add: resultColumn ;
			yourself) ;
		positionOfSlider: 0.3 ;
		yourself
]

{ #category : 'actions' }
MiDeadBrowser >> followEntity: anEntity [

	super followEntity: anEntity anyOne mooseModel.
	specModel followEntity: anEntity
]

{ #category : 'initialization' }
MiDeadBrowser >> initializePresenters [

	lstMethod := self newList
		display: #name ;
		sortingBlock: #name ascending.

	lblAllMethods := self newLabel
		label: '0 entities'.

	ruleColumn := self instantiate: MiDeadBrowserRuleColumn.
	resultColumn := self instantiate: MiDeadBrowserResultColumn.
]

{ #category : 'accessing' }
MiDeadBrowser >> miSelectedItem [

	^specModel miSelectedItem 
]

{ #category : 'accessing' }
MiDeadBrowser >> ruleColumn [

	^ruleColumn 
]

{ #category : 'TOREMOVE' }
MiDeadBrowser >> toolbarHeight [

	^self class toolbarHeight
]

{ #category : 'actions' }
MiDeadBrowser >> updateChosenRules [

	ruleColumn chosenRuleItems: specModel chosenRules.
	resultColumn updateChosenRules
]

{ #category : 'actions' }
MiDeadBrowser >> updateDeadEntities [

	resultColumn update
]

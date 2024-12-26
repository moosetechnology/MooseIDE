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
	#name : #MiDeadCodeBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'lstMethod',
		'lstHeuristicsOffered',
		'lstHeuristicsChosen',
		'lstDeadMethods',
		'btnSelectHeuristic',
		'btnFirstRound',
		'btnRecursive',
		'btnRejectHeuristic',
		'lblDeadMethods',
		'lblAllMethods'
	],
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #'world menu' }
MiDeadCodeBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiDeadCodeBrowser class >> menuItem [

	^#DeadCodeBrowser
]

{ #category : #'world menu' }
MiDeadCodeBrowser class >> menuPriority [

	^ self menuMetaToolsPriority + 1
]

{ #category : #'world menu' }
MiDeadCodeBrowser class >> newModel [

	^ MiDeadCodeBrowserModel new
]

{ #category : #'world menu' }
MiDeadCodeBrowser class >> open [
	<script>
	^ super open
]

{ #category : #'world menu' }
MiDeadCodeBrowser class >> title [
	^'Dead code browser'
]

{ #category : #'world menu' }
MiDeadCodeBrowser class >> windowSize [

	^ 900 @ 700
]

{ #category : #accessing }
MiDeadCodeBrowser >> availableHeuristics [

	^specModel availableHeuristics
]

{ #category : #'accessing - private tests' }
MiDeadCodeBrowser >> buttonSelectHeuristics [

	^btnSelectHeuristic 
]

{ #category : #testing }
MiDeadCodeBrowser >> canFollowEntity: anObject [

	^anObject isCollection and:
	[ anObject anySatisfy: [ :entity | entity usesFamixTrait: FamixTWithInvocations ] ]
]

{ #category : #layout }
MiDeadCodeBrowser >> candidateEntiesColumnLayout [

	^SpBoxLayout newTopToBottom
		add: lblAllMethods expand: false;
		add: lstMethod ;
		yourself
]

{ #category : #'accessing - private tests' }
MiDeadCodeBrowser >> candidateEntities [

	^lstMethod 
]

{ #category : #accessing }
MiDeadCodeBrowser >> candidateEntities: aCollection [

	lstMethod items: aCollection 
]

{ #category : #accessing }
MiDeadCodeBrowser >> chosenHeuristics [

	^specModel chosenHeuristics
]

{ #category : #layout }
MiDeadCodeBrowser >> deadMethodColumnLayout [

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

{ #category : #layout }
MiDeadCodeBrowser >> defaultLayout [

	^SpPanedLayout newLeftToRight 
		add: self candidateEntiesColumnLayout;
		add: (SpPanedLayout newLeftToRight 
			add: self heuristicColumnLayout ;
			add: self deadMethodColumnLayout ;
			yourself) ;
		positionOfSlider: 0.3 ;
		yourself
]

{ #category : #actions }
MiDeadCodeBrowser >> followEntity: anEntity [

	super followEntity: anEntity anyOne mooseModel.
	specModel followEntity: anEntity
]

{ #category : #layout }
MiDeadCodeBrowser >> heuristicColumnLayout [

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

{ #category : #'accessing - private tests' }
MiDeadCodeBrowser >> heuristicsOffered [ 

	^lstHeuristicsOffered 
]

{ #category : #initialization }
MiDeadCodeBrowser >> initializePresenters [

	lstMethod := self newList.
	lstHeuristicsOffered := self newList
		items: specModel availableHeuristics ;
		beMultipleSelection ;
		display: [:item | item name] ;
		sortingBlock: #name ascending.

	lstHeuristicsChosen := self newList
		beMultipleSelection ;
		display: [:item | item name] ;
		sortingBlock: #name ascending.
	self selectedHeuristics: specModel selectedHeuristics.

	lstDeadMethods := self newList.

	btnSelectHeuristic := self newButton
		label: 'v' ;
		action: [ specModel selectHeuristics].

	btnRejectHeuristic := self newButton
		label: '^' ;
		action: [ specModel rejectHeuristics].

	btnFirstRound := self newButton
		label: '1st round' ;
		action: [ specModel firstRoundComputation].

	btnRecursive := self newButton
		label: 'recursion' ;
		action: [ specModel recursiveComputation].

	lblAllMethods := self newLabel
		label: '0 entities'.
	lblDeadMethods := self newLabel
		label: '0 dead entities'
]

{ #category : #'accessing - private tests' }
MiDeadCodeBrowser >> listHeuristicsOffered [ 

	^lstHeuristicsOffered 
]

{ #category : #'accessing - private tests' }
MiDeadCodeBrowser >> listHeuristicsSelected [ 

	^lstHeuristicsChosen
]

{ #category : #accessing }
MiDeadCodeBrowser >> miSelectedItem [

	^specModel miSelectedItem 
]

{ #category : #actions }
MiDeadCodeBrowser >> selectedHeuristics: aCollection [

	lstHeuristicsChosen items: aCollection asOrderedCollection
]

{ #category : #'accessing - private tests' }
MiDeadCodeBrowser >> specModel [

	^specModel
]

{ #category : #TOREMOVE }
MiDeadCodeBrowser >> toolbarHeight [

	^self class toolbarHeight
]

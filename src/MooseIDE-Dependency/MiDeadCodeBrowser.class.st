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

	^#DeadCode
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
	^ 'Dead code browser'
]

{ #category : #testing }
MiDeadCodeBrowser >> canFollowEntity: anObject [

	^anObject isCollection and:
	[ anObject anySatisfy: #isMethod ]
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
		add: (SpBoxLayout newTopToBottom
			add: lblAllMethods expand: false;
			add: lstMethod ;
			yourself) ;
		add: (SpPanedLayout newLeftToRight 
			add: self heuristicColumnLayout ;
			add: self deadMethodColumnLayout ;
			yourself) ;
		yourself
]

{ #category : #actions }
MiDeadCodeBrowser >> followEntity: anEntity [

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

{ #category : #initialization }
MiDeadCodeBrowser >> initializePresenters [

	lstMethod := self newList.
	lstHeuristicsOffered := self newList.
	lstHeuristicsChosen := self newList.
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

{ #category : #accessing }
MiDeadCodeBrowser >> miSelectedItem [

	^specModel miSelectedItem 
]

{ #category : #TOREMOVE }
MiDeadCodeBrowser >> toolbarHeight [

	^self class toolbarHeight
]

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
		'btnSelectHeuristic',
		'btnRejectHeuristic',
		'lblAllMethods',
		'resultColumn',
		'heuristicColumn'
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

	^#mooseCancel
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
MiDeadCodeBrowser class >> preferredExtent [

	^ 900 @ 700
]

{ #category : #'world menu' }
MiDeadCodeBrowser class >> title [
	^'Dead code browser'
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

	lstMethod items: aCollection.
	lblAllMethods label: aCollection size asString , ' entities'
]

{ #category : #'heuristic column' }
MiDeadCodeBrowser >> chosenHeuristics [

	^specModel chosenHeuristics
]

{ #category : #layout }
MiDeadCodeBrowser >> defaultLayout [

	^SpPanedLayout newLeftToRight 
		add: self candidateEntiesColumnLayout;
		add: (SpPanedLayout newLeftToRight 
			add: heuristicColumn ;
			add: resultColumn ;
			yourself) ;
		positionOfSlider: 0.3 ;
		yourself
]

{ #category : #actions }
MiDeadCodeBrowser >> followEntity: anEntity [

	super followEntity: anEntity anyOne mooseModel.
	specModel followEntity: anEntity
]

{ #category : #accessing }
MiDeadCodeBrowser >> heuristicColumn [

	^heuristicColumn 
]

{ #category : #initialization }
MiDeadCodeBrowser >> initializePresenters [

	lstMethod := self newList.
	lblAllMethods := self newLabel
		label: '0 entities'.

	heuristicColumn := self instantiate: MiDeadCodeBrowserHeuristicColum.
	resultColumn := self instantiate: MiDeadCodeBrowserResultColum.
]

{ #category : #'accessing - private tests' }
MiDeadCodeBrowser >> labelCandidateEntities [

	^lblAllMethods 
]

{ #category : #accessing }
MiDeadCodeBrowser >> miSelectedItem [

	^specModel miSelectedItem 
]

{ #category : #accessing }
MiDeadCodeBrowser >> resultColumn [

	^resultColumn 
]

{ #category : #'heuristic column' }
MiDeadCodeBrowser >> selectedHeuristics: aCollection [

	heuristicColumn selectedHeuristics: aCollection
]

{ #category : #TOREMOVE }
MiDeadCodeBrowser >> toolbarHeight [

	^self class toolbarHeight
]

{ #category : #actions }
MiDeadCodeBrowser >> updateDeadEntities [

	resultColumn update
]

{ #category : #actions }
MiDeadCodeBrowser >> updateHeuristicSelection [

	heuristicColumn selectedHeuristics: specModel selectedHeuristics.
	resultColumn updateHeuristicSelection
]

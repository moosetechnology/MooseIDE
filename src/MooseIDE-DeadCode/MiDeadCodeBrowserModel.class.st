"
The spec model for the MiDeadCodeBrowser

Responsible for handling all interactions as well as computing the dead entities
"
Class {
	#name : 'MiDeadCodeBrowserModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'deadEntities',
		'candidateEntities',
		'selectedDeadEntities',
		'chosenRules',
		'availableRules'
	],
	#category : 'MooseIDE-DeadCode-Model',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Model'
}

{ #category : 'actions' }
MiDeadCodeBrowserModel >> applyChosenRules: entity [
	"search for a heuristic that could deal with the entity"

	chosenRules do: [ :heuristic |
		(self rule: heuristic handle: entity)
			ifTrue: [ ^self ]
		]
]

{ #category : 'accessing' }
MiDeadCodeBrowserModel >> availableRules [

	^availableRules ifNil: [
		availableRules := MiDeadAbstractRule withAllSubclasses
			select: [ :class | class isAbstract not ]
			thenCollect: [ :class | class new ]
	]
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> chooseRules: heuristicCollection [
	"add all of heuristicCollection  to the internal list of chosenHeuristics"

	chosenRules := (chosenRules union: heuristicCollection)
		sort: self rulesSortBlock.
	browser updateChosenRules
]

{ #category : 'accessing' }
MiDeadCodeBrowserModel >> chosenRules [

	^chosenRules 
]

{ #category : 'accessing - private tests' }
MiDeadCodeBrowserModel >> clearChosenRules [

	chosenRules removeAll
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> clearDeads [

	deadEntities removeAll.

	browser updateDeadEntities.
	browser updateToolbar.

]

{ #category : 'settings management' }
MiDeadCodeBrowserModel >> currentConfiguration [
	"no settings"
]

{ #category : 'accessing' }
MiDeadCodeBrowserModel >> deadEntities [

	^deadEntities 
]

{ #category : 'settings management' }
MiDeadCodeBrowserModel >> defaultConfiguration [
	"no settings"
]

{ #category : 'accessing' }
MiDeadCodeBrowserModel >> entities [

	^candidateEntities
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> followEntity: aCollection [

	candidateEntities := aCollection.
	browser candidateEntities: aCollection.
	browser updateChosenRules
]

{ #category : 'initialization' }
MiDeadCodeBrowserModel >> initialize [ 

	super initialize.

	self initializeRules.
	deadEntities := OrderedCollection new.
	selectedDeadEntities := #()
]

{ #category : 'initialization' }
MiDeadCodeBrowserModel >> initializeRules [

	chosenRules := OrderedCollection new:
		                    self availableRules size.
	chosenRules addAll:
		(self availableRules select: [ :heuristic |
			 heuristic selectedByDefault ])
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> isNewDead: anEntity [
	"is a newDead if
	 - not already dead
	 - not saved by refutting heuristics
	 - not invoked by a not dead entity"

	(deadEntities includes: anEntity) ifTrue: [ ^ false ].

	chosenRules do: [ :heuristic |
		(heuristic refuteDead and: [ heuristic notDead: anEntity ])
			ifTrue: [ ^false ]
	].

	^(anEntity queryIncoming: FamixTInvocation) opposites
		allSatisfy: [ :invoker | deadEntities includes: invoker ]
]

{ #category : 'accessing' }
MiDeadCodeBrowserModel >> miSelectedItem [

	^selectedDeadEntities ifEmpty: [ deadEntities ] 
]

{ #category : 'accessing' }
MiDeadCodeBrowserModel >> miSelectedItems: aCollection [

	selectedDeadEntities := aCollection 
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> oneRoundRecursion [

	| addedDeads |
	addedDeads := false.

	deadEntities copy do: [ :dead |
		(dead queryOutgoing: FamixTInvocation) opposites do: [ :invoked |
			(self isNewDead: invoked) ifTrue: [
				deadEntities add: invoked.
				addedDeads := true
			]
		]
	].

	^ addedDeads
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> recursionComputation [
	"Compute dead entities only invoked by already dead entities
	 In the end restrict the result to be within the initial list of candidate (followed) entities"
	[ self oneRoundRecursion ]
		whileTrue.

	deadEntities := deadEntities select: [ :entity | candidateEntities includes: entity ].

	browser updateDeadEntities
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> rule: rule handle: entity [
	"returns whether a decision was reached or not + register a dead entity
	 A decision is reached for _refuting_ rules if the entity is not dead
	   and there is nothing to do (but we do not need to check other rules)
	 A decision is reached for _asserting_ rules, if the entity is dead
	   and it must be added to the list of dead entities"

	rule refuteDead 
		ifTrue: [ (rule isDead: entity) ifFalse: [ ^true ] ]
		ifFalse: [
			(rule isDead: entity)
				ifTrue: [ deadEntities add: entity. ^true ]
		].
	
	^false
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> rulesSortBlock [
	"sorts refuting heuristics before asserting ones.
	 inside these two categories, sort on their names"

	^[ :a :b |
		(a refuteDead = b refuteDead)
			ifTrue: [ a name < b name ]
			ifFalse: [ a refuteDead ]
		]
]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> runComputation [
	"First compute all dead entities according to the chosen rules
	 Then compute dead entities only used by already dead entities
	 In the end restrict the result to be within the initial list of candidate (followed) entities"

	self clearDeads.

	"First step"
	self entities do: [ :entity | self applyChosenRules: entity ].

	"Second step: recusrion"
	[ self oneRoundRecursion ]
		whileTrue.

	"Third step, filter to candidate entities"
	deadEntities := deadEntities select: [ :entity | candidateEntities includes: entity ].

	browser updateDeadEntities.
	browser updateToolbar.

]

{ #category : 'settings management' }
MiDeadCodeBrowserModel >> settings [
	"no settings"

]

{ #category : 'actions' }
MiDeadCodeBrowserModel >> unchooseRules: rules [
	"remove all #rules from the internal list of chosenRules"

	chosenRules removeAll: rules.
	browser updateChosenRules
]

{ #category : 'settings management' }
MiDeadCodeBrowserModel >> updateFromConfiguration: aConfiguration [
	"no settings"
]

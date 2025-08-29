Class {
	#name : 'MiDeadCodeBrowserTest',
	#superclass : 'MiAbstractBrowserTest',
	#instVars : [
		'newBrowser'
	],
	#category : 'MooseIDE-Tests-Browsers',
	#package : 'MooseIDE-Tests',
	#tag : 'Browsers'
}

{ #category : 'running' }
MiDeadCodeBrowserTest >> browserClass [

	^MiDeadCodeBrowser
]

{ #category : 'running' }
MiDeadCodeBrowserTest >> populateBrowser: mooseModel [

	mooseModel newMethodNamed: 'aMethod'.
	mooseModel newMethodNamed: 'anotherMethod'.

	browser followEntity: mooseModel entities.

]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testActivateActionButtons [
	"can only propagate dead methods, therefore receiving entities alone
	 does not allow to propagae anything"

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	self receiveEntityToSelect.

	browser actionButtons do: [ :button | self deny: button isEnabled ]
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testCanPropagateAfterDeadComputation [

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.

	browser specModel deadEntities addAll: self mooseObjects.

	self assert: browser canPropagate.

]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testCannotPropagateAtInitialization [

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.

	self deny: browser canPropagate.

]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testDisabledFirstRoundButton [
	"without selected heuristics, 1st-round button is disabled"

	browser specModel clearSelectedHeuristics.
	browser updateHeuristicSelection.

	self deny: browser resultColumn buttonFirstRound isEnabled
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testEnabledFirstRoundButton [
	"with a selected heuristics, 1st-round button is enabled"

	browser updateHeuristicSelection.
	self assert: browser resultColumn buttonFirstRound isEnabled
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testInitializeCandidateEntityList [

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.

	self assert: browser candidateEntities items isNotEmpty.
	self assert: browser labelCandidateEntities label equals: '2 entities'
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testInitializeHeuristicsList [

	self assert: browser heuristicColumn listHeuristicsOffered items isNotEmpty
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testInitializeSelectedHeuristicsList [
	"by default, there is one selected heuristics: `MiDeadCodeNoIncomingInvocationHeuristic`
	 see also: MiDeadCodeAbstractHeuristic >> selectedByDefault"

	self assert: browser heuristicColumn listHeuristicsSelected items size equals: 1.

]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testRejectHeuristic [
	"by default, there is one selected heuristics"

	browser heuristicColumn listHeuristicsSelected selectIndex: 1.
	browser heuristicColumn buttonRejectHeuristics click.

	self assert: browser heuristicColumn listHeuristicsSelected items size equals: 0
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testSelectHeuristics [
	"by default, there is one selected heuristics"

	browser heuristicColumn listHeuristicsOffered
		selectItem: 	(browser heuristicColumn listHeuristicsOffered items
			detect: [:item | item selectedByDefault not ]).
	browser heuristicColumn buttonSelectHeuristics click.

	self assert: browser heuristicColumn listHeuristicsSelected items size equals: 2
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testUpdateDeadEntities [

	self assert: browser resultColumn listDeadEntities items size equals: 0.
	self deny: browser resultColumn buttonRecursiveRound isEnabled.

	browser specModel deadEntities addAll: { FamixStMethod new . FamixStMethod new }.
	browser updateDeadEntities.

	self assert: browser resultColumn listDeadEntities items size equals: 2.
	self assert: browser resultColumn labelDeadEntities label equals: '2 dead entities'
]

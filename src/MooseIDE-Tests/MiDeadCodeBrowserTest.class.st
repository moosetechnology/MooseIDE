Class {
	#name : #MiDeadCodeBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'newBrowser'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiDeadCodeBrowserTest >> browserClass [

	^MiDeadCodeBrowser
]

{ #category : #running }
MiDeadCodeBrowserTest >> populateBrowser: mooseModel [

	mooseModel newMethodNamed: 'aMethod'.
	mooseModel newMethodNamed: 'anotherMethod'.

	browser followEntity: mooseModel entities.

]

{ #category : #tests }
MiDeadCodeBrowserTest >> testActivateActionButtons [
	"can only propagate dead methods, therefore receiving entities alone
	 does not allow to propagae anything"

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	self receiveEntityToSelect.

	browser actionButtons do: [ :button | self deny: button isEnabled ]
]

{ #category : #tests }
MiDeadCodeBrowserTest >> testInitializeCandidateEntityList [

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.

	self assert: browser candidateEntities items isNotEmpty
]

{ #category : #tests }
MiDeadCodeBrowserTest >> testInitializeHeuristicsList [

	self assert: browser listHeuristicsOffered items isNotEmpty
]

{ #category : #tests }
MiDeadCodeBrowserTest >> testSelectHeuristics [
	"by default, there is one selected heuristics: `MiDeadCodeNoIncomingInvocationHeuristic`
	 see also: MiDeadCodeAbstractHeuristic >> selectedByDefault"

	self assert: browser listHeuristicsSelected items size equals: 1.

	browser listHeuristicsOffered
		selectItem: 	(browser listHeuristicsOffered items
			detect: [:item | item selectedByDefault not ]).
	browser buttonSelectHeuristics click.

	self assert: browser listHeuristicsSelected items size equals: 2
]

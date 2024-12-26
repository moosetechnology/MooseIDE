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
MiDeadCodeBrowserTest >> testGatherHeuristicsList [
	"Expected number must be updated according to number of non abstract heuristics classes"

	self assert: browser specModel gatherHeuristics size equals: 5
]

{ #category : #tests }
MiDeadCodeBrowserTest >> testInitializeHeuristicsList [

	self assert: browser heuristicsOffered items isNotEmpty
]

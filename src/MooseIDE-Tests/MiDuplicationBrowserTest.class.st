Class {
	#name : #MiDuplicationBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiDuplicationBrowserTest >> browserClass [

	^MiDuplicationBrowser 
]

{ #category : #running }
MiDuplicationBrowserTest >> method: aName [

	^ FamixRepTestMethod named: aName
]

{ #category : #running }
MiDuplicationBrowserTest >> method: aName withSource: lineInterval [

	^ (self method: aName)
		  sourceAnchor:
			  (FamixRepTestSourceTextAnchor source:
					   (self sourceCode: lineInterval));
		  yourself
]

{ #category : #running }
MiDuplicationBrowserTest >> replicaFor: anEntity source: lineInterval [

	| replica |
	replica := (FamixReplica
		            from: lineInterval first
		            to: lineInterval last
		            for: anEntity)
		           fileAnchor:
			           (FamixRepTestSourceTextAnchor source:
					            anEntity sourceText);
		           yourself.

	anEntity addReplica: replica.
	^ replica
]

{ #category : #running }
MiDuplicationBrowserTest >> replicatedFragment [

	| fragment method replica |
	fragment := FamixReplicatedFragment new
		            fragmentName: 'testFragment';
		            yourself.

	method := self method: 'method1' withSource: (1 to: 5).
	replica := self replicaFor: method source: (3 to: 5).
	fragment addReplica: replica.

	method := self method: 'method2' withSource: (3 to: 8).
	replica := self replicaFor: method source: (1 to: 3).
	fragment addReplica: replica.

	^ fragment
]

{ #category : #running }
MiDuplicationBrowserTest >> sourceCode: lineInterval [

	^ String cr join:
			   (#( '"What a deep voice you have", said the little girl,'
			       '"The better to greet you with", said the wolf.'
			       '"Goodness, what big eyes you have,"'
			       '"The better to see you with."'
			       '"And what big hands you have" exclaimed Little Red Riding Hood,'
			       '"The better to hug you with," said the wolf.'
			       '"What a big mouth you have," the little girl murmured in a weak voice.'
			       '"The better to eat you with!" growled the wolf,'
			       'and jumping out of bed, he swallowed her up too.' )
				    copyFrom: lineInterval first
				    to: lineInterval last)
]

{ #category : #tests }
MiDuplicationBrowserTest >> testFollowEntity [

	self assertEmpty: browser model entities.

	browser followEntity: { 
			(self method: 'method1').
			(self method: 'method2') }.

	self assert: browser model entities size equals: 2
]

{ #category : #tests }
MiDuplicationBrowserTest >> testFormatReplicatedFragment [

	self
		assert: (browser formatReplicatedFragment: self replicatedFragment)
		equals: '2:"Goodness, what big ey...'
]

{ #category : #tests }
MiDuplicationBrowserTest >> testHighlightEntities [

	| entities |
	entities := { 
		            (self method: 'method1').
		            (self method: 'method2') }.
	browser showEntities: entities.

	self assertEmpty: browser lstEntities selectedItems.

	browser highlightEntities: entities.
	self assert: browser lstEntities selectedItems size equals: 2
]

{ #category : #tests }
MiDuplicationBrowserTest >> testMiSelectedItem [

	| entities |
	entities := { 
		            (self method: 'method1').
		            (self method: 'method2') } asMooseGroup.

	browser model entities: entities.

	self assertEmpty: browser miSelectedItem.
	self deny: browser canPropagate.

	browser model selectedEntity: entities.
	self assert: browser miSelectedItem size equals: 2.
	self assert: browser canPropagate
]

{ #category : #tests }
MiDuplicationBrowserTest >> testResetReplicas [

	browser showReplicas: self replicatedFragment replicas.
	self assert: browser panCodes pages size equals: 2.

	browser resetReplicas.
	self assertEmpty: browser panCodes pages
]

{ #category : #tests }
MiDuplicationBrowserTest >> testShowEntities [

	self assertEmpty: browser lstEntities items.

	browser showEntities: { 
			(self method: 'method1').
			(self method: 'method2') }.

	self assert: browser lstEntities items size equals: 2.
	self assert: browser lstEntities items first name equals: 'method1'
]

{ #category : #tests }
MiDuplicationBrowserTest >> testShowReplicas [

	self assertEmpty: browser panCodes pages.

	browser showReplicas: self replicatedFragment replicas.
	self assert: browser panCodes pages size equals: 2.
	self assert: browser panCodes pages first title equals: 'method1'
]

{ #category : #tests }
MiDuplicationBrowserTest >> testShowReplicatedFragments [

	self assertEmpty: browser lstReplicatedFragments items.

	browser showReplicatedFragments: { self replicatedFragment }.
	self assert: browser lstReplicatedFragments items size equals: 1.
	self
		assert: browser lstReplicatedFragments items first fragmentName
		equals: 'testFragment'
]

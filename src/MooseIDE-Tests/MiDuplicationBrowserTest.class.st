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
MiDuplicationBrowserTest >> testMiSelectedItem [

	| entities |
	entities := { 
		            (self method: 'method1').
		            (self method: 'method2') } asMooseGroup.

	browser model entities: entities.

	self assertEmpty: browser miSelectedItem.
	self deny: browser canPropagate.

	browser model selectedEntities: entities.
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
MiDuplicationBrowserTest >> testSelectEntity [
	"issue https://github.com/moosetechnology/MooseIDE/issues/655"

	browser model entities: { 
		(self method: 'method1').
		(self method: 'method2') } asMooseGroup.

	self shouldnt: (browser lstEntities selectIndex: 1) raise: Error.
]

{ #category : #'tests - tags' }
MiDuplicationBrowserTest >> testSelectedTagSetAndGet [
	| model entity tag |
	model := FamixRepTestModel new.
	tag := model tagNamed: 'aTag'.
	entity := (self method: 'aMethod') mooseModel: model ; yourself.

	browser followEntity: entity.
	browser selectedTag: tag.
	self assert: browser selectedTag equals: tag
]

{ #category : #'tests - opening' }
MiDuplicationBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
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
	| fragment |
	fragment := self replicatedFragment.
	browser model replicatedFragmentsHierarchy
		at: fragment
		put: #(  ).

	self assertEmpty: browser lstReplicatedFragments roots.
	browser showReplicatedFragments: { fragment }.
	self assert: browser lstReplicatedFragments roots size equals: 1.
	self
		assert: browser lstReplicatedFragments roots first
		equals: fragment
]

{ #category : #tests }
MiDuplicationBrowserTest >> testUpdateStatusBar [

	| fragment |
	self
		assert: browser statusBarText
		equals:
		'Searched entities: 0 | Number of clones: 0 | Entities with clones: 0 | Selected entities: 0 | Selected clones: 0'.

	browser followEntity: { 
			(self method: 'method1').
			(self method: 'method2') }.
	self
		assert: browser statusBarText
		equals:
		'Searched entities: 2 | Number of clones: 0 | Entities with clones: 0 | Selected entities: 0 | Selected clones: 0'.
	fragment := self replicatedFragment.

	browser model replicatedFragmentsHierarchy at: fragment put: #(  ).
	browser updateStatusBar.
	self
		assert: browser statusBarText
		equals:
		'Searched entities: 2 | Number of clones: 1 | Entities with clones: 2 | Selected entities: 0 | Selected clones: 0'.

	browser model selectedFragments: { fragment }.
	self
		assert: browser updateStatusBar
		equals:
		'Searched entities: 2 | Number of clones: 1 | Entities with clones: 2 | Selected entities: 2 | Selected clones: 0'
]

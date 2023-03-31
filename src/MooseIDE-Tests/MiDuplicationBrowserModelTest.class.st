Class {
	#name : #MiDuplicationBrowserModelTest,
	#superclass : #TestCase,
	#instVars : [
		'method1',
		'method2',
		'method3',
		'model',
		'fragment1',
		'fragment2',
		'fragment3'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiDuplicationBrowserModelTest >> method: aName [

	^ FamixRepTestMethod named: aName
]

{ #category : #running }
MiDuplicationBrowserModelTest >> method: aName withSource: lineInterval [

	^ (self method: aName)
		  sourceAnchor:
			  (FamixRepTestSourceTextAnchor source:
					   (self sourceCode: lineInterval));
		  yourself
]

{ #category : #running }
MiDuplicationBrowserModelTest >> replicaFor: anEntity source: lineInterval inFragment: aFragment [

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
	aFragment addReplica: replica.

	^ replica
]

{ #category : #running }
MiDuplicationBrowserModelTest >> setUp [

	model := MiDuplicationBrowserModel new.
	model browser: Mock new.

	"to simplify building the test mode;l, all methods are the same"
	method1 := self method: 'method1' withSource: (1 to: 8).
	method2 := self method: 'method2' withSource: (1 to: 8).
	method3 := self method: 'method2' withSource: (1 to: 8).

	fragment1 := FamixReplicatedFragment new
		             fragmentName: 'fragment1';
		             yourself.
	fragment2 := FamixReplicatedFragment new
		             fragmentName: 'fragment2';
		             yourself.
	fragment3 := FamixReplicatedFragment new
		             fragmentName: 'fragment3';
		             yourself.

	self replicaFor: method1 source: (3 to: 5) inFragment: fragment1.
	self replicaFor: method2 source: (3 to: 5) inFragment: fragment1.
	self replicaFor: method3 source: (3 to: 5) inFragment: fragment1.

	self replicaFor: method1 source: (2 to: 6) inFragment: fragment2.
	self replicaFor: method2 source: (2 to: 6) inFragment: fragment2.

	self replicaFor: method2 source: (1 to: 8) inFragment: fragment3
]

{ #category : #running }
MiDuplicationBrowserModelTest >> sourceCode: lineInterval [

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
MiDuplicationBrowserModelTest >> testAncestorsOfIn [

	self assertEmpty: (model ancestorsOf: fragment1 in: { 
				 fragment1.
				 fragment2.
				 fragment3 }).
	self
		assertCollection: (model ancestorsOf: fragment2 in: { 
					 fragment1.
					 fragment2.
					 fragment3 })
		hasSameElements: { fragment1 }.
	self
		assertCollection: (model ancestorsOf: fragment3 in: { 
					 fragment1.
					 fragment2.
					 fragment3 })
		hasSameElements: { fragment1 .fragment2 }
]

{ #category : #tests }
MiDuplicationBrowserModelTest >> testChildrenFragments [

	model replicatedFragmentsHierarchy: (model hierarchyOfReplicatedFragment: { 
				 fragment1.
				 fragment2.
				 fragment3 }).

	self
		assertCollection: (model childrenFragments: fragment1)
		hasSameElements: { fragment2 }.
	self
		assertCollection: (model childrenFragments: fragment2)
		hasSameElements: { fragment3 }.
	self assertEmpty: (model childrenFragments: fragment3)
]

{ #category : #tests }
MiDuplicationBrowserModelTest >> testDirectParentOfIn [

	self assert: (model directParentOf: fragment1 in: { 
				 fragment1.
				 fragment2.
				 fragment3 }) equals: nil.
	self
		assert: (model directParentOf: fragment2 in: { 
					 fragment1.
					 fragment2.
					 fragment3 })
		equals: fragment1.
	self
		assert: (model directParentOf: fragment3 in: { 
					 fragment1.
					 fragment2.
					 fragment3 })
		equals:
				fragment2
]

{ #category : #tests }
MiDuplicationBrowserModelTest >> testFragmentIncludes [

	self assert: (model fragment: fragment1 includes: fragment2).
	self deny: (model fragment: fragment1 includes: fragment1).
	self deny: (model fragment: fragment2 includes: fragment1)
]

{ #category : #tests }
MiDuplicationBrowserModelTest >> testHierarchyOfReplicatedFragment [

	| hierarchy |
	hierarchy := model hierarchyOfReplicatedFragment: { 
			             fragment1.
			             fragment2.
			             fragment3 }.
		
		self assertCollection: (hierarchy at: fragment1) hasSameElements: { fragment2 }.
		self assertCollection: (hierarchy at: fragment2) hasSameElements: { fragment3 }.
		self assertEmpty: (hierarchy at: fragment3).
]

{ #category : #tests }
MiDuplicationBrowserModelTest >> testHighlightEntity [

	| selectedFragments |
	(model browser stub selectFragments: Any) will: [ 
		:receivedFragments | selectedFragments := receivedFragments ].

	self assert: selectedFragments isNil.

	model highlightEntity: { method1 }.
	self assert: selectedFragments isCollection.
	self assertCollection: selectedFragments hasSameElements: { 
			fragment1.
			fragment2 }
]

{ #category : #tests }
MiDuplicationBrowserModelTest >> testRootFragments [

	model replicatedFragmentsHierarchy: (model hierarchyOfReplicatedFragment: { 
				 fragment1.
				 fragment2.
				 fragment3 }).

	self
		assertCollection: model rootFragments
		hasSameElements: { fragment1 }
]

{ #category : #tests }
MiDuplicationBrowserModelTest >> testSelectedFragment [
	model entities: { method1 . method2 . method3 }.
	self assertEmpty: model selectedEntities.

	model selectedFragments: {fragment2}.
	self assert: model selectedEntities size equals: 2.
	self assert: (model isSelected: method1).
	self assert: (model isSelected: method2).
	self deny: (model isSelected: method3).
]

"
A MiBulkEndLineCommentRewriterTest is a test class for testing the behavior of MiBulkEndLineCommentRewriter
"
Class {
	#name : 'MiBulkEditDuplicatedConstantesTest',
	#superclass : 'MiBulkAbstractTest',
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkEditDuplicatedConstantesTest >> classToTest [

	^MiBulkEditDuplicatedConstantes
]

{ #category : 'tests' }
MiBulkEditDuplicatedConstantesTest >> testCollectIntervalsData [

	| methods data intervals |
	methods := {
		self methodWithPos: 7 @ 10 .
		self methodWithPos: 18 @ 32 .
		self methodWithPos: 1 @ 5 .
		self methodWithPos: 35 @ 42 .
  }.
	data := {
		methods first  -> { methods second } .
		methods second -> { methods first } .
		methods third  -> { methods fourth } .
		methods fourth -> { methods third } .
	}.

	intervals := bulkEditor collectIntervals: data.

	self assert: intervals size equals: 4.

	intervals with: methods do: [ :interval :method |
		self assert: interval data key equals: method.
		self assert: interval first equals: method sourceAnchor startPos.
	]
]

{ #category : 'tests' }
MiBulkEditDuplicatedConstantesTest >> testCollectIntervalsFilter [

	| methods data intervals |
	methods := {
		self methodWithPos: 7 @ 10 .
		FamixJavaMethod new .
		self methodWithPos: 1 @ 5 .
		self methodWithPos: 35 @ 42 .
  }.
	data := {
		methods first  -> { methods second } .
		methods second -> { methods first } .
		methods third  -> { methods fourth } .
		methods fourth -> { methods third } .
	}.

	intervals := bulkEditor collectIntervals: data.

	self assert: intervals size equals: 3.

	self assert: intervals first  first equals: 7.
	self assert: intervals second first equals: 1.
	self assert: intervals third  first equals: 35.
]

{ #category : 'tests' }
MiBulkEditDuplicatedConstantesTest >> testGroupByFile [

	| methods data grouped |

	methods := { self methodWithPos: 1@2 . self methodWithPos: 3@4 . self methodWithPos: 5@6  }.
	methods second sourceAnchor fileName: 'otherFile.test'.
	methods third  sourceAnchor fileName: 'SourceFile.test'.
	
	data := {
		'cst1' -> { methods first . methods second }.
		'cst2' -> { methods third }
		}.

	grouped := bulkEditor groupByFile: data.

	self assert: grouped size equals: 2.

	self assert: (grouped at: 'SourceFile.test') size equals: 2.
	self assert: ((grouped at: 'SourceFile.test') anySatisfy: [:asso | asso key = methods first]) .
	self assert: ((grouped at: 'SourceFile.test') anySatisfy: [:asso | asso key = methods third]) .

	self assert: (grouped at: 'otherFile.test') size equals: 1.
	self assert: (grouped at: 'SourceFile.test') anyOne key equals: methods first

]

{ #category : 'tests' }
MiBulkEditDuplicatedConstantesTest >> testMooseModel [

	| methods data model |
	methods := { FamixJavaMethod new . FamixJavaMethod new . FamixJavaMethod new  }.
	data := {
		'cst1' -> { methods first . methods second }.
		'cst2' -> { methods third }
		}.
	model := FamixJavaModel new.
	methods do: [ :m | m mooseModel: model ].

	self assert: (bulkEditor mooseModel: data) equals: model
]

{ #category : 'tests' }
MiBulkEditDuplicatedConstantesTest >> testRestructureData [

	| methods data |
	methods := { FamixJavaMethod new . FamixJavaMethod new . FamixJavaMethod new  }.
	data := {
		'cst1' -> { methods first . methods second }.
		'cst2' -> { methods third }
		}.

	data := bulkEditor restructureData: data.

	self assert: data size equals: 3.

	self assert: data first key equals: methods first.
	self assert: data first value size equals: 1.
	self assert: data first value anyOne equals: methods second.

	self assert: data second key equals: methods second.
	self assert: data second value size equals: 1.
	self assert: data second value anyOne equals: methods first.

	self assert: data third key equals: methods third.
	self assert: data third value size equals: 0
	
]

"
A MiBulkEndLineCommentRewriterTest is a test class for testing the behavior of MiBulkEndLineCommentRewriter
"
Class {
	#name : 'MiBulkEditDuplicatedConstantesTest',
	#superclass : 'MiBulkAbstractTest',
	#instVars : [
		'entities'
	],
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkEditDuplicatedConstantesTest >> classToTest [

	^MiBulkEditDuplicatedConstantes
]

{ #category : 'running' }
MiBulkEditDuplicatedConstantesTest >> setUp [

	super setUp.

	entities := {
		self methodWithPos: 7 @ 10 .
		self methodWithPos: 18 @ 32 .
		self methodWithPos: 1 @ 5 .
		self methodWithPos: 35 @ 42 .
  }.

]

{ #category : 'tests' }
MiBulkEditDuplicatedConstantesTest >> testCollectIntervalsData [

	| data intervals |
	data := {
		entities first  -> { entities second } .
		entities second -> { entities first } .
		entities third  -> { entities fourth } .
		entities fourth -> { entities third } .
	}.

	intervals := bulkEditor collectIntervals: data.

	self assert: intervals size equals: 4.

	intervals with: entities do: [ :interval :entity |
		self assert: interval data key equals: entity.
		self assert: interval first equals: entity sourceAnchor startPos.
	]
]

{ #category : 'tests' }
MiBulkEditDuplicatedConstantesTest >> testCollectIntervalsFilter [

	| data intervals |
	entities third sourceAnchor: nil.
	data := {
		entities first  -> { entities second } .
		entities second -> { entities first } .
		entities third  -> { entities fourth } .
		entities fourth -> { entities third } .
	}.

	intervals := bulkEditor collectIntervals: data.

	self assert: intervals size equals: 3.

	self assert: intervals first  first equals: 7.
	self assert: intervals second first equals: 18.
	self assert: intervals third  first equals: 35.
]

{ #category : 'tests' }
MiBulkEditDuplicatedConstantesTest >> testGroupByFile [

	| data grouped |

	entities second sourceAnchor fileName: 'otherFile.test'.
	entities third  sourceAnchor fileName: 'SourceFile.test'.
	entities fourth sourceAnchor fileName: 'thirdFile.test'.
	
	data := {
		'cst1' -> { entities first . entities second }.
		'cst2' -> { entities third . entities fourth }
		}.

	grouped := bulkEditor groupByFile: data.

	self assert: grouped size equals: 3.

	self assert: (grouped at: 'SourceFile.test') size equals: 2.
	self assert: ((grouped at: 'SourceFile.test') anySatisfy: [:asso | asso key = entities first]) .
	self assert: ((grouped at: 'SourceFile.test') anySatisfy: [:asso | asso key = entities third]) .

	self assert: (grouped at: 'otherFile.test') size equals: 1.
	self assert: (grouped at: 'otherFile.test') anyOne key equals: entities second.

	self assert: (grouped at: 'thirdFile.test') size equals: 1.
	self assert: (grouped at: 'thirdFile.test') anyOne key equals: entities fourth

]

{ #category : 'tests' }
MiBulkEditDuplicatedConstantesTest >> testMooseModel [

	| data model |
	data := {
		'cst1' -> { entities first . entities second }.
		'cst2' -> { entities third . entities fourth }
	}.
	model := FamixJavaModel new.
	entities do: [ :m | m mooseModel: model ].

	self assert: (bulkEditor mooseModel: data) equals: model
]

{ #category : 'tests' }
MiBulkEditDuplicatedConstantesTest >> testRestructureData [

	| data |
	data := {
		'cst1' -> { entities first . entities second }.
		'cst2' -> { entities third . entities fourth }
		}.

	data := bulkEditor restructureData: data.

	self assert: data size equals: 4.

	data with: entities do: [ :asso :entity |
		self assert: asso key equals: entity.
		self assert: asso value size equals: 1
	].

	self assert: data first  value anyOne equals: entities second.
	self assert: data second value anyOne equals: entities first.
	self assert: data third  value anyOne equals: entities fourth.
	self assert: data fourth value anyOne equals: entities third

]

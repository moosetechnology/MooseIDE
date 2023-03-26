Class {
	#name : #MiCoTagVisualizationTest,
	#superclass : #TestCase,
	#instVars : [
		'builder'
	],
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #running }
MiCoTagVisualizationTest >> createTag: aName [
	^builder visualization specModel currentMooseModel tagNamed: aName
]

{ #category : #running }
MiCoTagVisualizationTest >> setUp [
	| visualization |
	super setUp.

	visualization := MiCoUsageMapVisualization new.
	visualization specModel: MiCoUsageMapModel new.
	visualization specModel collectionModel: MiCoUsageTestFamixModel new allMethods.

	builder := MiCoUsageMapBuilder new.
	builder visualization: visualization.
	builder methods: MiCoUsageTestFamixModel new allMethods.

]

{ #category : #tests }
MiCoTagVisualizationTest >> testEmptyLegend [
	"Empty legend has one entry (at bottom) describing the size of the inner box"
	builder buildForTest.

	self assert: builder legendTagBuilder shapes size equals: 1
]

{ #category : #tests }
MiCoTagVisualizationTest >> testNotEmptyLegend [
	"Empty legend has one entry for each tag + one (at bottom) describing the size of the inner box"

	self createTag: 'tag1'.
	self createTag: 'tag2'.
	self createTag: 'tag3'.

	builder buildForTest ; updateLegend.

	self assert: builder legendTagBuilder shapes size equals: 4
]

{ #category : #tests }
MiCoTagVisualizationTest >> testToggleTag [
	| tagShape |
	
	self createTag: 'aTag'.
	builder buildForTest.

	tagShape := builder legendTagBuilder shapes first.
	self assert: tagShape isComposite.
	self assert: tagShape shapes size equals: 3.

	builder legendTagBuilder toggleTag: (RSMouseClick new shape: tagShape shapes first).
	
]

Class {
	#name : #MiCoTagVisualizationTest,
	#superclass : #TestCase,
	#instVars : [
		'builder'
	],
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #running }
MiCoTagVisualizationTest >> setUp [
	| visualization |
	super setUp.
	visualization := Mock named: 'visualization'.
	visualization stub specModel willReturn: visualization.
	visualization stub tagList willReturn: OrderedCollection new.

	builder := MiCoUsageMapBuilder new.
	builder visualization: visualization.
	builder methods: MiCoUsageTestFamixModel new allMethods.

]

{ #category : #tests }
MiCoTagVisualizationTest >> test01Legend [

	| legendTag|
	builder buildForTest.
	legendTag := builder legendTagBuilder.
	self assert: legendTag shapes size equals: 1.

	legendTag addTag: FamixTag new.
	legendTag addTag: FamixTag new.
	builder buildForTest.
	self assert: legendTag shapes size equals: 3
]

{ #category : #tests }
MiCoTagVisualizationTest >> testToggleTag [
	| tagShape |
	builder legendTagBuilder addTag: FamixTag new.
	builder buildForTest.
	self assert: builder legendTagBuilder shapes size equals: 2.

	tagShape := builder legendTagBuilder shapes first.
	self assert: tagShape isComposite.
	self assert: tagShape shapes size equals: 3.

	builder legendTagBuilder toggleTag: (RSMouseClick new shape: tagShape shapes first).
	
]

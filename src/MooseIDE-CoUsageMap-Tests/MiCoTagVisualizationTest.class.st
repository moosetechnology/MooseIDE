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

	builder visualization stub tagList willReturn: { 
			FamixTag new.
			FamixTag new.
			FamixTag new }.

	builder buildForTest ; updateLegend.

	self assert: builder legendTagBuilder shapes size equals: 4
]

{ #category : #tests }
MiCoTagVisualizationTest >> testToggleTag [
	| tagShape |
	builder visualization stub tagList willReturn: { FamixTag new }.
	builder buildForTest.

	tagShape := builder legendTagBuilder shapes first.
	self assert: tagShape isComposite.
	self assert: tagShape shapes size equals: 3.

	builder legendTagBuilder toggleTag: (RSMouseClick new shape: tagShape shapes first).
	
]

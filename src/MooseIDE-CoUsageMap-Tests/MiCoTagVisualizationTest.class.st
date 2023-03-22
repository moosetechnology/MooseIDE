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
	super setUp.

	builder := MiCoUsageMapBuilder new.
	builder methods: MiCoUsageTestFamixModel new allMethods.

]

{ #category : #tests }
MiCoTagVisualizationTest >> test01Legend [

	| legendTag|
	builder buildForTest.
	legendTag := builder legendTag .
	self assert: legendTag shapes size equals: 1.

	legendTag addTag: FamixTag new.
	legendTag addTag: FamixTag new.
	builder buildForTest.
	self assert: legendTag shapes size equals: 3
]

{ #category : #tests }
MiCoTagVisualizationTest >> testToggleTag [
	| tagShape |
	builder legendTag addTag: FamixTag new.
	builder buildForTest.
	self assert: builder legendTag shapes size equals: 2.

	tagShape := builder legendTag shapes first.
	self assert: tagShape isComposite.
	self assert: tagShape shapes size equals: 3.

	builder legendTag toggleTag: (RSMouseClick new shape: tagShape shapes first).
	
]

Class {
	#name : #MiCoTagLegendTest,
	#superclass : #MiCoUsageAbstractTest,
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #running }
MiCoTagLegendTest >> createTag: aName [
	^builder methods anyOne mooseModel tagNamed: aName
]

{ #category : #tests }
MiCoTagLegendTest >> testEmptyLegend [
	"Empty legend has one entry (at bottom) describing the size of the inner box"
	builder buildForTest.

	self assert: builder legendTagBuilder shapes size equals: 1
]

{ #category : #tests }
MiCoTagLegendTest >> testNotEmptyLegend [
	"Empty legend has one entry for each tag + one (at bottom) describing the size of the inner box"

	self createTag: 'tag1'.
	self createTag: 'tag2'.
	self createTag: 'tag3'.

	builder buildForTest ; updateLegend.

	self assert: builder legendTagBuilder shapes size equals: 4
]

{ #category : #tests }
MiCoTagLegendTest >> testToggleTag [
	| tagShape |
	
	self createTag: 'aTag'.
	builder buildForTest.

	tagShape := builder legendTagBuilder shapes first.
	self assert: tagShape isComposite.
	self assert: tagShape shapes size equals: 3.

	builder legendTagBuilder toggleTag: (RSMouseClick new shape: tagShape shapes first).
	
]

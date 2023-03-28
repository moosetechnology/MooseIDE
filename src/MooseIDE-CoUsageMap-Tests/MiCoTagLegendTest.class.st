Class {
	#name : #MiCoTagLegendTest,
	#superclass : #MiCoUsageAbstractTest,
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #tests }
MiCoTagLegendTest >> testEmptyLegend [
	"Empty legend has one entry (at bottom) describing the size of the inner box"
	self buildForTest.

	self assert: builder legendTagBuilder shapes size equals: 1
]

{ #category : #tests }
MiCoTagLegendTest >> testNotEmptyLegend [
	"Empty legend has one entry for each tag + one (at bottom) describing the size of the inner box"

	self tagsWithPalette: #( tag1 tag2 tag3).

	self buildForTest.
	builder updateLegend.

	self assert: builder legendTagBuilder shapes size equals: 4
]

{ #category : #tests }
MiCoTagLegendTest >> testToggleTag [
	| tagShape |
	
	self createTag: 'aTag'.
	self buildForTest.

	tagShape := builder legendTagBuilder shapes first.
	self assert: tagShape isComposite.
	self assert: tagShape shapes size equals: 3.

	builder legendTagBuilder toggleTag: (RSMouseClick new shape: tagShape shapes first).
	
]
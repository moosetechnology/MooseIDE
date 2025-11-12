Class {
	#name : 'MiCoHighlightManagerTest',
	#superclass : 'MiCoUsageAbstractTest',
	#category : 'MooseIDE-CoUsageMap-Tests-Browser',
	#package : 'MooseIDE-CoUsageMap-Tests',
	#tag : 'Browser'
}

{ #category : 'tests' }
MiCoHighlightManagerTest >> testDeselectGoesToModel [
	| mooseEntity attribute1 shape1 |
	mooseEntity := self specModel currentMooseModel entityNamed: #att1.
	attribute1 := self specModel getInnerBoxNamed: #att1.
	shape1 := builder canvas deepShapeFromModel: attribute1.

	self specModel selectedEntity: mooseEntity.

	builder canvas announce: (RSMouseLeftClick new shape: builder canvas).
	self
		assert: self specModel selectedEntity
		equals: nil
	
]

{ #category : 'tests' }
MiCoHighlightManagerTest >> testDeselectInnerBox [
	| attribute1 shape1 default selected |
	self tagsWithPalette: { 'Frame'. 'Connection' }.

	attribute1 := self specModel getInnerBoxNamed: #att1.
	shape1 := builder canvas deepShapeFromModel: attribute1.

	default := builder highlightManager defaultBoxBorder color.
	selected := builder highlightManager selectedBoxBorder color.

	shape1 announce: (RSMouseLeftClick new shape: shape1).
	self assert: shape1 border color equals: selected.

	builder canvas announce: (RSMouseLeftClick new shape: builder canvas).
	self assert: shape1 border color equals: default.

]

{ #category : 'tests' }
MiCoHighlightManagerTest >> testHighlight [
	| attribute1 shape1 default selected |
	self tagsWithPalette: { 'Frame'. 'Connection' }.

	attribute1 := self specModel getInnerBoxNamed: #att1.
	shape1 := builder canvas deepShapeFromModel: attribute1.
	
	default := builder highlightManager defaultBoxBorder color.
	selected := builder highlightManager selectedBoxBorder color.
	
	self assert: shape1 border color equals: default.
	
	shape1 announce: (RSMouseEnter new shape: shape1).
	self assert: shape1 border color equals: selected.

	shape1 announce: (RSMouseLeave new shape: shape1).
	self assert: shape1 border color equals: default.
	
]

{ #category : 'tests' }
MiCoHighlightManagerTest >> testNoHighlightWhenSelectedInnerBox [
	| attribute3 shape3 default selected attribute4 shape4 |
	self tagsWithPalette: { 'Frame'. 'Connection' }.

	attribute3 := self specModel getInnerBoxNamed: #att3.
	attribute4 := self specModel getInnerBoxNamed: #att4.
	shape3 := builder canvas deepShapeFromModel: attribute3.
	shape4 := builder canvas deepShapeFromModel: attribute4.

	default := builder highlightManager defaultBoxBorder color.
	selected := builder highlightManager selectedBoxBorder color.

	self assert: shape4 border color equals: default.

	shape3 announce: (RSMouseLeftClick new shape: shape3).
	shape4 announce: (RSMouseEnter new shape: shape4).

	self assert: shape4 border color equals: default.

]

{ #category : 'tests' }
MiCoHighlightManagerTest >> testSelectGoesToModel [
	| attribute1 shape1 |
	attribute1 := self specModel getInnerBoxNamed: #att1.
	shape1 := builder canvas deepShapeFromModel: attribute1.

	shape1 announce: (RSMouseLeftClick new shape: shape1).
	self
		assert: self specModel selectedEntity
		equals: (self specModel currentMooseModel entityNamed: #att1)
	
]

{ #category : 'tests' }
MiCoHighlightManagerTest >> testSelectInnerBox [
	| attribute1 shape1 default selected |
	self tagsWithPalette: { 'Frame'. 'Connection' }.

	attribute1 := self specModel getInnerBoxNamed: #att1.
	shape1 := builder canvas deepShapeFromModel: attribute1.

	default := builder highlightManager defaultBoxBorder color.
	selected := builder highlightManager selectedBoxBorder color.

	self assert: shape1 border color equals: default.

	shape1 announce: (RSMouseLeftClick new shape: shape1).
	self assert: shape1 border color equals: selected.
	
]

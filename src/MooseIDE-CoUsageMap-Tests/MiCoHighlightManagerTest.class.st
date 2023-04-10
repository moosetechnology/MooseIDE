Class {
	#name : #MiCoHighlightManagerTest,
	#superclass : #MiCoUsageAbstractTest,
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #tests }
MiCoHighlightManagerTest >> testDeselectGoesToModel [
	| mooseEntity attribute1 shape1 |
	mooseEntity := self specModel currentMooseModel entityNamed: #var1.
	attribute1 := self specModel getInnerBoxNamed: #var1.
	shape1 := builder canvas deepShapeFromModel: attribute1.

	self specModel selectedEntity: mooseEntity.

	builder canvas announce: (RSMouseLeftClick new shape: builder canvas).
	self
		assert: self specModel selectedEntity
		equals: nil
	
]

{ #category : #tests }
MiCoHighlightManagerTest >> testDeselectInnerBox [
	| attribute1 shape1 default selected |
	self tagsWithPalette: { 'Frame'. 'Connection' }.

	attribute1 := self specModel getInnerBoxNamed: #var1.
	shape1 := builder canvas deepShapeFromModel: attribute1.

	default := builder highlightManager defaultBoxBorder color.
	selected := builder highlightManager selectedBoxBorder color.

	shape1 announce: (RSMouseLeftClick new shape: shape1).
	self assert: shape1 border color equals: selected.

	builder canvas announce: (RSMouseLeftClick new shape: builder canvas).
	self assert: shape1 border color equals: default.

]

{ #category : #tests }
MiCoHighlightManagerTest >> testHighlight [
	| attribute1 shape1 default selected |
	self tagsWithPalette: { 'Frame'. 'Connection' }.

	attribute1 := self specModel getInnerBoxNamed: #var1.
	shape1 := builder canvas deepShapeFromModel: attribute1.
	
	default := builder highlightManager defaultBoxBorder color.
	selected := builder highlightManager selectedBoxBorder color.
	
	self assert: shape1 border color equals: default.
	
	shape1 announce: (RSMouseEnter new shape: shape1).
	self assert: shape1 border color equals: selected.

	shape1 announce: (RSMouseLeave new shape: shape1).
	self assert: shape1 border color equals: default.
	
]

{ #category : #tests }
MiCoHighlightManagerTest >> testNoHighlightWhenSelectedInnerBox [
	| attribute1 shape1 default selected attribute2 shape2 |
	self tagsWithPalette: { 'Frame'. 'Connection' }.

	attribute1 := self specModel getInnerBoxNamed: #var1.
	attribute2 := self specModel getInnerBoxNamed: #var2.
	shape1 := builder canvas deepShapeFromModel: attribute1.
	shape2 := builder canvas deepShapeFromModel: attribute2.

	default := builder highlightManager defaultBoxBorder color.
	selected := builder highlightManager selectedBoxBorder color.

	self assert: shape2 border color equals: default.

	shape1 announce: (RSMouseLeftClick new shape: shape1).
	shape2 announce: (RSMouseEnter new shape: shape2).

	self assert: shape2 border color equals: default.

]

{ #category : #tests }
MiCoHighlightManagerTest >> testSelectGoesToModel [
	| attribute1 shape1 |
	attribute1 := self specModel getInnerBoxNamed: #var1.
	shape1 := builder canvas deepShapeFromModel: attribute1.

	shape1 announce: (RSMouseLeftClick new shape: shape1).
	self
		assert: self specModel selectedEntity
		equals: (self specModel currentMooseModel entityNamed: #var1)
	
]

{ #category : #tests }
MiCoHighlightManagerTest >> testSelectInnerBox [
	| attribute1 shape1 default selected |
	self tagsWithPalette: { 'Frame'. 'Connection' }.

	attribute1 := self specModel getInnerBoxNamed: #var1.
	shape1 := builder canvas deepShapeFromModel: attribute1.

	default := builder highlightManager defaultBoxBorder color.
	selected := builder highlightManager selectedBoxBorder color.

	self assert: shape1 border color equals: default.

	shape1 announce: (RSMouseLeftClick new shape: shape1).
	self assert: shape1 border color equals: selected.
	
]

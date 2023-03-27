Class {
	#name : #MiCoMenuManagerTest,
	#superclass : #MiCoUsageAbstractTest,
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #tests }
MiCoMenuManagerTest >> test02OpenMenu [

	| attribute method |
	self tagsWithPalette: { 'base'. 'simple' }.
	builder buildForTest.

	attribute := builder attributeNamed: #var2.
	method := builder methodNamed: #method1.
	builder menuManager createMenu: MenuMorph new onBox: attribute.
	builder menuManager createMenu: MenuMorph new onBox: method.
	builder menuManager
		createGlobalMenuOn: MenuMorph new;
		createMenu: MenuMorph new onShape: builder canvas
]

{ #category : #tests }
MiCoMenuManagerTest >> test06SelectInnerBox [
	| attribute1 attribute2 method shape1 shape2 default selected |
	self tagsWithPalette: { 'Frame'. 'Connection' }.
	builder buildForTest.
	attribute1 := builder attributeNamed: #var1.
	attribute2 := builder attributeNamed: #var2.
	method := builder methodNamed: #method1.
	shape1 := builder canvas deepShapeFromModel: attribute1.
	shape2 := builder canvas deepShapeFromModel: attribute2.
	default := builder highlightManager defaultBoxBorder color.
	selected := builder highlightManager selectedBoxBorder color.
	
	self assert: shape1 border color equals: default.
	shape1 announce: (RSMouseEnter new shape: shape1).
	self assert: shape1 border color equals: selected.
	shape1 announce: (RSMouseLeave new shape: shape1).
	self assert: shape1 border color equals: default.
	
	shape1 announce: (RSMouseLeftClick new shape: shape1).
	self assert: shape1 border color equals: selected.
	
	shape2 announce: (RSMouseEnter new shape: shape2).
	self assert: shape1 border color equals: selected.
	self assert: shape2 border color equals: default.
	
	shape2 announce: (RSMouseLeave new shape: shape2).
	self assert: shape1 border color equals: selected.
	self assert: shape2 border color equals: default.	
	
	shape2 announce: (RSMouseLeftClick new shape: shape2).
	self assert: shape1 border color equals: default.
	self assert: shape2 border color equals: selected.
	
	builder canvas announce: (RSMouseLeftClick new shape: builder canvas).
	self assert: shape1 border color equals: default.
	self assert: shape2 border color equals: default.
	
	shape1 announce: (RSMouseEnter new shape: shape1).
	self assert: shape1 border color equals: selected.
	shape1 announce: (RSMouseLeave new shape: shape1).
	self assert: shape1 border color equals: default.

]

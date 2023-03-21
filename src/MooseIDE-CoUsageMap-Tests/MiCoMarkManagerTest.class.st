Class {
	#name : #MiCoMarkManagerTest,
	#superclass : #TestCase,
	#instVars : [
		'builder'
	],
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #running }
MiCoMarkManagerTest >> setUp [
	super setUp.

	builder := MiCoUsageMapMooseBuilder new.
	builder methods: MiCoUsageTestFamixModel new allMethods.
]

{ #category : #tests }
MiCoMarkManagerTest >> test01ColorASingleMethod [

	| attribute tag shapes tagColor method4 method5 |
	builder legendTag tagsWithPalette: { 'base'. 'simple' }.
	builder buildForTest.

	attribute := builder attributeNamed: #var6.
	shapes := builder canvas deepShapesFromModel: attribute.
	self assert: shapes size equals: 2.

	tag := builder tagNamed: 'base'.
	tagColor := builder markManager tagColorFrom: nil.
	self assert: (shapes allSatisfy: [ :arg1 | arg1 color = tagColor ]).

	builder markManager setTag: tag onAttribute: attribute.
	self assert: (shapes allSatisfy: [ :arg2 | arg2 color = tag color ]).

	builder markManager automaticColor.
	method4 := builder methodNamed: #method4.
	method5 := builder methodNamed: #method5.
	self
		assert: (builder canvas shapeFromModel: method4) children second color
		equals: tag color;
		assert: (builder canvas shapeFromModel: method5) children second color
		equals: tag color
]

{ #category : #tests }
MiCoMarkManagerTest >> test02OpenMenu [

	| attribute method |
	builder legendTag tagsWithPalette: { 'base'. 'simple' }.
	builder buildForTest.

	attribute := builder attributeNamed: #var2.
	method := builder methodNamed: #method1.
	attribute createMenuOn: MenuMorph new markManager: builder markManager.
	method createMenuOn: MenuMorph new markManager: builder markManager.
	builder markManager
		createGlobalMenuOn: MenuMorph new;
		createMenuOn: MenuMorph new for: builder canvas
]

{ #category : #tests }
MiCoMarkManagerTest >> test03MarkingAttributes [

	| attribute tag |
	builder legendTag tagsWithPalette: { 'Frame'. 'Connection' }.
	builder buildForTest.
	tag := builder tagNamed: 'Frame'.
	attribute := builder attributeNamed: 'var2'.
	builder markManager setTag: tag onAttribute: attribute.
	self assert:
		((builder canvas deepShapesFromModel: attribute) allSatisfy: [ :shape | 
			 shape color = tag color ])
]

{ #category : #tests }
MiCoMarkManagerTest >> test04ClickLastTag [

	| attribute method tag |
	builder legendTag tagsWithPalette: { 'Frame'. 'Connection' }.
	builder buildForTest.
	self assert: builder markManager lastTagSelected isNil.
	attribute := builder attributeNamed: #var2.
	method := builder methodNamed: #method1.
	tag := builder tagNamed: 'Frame'.
	builder markManager setTag: tag onAttribute: attribute.
	self assert: builder markManager lastTagSelected notNil.
	builder markManager
		lastTagSelected: nil;
		setTag: tag onAttribute: method.
	self assert: builder markManager lastTagSelected notNil
]

{ #category : #tests }
MiCoMarkManagerTest >> test05ClickLastTag [
	| attribute1 attribute2 method tag shapes tagColor event |
	builder legendTag tagsWithPalette: { 'Frame'. 'Connection' }.
	builder buildForTest.
	attribute1 := builder attributeNamed: #var1.
	attribute2 := builder attributeNamed: #var2.
	method := builder methodNamed: #method1.
	tag := builder tagNamed: 'Frame'.
	tagColor := builder markManager tagColorFrom: nil.
	shapes := builder canvas deepShapesFromModel: attribute1.
	builder markManager clickOn: (RSMouseClick new shape: shapes first).
	self
		assert: attribute1 tag isNil;
		assert: (shapes allSatisfy: [ :shape | shape color = tagColor ]).
	builder markManager
		lastTagSelected: tag;
		clickOn: (RSMouseClick new shape: shapes first).
	self
		assert: attribute1 tag isNil;
		assert: (shapes allSatisfy: [ :shape | shape color = tagColor ]).
	event := RSMouseClick new.
	event shape: shapes first.
	event commandKeyPressed: true.
	event controlKeyPressed: true.
	builder markManager clickOn: event.
	self
		assert: attribute1 tag equals: tag;
		assert: (shapes allSatisfy: [ :shape | shape color = tag color ])
]

{ #category : #tests }
MiCoMarkManagerTest >> test06SelectInnerBox [
	| attribute1 attribute2 method shape1 shape2 default selected |
	builder legendTag tagsWithPalette: { 'Frame'. 'Connection' }.
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

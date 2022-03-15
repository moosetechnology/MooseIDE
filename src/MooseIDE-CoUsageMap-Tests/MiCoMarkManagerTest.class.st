Class {
	#name : #MiCoMarkManagerTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-CoUsageMap-Tests'
}

{ #category : #tests }
MiCoMarkManagerTest >> test01ColorASingleMethod [

	| v attribute tag shapes tagColor method4 method5 |
	v := MiCoUsageMapBuilder new.
	v godClass: MiCoTestClass.
	v legendTag conflictTag: 'conflic' tags: { 'base'. 'simple' }.
	v build.
	attribute := v attributeNamed: #var6.
	tag := v tagNamed: 'base'.
	tagColor := v markManager tagColorFrom: nil.
	shapes := v canvas deepShapesFromModel: attribute.
	self
		assert: shapes size equals: 2;
		assert: (shapes allSatisfy: [ :arg1 | arg1 color = tagColor ]).
	v markManager setTag: tag onAttribute: attribute.
	self assert: (shapes allSatisfy: [ :arg2 | arg2 color = tag color ]).
	v markManager automaticColor.
	method4 := v methodNamed: #method4.
	method5 := v methodNamed: #method5.
	self
		assert: (v canvas shapeFromModel: method4) children second color
		equals: tag color;
		assert: (v canvas shapeFromModel: method5) children second color
		equals: tag color
]

{ #category : #tests }
MiCoMarkManagerTest >> test02OpenMenu [

	| v attribute method |
	v := MiCoUsageMapBuilder new.
	v godClass: MiCoTestClass.
	v legendTag conflictTag: 'conflic' tags: { 'base'. 'simple' }.
	v build.
	attribute := v attributeNamed: #var2.
	method := v methodNamed: #method1.
	attribute createMenuOn: MenuMorph new markManager: v markManager.
	method createMenuOn: MenuMorph new markManager: v markManager.
	v markManager
		createGlobalMenuOn: MenuMorph new;
		createMenuOn: MenuMorph new for: v canvas
]

{ #category : #tests }
MiCoMarkManagerTest >> test03MarkingAttributes [

	| v class attribute tag |
	v := MiCoUsageMapBuilder new.
	class := MiCoTestClass.
	v godClass: class.
	v legendTag
		conflictTag: 'need work'
		tags: { 'Frame'. 'Connection' }.
	v build.
	tag := v tagNamed: 'Frame'.
	attribute := v attributeNamed: 'var2'.
	v markManager setTag: tag onAttribute: attribute.
	self assert:
		((v canvas deepShapesFromModel: attribute) allSatisfy: [ :shape | 
			 shape color = tag color ])
]

{ #category : #tests }
MiCoMarkManagerTest >> test04ClickLastTag [

	| v class attribute method tag |
	v := MiCoUsageMapBuilder new.
	class := MiCoTestClass.
	v godClass: class.
	v legendTag
		conflictTag: 'need work'
		tags: { 'Frame'. 'Connection' }.
	v build.
	self assert: v markManager lastTagSelected isNil.
	attribute := v attributeNamed: #var2.
	method := v methodNamed: #method1.
	tag := v tagNamed: 'Frame'.
	v markManager setTag: tag onAttribute: attribute.
	self assert: v markManager lastTagSelected notNil.
	v markManager
		lastTagSelected: nil;
		setTag: tag onAttribute: method.
	self assert: v markManager lastTagSelected notNil
]

{ #category : #tests }
MiCoMarkManagerTest >> test05ClickLastTag [

	| v class attribute1 attribute2 method tag shapes tagColor event |
	v := MiCoUsageMapBuilder new.
	class := MiCoTestClass.
	v godClass: class.
	v legendTag
		conflictTag: 'need work'
		tags: { 'Frame'. 'Connection' }.
	v build.
	attribute1 := v attributeNamed: #var1.
	attribute2 := v attributeNamed: #var2.
	method := v methodNamed: #method1.
	tag := v tagNamed: 'Frame'.
	tagColor := v markManager tagColorFrom: nil.
	shapes := v canvas deepShapesFromModel: attribute1.
	v markManager clickOn: (RSMouseClick new shape: shapes first).
	self
		assert: attribute1 tag isNil;
		assert: (shapes allSatisfy: [ :shape | shape color = tagColor ]).
	v markManager
		lastTagSelected: tag;
		clickOn: (RSMouseClick new shape: shapes first).
	self
		assert: attribute1 tag isNil;
		assert: (shapes allSatisfy: [ :shape | shape color = tagColor ]).
	event := RSMouseClick new.
	event shape: shapes first.
	v markManager clickOn: (event commandKeyPressed: true).
	self
		assert: attribute1 tag equals: tag;
		assert: (shapes allSatisfy: [ :shape | shape color = tag color ])
]

{ #category : #tests }
MiCoMarkManagerTest >> test06SelectInnerBox [

	| v class attribute1 attribute2 method shape1 shape2 default selected |
	v := MiCoUsageMapBuilder new.
	class := MiCoTestClass.
	v godClass: class.
	v legendTag
		conflictTag: 'need work'
		tags: { 'Frame'. 'Connection' }.
	v build.
	attribute1 := v attributeNamed: #var1.
	attribute2 := v attributeNamed: #var2.
	method := v methodNamed: #method1.
	shape1 := v canvas deepShapeFromModel: attribute1.
	shape2 := v canvas deepShapeFromModel: attribute2.
	default := v highlightManager defaultBoxBorder color.
	selected := v highlightManager selectedBoxBorder color.
	
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
	
	v canvas announce: (RSMouseLeftClick new shape: v canvas).
	self assert: shape1 border color equals: default.
	self assert: shape2 border color equals: default.
	
	shape1 announce: (RSMouseEnter new shape: shape1).
	self assert: shape1 border color equals: selected.
	shape1 announce: (RSMouseLeave new shape: shape1).
	self assert: shape1 border color equals: default.

]

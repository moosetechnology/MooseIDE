Class {
	#name : #MiCoUsageVisualizationTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-CoUsageMap-Tests'
}

{ #category : #tests }
MiCoUsageVisualizationTest >> test00Basic [

	| v class window |
	v := MiCoUsageMapBuilder new.
	self assert: v canvas nodes size equals: 0.
	class := ZnUrl.
	v godClass: class.
	window := v open.
	window delete
]

{ #category : #tests }
MiCoUsageVisualizationTest >> test01Basic [

	| v class |
	v := MiCoUsageMapBuilder new.
	v build.
	self assert: v canvas nodes size equals: 0.
	class := ZnUrl.
	v
		godClass: class;
		build.
	self
		assert: v godClass equals: class;
		assert: v miMethods size equals: class methods size;
		assert: v miAttributes size equals: class instVarNames size;
		assert: v canvas nodes size equals: class methods size
]

{ #category : #tests }
MiCoUsageVisualizationTest >> test02MethodsAttributes [

	| v class method attribute |
	v := MiCoUsageMapBuilder new.
	class := MiCoTestClass.
	v
		godClass: class;
		build.
	self
		assert: v miMethods size equals: class methods size;
		assert: v miAttributes size equals: class instVarNames size-1."because one attribute is not used"
	method := v methodNamed: #method1.
	self
		assert: method class equals: MiCoMethod;
		assert: method usedAttributes size equals: 2;
		assert: method usedAttributes first class equals: MiCoAttribute.
	method := v methodNamed: #method2.
	self assert: method usedAttributes size equals: 0.
	method := v methodNamed: #method3.
	self assert: method usedAttributes size equals: 3.
	attribute := v attributeNamed: #var2.
	self assert: attribute usedInMethods size equals: 2.
	attribute := v attributeNamed: #var4.
	self assert: attribute usedInMethods size equals: 1.
	"var5 is not used"
	self should: [v attributeNamed: #var5] raise: Error.
]

{ #category : #tests }
MiCoUsageVisualizationTest >> test03AttributeWidth [

	| v class method attribute shapes |
	v := MiCoUsageMapBuilder new.
	class := MiCoTestClass.
	v
		godClass: class;
		build.
	attribute := v attributeNamed: #var1.
	method := v methodNamed: #method1.
	shapes := v canvas deepShapesFromModel: attribute.
	self
		assert: shapes size equals: attribute usedInMethods size;
		assert: (attribute numberOfUsesOn: method) equals: 3.
	attribute := v attributeNamed: #var4.
	method := v methodNamed: #method3.
	self assert: (attribute numberOfUsesOn: method) equals: 1
]

{ #category : #tests }
MiCoUsageVisualizationTest >> test04Highlight [

	| v class attribute shapes border event |
	v := MiCoUsageMapBuilder new.
	class := MiCoTestClass.
	v godClass: class.
	v legendTag
		conflictTag: 'need work'
		tags: { 'Frame'. 'Connection' }.
	v build.
	attribute := v attributeNamed: #var2.
	border := v highlightManager selectedBoxBorder.
	shapes := v canvas deepShapesFromModel: attribute.
	event := RSMouseEnter new
		shape: shapes first;
		yourself.
	shapes first announce: event.
	self assert: (shapes allSatisfy: [ :shape | 
			 shape border color = border color and: [ 
				 shape border width = border width ] ]).
	event := RSMouseLeave new
		shape: shapes first;
		yourself.
	shapes first announce: event.
	self deny: (shapes allSatisfy: [ :shape | 
			 shape border color = border color and: [ 
				 shape border width = border width ] ])
]

{ #category : #tests }
MiCoUsageVisualizationTest >> test05MethodAttributePopup [

	| v class attribute method |
	v := MiCoUsageMapBuilder new.
	class := MiCoTestClass.
	v godClass: class.
	v legendTag
		conflictTag: 'need work'
		tags: { 'Frame'. 'Connection' }.
	v build.
	attribute := v attributeNamed: #var2.
	method := v methodNamed: #method1.
	v
		createAttributeTextMorphFor: attribute method: method;
		createMethodTextMorphFor: method
]

{ #category : #tests }
MiCoUsageVisualizationTest >> test06ExtentChanged [

	| v |
	v := MiCoUsageMapBuilder new.
	v godClass: Morph.
	v legendTag
		conflictTag: 'need work'
		tags: { 'Frame'. 'Connection' }.
	v build.
	self assert: v canvas extent x equals: 500.
	self assert: (v canvas encompassingRectangle width between: 400 and: 500).
	v canvas extent: 700 asPoint.
	self assert: v canvas extent x equals: 700.
	self assert: (v canvas encompassingRectangle width between: 600 and: 700).
	v canvas camera scale: 0.5.
	v canvas extent: 500 asPoint.
	self assert: (v canvas encompassingRectangle width between: 900 and: 1000).
]

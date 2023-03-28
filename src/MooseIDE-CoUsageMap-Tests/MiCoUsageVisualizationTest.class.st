Class {
	#name : #MiCoUsageVisualizationTest,
	#superclass : #MiCoUsageAbstractTest,
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #tests }
MiCoUsageVisualizationTest >> test00Basic [

	| window |
	self assert: builder settings notNil.
	self assert: builder canvas nodes size equals: 0.

	window := builder open.
	window delete
]

{ #category : #tests }
MiCoUsageVisualizationTest >> test01Basic [

	self buildForTest.
	self assert: builder containerBoxes size equals: 5.
	self assert: builder innerBoxes size equals: 5. "var5 is not used"
	self assert: builder canvas nodes size equals: 5
]

{ #category : #tests }
MiCoUsageVisualizationTest >> test02MethodsAttributes [

	| method |
	builder containerEntities: MiCoUsageTestFamixModel new allMethods.
	self buildForTest.

	method := builder containerBoxNamed: #method1.
	self assert: method class equals: MiCoContainerBox.
	self assert: method innerBoxes size equals: 2.
	self assert: method innerBoxes first class equals: MiCoInnerBox.

	self assert: (builder containerBoxNamed: #method2) innerBoxes size equals: 0.
	self assert: (builder containerBoxNamed: #method3) innerBoxes size equals: 3.
	self assert: (builder innerBoxNamed: #var2) numberOfUses equals: 2.
	self assert: (builder innerBoxNamed: #var4) numberOfUses equals: 1.
	self should: [builder innerBoxNamed: #var5] raise: Error.
]

{ #category : #tests }
MiCoUsageVisualizationTest >> test03AttributeWidth [

	| method attribute shapes |
	builder containerEntities: MiCoUsageTestFamixModel new allMethods.
	self buildForTest.
	
	attribute := builder innerBoxNamed: #var1.
	method := builder containerBoxNamed: #method1.
	shapes := builder canvas deepShapesFromModel: attribute.
	self assert: shapes size equals: 1.
	self assert: (attribute numberOfUsesOn: method) equals: 3.

	attribute := builder innerBoxNamed: #var4.
	method := builder containerBoxNamed: #method3.
	self assert: (attribute numberOfUsesOn: method) equals: 1
]

{ #category : #tests }
MiCoUsageVisualizationTest >> test04Highlight [

	| attribute shapes border event |
	builder containerEntities: MiCoUsageTestFamixModel new allMethods.
	self tagsWithPalette: { 'Frame'. 'Connection' }.
	self buildForTest.
	attribute := builder innerBoxNamed: #var2.
	border := builder highlightManager selectedBoxBorder.
	shapes := builder canvas deepShapesFromModel: attribute.

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

	| attribute method |
	builder containerEntities: MiCoUsageTestFamixModel new allMethods.
	self tagsWithPalette: { 'Frame'. 'Connection' }.
	self buildForTest.
	attribute := builder innerBoxNamed: #var2.
	method := builder containerBoxNamed: #method1.
	builder
		createAttributeTextMorphFor: attribute method: method;
		createContainerBoxTextMorphFor: method
]

{ #category : #tests }
MiCoUsageVisualizationTest >> test06ExtentChanged [
	"Note: size of canvas depends on number of methods, attributes, and accesses"

	builder containerEntities: MiCoUsageTestFamixModel new allMethods.
	self tagsWithPalette: { 'Frame'. 'Connection' }.
	self buildForTest.
	self assert: builder canvas extent x equals: 500.
	self assert: (builder canvas encompassingRectangle width between: 400 and: 500).

	builder canvas extent: 700 asPoint.
	self assert: builder canvas extent x equals: 700.
	self assert: (builder canvas encompassingRectangle width between: 600 and: 700).

	builder canvas camera scale: 0.5.
	builder canvas extent: 500 asPoint.
	self assert: (builder canvas encompassingRectangle width between: 600 and: 700).
]

{ #category : #tests }
MiCoUsageVisualizationTest >> testConsumeTag [

	self shouldnt: (visualization consume: (self createTag: 'aTag')) raise: Error
]

Class {
	#name : #MiCoUsageVisualizationTest,
	#superclass : #MiCoUsageAbstractTest,
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #tests }
MiCoUsageVisualizationTest >> test01Basic [

	self assert: builder canvas nodes size equals: 5
]

{ #category : #tests }
MiCoUsageVisualizationTest >> test03AttributeWidth [

	| attribute shapes |
	attribute := self specModel getInnerBoxNamed: #var1.
	shapes := builder canvas deepShapesFromModel: attribute.
	self assert: shapes size equals: 1.

]

{ #category : #tests }
MiCoUsageVisualizationTest >> test04Highlight [

	| attribute shapes border event |
	self tagsWithPalette: { 'Frame'. 'Connection' }.

	attribute := self specModel getInnerBoxNamed: #var2.
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
	self tagsWithPalette: { 'Frame'. 'Connection' }.
	attribute := self specModel getInnerBoxNamed: #var2.
	method := self specModel containerBoxNamed: #method1.
	builder
		createInnerBoxTextMorphFor: attribute containerBox: method;
		createContainerBoxTextMorphFor: method
]

{ #category : #tests }
MiCoUsageVisualizationTest >> test06ExtentChanged [
	"Note: size of canvas depends on number of methods, attributes, and accesses"

	self assert: builder canvas extent x equals: 500.
	self
		assert: (builder canvas encompassingRectangle width between: 400 and: 500)
		description: 'Value: ' , builder canvas encompassingRectangle width asString , ' not in specified interval'.

	builder canvas extent: 700 asPoint.
	self assert: builder canvas extent x equals: 700.
	self
		assert: (builder canvas encompassingRectangle width between: 600 and: 700)
		description: 'Value: ' , builder canvas encompassingRectangle width asString , ' not in specified interval'.

	builder canvas camera scale: 0.5.
	builder canvas extent: 500 asPoint.
	self
		assert: (builder canvas encompassingRectangle width between: 600 and: 700)
		description: 'Value: ' , builder canvas encompassingRectangle width asString , ' not in specified interval'.
]

{ #category : #tests }
MiCoUsageVisualizationTest >> testConsumeTag [

	self shouldnt: (visualization consume: (self createTag: 'aTag')) raise: Error
]

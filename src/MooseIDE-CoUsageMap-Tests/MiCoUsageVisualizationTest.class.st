Class {
	#name : 'MiCoUsageVisualizationTest',
	#superclass : 'MiCoUsageAbstractTest',
	#category : 'MooseIDE-CoUsageMap-Tests-Browser',
	#package : 'MooseIDE-CoUsageMap-Tests',
	#tag : 'Browser'
}

{ #category : 'tests' }
MiCoUsageVisualizationTest >> test01Basic [

	self assert: builder canvas nodes size equals: 5
]

{ #category : 'tests' }
MiCoUsageVisualizationTest >> test03AttributeWidth [

	| attribute shapes |
	attribute := self specModel getInnerBoxNamed: #att1.
	shapes := builder canvas deepShapesFromModel: attribute.
	self assert: shapes size equals: 1.

]

{ #category : 'tests' }
MiCoUsageVisualizationTest >> test04Highlight [

	| attribute shapes border event |
	self tagsWithPalette: { 'Frame'. 'Connection' }.

	attribute := self specModel getInnerBoxNamed: #att3.
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

{ #category : 'tests' }
MiCoUsageVisualizationTest >> test05MethodAttributePopup [

	| attribute method |
	self tagsWithPalette: { 'Frame'. 'Connection' }.
	attribute := self specModel getInnerBoxNamed: #att3.
	method := self specModel containerBoxNamed: #method3.
	builder
		createInnerBoxTextMorphFor: attribute containerBox: method;
		createContainerBoxTextMorphFor: method
]

{ #category : 'tests' }
MiCoUsageVisualizationTest >> testConsumeTag [

	self shouldnt: (visualization consume: (self createTag: 'aTag')) raise: Error
]

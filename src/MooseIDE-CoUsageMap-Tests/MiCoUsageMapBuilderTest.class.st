Class {
	#name : #MiCoUsageMapBuilderTest,
	#superclass : #MiCoUsageAbstractTest,
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #running }
MiCoUsageMapBuilderTest >> browserClass [
	^ MiCoUsageMapBrowser
]

{ #category : #running }
MiCoUsageMapBuilderTest >> setUp [
	super setUp.

	"browser collectionModel: MiCoUsageTestFamixModel new allMethods.

	visualization := browser mapVisualization.
	builder := visualization mapBuilder.
	builder methods: browser collectionModel
"
]

{ #category : #tests }
MiCoUsageMapBuilderTest >> testAutomaticColorOfContainerBox [

	| attribute tag method4 method5 |
	self tagsWithPalette: { 'base'. 'simple' }.
	builder buildForTest.

	attribute := builder attributeNamed: #var6.
	tag := builder tagNamed: 'base'.
	builder setTag: tag onAttribute: attribute.

	builder automaticColor.
	method4 := builder methodNamed: #method4.
	method5 := builder methodNamed: #method5.
	self
		assert: (builder canvas shapeFromModel: method4) children second color
		equals: tag color.
	self
		assert: (builder canvas shapeFromModel: method5) children second color
		equals: tag color
]

{ #category : #tests }
MiCoUsageMapBuilderTest >> testLastTagInitialization [

	self tagsWithPalette: { 'Frame'. 'Connection' }.
	builder buildForTest.

	self assert: builder lastTagSelected isNil.

]

{ #category : #tests }
MiCoUsageMapBuilderTest >> testLastTagWithTag [

	| attribute method tag |
	self tagsWithPalette: { 'Frame'. 'Connection' }.
	builder buildForTest.

	attribute := builder attributeNamed: #var2.
	method := builder methodNamed: #method1.
	tag := builder tagNamed: 'Frame'.

	builder setTag: tag onAttribute: attribute.
	self assert: builder lastTagSelected equals: tag.

]

{ #category : #tests }
MiCoUsageMapBuilderTest >> testQuickTaggingWithoutLastTag [
	| innerBox shapes tagColor event |
	self tagsWithPalette: { 'Frame'. 'Connection' }.
	builder buildForTest.

	innerBox := builder attributeNamed: #var1.
	shapes := builder canvas deepShapesFromModel: innerBox.
	tagColor := builder tagColorFrom: nil.
	event := RSMouseClick new shape: shapes first.

	builder menuManager clickOn: event.

	self assert: innerBox tag isNil.
	self assert: (shapes allSatisfy: [ :shape | shape color = tagColor ]).

]

{ #category : #tests }
MiCoUsageMapBuilderTest >> testQuickTaggingWithoutMetaKey [
	| innerBox shapes  event tag |
	self tagsWithPalette: { 'Frame'. 'Connection' }.
	builder buildForTest.

	tag := builder tagNamed: 'Frame'.
	innerBox := builder attributeNamed: #var1.
	shapes := builder canvas deepShapesFromModel: innerBox.
	event := RSMouseClick new
		shape: shapes first ;
		commandKeyPressed: true ;
		controlKeyPressed: true.

	builder lastTagSelected: tag.
	builder menuManager clickOn: event.

	self assert: innerBox tag equals: tag.
	self assert: (shapes allSatisfy: [ :shape | shape color = tag color ]).

]

{ #category : #tests }
MiCoUsageMapBuilderTest >> testSeveralInnerBoxesColorWithTag [

	| attribute shapes tag |
	self tagsWithPalette: { 'base'. 'simple' }.
	builder buildForTest.

	attribute := builder attributeNamed: #var6.
	shapes := builder canvas deepShapesFromModel: attribute.

	tag := builder tagNamed: 'base'.
	builder setTag: tag onAttribute: attribute.
	self assert: (shapes allSatisfy: [ :shape | shape color = tag color ]).

]

{ #category : #tests }
MiCoUsageMapBuilderTest >> testSeveralInnerBoxesColorWithoutTag [

	| attribute shapes tagColor |
	builder buildForTest.

	attribute := builder attributeNamed: #var6.
	shapes := builder canvas deepShapesFromModel: attribute.

	tagColor := builder tagColorFrom: nil.
	self assert: (shapes allSatisfy: [ :shape | shape color = tagColor ]).

]

{ #category : #tests }
MiCoUsageMapBuilderTest >> testSeveralInnerBoxesForOneEntity [

	| attribute shapes |
	builder buildForTest.

	attribute := builder attributeNamed: #var6.
	shapes := builder canvas deepShapesFromModel: attribute.
	self assert: shapes size equals: 2.

]

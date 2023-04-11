Class {
	#name : #MiCoUsageMapBuilderTest,
	#superclass : #MiCoUsageAbstractTest,
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #running }
MiCoUsageMapBuilderTest >> browserClass [
	^ MiCoUsageMapBrowser
]

{ #category : #tests }
MiCoUsageMapBuilderTest >> testLastTagInitialization [

	self createTag: 'aTag'.

	self assert: visualization selectedTag isNil

]

{ #category : #tests }
MiCoUsageMapBuilderTest >> testQuickTaggingWithoutLastTag [
	| innerBox shapes tagColor event |
	self createTag: 'aTag'.

	innerBox := self specModel getInnerBoxNamed: #var1.
	shapes := builder canvas deepShapesFromModel: innerBox.
	tagColor := builder colorFromTags: nil.
	event := RSMouseClick new shape: shapes first.

	builder menuManager clickOn: event.

	self assert: innerBox tag isNil.
	self assert: (shapes allSatisfy: [ :shape | shape color = tagColor ]).

]

{ #category : #tests }
MiCoUsageMapBuilderTest >> testQuickTaggingWithoutMetaKey [
	| innerBox shapes  event tag |
	tag := self createTag: 'aTag'.
	innerBox := self specModel getInnerBoxNamed: #var1.
	shapes := builder canvas deepShapesFromModel: innerBox.
	event := RSMouseClick new
		shape: shapes first ;
		commandKeyPressed: true ;
		controlKeyPressed: true.

	self specModel selectedTag: tag.
	builder menuManager clickOn: event.

	self assert: innerBox tag equals: tag.
	self assert: (shapes allSatisfy: [ :shape | shape color = tag color ]).

]

{ #category : #tests }
MiCoUsageMapBuilderTest >> testSeveralInnerBoxesColorWithTag [

	| attribute shapes tag |
	attribute := self specModel getInnerBoxNamed: #var6.
	shapes := builder canvas deepShapesFromModel: attribute.
	tag := self createTag: 'aTag'.
	self specModel setTag: tag onInnerBox: attribute.

	self assert: (shapes allSatisfy: [ :shape | shape color = tag color ]).

]

{ #category : #tests }
MiCoUsageMapBuilderTest >> testSeveralInnerBoxesColorWithoutTag [

	| attribute shapes tagColor |

	attribute := self specModel getInnerBoxNamed: #var6.
	shapes := builder canvas deepShapesFromModel: attribute.
	tagColor := builder colorFromTags: nil.

	self assert: (shapes allSatisfy: [ :shape | shape color = tagColor ]).

]

{ #category : #tests }
MiCoUsageMapBuilderTest >> testSeveralInnerBoxesForOneEntity [

	| attribute shapes |
	attribute := self specModel getInnerBoxNamed: #var6.
	shapes := builder canvas deepShapesFromModel: attribute.
	self assert: shapes size equals: 2.

]

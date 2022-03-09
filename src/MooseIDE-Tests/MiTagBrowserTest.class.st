Class {
	#name : #MiTagBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'detailsPage',
		'helper'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiTagBrowserTest >> browserClass [
	^ MiTagBrowser
]

{ #category : #tests }
MiTagBrowserTest >> mooseModelSize [

	^ helper classesAndMethods anyOne mooseModel size
]

{ #category : #tests }
MiTagBrowserTest >> numberOfTaggedEntities [

	^ (helper classesAndMethods anyOne mooseModel select: #isTagged) size
]

{ #category : #running }
MiTagBrowserTest >> setUp [

	super setUp.

	helper := FQTestsHelper current.
	browser followEntity: helper classesAndMethods.
	detailsPage := browser descriptionPage
]

{ #category : #tests }
MiTagBrowserTest >> testIsConsumerOfFQAbstractQuery [

	self assert:
		((browser application consumersOf: FQAbstractQuery) anySatisfy: [ :elt | 
			 elt = browser tagCreationForm ])
]

{ #category : #tests }
MiTagBrowserTest >> testIsConsumerOfTagAssociation [

	self assert:
		((browser application consumersOf: FamixTagAssociation) anySatisfy: [ :elt | 
			 elt = browser ])
]

{ #category : #tests }
MiTagBrowserTest >> testIsProducerOfDynamicTag [

	self assert:
		((browser application producersOf: MiDynamicTag) anySatisfy: [ :elt | 
			 elt = browser ])
]

{ #category : #tests }
MiTagBrowserTest >> testIsProducerOfFamixTags [

	self assert:
		((browser application producersOf: FamixTag) anySatisfy: [ :elt | 
			 elt = browser ])
]

{ #category : #tests }
MiTagBrowserTest >> testNoTagDetailPageAddDoNothing [

	| entities |
	entities := detailsPage tagModel mooseModel entities.
	self assert: entities size equals: self mooseModelSize.

	detailsPage addAll.

	self
		assert: (entities select: #isTagged) size
		equals: self numberOfTaggedEntities
]

{ #category : #tests }
MiTagBrowserTest >> testTagDetailPageAddEntityToTag [

	| entities tag |
	entities := detailsPage tagModel mooseModel entities.
	self assert: entities size equals: self mooseModelSize.

	tag := detailsPage tagModel addTag: 'aTag'.
	detailsPage tagModel currentTag: tag.
	detailsPage addAll.

	self
		assert: (entities select: #isTagged) size
		equals: self numberOfTaggedEntities
]

{ #category : #tests }
MiTagBrowserTest >> testTagModelInitialization [

	| specModel |
	specModel := detailsPage tagModel.
	self assert: specModel isNotNil.
	self assert: specModel mooseModel isNotNil.
	self assert: specModel mooseModel size equals: self mooseModelSize
]

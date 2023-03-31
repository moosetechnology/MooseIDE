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

{ #category : #running }
MiTagBrowserTest >> mooseModelSize [

	^ helper classesAndMethods anyOne mooseModel size
]

{ #category : #running }
MiTagBrowserTest >> numberOfTaggedEntities [

	^ (helper classesAndMethods anyOne mooseModel select: #isTagged) size
]

{ #category : #running }
MiTagBrowserTest >> setUp [

	super setUp.

	helper := FQTestsHelper new.
	browser followEntity: helper classesAndMethods.
	detailsPage := browser descriptionPage
]

{ #category : #'tests - opening' }
MiTagBrowserTest >> testCanTagEntities [
	self deny: browser canTagEntities 
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
	entities := detailsPage model mooseModel entities.
	self assert: entities size equals: self mooseModelSize.

	detailsPage addAll.

	self
		assert: (entities select: #isTagged) size
		equals: self numberOfTaggedEntities
]

{ #category : #tests }
MiTagBrowserTest >> testTagDetailPageAddEntityToTag [

	| entities tag |
	entities := detailsPage model mooseModel entities.
	self assert: entities size equals: self mooseModelSize.

	tag := detailsPage model addTag: 'aTag'.
	detailsPage model currentTag: tag.
	detailsPage addAll.

	self
		assert: (entities select: #isTagged) size
		equals: self numberOfTaggedEntities
]

{ #category : #tests }
MiTagBrowserTest >> testTagModelInitialization [

	| specModel |
	specModel := detailsPage model.
	self assert: specModel isNotNil.
	self assert: specModel mooseModel isNotNil.
	self assert: specModel mooseModel size equals: self mooseModelSize
]

Class {
	#name : #MiTagBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'detailsPage',
		'helper'
	],
	#category : #'MooseIDE-Tagging-Tests'
}

{ #category : #running }
MiTagBrowserTest >> browserClass [
	^ MiTagBrowser
]

{ #category : #running }
MiTagBrowserTest >> defaultEntityToSelect [

	^ FQTestsHelper new classesAndMethods
]

{ #category : #running }
MiTagBrowserTest >> mooseModelSize [

	^ self defaultEntityToSelect anyOne mooseModel size
]

{ #category : #running }
MiTagBrowserTest >> numberOfTaggedEntities [

	^ (self defaultEntityToSelect anyOne mooseModel select: #isTagged)
		  size
]

{ #category : #running }
MiTagBrowserTest >> receiveEntityToSelect [

	| tag |
	super receiveEntityToSelect.

	tag := detailsPage model addTag: 'aTag'.
	detailsPage model currentTag: tag.

	browser refreshTagList.
	browser tagManagementPage setTagTo: tag.
	browser tagManagementPage descriptionPage addAll
]

{ #category : #running }
MiTagBrowserTest >> setUp [

	super setUp.

	browser followEntity: entityToSelect.
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

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
	detailsPage := browser tagDetailsPage retrievePresenter
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
MiTagBrowserTest >> testNoTagDetailPageLabel [
	self assert: (detailsPage taggedEntitiesLabel label beginsWith: '!*!')
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

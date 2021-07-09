Class {
	#name : #MiTagBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'detailsPage'
	],
	#category : #'Midas-Tests-Browsers'
}

{ #category : #running }
MiTagBrowserTest >> browserClass [
	^ MiTagBrowser
]

{ #category : #running }
MiTagBrowserTest >> setUp [
	| model |
	super setUp.

	"putting some entities in the current MooseModel"
	model := browser tagModel mooseModel.
	MooseEntity new mooseModel: model.
	MooseEntity new mooseModel: model.

	"putting the mooseModel in the logger for the browser to retrieve its entities"
	self application defaultBus logger newLogFor: model.
	detailsPage := browser tagDetailsPage retrievePresenter.
]

{ #category : #tests }
MiTagBrowserTest >> testNoTagDetailPageAddDoNothing [
	| entities |
	entities := detailsPage tagModel mooseModel entities.
	self assert: entities size equals: 2.

	detailsPage addAll.

	self assert: (entities select: #isTagged) size equals: 0
]

{ #category : #tests }
MiTagBrowserTest >> testNoTagDetailPageLabel [
	self assert: (detailsPage lblTagEntities label beginsWith: '!*!')
]

{ #category : #tests }
MiTagBrowserTest >> testTagDetailPageAddEntityToTag [
	| entities tag |
	entities := detailsPage tagModel mooseModel entities.
	self assert: entities size equals: 2.

	tag := detailsPage tagModel addTag: 'aTag'.
	detailsPage tagModel currentTag: tag.
	detailsPage addAll.

	self assert: (entities select: #isTagged) size equals: 2
]

{ #category : #tests }
MiTagBrowserTest >> testTagModelInitialization [
	| specModel |
	specModel := detailsPage tagModel.
	self assert: specModel isNotNil.
	self assert: specModel mooseModel isNotNil.
	self assert: specModel mooseModel size equals: 2.
]

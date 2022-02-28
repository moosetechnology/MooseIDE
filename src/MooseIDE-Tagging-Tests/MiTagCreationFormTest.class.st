Class {
	#name : #MiTagCreationFormTest,
	#superclass : #MiTagPresenterTest,
	#category : #'MooseIDE-Tagging-Tests'
}

{ #category : #helpers }
MiTagCreationFormTest >> presenterClass [

	^ MiTagCreationForm
]

{ #category : #helpers }
MiTagCreationFormTest >> presenterOwner [

	^ browser
]

{ #category : #initialization }
MiTagCreationFormTest >> setUp [

	super setUp.
	browser openTagCreationForm.
]

{ #category : #tests }
MiTagCreationFormTest >> testCancelTagCreation [

	self assert: browser layout child equals: browser tagCreationForm.
	presenter cancelButton click.
	self deny: browser layout child equals: browser tagCreationForm
]

{ #category : #tests }
MiTagCreationFormTest >> testCategoryDropListContainsCategories [

	self
		createCategory: 'Category001';
		createCategory: 'Category002';
		createCategory: 'Category003'.
	presenter updateCategories.
	self assert: presenter categorySelection items size equals: 4
]

{ #category : #tests }
MiTagCreationFormTest >> testExtentTagDefault [

	self assert: presenter extentButton state equals: true.
	self deny: presenter queryListLabeled isVisible
]

{ #category : #tests }
MiTagCreationFormTest >> testQueryDropListFetchQueriesFromQueriesProducer [

	| mockProducer query |
	mockProducer := Mock named: 'producer'.
	browser application
		registerProducer: mockProducer
		for: FQAbstractQuery.
	query := FQBooleanQuery new property: #isAbstract.
	(mockProducer stub itemsFor: FQAbstractQuery) willReturn: { query }.
	presenter updateQueryList.
	self assert: (presenter queryList items anySatisfy: [ :q | q = query ])
]

{ #category : #tests }
MiTagCreationFormTest >> testSetIntentTag [

	self assert: presenter intentButton state equals: false.
	self flag: 'fix weird behavior'.
	presenter intentButton click.
	presenter intentButton action value.
	self assert: presenter intentButton state equals: true.
	self assert: presenter extentButton state equals: false.
	self assert: presenter queryListLabeled isVisible
]

{ #category : #tests }
MiTagCreationFormTest >> testShouldNotSubmitWithoutName [

	presenter submit.
	self assert: browser layout child equals: browser tagCreationForm
]

{ #category : #tests }
MiTagCreationFormTest >> testSubmitCreatesATag [

	self assert: browser tagModel allTags size equals: 0.
	presenter nameField text: 'Tag001'.
	presenter submitButton click.
	self assert: browser tagModel allTags size equals: 1
]

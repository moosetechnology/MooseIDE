Class {
	#name : 'MiTagCreationFormTest',
	#superclass : 'MiTagPresenterTest',
	#instVars : [
		'creationForm'
	],
	#category : 'MooseIDE-Tagging-Tests',
	#package : 'MooseIDE-Tagging-Tests'
}

{ #category : 'helpers' }
MiTagCreationFormTest >> presenterClass [

	^ MiTagCreationForm
]

{ #category : 'helpers' }
MiTagCreationFormTest >> presenterOwner [

	^ browser
]

{ #category : 'running' }
MiTagCreationFormTest >> setUp [

	super setUp.
	creationForm := browser createTag
]

{ #category : 'running' }
MiTagCreationFormTest >> tearDown [

	creationForm close.

	super tearDown 
]

{ #category : 'tests' }
MiTagCreationFormTest >> testCancelTagCreation [

	self assert: creationForm isDisplayed.
	self assert: browser specModel allTags size equals: 0.

	creationForm cancelButton click.

	self deny: creationForm isDisplayed.
	self assert: browser specModel allTags size equals: 0.

]

{ #category : 'tests' }
MiTagCreationFormTest >> testCategoryDropListContainsCategories [

	self
		createCategory: 'Category001';
		createCategory: 'Category002';
		createCategory: 'Category003'.
	creationForm updateCategories.
	self assert: creationForm categorySelection items size equals: 4
]

{ #category : 'tests' }
MiTagCreationFormTest >> testExtentTagDefault [

	self assert: creationForm extentButton state equals: true.
	self deny: creationForm queryListLabeled isVisible
]

{ #category : 'tests' }
MiTagCreationFormTest >> testIsConsumerOfFQAbstractQuery [

	self skip: #TODO.

	self assert:
		((browser application consumersOf: FQAbstractQuery) anySatisfy: [ :elt | 
			 elt = creationForm ])
]

{ #category : 'tests' }
MiTagCreationFormTest >> testQueryDropListFetchQueriesFromQueriesProducer [

	| mockProducer query |
	mockProducer := Mock named: 'producer'.
	browser application
		registerProducer: mockProducer
		for: FQAbstractQuery.
	query := FQBooleanQuery new property: #isAbstract.
	(mockProducer stub itemsFor: FQAbstractQuery) willReturn: { query }.

	creationForm updateQueryList.

	self assert: (creationForm queryList items anySatisfy: [ :q |  (q class = query class) and: [ q property = query property ] ])
]

{ #category : 'tests' }
MiTagCreationFormTest >> testSetIntentTag [

	self deny: creationForm intentButton state.
	
	self flag: 'fix weird behavior'.
	
	creationForm intentButton click.
	creationForm intentButton action value.
	
	self assert: creationForm intentButton state.
	self deny: creationForm extentButton state.
	self assert: creationForm queryListLabeled isVisible
]

{ #category : 'tests' }
MiTagCreationFormTest >> testShouldNotSubmitWithoutName [

	creationForm submit.

	self assert: creationForm isDisplayed 
]

{ #category : 'tests' }
MiTagCreationFormTest >> testSubmitCreatesATag [

	self assert: browser specModel allTags size equals: 0.

	creationForm nameField text: 'Tag001'.
	creationForm submitButton click.

	self assert: browser specModel allTags size equals: 1.
	self assert: browser specModel allTags anyOne name equals: 'Tag001'
]

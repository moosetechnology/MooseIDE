Class {
	#name : #MiQueriesCombinationPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'helper',
		'presenter'
	],
	#category : #'Midas-FamixQueries-Tests-Presenters'
}

{ #category : #running }
MiQueriesCombinationPresenterTest >> browserWithTwoQueries [
	| browser |
	browser := MiQueriesBrowser
		on:
			(FQRootQuery new
				result: helper classesAndMethods;
				yourself).
	{(FQBooleanQuery property: #isDead).
	(FQTypeQuery new type: FamixStClass)}
		do: [ :parent | 
			parent beChildOf: browser initialQuery.
			browser updateForQuery: parent.
			browser selectQuery: browser initialQuery ].
	^ browser
]

{ #category : #running }
MiQueriesCombinationPresenterTest >> classToTest [
	^ MiQueriesCombinationPresenter
]

{ #category : #running }
MiQueriesCombinationPresenterTest >> openInstance [
	presenter
		onQueries:
			(presenter browser queries copyWithout: presenter browser initialQuery);
		openWithSpec
]

{ #category : #running }
MiQueriesCombinationPresenterTest >> setUp [
	helper := FQTestsHelper current.
	presenter := self classToTest on: self browserWithTwoQueries
]

{ #category : #running }
MiQueriesCombinationPresenterTest >> tearDown [
	presenter window ifNotNil: [ :window | window close ]
]

{ #category : #tests }
MiQueriesCombinationPresenterTest >> testBasicInitialization [

	self
		assertCollection: presenter combinationsDroplist listItems
		hasSameElements: { 
				FQUnionQuery.
				FQIntersectionQuery.
				FQSubtractionQuery }.
	self
		assertCollection: presenter resultList items
		hasSameElements: #(  ).
	self assert: presenter toolbar class identicalTo: SpToolbarPresenter.
	self
		assert: presenter toolbar presenters first class
		identicalTo: SpToolbarButtonPresenter
]

{ #category : #tests }
MiQueriesCombinationPresenterTest >> testNeverKeepFalseChildren [
	self openInstance.
	presenter combinationsDroplist selectItem: FQUnionQuery.

	presenter parentQueries
		do: [ :parent | 
			self assert: parent children size equals: 1.
			self assert: (parent children includes: presenter newQuery).
			self assert: (presenter newQuery subqueries includes: parent) ].
		
	presenter combinationsDroplist selectItem: FQIntersectionQuery.

	presenter parentQueries
		do: [ :parent | 
			self assert: parent children size equals: 1.
			self assert: (parent children includes: presenter newQuery).
			self assert: (presenter newQuery subqueries includes: parent) ].
]

{ #category : #tests }
MiQueriesCombinationPresenterTest >> testNonCommutativeQueryButton [
	| firstParent secondParent initialResult |
	self openInstance.
	presenter combinationsDroplist selectItem: FQSubtractionQuery.
	firstParent := presenter newQuery subqueries first.
	secondParent := presenter newQuery subqueries second.
	initialResult := presenter newQuery result.
	(presenter presenters
		detect: [ :pres | pres class == SpButtonPresenter ]) click.
	self
		assert: presenter newQuery subqueries first
		identicalTo: secondParent.
	self
		assert: presenter newQuery subqueries second
		identicalTo: firstParent.
	self
		denyCollection: presenter newQuery result
		hasSameElements: initialResult.
	self
		assertCollection: presenter resultList items
		hasSameElements: presenter newQuery result
]

{ #category : #tests }
MiQueriesCombinationPresenterTest >> testNonCommutativeQueryLabels [
	self openInstance.
	presenter combinationsDroplist selectItem: FQSubtractionQuery.
	self
		assertCollection:
			((presenter presenters
				select: [ :pres | pres class == SpLabelPresenter ])
				collect: #label)
		hasSameElements: {'isDead' . '\' . 'Classes'}
]

{ #category : #tests }
MiQueriesCombinationPresenterTest >> testOnQueries [
	self openInstance.
	self
		assert: presenter newQuery class
		identicalTo: presenter combinationsDroplist selectedItem.
	self
		assert: presenter queriesTree class
		identicalTo: MiRoassalQueryPresenter.
	self
		assert: presenter queriesTree selectedItem
		identicalTo: presenter newQuery.
	self
		assertCollection: presenter resultList items
		hasSameElements: presenter newQuery result
]

{ #category : #tests }
MiQueriesCombinationPresenterTest >> testToolBarAction [
	| initialQueriesSize |
	self openInstance.
	initialQueriesSize := presenter browser queries size.
	presenter toolbar presenters first click.
	self
		assert: presenter browser queries size
		equals: initialQueriesSize + 1.
	self
		assert: presenter browser selectedQuery
		equals: presenter newQuery.
	self
		assertCollection: presenter browser selectedQuery subqueries
		hasSameElements: presenter parentQueries.
	(presenter browser queries
		copyWithoutAll:
			{presenter browser initialQuery.
			presenter newQuery})
		do: [ :parent | 
			self assert: parent children size equals: 1.
			self assert: (parent children includes: presenter newQuery) ]
]

{ #category : #tests }
MiQueriesCombinationPresenterTest >> testUpdateForQueryClass [
	self openInstance.
	presenter combinationsDroplist selectItem: FQUnionQuery.
	
	self assert: presenter newQuery class identicalTo: FQUnionQuery.
	
	presenter parentQueries
		do: [ :parent | 
			self assert: parent children size equals: 1.
			self assert: (parent children includes: presenter newQuery).
			self assert: (presenter newQuery subqueries includes: parent) ].
	
	self
		assert: presenter queriesTree selectedItem
		identicalTo: presenter newQuery.
	
	self
		assertCollection: presenter resultList items
		hasSameElements: presenter newQuery result
]

{ #category : #tests }
MiQueriesCombinationPresenterTest >> testWindowClosedAction [
	| initialQueriesSize |
	self openInstance.
	initialQueriesSize := presenter browser queries size.
	presenter window close.
	self
		assert: presenter browser queries size
		equals: initialQueriesSize.
	self deny: presenter browser selectedQuery equals: presenter newQuery.
	self deny: (presenter browser queries includes: presenter newQuery).
	(presenter browser queries
		copyWithoutAll:
			{presenter browser initialQuery.
			presenter newQuery})
		do: [ :parent | self assert: parent children isEmpty ]
]

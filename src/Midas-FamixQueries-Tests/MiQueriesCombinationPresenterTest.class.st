Class {
	#name : #MiQueriesCombinationPresenterTest,
	#superclass : #SpTest,
	#instVars : [
		'helper'
	],
	#category : #'Midas-FamixQueries-Tests-Presenters'
}

{ #category : #running }
MiQueriesCombinationPresenterTest >> browserWithTwoQueries [
	| browser |
	browser := MiQueriesBrowser on: helper classesAndMethods.
	{(FQBooleanQuery new property: #isAbstract).
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
			(presenter browser queries copyWithout: presenter browser initialQuery).
	super openInstance
]

{ #category : #running }
MiQueriesCombinationPresenterTest >> setUp [
	helper := FQTestsHelper current.
	presenter := self classToTest on: self browserWithTwoQueries
]

{ #category : #tests }
MiQueriesCombinationPresenterTest >> testBasicInitialization [
	self
		assertCollection: presenter combinationsDroplist listItems
		hasSameElements:
			{FQUnionQuery.
			FQIntersectionQuery.
			FQSubstractionQuery}.
	self
		assertCollection: presenter resultList items
		hasSameElements: #().
	self assert: presenter toolBar class identicalTo: SpToolBarPresenter.
	self
		assert: presenter toolBar presenters first class
		identicalTo: SpToolBarButtonPresenter
]

{ #category : #tests }
MiQueriesCombinationPresenterTest >> testNeverKeepFalseChildren [
	self openInstance.
	presenter combinationsDroplist selectItem: FQUnionQuery.

	presenter parentQueries
		do: [ :parent | 
			self assert: parent children size equals: 1.
			self assert: (parent children includes: presenter newQuery).
			self assert: (presenter newQuery parents includes: parent) ].
		
	presenter combinationsDroplist selectItem: FQIntersectionQuery.

	presenter parentQueries
		do: [ :parent | 
			self assert: parent children size equals: 1.
			self assert: (parent children includes: presenter newQuery).
			self assert: (presenter newQuery parents includes: parent) ].
]

{ #category : #tests }
MiQueriesCombinationPresenterTest >> testNonCommutativeQueryButton [
	| firstParent secondParent initialResult |
	self openInstance.
	presenter combinationsDroplist selectItem: FQSubstractionQuery.
	firstParent := presenter newQuery parents first.
	secondParent := presenter newQuery parents second.
	initialResult := presenter newQuery result.
	(presenter presenters
		detect: [ :pres | pres class == SpButtonPresenter ]) click.
	self
		assert: presenter newQuery parents first
		identicalTo: secondParent.
	self
		assert: presenter newQuery parents second
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
	presenter combinationsDroplist selectItem: FQSubstractionQuery.
	self
		assertCollection:
			((presenter presenters
				select: [ :pres | pres class == SpLabelPresenter ])
				collect: #label)
		hasSameElements: {'isAbstract' . '\' . 'Classes'}
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
	presenter toolBar presenters first click.
	self
		assert: presenter browser queries size
		equals: initialQueriesSize + 1.
	self
		assert: presenter browser selectedQuery
		equals: presenter newQuery.
	self
		assertCollection: presenter browser selectedQuery parents
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
			self assert: (presenter newQuery parents includes: parent) ].
	
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

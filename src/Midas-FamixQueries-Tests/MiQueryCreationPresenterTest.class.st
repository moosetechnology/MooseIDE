Class {
	#name : #MiQueryCreationPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'helper',
		'presenter'
	],
	#category : #'Midas-FamixQueries-Tests-Presenters'
}

{ #category : #tests }
MiQueryCreationPresenterTest >> assertQueryMatchesInAllSubpresenters [
	self
		assert:
			(presenter query
				hasSameParametersAs: (helper queryFromCodeInPresenter: presenter)).
	self
		assertCollection: presenter queryConfigurationPresenter query result
		hasSameElements: presenter resultList items
]

{ #category : #running }
MiQueryCreationPresenterTest >> changeQueryType [
	presenter queryTypesDropList
		selectItem:
			(presenter queryTypesDropList listItems
				detect: [ :item | presenter queryTypesDropList selectedItem ~= item ]).
	presenter queryTypesDropList selectItem: FQScopeQuery
]

{ #category : #running }
MiQueryCreationPresenterTest >> classToTest [
	^ MiQueryCreationPresenter
]

{ #category : #running }
MiQueryCreationPresenterTest >> openInstance [
	presenter openWithSpec
]

{ #category : #running }
MiQueryCreationPresenterTest >> setUp [
	super setUp.
	helper := FQTestsHelper current.
	presenter := MiQueryCreationPresenter
		on:
			(MiQueriesBrowser
				on:
					(FQRootQuery new
						result: helper classesAndMethods;
						yourself))
]

{ #category : #running }
MiQueryCreationPresenterTest >> tearDown [
	presenter window ifNotNil: [ :window | window close ]
]

{ #category : #tests }
MiQueryCreationPresenterTest >> testCreateOnlyOneChild [
	self openInstance.
	self assert: presenter browser initialQuery children isEmpty.
	
	self changeQueryType.
	self assert: presenter browser initialQuery children isEmpty.
	
	presenter toolbar presenters first click.
	
	self assert: presenter browser initialQuery children size equals: 1.
	self
		assert: presenter browser initialQuery children anyOne
		identicalTo: presenter query
]

{ #category : #tests }
MiQueryCreationPresenterTest >> testDisabledToolBarButton [
	presenter := MiQueryCreationPresenter
		on:
			(MiQueriesBrowser
				on:
					(FQRootQuery new
						result: helper noEntities;
						yourself)).
	self openInstance.
	self deny: presenter toolbar presenters first isEnabled
]

{ #category : #tests }
MiQueryCreationPresenterTest >> testQueryCode [
	| query |
	self assert: presenter queryCode class identicalTo: SpCodePresenter.
	query := helper queryFromCodeInPresenter: presenter.
	self assert: (query isKindOf: FQAbstractQuery).
	self assert: query isValid.
	self
		assert:
			(query
				hasSameParametersAs: presenter queryConfigurationPresenter query)
]

{ #category : #tests }
MiQueryCreationPresenterTest >> testQueryConfigurationPresenter [
	self
		assert:
			(presenter queryConfigurationPresenter
				isKindOf: MiQueryConfigurationPresenter).
	self
		assert: presenter queryConfigurationPresenter query class
		identicalTo: presenter queryTypesDropList selectedItem
]

{ #category : #tests }
MiQueryCreationPresenterTest >> testQueryMatchesInAllSubpresenters [
	self assertQueryMatchesInAllSubpresenters
]

{ #category : #tests }
MiQueryCreationPresenterTest >> testQueryTypesDropList [
	self
		assert: presenter queryTypesDropList class
		identicalTo: SpDropListPresenter.
	self
		assertCollection: presenter queryTypesDropList listItems
		hasSameElements: (FQUnaryQuery allSubclasses select: #canBeConfigured).
	presenter queryTypesDropList listItems
		do: [ :queryClass | 
			presenter queryTypesDropList selectItem: queryClass.
			self
				assert: (presenter queryConfigurationPresenter query isKindOf: queryClass) ]
]

{ #category : #tests }
MiQueryCreationPresenterTest >> testResultList [
	self
		assert: presenter resultList class
		identicalTo: MiResultTreePresenter.
	self
		assertCollection: presenter resultList items
		hasSameElements: presenter queryConfigurationPresenter query result
]

{ #category : #tests }
MiQueryCreationPresenterTest >> testToolBar [

	| initialQueriesSize |
	self openInstance.
	self assert: presenter toolbar class identicalTo: SpToolbarPresenter.
	self
		assert: presenter toolbar presenters first class
		identicalTo: SpToolbarButtonPresenter.
	self assert: presenter toolbar presenters first isEnabled.
	initialQueriesSize := presenter browser queries size.

	presenter toolbar presenters first click.
	self
		assert: presenter browser queries size
		equals: initialQueriesSize + 1.
	self
		assert: presenter browser selectedQuery
		equals: presenter queryConfigurationPresenter query
]

{ #category : #tests }
MiQueryCreationPresenterTest >> testTransmissions [
	presenter queryTypesDropList selectIndex: 2.
	self assertQueryMatchesInAllSubpresenters.
	presenter queryTypesDropList selectIndex: 3.
	self assertQueryMatchesInAllSubpresenters.
	presenter queryTypesDropList selectIndex: 4.
	self assertQueryMatchesInAllSubpresenters
]

{ #category : #tests }
MiQueryCreationPresenterTest >> testWindowClosedAction [
	| initialQueriesSize |
	self openInstance.
	initialQueriesSize := presenter browser queries size.
	presenter window close.
	self
		assert: presenter browser queries size
		equals: initialQueriesSize.
	self
		assert: presenter browser selectedQuery
		equals: presenter queryConfigurationPresenter query parent.
	self
		deny:
			(presenter browser queries
				includes: presenter queryConfigurationPresenter query)
]

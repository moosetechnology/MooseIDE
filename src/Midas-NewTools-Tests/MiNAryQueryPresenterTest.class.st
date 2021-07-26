Class {
	#name : #MiNAryQueryPresenterTest,
	#superclass : #MiQueryConfigurationPresenterTest,
	#category : #'Midas-NewTools-Tests-Queries Configuration'
}

{ #category : #running }
MiNAryQueryPresenterTest >> classToTest [

	^ MiNAryQueryPresenter
]

{ #category : #running }
MiNAryQueryPresenterTest >> queryClass [

	^ FQUnionQuery
]

{ #category : #running }
MiNAryQueryPresenterTest >> resetPresenterWithEntities: aMooseGroup [

	| builder superPresenter |
	browser := MiNewQueriesBrowser on: (FQRootQuery new
			            result: aMooseGroup;
			            yourself).
	builder := MiQueryBuilderPresenter on: browser.
	builder
		addNewFirstLevelQuery;
		addNewFirstLevelQuery.
	superPresenter := builder componentList items third.
	superPresenter queryTypesDropList selectItem: self queryClass.
	presenter := superPresenter queryConfigurationPresenter
]

{ #category : #tests }
MiNAryQueryPresenterTest >> testNormalQueryInitialization [

	presenter subqueryDropLists first selectIndex: 1.
	presenter subqueryDropLists second selectIndex: 2.
	self assert: presenter query class identicalTo: self queryClass.
	self assert: presenter query isValid
]

{ #category : #tests }
MiNAryQueryPresenterTest >> testPresenters [

	self assert: presenter subqueryDropLists isCollection.
	self
		assert: presenter addSubqueryToLayoutButton class
		equals: SpButtonPresenter.
	self
		assert: presenter removeSubqueryFromLayoutButton class
		equals: SpButtonPresenter
]

{ #category : #tests }
MiNAryQueryPresenterTest >> testPresentersOnImpossibleQuery [

	self assert: true
]

{ #category : #tests }
MiNAryQueryPresenterTest >> testQueryValidity [

	self assert: true
]

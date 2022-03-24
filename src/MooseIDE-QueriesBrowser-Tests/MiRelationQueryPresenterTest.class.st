Class {
	#name : #MiRelationQueryPresenterTest,
	#superclass : #MiQueryConfiguratorPresenterTest,
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Configuration'
}

{ #category : #tests }
MiRelationQueryPresenterTest >> assertSubpresentersAreConfigured [

	self
		assert: presenter relationsList selectedItem
		equals: self createNewQuery relationName
]

{ #category : #running }
MiRelationQueryPresenterTest >> classToTest [

	^ MiRelationQueryPresenter
]

{ #category : #tests }
MiRelationQueryPresenterTest >> createNewQuery [

	| rootQuery |
	rootQuery := FQRootQuery new
		             result: helper classesAndMethods;
		             yourself.
	^ FQRelationQuery defaultForParent: rootQuery
]

{ #category : #running }
MiRelationQueryPresenterTest >> queryClass [

	^ FQRelationQuery
]

{ #category : #tests }
MiRelationQueryPresenterTest >> testPresenters [

	self
		assert: presenter relationsList class
		identicalTo: SpDropListPresenter
]

{ #category : #tests }
MiRelationQueryPresenterTest >> testPresentersOnImpossibleQuery [

	self resetPresenterWithEntities: helper noEntities.
	self
		assert: presenter relationsList class
		identicalTo: NoPossibleQueryPresenter
]

{ #category : #tests }
MiRelationQueryPresenterTest >> testQueryValidity [

	self deny: presenter query isValid.

	presenter relationsList selectIndex: 2.
	self assert: presenter query isValid.

	self resetPresenterWithEntities: helper noEntities.
	self deny: presenter query isValid
]

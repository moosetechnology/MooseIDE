Class {
	#name : #MiTypeQueryPresenterTest,
	#superclass : #MiQueryConfiguratorPresenterTest,
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Configuration'
}

{ #category : #tests }
MiTypeQueryPresenterTest >> assertSubpresentersAreConfigured [

	self assertCollection: presenter typesList selectedItems hasSameElements: self createNewQuery types
]

{ #category : #running }
MiTypeQueryPresenterTest >> classToTest [
	^ MiTypeQueryPresenter
]

{ #category : #tests }
MiTypeQueryPresenterTest >> createNewQuery [

	| rootQuery |
	rootQuery := FQRootQuery new
		result: helper classesAndMethods;
		yourself.
	^ (FQTypeQuery defaultForParent: rootQuery)
			types: { FamixStClass . FamixStAttribute };
			yourself
]

{ #category : #running }
MiTypeQueryPresenterTest >> queryClass [
	^ FQTypeQuery
]

{ #category : #tests }
MiTypeQueryPresenterTest >> testImpossibleQueryInitialization [

	self resetPresenterWithEntities: helper noEntities.
	self assert: presenter query class identicalTo: self queryClass.
	"Famix queries changed. Now the type query can be empty and can have no types."
	self assert: presenter query isValid
]

{ #category : #tests }
MiTypeQueryPresenterTest >> testPresenters [

	self assert: presenter typesButton class equals: SpButtonPresenter
]

{ #category : #tests }
MiTypeQueryPresenterTest >> testPresentersOnImpossibleQuery [

	self resetPresenterWithEntities: helper noEntities.
	self
		assert: presenter typesButton class
		identicalTo: NoPossibleQueryPresenter
]

{ #category : #tests }
MiTypeQueryPresenterTest >> testQueryValidity [

	self assert: presenter query isValid.
	self resetPresenterWithEntities: helper noEntities.
	"A type query can be empty and have no types"
	self assert: presenter query isValid
]

{ #category : #test }
MiTypeQueryPresenterTest >> testUpdateQueryWithSelectedTypes [

	| typesRemoved |
	typesRemoved := presenter query availableTypes removeFirst: 2.
	presenter updateQueryWithSelectedTypes: typesRemoved.
	self
		assertCollection: presenter query types
		hasSameElements: typesRemoved
]

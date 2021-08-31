Class {
	#name : #MiTypeQueryPresenterTest,
	#superclass : #MiQueryConfigurationPresenterTest,
	#category : #'MooseIDE-NewTools-Tests-Queries Configuration'
}

{ #category : #running }
MiTypeQueryPresenterTest >> classToTest [
	^ MiTypeQueryPresenter
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
		identicalTo: MiNoPossibleQueryPresenter
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

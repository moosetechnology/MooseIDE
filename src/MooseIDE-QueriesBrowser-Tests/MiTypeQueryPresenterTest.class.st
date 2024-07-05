Class {
	#name : #MiTypeQueryPresenterTest,
	#superclass : #MiQueryConfiguratorPresenterTest,
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Configuration'
}

{ #category : #tests }
MiTypeQueryPresenterTest >> assertSubpresentersAreConfigured [

	self
		assertCollection: presenter typesList items
		includesAll: self createNewQuery types.
	self
		assertCollection: presenter typesList selectedItems
		hasSameElements: self createNewQuery types.

	self assert: presenter typesButton class equals: SpButtonPresenter
]

{ #category : #running }
MiTypeQueryPresenterTest >> classToTest [
	^ MiTypeQueryPresenter
]

{ #category : #tests }
MiTypeQueryPresenterTest >> createNewQuery [

	| rootQuery |

	rootQuery := FQRootQuery new
		             input: helper classesAndMethods;
		             yourself.
	^ (FQTypeQuery defaultForParent: rootQuery)
		  types: {
				  FamixStClass.
				  FamixStAttribute };
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
	self deny: presenter query isValid
]

{ #category : #tests }
MiTypeQueryPresenterTest >> testModalSelectionTypes [

	presenter typesList selectItems: { FamixStClass }.
	presenter selectTypeAction: nil.

	self
		assertCollection: presenter query types
		hasSameElements: { FamixStClass }
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

	"A type query with no types is invalid"

	self deny: presenter query isValid.
	self resetPresenterWithEntities: helper noEntities.

	self deny: presenter query isValid
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

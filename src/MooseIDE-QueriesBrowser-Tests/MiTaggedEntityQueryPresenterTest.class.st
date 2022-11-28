Class {
	#name : #MiTaggedEntityQueryPresenterTest,
	#superclass : #MiQueryConfiguratorPresenterTest,
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Configuration'
}

{ #category : #tests }
MiTaggedEntityQueryPresenterTest >> assertSubpresentersAreConfigured [

	self
		assert: presenter tagList selectedItem
		equals: self createNewQuery tagName
]

{ #category : #running }
MiTaggedEntityQueryPresenterTest >> classToTest [
	^MiTaggedEntityQueryPresenter 
]

{ #category : #tests }
MiTaggedEntityQueryPresenterTest >> createNewQuery [

	| rootQuery |
	rootQuery := FQRootQuery new
		             result: helper classesAndMethods;
		             yourself.
	^ FQTaggedEntityQuery defaultForParent: rootQuery
]

{ #category : #running }
MiTaggedEntityQueryPresenterTest >> createTestHelper [
	| tag |
	helper := super createTestHelper.

	tag := FamixTag new name: 'classes' ; mooseModel: helper modelExample.
	helper modelExample allModelClasses do: [ :c | tag tagEntity: c ].
	
	^helper
]

{ #category : #running }
MiTaggedEntityQueryPresenterTest >> queryClass [
	^ FQTaggedEntityQuery 
]

{ #category : #tests }
MiTaggedEntityQueryPresenterTest >> testPresenters [

	self
		assert: presenter tagList class
		identicalTo: SpDropListPresenter
]

{ #category : #tests }
MiTaggedEntityQueryPresenterTest >> testPresentersOnImpossibleQuery [

	self resetPresenterWithEntities: helper noEntities.
	self
		assert: presenter tagList class
		identicalTo: NoPossibleQueryPresenter
]

{ #category : #tests }
MiTaggedEntityQueryPresenterTest >> testQueryValidity [

	self deny: presenter query isValid.

	presenter tagList selectIndex: 1.
	self assert: presenter query isValid.

	self resetPresenterWithEntities: helper noEntities.
	self deny: presenter query isValid
]

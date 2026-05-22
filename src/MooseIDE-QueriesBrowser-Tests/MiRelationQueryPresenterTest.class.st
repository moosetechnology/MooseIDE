Class {
	#name : 'MiRelationQueryPresenterTest',
	#superclass : 'MiQueryConfiguratorPresenterTest',
	#category : 'MooseIDE-QueriesBrowser-Tests-Queries Configuration',
	#package : 'MooseIDE-QueriesBrowser-Tests',
	#tag : 'Queries Configuration'
}

{ #category : 'tests' }
MiRelationQueryPresenterTest >> assertSubpresentersAreConfigured [

	self
		assert: self relationsList selectedItem
		equals: self createNewQuery relationName
]

{ #category : 'running' }
MiRelationQueryPresenterTest >> classToTest [

	^ MiRelationQueryPresenter
]

{ #category : 'tests' }
MiRelationQueryPresenterTest >> createNewQuery [

	| rootQuery |

	rootQuery := FQRootQuery new
		             input: helper classesAndMethods;
		             yourself.
	^ FQRelationQuery defaultForParent: rootQuery
]

{ #category : 'running' }
MiRelationQueryPresenterTest >> queryClass [

	^ FQRelationQuery
]

{ #category : 'accessing-subpresenters' }
MiRelationQueryPresenterTest >> relationsList [

	^ presenter presenterAt: #relationsList
]

{ #category : 'tests' }
MiRelationQueryPresenterTest >> testPresenters [

	self
		assert: self relationsList class
		identicalTo: SpDropListPresenter
]

{ #category : 'tests' }
MiRelationQueryPresenterTest >> testPresentersOnImpossibleQuery [

	self resetPresenterWithEntities: helper noEntities.
	self
		assert: self relationsList class
		identicalTo: NoPossibleQueryPresenter
]

{ #category : 'tests' }
MiRelationQueryPresenterTest >> testQueryValidity [

	self deny: presenter query isValid.

	self relationsList selectIndex: 2.
	self assert: presenter query isValid.

	self resetPresenterWithEntities: helper noEntities.
	self deny: presenter query isValid
]

Class {
	#name : 'MiNavigationQueryPresenterTest',
	#superclass : 'MiQueryConfiguratorPresenterTest',
	#category : 'MooseIDE-QueriesBrowser-Tests-Queries Configuration',
	#package : 'MooseIDE-QueriesBrowser-Tests',
	#tag : 'Queries Configuration'
}

{ #category : 'tests' }
MiNavigationQueryPresenterTest >> assertSubpresentersAreConfigured [

	self
		assert: self directionDropList selectedItem
		equals: self createNewQuery directionStrategy.


	self
		assertCollection: self associationsList items
		includesAll: self createNewQuery associations.
	self
		assertCollection: self associationsList selectedItems
		hasSameElements: self createNewQuery associations.

	self
		assert: self associationsButton class
		equals: SpButtonPresenter
]

{ #category : 'accessing-subpresenters' }
MiNavigationQueryPresenterTest >> associationsButton [

	^ presenter presenterAt: #associationsButton
]

{ #category : 'accessing-subpresenters' }
MiNavigationQueryPresenterTest >> associationsList [

	^ presenter presenterAt: #associationsList
]

{ #category : 'running' }
MiNavigationQueryPresenterTest >> classToTest [
	^ MiNavigationQueryPresenter
]

{ #category : 'tests' }
MiNavigationQueryPresenterTest >> createNewQuery [

	| rootQuery |

	rootQuery := FQRootQuery new
		             input: helper classesAndMethods;
		             yourself.
	^ (FQNavigationQuery defaultForParent: rootQuery)
		  resetAndChangeDirection: FQIncomingNavigation;
		  association: FamixStInvocation;
		  yourself
]

{ #category : 'accessing-subpresenters' }
MiNavigationQueryPresenterTest >> directionDropList [

	^ presenter presenterAt: #directionDropList
]

{ #category : 'running' }
MiNavigationQueryPresenterTest >> queryClass [
	^ FQNavigationQuery
]

{ #category : 'tests' }
MiNavigationQueryPresenterTest >> testPresenters [

	self assert: self directionDropList class equals: SpDropListPresenter.
	self
		assertCollection: self directionDropList items
		hasSameElements: presenter query class directionStrategies.

	self directionDropList selectIndex: 2.
	self assert: self associationsButton class equals: SpButtonPresenter
]

{ #category : 'tests' }
MiNavigationQueryPresenterTest >> testPresentersOnImpossibleQuery [

	self resetPresenterWithEntities: helper noEntities.

	self
		assert: self directionDropList class
		equals: SpDropListPresenter.
	self
		assert: self associationsButton class
		identicalTo: NoPossibleQueryPresenter
]

{ #category : 'tests' }
MiNavigationQueryPresenterTest >> testQueryValidity [

	| popover |
	self deny: presenter query isValid.

	(presenter presenterAt: #directionDropList) selectIndex: 1.
	self deny: presenter query isValid.

	popover := presenter newAssociationsPopover.
	(presenter presenterAt: #associationsList) activateItem:
		presenter query availableAssociations anyOne.
	popover popoverClosed.
	self assert: presenter query isValid.

	self resetPresenterWithEntities:
		helper entitiesWithNoIncomingAssociations.
	self deny: presenter query isValid.

	self resetPresenterWithEntities: helper noEntities.
	self deny: presenter query isValid
]

{ #category : 'tests' }
MiNavigationQueryPresenterTest >> testSelectedAssociationsLabel [

	| item |
	presenter query beDefaultForParent.
	item := presenter query availableAssociations select: [ :i | i name = 'FamixStInheritance' ].
	(presenter presenterAt: #associationsList) activateItem: item first.
	item := presenter query availableAssociations select: [ :i | i name = 'FamixStAccess' ].

	(presenter presenterAt: #associationsList) activateItem: item first.
	item := presenter query availableAssociations select: [ :i | i name = 'FamixStInvocation' ].

	(presenter presenterAt: #associationsList) activateItem: item first.
	self assert: presenter selectedAssociationsLabel label equals: 'Access, Inheritance, Invocation'
]

{ #category : 'tests' }
MiNavigationQueryPresenterTest >> testUpdateDirectionWithSelectedAssociations [

	presenter query beDefaultForParent.

	self associationsList activateItem:
		presenter query availableAssociations first.

	self assert: presenter selectedAssociationsLabel label isNotEmpty.

	presenter updateDirection: FQLocalIncomingNavigation.

	self assert: presenter selectedAssociationsLabel label equals: ''
]

{ #category : 'tests' }
MiNavigationQueryPresenterTest >> testUpdateQueryWithSelectedAssociations [

	| associationsRemoved |
	presenter query beDefaultForParent.
	associationsRemoved := presenter query availableAssociations 
		                       removeFirst: 2.
	presenter updateQueryWithSelectedAssociations: associationsRemoved.
	self
		assertCollection: presenter query associations
		hasSameElements: associationsRemoved
]

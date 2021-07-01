Class {
	#name : #MiNewQueryCreationPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'presenter',
		'browser'
	],
	#category : #'Midas-NewTools-Tests-Queries Browser'
}

{ #category : #running }
MiNewQueryCreationPresenterTest >> bus [

	^ MiApplication current busNamed: 'TestBus'
]

{ #category : #running }
MiNewQueryCreationPresenterTest >> setUp [

	| parentPresenter helper |
	super setUp.

	helper := FQTestsHelper current.
	browser := MiNewQueriesBrowser runMeFollowing: self bus.
	browser selectEntity: helper classesAndMethods.
	parentPresenter := MiQueryBuilderPresenter on: browser.

	presenter := MiNewQueryCreationPresenter
		             on: FQRootQuery new
		             parentPresenter: parentPresenter.
	presenter updateQueryConfigurationFor: FQStringQuery
]

{ #category : #running }
MiNewQueryCreationPresenterTest >> tearDown [

	browser window ifNotNil: [ :window | window close ].
	MiApplication current deleteBus: self bus.
	super tearDown
]

{ #category : #tests }
MiNewQueryCreationPresenterTest >> testClickNegateSetsButtonInNegatedState [
	presenter negateButton click.
	self assert: presenter isNegated.
	self assert: presenter negateButton icon equals: (self iconNamed: #cancel).
	self assert: (presenter negateButton help includesSubstring: 'un-negate')
]

{ #category : #tests }
MiNewQueryCreationPresenterTest >> testClickNegateTwiceSetsButtonInUnnegatedState [
	presenter negateButton click.
	presenter negateButton click.

	self deny: presenter isNegated.
	self assert: presenter negateButton icon equals: (self iconNamed: #exception).
	self assert: (presenter negateButton help beginsWith: 'Negate ')
]

{ #category : #tests }
MiNewQueryCreationPresenterTest >> testInitializeButtonHasDefaultValues [
	self deny: presenter isNegated.
	self assert: presenter negateButton icon equals: (self iconNamed: #exception).
	self assert: (presenter negateButton help beginsWith: 'Negate ')
]

{ #category : #tests }
MiNewQueryCreationPresenterTest >> testQueryCanBeNegatedButtonIsENabled [
	presenter updateQueryConfigurationFor: FQStringQuery.
	self assert: presenter negateButton isEnabled.

]

{ #category : #tests }
MiNewQueryCreationPresenterTest >> testQueryCannotBeNegatedButtonIsDisabled [
	presenter updateQueryConfigurationFor: FQTypeQuery.
	self deny: presenter negateButton isEnabled.

]

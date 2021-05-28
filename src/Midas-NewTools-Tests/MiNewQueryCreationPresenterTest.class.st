Class {
	#name : #MiNewQueryCreationPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'presenter'
	],
	#category : #'Midas-NewTools-Tests-Queries Browser'
}

{ #category : #running }
MiNewQueryCreationPresenterTest >> setUp [
	| browser |
	super setUp.

	browser := Mock new.
	presenter := MiNewQueryCreationPresenter on: FQRootQuery new.
	presenter parentPresenter: browser.
	presenter updateQueryConfigurationFor: FQStringQuery
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

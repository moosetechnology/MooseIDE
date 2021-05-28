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
"parentQuery parentSequence size - 1."
	browser := Mock new.
	presenter := MiNewQueryCreationPresenter on: FQRootQuery new.
	presenter parentPresenter: browser.
]

{ #category : #tests }
MiNewQueryCreationPresenterTest >> testClickNegate [
	presenter negateButton click.
	self assert: presenter isNegated.
	self assert: presenter negateButton icon equals: (self iconNamed: #cancel).
	self assert: (presenter negateButton help includesSubstring: 'un-negate')
]

{ #category : #tests }
MiNewQueryCreationPresenterTest >> testClickNegateTwice [
	presenter negateButton click.
	presenter negateButton click.

	self deny: presenter isNegated.
	self assert: presenter negateButton icon equals: (self iconNamed: #exception).
	self assert: (presenter negateButton help beginsWith: 'Negate ')
]

{ #category : #tests }
MiNewQueryCreationPresenterTest >> testInitializeNegation [
	self deny: presenter isNegated.
	self assert: presenter negateButton icon equals: (self iconNamed: #exception).
	self assert: (presenter negateButton help beginsWith: 'Negate ')
]
